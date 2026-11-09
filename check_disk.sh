#!/bin/bash
# check_disk.sh - alerte si l'espace disque utilisé dépasse un seuil
# Usage : ./check_disk.sh [seuil_en_pourcentage]   (80 par défaut)

SEUIL="${1:-80}"
UTILISATION=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : disque utilisé à ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 1
else
    echo "OK : disque utilisé à ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 0
fi
