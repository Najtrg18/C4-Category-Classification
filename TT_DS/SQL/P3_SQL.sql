-- Requetes ecrites et executees sur MySQL Workbench

-- Premiere requete - option 1 avec montant global total
SELECT 
	IF (GROUPING(t.date), 'All Dates', DATE(t.date)) AS date, -- Pour afficher la date au format jour (sans heure) et le montant global sous format "All Dates"
	ROUND(sum(t.prod_price * t.prod_qty), 2) AS montant_ventes_EUR -- Pour afficher le chiffre d’affaires (le montant total des ventes = prix produit * quantite produit). Aucune ambiguite sur le prix produit etant le prix unitaire au vue du resultat fourni pour la requete 2.
FROM transaction t
WHERE t.date BETWEEN "2019-01-01" AND "2019-12-31" -- du 1er janvier 2019 au 31 décembre 2019 comme demande. Notons que les echantillons fournis indiquent 2020 et non 2019.
GROUP BY t.date WITH ROLLUP -- pour grouper par date et avoir un resultat jour par jour, et aussi pour obtenir le total
ORDER BY t.date -- pour trier les jours

-- Premiere requete - option 1 sans montant global total
SELECT 
	DATE(t.date), -- Pour afficher la date au format jour (sans heure)
    ROUND(sum(t.prod_price * t.prod_qty), 2) AS montant_ventes_EUR -- Pour afficher le chiffre d’affaires (le montant total des ventes = prix produit * quantite produit). Aucune ambiguite sur le prix produit etant le prix unitaire au vue du resultat fourni pour la requete 2.
FROM transaction t
WHERE t.date BETWEEN "2019-01-01" AND "2019-12-31" -- du 1er janvier 2019 au 31 décembre 2019 comme demande. Notons que les echantillons fournis indiquent 2020 et non 2019.
GROUP BY t.date  -- pour grouper par date et avoir un resultat jour par jour, et aussi pour obtenir le total
ORDER BY t.date -- pour trier les jours

-- Deuxieme requete 
SELECT 
	t.client_id AS client_id, -- pour afficher le client
	SUM(IF(p.product_type = "MEUBLE", t.prod_price * t.prod_qty, 0)) AS ventes_meuble, -- les ventes meuble réalisées
	SUM(IF(p.product_type = "DECO", t.prod_price * t.prod_qty, 0)) AS ventes_deco -- les ventes déco réalisées
FROM transaction t
	INNER JOIN product p
		ON t.prod_id = p.product_id 
			WHERE t.date BETWEEN "2019-01-01" AND "2019-12-31" -- période allant du 1er janvier 2019 au 31 décembre 2019
GROUP BY t.client_id -- groupe par client. D'apres l'echantillon fourni, je comprends qu'il n'est pas demande de les ordonner.
-- Note: Je comprends que l'echantillon resultat fourni est surtout pour indiquer le format. Il n'est en aucun cas le resultat de la requete qui est pour des dates en 2019, et non 2020.