#!/bin/bash
# mapps4docker
# version : alpha
# Auteur : BRULEBOIS Loïc

usage() {
    echo "$0 usage: -c <config.csv> [-p <code1,code2,code3...>]"
    exit 1
}

# Répertoire d'exécution du script...
BASEDIR=$(dirname "$0")

# Récupération des arguments fournis...
while getopts "c:p:" flag; do
    case "${flag}" in
        c) CONFIG=${OPTARG};;
        p) STR_APPS=${OPTARG};;
        *) usage ;;
    esac
done

# Si aucun fichier de configuration n'est fourni,
# le script tente alors de charger le fichier par défaut
if [ -z "$CONFIG" ]
then
    CONFIG="$BASEDIR/config.csv"
fi

# Si la chaîne des applications à démarrer n'est pas
# vide, on la parse pour lister les codes autorisés à
# être démarrés...
if [ ! -z "$STR_APPS" ]
then
    AUTH_APPS=()
    IFS=',' read -a LISTAPPS <<< "$STR_APPS"
    for iapp in "${!LISTAPPS[@]}"; do
        AUTH_APPS+=(${LISTAPPS[$iapp]})
    done
fi

echo "mapps4docker"
echo "> start.sh - démarrage des applications"
echo "Paramètres :"
echo "  - BASEDIR = $BASEDIR"
echo "  - CONFIG  = $CONFIG"
echo "  - APPS    = ${AUTH_APPS[@]}"

# 1) On vérifie que le fichier de configuration existe sans
# quoi on retourne une erreur...
if [ ! -f "$CONFIG" ]
then
    echo "[ERR] Le fichier '$CONFIG' n'existe pas ou plus..."
    exit 2
fi

# 2) On parse le fichier CSV pour extraire l'ensemble des
# fichiers docker-compose à importer pour lancer l'ensemble
# des applications installées sur l'instance...
echo
echo "[...] Lecture du fichier de configuration..."
COMPOSE_FILES=()
PROJECTS_NAMES=()
while IFS=';' read -r filepath name args
do
    CONF_FILE="$BASEDIR/$filepath"
    echo "> Fichier détecté : '$CONF_FILE'"
    if [ ! -f "$CONF_FILE" ]
    then
        # Si le fichier n'existe pas, on en informe l'utilisateur...
        echo "[WRN] Le fichier '$CONF_FILE' n'existe pas ou plus et sera ignoré..."
    else
        # Sinon on référence ce dernier pour être exécuté dans la 
        # commande de démarrage...
        COMPOSE_FILES+=("$CONF_FILE") 
        PROJECTS_NAMES+=("$name")
        # En on parle les arguments complémentaires
        IFS=',' read -a DATAARGS <<< "$args"
        for iarg in "${!DATAARGS[@]}"; do
            ARG=${DATAARGS[$iarg]}
        done
    fi
done < "$CONFIG"
echo "[INF] Fin de Lecture du fichier de configuration..."

# On peut alors générer la commande qui va démarrer l'ensemble
# de la pile des applications...
echo 
CMD_START="docker-compose"
for icfile in ${!COMPOSE_FILES[@]}; do
    CFILE=${COMPOSE_FILES[$icfile]}
    PJ_NAME=${PROJECTS_NAMES[$icfile]}
    DIR_CFILE=`dirname $CFILE`

    # Si la chaîne des applications à charger n'est pas vide et
    # qu'il s'agît du premier fichier (ou fichier racine) ou 
    # d'un code projet autorisé alors on charge la configuration...
    CAN_EXEC="false"
    if [ -z "$STR_APPS" ]
    then
        CAN_EXEC="true"
    else
        if [ ! -z "$STR_APPS" ] && ([ "$icfile" == "0" ] ||  [[ ${AUTH_APPS[@]} =~ "$PJ_NAME" ]])
        then
            CAN_EXEC="true"
        fi
    fi

    if [ "$CAN_EXEC" == "true" ]
    then 
        echo "[...] Démarrage de la configuration pour #$PJ_NAME '$CFILE' ($DIR_CFILE)"
        eval "$CMD_START -p $PJ_NAME --project-directory $DIR_CFILE -f $CFILE up -d"
    fi
done

echo
echo "[INF] Fin du démarrage..."
