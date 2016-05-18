#! /usr/bin/env bash

DATADIR=$1

if [ -d "${DATADIR}/modules" ]; then
  cwd="$(pwd)"
  modules=$(find "${DATADIR}/modules" -name "*.cpp")

  for module in $modules; do
    cd "$(dirname "$module")"
    znc-buildmod "$module"
  done

  cd "$cwd"
fi

if [ ! -f "${DATADIR}/configs/znc.conf" ]; then
    mkdir -p "${DATADIR}/configs"
    cp /znc.conf.default "${DATADIR}/configs/znc.conf"
fi

su -c "znc --makepem --datadir=$DATADIR" -s /bin/sh znc
echo "SSLCertFile $DATADIR/znc.pem" >> $DATADIR/configs/znc.conf

chown -R znc:znc "$DATADIR"

su -c "znc --foreground --datadir=$DATADIR" -s /bin/sh znc
