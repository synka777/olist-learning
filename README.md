# Olist: ETL de données et SQL avancé

## 🎯 Objectif

Le but de ce projet est de lire, nettoyer, concevoir un modèle de données et charger les données dans la base en autonomie, afin d'avoir un environnement de travail fiable pour pratiquer SQL sur le reste de la semaine.

## 🗃️ Source de données:

Il a fallu aller chercher les données sur Kaggle en filtrant sur le type `dataset`, avec le terme `olist`.

Lien vers les datasets:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?resource=download

## 🪣 Base de données

Comme conseillé par Orkun, j'ai choisi sqlite pour un setup simple et rapide.

## 🪚 Lancement du projet

1. Installer les prérequis:
```bash
pip install -r requirements.txt
```

2. Copier les datasets dans le projet
Télécharger et positionner les 9 datasets olist dans le sous-répertoire `./data/`.

3. Utilisation du projet
Ensuite, il n'y a plus qu'à utiliser le notebook `process.ipynb` présent à la racine du projet.