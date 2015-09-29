#!/bin/bash
set -e

if [ -z "$WORDPRESS_DB_HOST" ]; then
	echo >&2 'Error: missing WORDPRESS_DB_HOST environment variable'
	exit 1
fi

if [ -z "$WORDPRESS_DB_USER" ]; then
	echo >&2 'Error: missing WORDPRESS_DB_USER environment variables'
	exit 1
fi

if [ -z "$WORDPRESS_DB_PASSWORD" ]; then
	echo >&2 'Error: missing WORDPRESS_DB_PASSWORD environment variable'
	exit 1
fi

# Copy /usr/src/wordpress to the /var/www/html mount
if ! [ -e index.php -a -e wp-includes/version.php ]; then
	echo >&2 "WordPress not found in $(pwd) - copying now..."
	if [ "$(ls -A)" ]; then
		echo >&2 "WARNING: $(pwd) is not empty - press Ctrl+C now if this is an error!"
		( set -x; ls -A; sleep 10 )
	fi
	tar cf - --one-file-system -C /usr/src/wordpress . | tar xf -
	echo >&2 "Complete! WordPress has been successfully copied to $(pwd)"
fi

# Set up wp-config.php
if [ ! -e wp-config.php ]; then
	awk '/^\/\*.*stop editing.*\*\/$/ && c == 0 { c = 1; system("cat") } { print }' wp-config-sample.php > wp-config.php <<'EOPHP'
// If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact
// see also http://codex.wordpress.org/Administration_Over_SSL#Using_a_Reverse_Proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
$_SERVER['HTTPS'] = 'on';
}

EOPHP
fi

# Set DB config
sed_escape_lhs() {
	echo "$@" | sed 's/[]\/$*.^|[]/\\&/g'
}
sed_escape_rhs() {
	echo "$@" | sed 's/[\/&]/\\&/g'
}
php_escape() {
	php -r 'var_export((string) $argv[1]);' "$1"
}
set_config() {
	key="$1"
	value="$2"
	regex="(['\"])$(sed_escape_lhs "$key")\2\s*,"
	if [ "${key:0:1}" = '$' ]; then
		regex="^(\s*)$(sed_escape_lhs "$key")\s*="
	fi
	sed -ri "s/($regex\s*)(['\"]).*\3/\1$(sed_escape_rhs "$(php_escape "$value")")/" wp-config.php
}

set_config 'DB_HOST' "$WORDPRESS_DB_HOST"
set_config 'DB_USER' "$WORDPRESS_DB_USER"
set_config 'DB_PASSWORD' "$WORDPRESS_DB_PASSWORD"
set_config 'DB_NAME' "$WORDPRESS_DB_NAME"

# Set salts
UNIQUES=(
	AUTH_KEY
	SECURE_AUTH_KEY
	LOGGED_IN_KEY
	NONCE_KEY
	AUTH_SALT
	SECURE_AUTH_SALT
	LOGGED_IN_SALT
	NONCE_SALT
)
for unique in "${UNIQUES[@]}"; do
	eval unique_value=\$WORDPRESS_$unique
	if [ "$unique_value" ]; then
		set_config "$unique" "$unique_value"
	else
		# if not specified, let's generate a random value
		current_set="$(sed -rn "s/define\((([\'\"])$unique\2\s*,\s*)(['\"])(.*)\3\);/\4/p" wp-config.php)"
		if [ "$current_set" = 'put your unique phrase here' ]; then
			set_config "$unique" "$(head -c1M /dev/urandom | sha1sum | cut -d' ' -f1)"
		fi
	fi
done

# Check MySQL config actually works
TERM=dumb php -- "$WORDPRESS_DB_HOST" "$WORDPRESS_DB_USER" "$WORDPRESS_DB_PASSWORD" "$WORDPRESS_DB_NAME" <<'EOPHP'
<?php
// database might not exist, so let's try creating it (just to be safe)

$stderr = fopen('php://stderr', 'w');

list($host, $port) = explode(':', $argv[1], 2);

$maxTries = 10;
do {
	$mysql = new mysqli($host, $argv[2], $argv[3], '', (int)$port);
	if ($mysql->connect_error) {
		fwrite($stderr, "\n" . 'MySQL Connection Error: (' . $mysql->connect_errno . ') ' . $mysql->connect_error . "\n");
		--$maxTries;
		if ($maxTries <= 0) {
			exit(1);
		}
		sleep(3);
	}
} while ($mysql->connect_error);

if (!$mysql->query('CREATE DATABASE IF NOT EXISTS `' . $mysql->real_escape_string($argv[4]) . '`')) {
	fwrite($stderr, "\n" . 'MySQL "CREATE DATABASE" Error: ' . $mysql->error . "\n");
	$mysql->close();
	exit(1);
}

$mysql->close();
EOPHP

# Download nginx helper plugin
curl -O `curl -i -s https://wordpress.org/plugins/nginx-helper/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
unzip -o nginx-helper.*.zip -d wp-content/plugins

# Install Redis cache
curl -s -o wp-content/object-cache.php https://raw.githubusercontent.com/ericmann/Redis-Object-Cache/master/object-cache.php
sed -i -e "s/127.0.0.1/$REDIS_IP/" wp-content/object-cache.php

# Install w3 plugin
curl -O `curl -i -s https://wordpress.org/plugins/w3-total-cache/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
unzip -o w3-total-cache.*.zip -d wp-content/plugins

# Activate plugins once logged in
cat << ENDL >> wp-config.php
\$plugins = get_option( 'active_plugins' );
if ( count( \$plugins ) === 0 ) {
require_once(ABSPATH .'/wp-admin/includes/plugin.php');
\$pluginsToActivate = array( 'nginx-helper/nginx-helper.php', 'w3-total-cache/w3-total-cache.php' );
foreach ( \$pluginsToActivate as \$plugin ) {
  if ( !in_array( \$plugin, \$plugins ) ) {
    activate_plugin( '/var/html/wp-content/plugins/' . \$plugin );
  }
}
}
ENDL

# A bunch of hacks to make sure W3 works
mkdir -r wp-content/cache/tmp wp-content/w3tc-config
touch wp-content/w3tc-config/master.php
chmod -R 777 wp-content/w3tc-config wp-content/cache
rm -rf wp-content/cache/config

# Set ownership
chown -R www-data:www-data .

# Run config script to set API creds
php /set-config.php

# Run nginx
exec "$@"
