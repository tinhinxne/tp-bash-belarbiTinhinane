#!/bin/bash
# backup.sh - archive un dossier, horodate l'archive, supprime les sauvegardes > 7 jours
# Usage : ./backup.sh <dossier_source> [dossier_destination]

set -Eeuo pipefail

DOSSIER="${1:-}"
DEST="${2:-$HOME/backups}"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$DEST/backup_${DATE}.tar.gz"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

if [ -z "$DOSSIER" ]; then
    echo "Usage : $0 <dossier_source> [dossier_destination]" >&2
    exit 1
fi

if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier '$DOSSIER' n'existe pas." >&2
    exit 1
fi

mkdir -p "$DEST"

log "Début de la sauvegarde de $DOSSIER"
tar -czf "$ARCHIVE" "$DOSSIER"
log "Archive créée : $ARCHIVE"

# Suppression des sauvegardes de plus de 7 jours
for fichier in "$DEST"/backup_*.tar.gz; do
    [ -e "$fichier" ] || continue
    if [ -n "$(find "$fichier" -mtime +7)" ]; then
        rm "$fichier"
        log "Ancienne sauvegarde supprimée : $fichier"
    fi
done

log "Sauvegarde terminée avec succès"
exit 0
