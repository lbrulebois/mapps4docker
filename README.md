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