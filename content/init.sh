#!/bin/bash

if [[ ! "$ENABLE_RELAY" =~ ^[T-t]rue* ]]; then
   unset ENABLE_RELAY;
fi

if [[ "$GENERATE_TEMPLATE" =~ ^[T-t]rue* ]]; then
    cat /etc/custom.xml | mo > /etc/icecast.xml
fi

case "$1" in
    run-icecast)
      icecast -c /etc/icecast.xml
      ;;
    ash)
      ash
      ;;
    bash)
      bash
      ;;
    *)
      echo "Usage: run-icecast"
      exit 1
esac