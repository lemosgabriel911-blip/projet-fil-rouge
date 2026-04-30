CREATE EXTENSION IF NOT EXISTS unaccent;

-- select unaccent(materiau)
-- from staging.inventaire;
--Enlever accents

-- INSERT INTO
--     public.fournisseur (telephone)
-- SELECT telephone
-- FROM (
--         SELECT DISTINCT
--             CASE
--                 WHEN lower(trim(telephone)) LIKE '%+41 21 456 78 90%' THEN 214567890
--                 ELSE NULL
--             END AS telephone
--         FROM staging.fournisseur
--     )
-- WHERE
--     telephone IS NOT NULL;

-- A voir

INSERT INTO type_mobilier (libelle)
SELECT DISTINCT (
    CASE
        WHEN LOWER(TRIM("type")) LIKE '%banc%' THEN 'banc'
        WHEN LOWER(TRIM("type")) LIKE '%lampadaire%' THEN 'lampadaire'
        WHEN LOWER(TRIM("type")) LIKE '%corbeille%' THEN 'poubelle'
        WHEN LOWER(TRIM("type")) LIKE '%poubelle%' THEN 'poubelle'
        WHEN LOWER(TRIM("type")) LIKE '%fontaine%' THEN 'fontaine'
        WHEN LOWER(TRIM("type")) LIKE '%borne%' THEN 'borne recharge EV'
        WHEN LOWER(TRIM("type")) LIKE '%panneau%' THEN 'panneau'
        ELSE 'non spécifié'
     END ) AS type_mobilier_nettoye
FROM staging.inventaire;
-- Nettoyage inventaire mobilier

INSERT INTO type_materiau (libelle)
SELECT DISTINCT (
    CASE
        WHEN LOWER(TRIM("materiau")) LIKE '%bois%' THEN 'bois'
        WHEN LOWER(TRIM(unaccent("materiau"))) LIKE '%metal%' THEN 'metal'
        WHEN LOWER(TRIM("materiau")) LIKE '%sodium%' THEN 'sodium'
        WHEN LOWER(TRIM("materiau")) LIKE '%led%' THEN 'led'
        WHEN LOWER(TRIM("materiau")) LIKE '%pierre%' THEN 'pierre'
        WHEN LOWER(TRIM(unaccent("materiau"))) LIKE '%beton%' THEN 'beton'
        ELSE 'non spécifié'
     END ) AS type_materiau_nettoye
FROM staging.inventaire;
-- Nettoyage inventaire materiau

INSERT INTO etat_inventaire (libelle)
SELECT DISTINCT (
    CASE
        WHEN LOWER(TRIM("etat")) LIKE '%bon%' THEN 'bon'
        WHEN LOWER(TRIM(unaccent("etat"))) LIKE '%a remplacer%' THEN 'a remplacer'
        WHEN LOWER(TRIM(unaccent("etat"))) LIKE '%use%' THEN 'use'
        ELSE 'non spécifié'
     END ) AS etat_inventaire_nettoye
FROM staging.inventaire;
-- Nettoyage inventaire etat

INSERT INTO type_interv (libelle)
SELECT DISTINCT (
    CASE
        WHEN LOWER(TRIM("type_intervention")) LIKE '%peinture%' THEN 'peinture'
        WHEN LOWER(TRIM("type_intervention")) LIKE '%hivernage%' THEN 'hivernage'
        WHEN LOWER(TRIM("type_intervention")) LIKE '%remplacement%' THEN 'remplacement'
        WHEN LOWER(TRIM("type_intervention")) LIKE '%remise en service%' THEN 'remise en service'
        WHEN LOWER(TRIM("type_intervention")) LIKE '%nettoyage%' THEN 'nettoyage'
        WHEN LOWER(TRIM(unaccent("type_intervention"))) LIKE '%redressage mat%' THEN 'redressage mat'
        WHEN LOWER(TRIM(unaccent("type_intervention"))) LIKE '%detartrage%' THEN 'detartrage'
        WHEN LOWER(TRIM(unaccent("type_intervention"))) LIKE '%reparation%' THEN 'reparation'
        WHEN LOWER(TRIM(unaccent("type_intervention"))) LIKE '%mise a jour%' THEN 'mise a jour'
        ELSE 'non spécifié'
     END ) AS type_interv_nettoye
FROM staging.interventions;
-- Nettoyage intervention type