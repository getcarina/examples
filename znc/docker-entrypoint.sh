#! /usr/bin/env bash

DATADIR=${1:-/home/znc/.znc}

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

chown -R znc:znc "$DATADIR"

su -c "znc --makepem && znc --foreground --datadir=$DATADIR" -s /bin/sh znc
