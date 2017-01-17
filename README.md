# Configurations
Ce dépot permet de configurer cygwin (git bash) pour windows
### Pré-requis
* Avoir node / npm d'installer
* Installer git pour windows

### Dependance
1. diff so fancy permet de stylisé les diff de facon plus lisible
```$ npm install -g diff-so-fancy```
2. git Credential
[Depot git](https://github.com/Microsoft/Git-Credential-Manager-for-Windows/eleases) pour récupérer l'installeur
3.[Installer meld](http://meldmerge.org/) pour gérer les conflits

## Installation
1. Il faut cloner le répertoire 
```$ git clone https://github.com/WhyThat/Configurations.git```
2. Copier tous les fichiers du dépot dans le dossier d'utilisateur /!\ Ceci remplacera toutes vos précédente configuration Git 
```$ cp .* /c/Users/NomUtilisateur```
3. Parametrer l'utilisateur par défaut de git
```$ git config --global user.name "John DOE"```
```$ git config --global user.email "John DOE"```

