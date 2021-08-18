# Deploying infrastructure on AWS

## Introduction
La recherche des différentes instances EC2 se fait sur les balises.  
Pour que le déploiement continu fonctionne, une nomenclature à respecter est obligatoire.  
Pour une meilleure lecture des Tags et balises adopter dans notre nomenclature, nous partons du prinicpe que :
* le service est une ***API***
* le nom de domaine est ***nicocaill13***
* l'environement est ***develop***

## Prerequisites on v1
* un compte aws
* aws cli installé
* configurer aws sur la machine
* terraform installé
* un accès SSH


## Nomenclature

### EC2's Tags
Une instance EC2 doit avoir au minimum c'est 3 balises pour que le déploiement continu fonctionne

| key | value | 
| ------------ | ----------- | 
|slug | api develop |
|Name | api-develop.nicocaill13.fr |
|env | develop | 


### Target Group
Le target group AWS doit respecter la nomenclature suivante.

#### Target Group simple
| EC2 | Target Group | is correct? |
| ------------ | ----------- | -----------|
|api-develop.nicocaill13.fr | api-develop-nicocaill13-fr-80 | yes |
|api.nicocaill13.fr | api-nicocaill13-fr-80-1 | no |
|api.nicocaill13.fr | api-develop-nicocaill13-fr-80 | no |

#### Target Group multiple
| EC2 | Target Group | is correct? |
| ------------ | ----------- | -----------|
|api-develop.nicocaill13.fr | api-develop-nicocaill13-fr-80 | no |
|api-develop.nicocaill13.fr | api-develop-nicocaill13-fr-80-1 | yes |
|api-develop.nicocaill13.fr | api-develop-nicocaill13-fr-80-2 | yes |


### EC2 AMI

L'AMI doit être disponible dans la console AWS. Si l'image est trop vieille et plus disponible, il faudra en créér une.    
Une AMI doit avoir un Nom, une description, une balise Name et une balise name correct pour que la création de l'image se déroule bien.

| Nom | description | tag Name | tag name |
| ------------ | ------------ | ------------ | ------------ | 
|api-develop-nicocaill13-fr-20210127-001 | api-develop-nicocaill13-fr-20210127-001 | api-develop-nicocaill13-fr-20210127-001 | api develop|

## Command on v1
* Pour vérifier le plan d'exécution
```shell script
./check.sh api develop api api 80 1 public dockerOn 
```
* Pour exécuter le plan
```shell script
./apply.sh api develop api api 80 1 public dockerOn 
```

### Arguments
* `$1` Nom de l'appli (1ère partie de la balise AWS slug de l'EC2)
* `$2` Environnement (develop/prod) (2ème partie de la balise AWS slug de l'EC2)
* `$3` Dossier de destination (/var/www/html/api)
* `$4` Nom du projet Gitlab (/!\ l'API Gitlab fait un "like" sur l'expression fournie)
* `$5` le port utilisé par le target group AWS
* `$6` le nombre de Target Group ? (1/n, si absent on considère 1)
* `$7` S'agit-il d'une application public ? (public/private, si absent ou différent de public on considère private)
* `$8` S'agit-il d'une application sous Docker ? (DockerOn/DockerOff, si absent ou différent de DockerOff on considère DockerOn)

## Command on v2
* Pour vérifier le plan d'exécution
```shell script
./check.sh
```
* Pour exécuter le plan
```shell script
./apply.sh
```

### Arguments
Dans cette version, on utlise les variables d'environnements pour terraform, en utilisant le préfix ```TF_VAR_```
* `TF_VAR_ENV` utilisé pour tagé EC2
* `TF_VAR_SLUG` utilisé pour tagé EC2
* `TF_VAR_NAME` utilisé pour tagé EC2
* `TF_VAR_INSTANCE` instance type EC2
* `TF_VAR_AMI` tag ami à utiliser
* `TF_VAR_PUBLIC` subnet public or private
* `TF_VAR_DOMAIN` le nom de domaine
* `TF_VAR_ALIAS` l'alias
* `TF_VAR_STATUS` CI or MERGE

## Prerequisites on v2
* un compte aws
* aws cli installé
* configurer aws sur la machine
* terraform installé
* un accès SSH
* un utilisateur terraform
* une zone dns créer
* une AMI créer

Ne pas oublier de compléter les variables dans le fichier ```variables.tf```


### Terraform user
Une bonne pratique est de créer un utilisateur terraform dans la console AWS et lui accordé les droits nécessaire.  
Ensuite une edition du fichier```  ~/.aws/credentials ``` pour créer le profil utilisateur 

```shell script
[terraform]
aws_access_key_id = **********
aws_secret_access_key = ****************
```

### Notre AMI
Notre AMI est basé sur un serveur Ubuntu 20.04 avec nginx installé, PM2 pour gérer node en cluster. Le code source est dans le répertoire ``` /var/www/project``` 

### Conf Nginx
``` nano /etc/nginx/sites-available/default ```
```shell script
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/project;

	server_name _;

	location / {
		proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
	}

}
```

### Déploiement
Le déploiement est fait via les GitHub Actions donc certaines actions sont indépendantes de terraform
* installation dépendances  
* build pour la prod
* retrait des devDependencies
* changement des variables dans le fichier .env
* ...


## Comportement

Le script va vérifier si un workspace terraform existe et en créér un s'il n'existe pas.  
Toute l'activité terraform, appelé 'state' est stocké sur S3. Ce state est consulté à chaque execution pour vérifier si la ressource existe ou pas.  Dans notre cas, un EC2 sera créer qu'une seule fois.  

* récupération AMI
* création EC2
* update du code source
* création d'un load balancer
* identification aupres de let's encrypt
* création d'un enregistrement sur route 53
* création du certificat
* création ecouteur port 80 et 443 