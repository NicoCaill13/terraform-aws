# Deploying infrastructure on AWS

## Introduction
La recherche des différentes instances EC2 se fait sur les balises.  
Pour que le déploiement continu fonctionne, une nomenclature à respecter est obligatoire.  
Pour une meilleure lecture des Tags et balises adopter dans notre nomenclature, nous partons du prinicpe que :
* le service est une ***API***
* le nom de domaine est ***nicocaill13***
* l'environement est ***develop***

## Prerequisites
* un compte aws
* aws cli installé
* configurer aws sur la machine
* terraform installé
* un accès SSH

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

## Command
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