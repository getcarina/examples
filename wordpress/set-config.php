<?php

define("WP_CONTENT_DIR", "/usr/src/wordpress/wp-content");

$wpRoot = '/usr/src/wordpress';

require_once $wpRoot . '/wp-load.php';
require_once $wpRoot . '/wp-content/plugins/w3-total-cache/inc/define.php';

w3_require_once(W3TC_LIB_W3_DIR . '/ConfigWriter.php');

// Set config values
$conf = new W3_ConfigWriter(0, false);
$conf->set('cdn.enabled', true);
$conf->set('cdn.engine', 'rscf');
$conf->set('cdn.rscf.user', getenv('RS_USERNAME'));
$conf->set('cdn.rscf.key', getenv('RS_API_KEY'));
$conf->set('cdn.rscf.location', getenv('RS_LOCATION'));
$conf->set('cdn.rscf.container', getenv('RS_CONTAINER'));
$conf->set('cdn.rscf.cname', getenv('RS_CNAME'));
$conf->set('cdn.rscf.ssl', 'enabled');
$conf->save();
