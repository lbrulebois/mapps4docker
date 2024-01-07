# mapps4docker

## Configuration
Pour ce faire, utilisez le fichier `config.csv` pour référencer le/les fichiers
`docker-compose.yml` à utiliser. La première ligne correspond au fichier dit "racine"
permettant d'initialiser les conteneurs communs aux différentes applications.

Pour chaque ligne, la synthaxe est la suivante :
```csv
<chemin vers le docker-compose.yml relatif à l'installation de mapps4docker>;<code applicatif>
```

Exemple :
```csv
example/root/docker-compose.yml;root
example/app1/docker-compose.yml;myapp
example/app2/docker-compose.yml;appli
```

## `start.sh` : démarrer les application
Pour ce faire il faut utiliser le script `start.sh`.
Exemple :
```shell
./start.sh -c ./example/config.csv -p myapp
```

### Configuration (`-c`)
Permet de spécifier le chemin vers le fichier de configuration à utiliser.
Exemple :
```shell
./start.sh -c ./example/config.csv
```

### Projets (`-p`)
Permet de spécifier le/les codes projets à démarrer (en plus du projet "racine") séparés par une virgule.
Exemple :
```shell
./start.sh -p myapp,appli
```

## `stop.sh` : arrêter les application
Pour ce faire il faut utiliser le script `stop.sh`.
Exemple :
```shell
./stop.sh -c ./example/config.csv -p myapp -r
```

### Configuration (`-c`)
Permet de spécifier le chemin vers le fichier de configuration à utiliser.
Exemple :
```shell
./stop.sh -c ./example/config.csv
```

### Projets (`-p`)
Permet de spécifier le/les codes projets à arrêter séparés par une virgule. Si aucun projet n'est spécifié tous sont arrêtés (dont le projet "racine").
Exemple :
```shell
./stop.sh -p appli
```

### Supprimer les conteneurs (`-r`)
Permet d'indiquer qu'en plus de l'arrêt, les conteneurs concernés doivent également être supprimés.
Exemple :
```shell
./stop.sh -r
```

## Module `proxy`

Ce module permet d'activer ou désactiver la fonctionnalité de proxy pour Docker et est autonome.
Son installation ou sa configuration ne sont pas nécessaires si vous n'utilisez pas ce module.

### Configuration

Pour configurer ce module, il vous faut au préalable référencer dans `proxy/config.ini` les valeurs suivantes :
* `DAEMON_PROXY_DIR` = le répertoire des fichiers de configuration du daemon de Docker
* `DOCKER_CONFIG_DIR` = le répertoire du fichier `config.json` permettant de configurer Docker
Si une des valeurs ci-dessus n'est pas renseignée alors elle ne pourra pas être utilisée pour gérer le proxy.

Si vous avez configuré `DAEMON_PROXY_DIR`, il vous faudra compléter avec vos valeurs le fichier `proxy/conf/http-proxy.conf`.
Si vous avez configuré `DOCKER_CONFIG_DIR`, il vous faudra compléter avec vos valeurs les fichiers `proxy/conf/proxy_confif.json` et `proxy/conf/noproxy_config.json`.

### `enable.sh` : Activer le module
Pour ce faire il faut utiliser le script `enable.sh`.
Exemple :
```shell
./proxy/enable.sh -y
```

### Auto-acceptation (`-y`)
Permet de spécifier que vous acceptez d'office le redémarrage de l'instance Docker pour activer le module
Exemple :
```shell
./proxy/enable.sh -y
```

### `disable.sh` : Désactiver le module
Pour ce faire il faut utiliser le script `disable.sh`.
Exemple :
```shell
./proxy/disable.sh -y
```

### Auto-acceptation (`-y`)
Permet de spécifier que vous acceptez d'office le redémarrage de l'instance Docker pour désactiver le module
Exemple :
```shell
./proxy/disable.sh -y
```