# neo4j-metro-parisien

Cet emplacement contient les fichiers liés à un article que j'ai écrit au sujet de l'utilisation de Neo4J pour trouver le meilleur chemin entre 2 stations du métro parisien :

https://medium.com/datascientest/comment-trouver-le-meilleur-trajet-en-m%C3%A9tro-parisien-avec-neo4j-9e3f02a58cd6

Le fichier alimentation-base permet de créer la base du métro parisien dans Neo4J. Il contient les lignes du métro hord les lignes bis. Certaines des stations les plus récemment ouvertes peuvent manquer.

Le fichier script-metro contient le code Cypher pour trouver le meilleur trajet.
