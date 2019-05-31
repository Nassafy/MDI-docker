# TP Docker

Le fichier Dockerfile permet crée deux images docker:
	- une contenant toute les dépendance de build permettannt de générer tout les dochier utile à l'éxécution du programme (environ 8gb).
	- une autre contenant uniquement le minimum necéssaire pour lancer le programme (617mb).

L'image de production peut être récupérer directement sur dockerhub à l'adresse nassafy/tpdocker.


Le serveur se lance à l'exécution du docker, il ne reste donc plus qu'à aller à l'adresse http://localhost:8080 pour accéder à l'application.
