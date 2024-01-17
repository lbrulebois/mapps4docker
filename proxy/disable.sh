#!/bin/bash
# mapps4docker - module "proxy"
# version : alpha
# Auteur : BRULEBOIS Loïc

usage() {
    echo "$0 usage: [-y]"
    exit 1
}

# Répertoire d'exécution du script...
BASEDIR=$(dirname "$0")
# Chemin vers le fichier de configuration...
CONFIG="$BASEDIR/config.ini"
# Répertoire des fichiers de configurations
CONFDIR="$BASEDIR/conf"

# Récupération des arguments fournis...
while getopts "y" flag; do
    case "${flag}" in
        y) AUTOVAL="true";;
        *) usage ;;
    esac
done

echo "mapps4docker / module 'proxy'"
echo "> disable.sh - désactivation du module proxy"
echo "Paramètres :"
echo "  - BASEDIR = $BASEDIR"
echo "  - CONFIG  = $CONFIG"
echo "  - AUTOVAL = $AUTOVAL"

# 1) On vérifie que le fichier de configuration existe sans
# quoi on retourne une erreur...
if [ ! -f "$CONFIG" ]
then
    echo "[ERR] Le fichier '$CONFIG' n'existe pas ou plus..."
    exit 2
fi

# Si le fichier existe, on importe la configuration...
echo "[INF] Chargement de la configuration..."
. "$CONFIG"
echo "[INF] Configuration chargée..."

# 2) A partir de la configration, on vérifie que l'on
# dispose des ressources nécessaires pour activer le
# proxy dans docker...

# - Variable "DAEMON_PROXY_DIR" : si elle est définie, on
# attend que le répertoire "conf/" contienne le fichier 
# "http-proxy.conf" sans quoi on retourne une erreur...
HTTPPROXY_CONF_FILEPATH="$CONFDIR/http-proxy.conf"
if [ ! -z "$DAEMON_PROXY_DIR" ] && [ ! -f "$HTTPPROXY_CONF_FILEPATH" ]
then
    echo "[ERR] Le fichier '$HTTPPROXY_CONF_FILEPATH' n'existe pas ou plus..."
    exit 3
fi

# - Variable "DOCKER_CONFIG_DIR" : si elle est définie, on
# attend que le répertoire "conf/" contienne deux fichiers
# "proxy_config.json" et "noproxy_config.json" sans quoi on 
# retourne une erreur...
PROXY_CONFJSON_FILEPATH="$CONFDIR/proxy_config.json"
NOPROXY_CONFJSON_FILEPATH="$CONFDIR/noproxy_config.json"
if [ ! -z "$DOCKER_CONFIG_DIR" ] && ([ ! -f "$PROXY_CONFJSON_FILEPATH" ] || [ ! -f "$NOPROXY_CONFJSON_FILEPATH" ])
then
    echo "[ERR] Le fichier '$PROXY_CONFJSON_FILEPATH' et/ou '$NOPROXY_CONFJSON_FILEPATH' n'existe(nt) pas ou plus..."
    exit 4
fi

# 3) Une fois en possession de toutes les ressources, on
# fait confirmer (sauf si déjà fait) que l'utilisateur accèpte
# le redémarrage de l'instance docker pour activer le proxy...
if [ -z "$AUTOVAL" ] || [ "$AUTOVAL" != "true" ]
then
    echo -n "En désactivant le proxy, l'instance Docker va être redémarrée, êtes-vous d'accord ? [o/N]"
    read VALRESTART
    if [ "$VALRESTART" != "O" ] && [ "$VALRESTART" != "o" ] 
    then
        echo "[INF] Fin de la procédure de désactivation du proxy..."
        exit 0
    fi
fi

# 4) On peut enfin procéder aux manipulations...
echo "[INF] Début de la désactivation du proxy..."
if [ ! -z "$DAEMON_PROXY_DIR" ] 
then
    sudo rm -f "$DAEMON_PROXY_DIR/http-proxy.conf"
    echo "[Service]" | sudo tee  "$DAEMON_PROXY_DIR/http-proxy.conf" > /dev/null
fi

if [ ! -z "$DOCKER_CONFIG_DIR" ] 
then
    sudo cp "$NOPROXY_CONFJSON_FILEPATH" "$DOCKER_CONFIG_DIR/config.json"
fi

echo "[INF] Fin de la désactivation du proxy..."
