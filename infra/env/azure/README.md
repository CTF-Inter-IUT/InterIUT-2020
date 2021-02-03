# Cluster kubernetes sur Azure

La configuration de l'infrastructure est divise en deux parties :

La premiere "cluster" premet de creer un cluster kubernetes en utilisant AKS (Azure Kubernetes Service).

La deuxieme partie permet de configurer le cluster kubernetes avec les principaux deploiements
necessaires au CTF. Veuillez noter que les challenges ne sont pas deployes.

Comme la configuration du provider du module "k8s" depend directement de la sortie du module "cluster", il est necessaire de rediriger la sortie du module "cluster" avant d'appliquer le module "k8s".

Par exemple :
```bash
terraform apply 
```