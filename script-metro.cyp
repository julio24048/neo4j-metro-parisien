// calcul du plus court trajet entre 2 stations du métro parisien

//déclaration des stations de départ et d'arrivée
MATCH (depart :Station {nom : 'Convention'})
MATCH (arrivee :Station {nom : 'Cardinal Lemoine'})


//sous requête pour récupérer les lignes de métro connectant les stations de départ et d'arrivée
CALL  {
    WITH depart
    OPTIONAL MATCH (depart)-[lignesdepart :Ligne]-()
    RETURN lignesdepart.noligne as lignes
    UNION
    WITH arrivee
    OPTIONAL MATCH (arrivee)-[lignesarrivee :Ligne]-()
    RETURN lignesarrivee.noligne as lignes
}
//récupération des variables et mise en place d'une liste à partir des lignes concernées
WITH depart, arrivee,  COLLECT(lignes) AS lesLignes

//tentative pour trouver un chemin avec uniquement les lignes des stations de départ et d'arrivée
OPTIONAL MATCH trajet = SHORTESTPATH ((depart)-[*]-(arrivee))
WHERE ALL(r IN RELATIONSHIPS(trajet) WHERE r.noligne IN lesLignes)

//récupération des variables précédentes
WITH depart, arrivee, trajet, LENGTH(trajet) AS nbstations, lesLignes

//Recherche d'un trajet le plus court sans contrainte et récupération des lignes de correspondances
OPTIONAL MATCH tmptraj2 = SHORTESTPATH ((depart)-[*]-(arrivee))
UNWIND relationships(tmptraj2) AS lesLignes2

// récupération du trajet le plus court en utilisant seulement une seule des lignes de correspondances
WITH DISTINCT lesLignes2.noligne AS correspondance, depart, arrivee, lesLignes, trajet, nbstations
OPTIONAL MATCH trajet2 = SHORTESTPATH ((depart)-[*]-(arrivee))
WHERE ALL(r IN RELATIONSHIPS(trajet2) WHERE r.noligne IN lesLignes OR r.noligne = correspondance)
WITH trajet2, LENGTH(trajet2) AS nbstations2, trajet, nbstations
ORDER BY nbstations2
LIMIT 1

//sélection du trajet final en appliquant un handicap de 5 stations (5 minutes environ) pour compenser le temps de correspondance pour le trajet impliquant une correspondance supplémentaire
WITH trajet, nbstations, trajet2, nbstations2,
CASE
    WHEN nbstations <= nbstations2 + 5 THEN  trajet
    ELSE trajet2
END AS trajetfinal
RETURN trajetfinal
