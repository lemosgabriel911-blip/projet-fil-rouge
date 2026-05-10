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

WITH materiel_eclate AS (
    SELECT
        f.entreprise,
        materiel_value
    FROM staging.fournisseur f,
         UNNEST(regexp_split_to_array(f.materiel, ', *')) AS materiel_value
    WHERE f.materiel IS NOT NULL
),

materiel_normalise AS (
    SELECT DISTINCT
        entreprise,
        CASE
            WHEN LOWER(TRIM(materiel_value)) LIKE '%bancs%' THEN 'bancs'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%bancs bois%' THEN 'bancs bois'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%poubelles%' THEN 'poubelles'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%peinture%' THEN 'peinture'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%bornes%' THEN 'bornes recharge EV'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%nettoyage%' THEN 'nettoy age'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%panneaux%' THEN 'panneaux'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%visserie%' THEN 'visserie'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%tables%' THEN 'tables'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%plantations autour mobilier%' THEN 'plantations'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%abris bus%' THEN 'abris bus'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%reprise ancien mobilier%' THEN 'reprise mobilier'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%tags%' THEN 'tags'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%fontaines%' THEN 'fontaines'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%conduites%' THEN 'conduites'
            WHEN LOWER(TRIM(materiel_value)) LIKE '%vasques%' THEN 'vasques'
            WHEN LOWER(TRIM(unaccent(materiel_value))) LIKE '%bancs métal%' THEN 'bancs metal'
            WHEN LOWER(TRIM(unaccent(materiel_value))) LIKE '%éclairage LED%' THEN 'eclairage led'
            WHEN LOWER(TRIM(unaccent(materiel_value))) LIKE '%éclairage%' THEN 'eclairage'
            WHEN LOWER(TRIM(unaccent(materiel_value))) LIKE '%petites pièces%' THEN 'petites pieces'
            ELSE 'non spécifié'
        END AS libelle
    FROM materiel_eclate
)
INSERT INTO public.fournisseur_materiel (fournisseur_id, type_materiel_id)
SELECT DISTINCT
    pf.id,
    tm.id
FROM materiel_normalise mn
JOIN public.fournisseur pf ON pf.entreprise = mn.entreprise
JOIN public.type_materiel tm ON mn.libelle = tm.libelle;

-- A FAIRE nettoyage, éclatement et liaison fournisseur materiel

INSERT INTO signal_urgence (libelle)
SELECT DISTINCT (
    CASE
        WHEN urgence IS NULL OR TRIM("urgence") = '' THEN 'non urgent'
        WHEN LOWER(TRIM("urgence")) LIKE '%normal%' THEN 'urgence moderee'
        WHEN LOWER(TRIM("urgence")) LIKE '%urgent%' THEN 'urgence majeure'
        ELSE 'non spécifié'
     END ) AS signal_urgence_nettoye
FROM staging.signalements;
-- Nettoyage signal_urgence urgence 

INSERT INTO signal_statut (libelle)
SELECT DISTINCT (
    CASE
        WHEN statut IS NULL OR TRIM("statut") = '' THEN 'a planifier'
        WHEN LOWER(TRIM("statut")) LIKE '%en attente%' THEN 'en attente'
        WHEN LOWER(TRIM("statut")) LIKE '%en cours%' THEN 'en cours'
        WHEN LOWER(TRIM("statut")) LIKE '%fait%' THEN 'fait'
        ELSE 'non spécifié'
     END ) AS signal_statut_nettoye
FROM staging.signalements;
-- Nettoyage signal_statut urgence 

------------------------------------------TABLES NORMALES---------------------------------------

INSERT INTO signalement (date_signalement)
SELECT DISTINCT (
    CASE
        WHEN date LIKE '%.%.%'
            THEN to_date (date, 'DD-MM-YYYY')
        WHEN date LIKE '_____-__-__'
        THEN to_date (date, 'DD-MM-YYYY')
        ELSE NULL
FROM staging.signalements;
-- A FAIRE Nettoyage SIGNALEMENT

INSERT INTO public.signalement (signale_par)
SELECT DISTINCT (
    CASE
        WHEN urgence IS NULL OR TRIM("signale_par") = '' THEN 'inconnu'
        WHEN LOWER(TRIM("signale_par")) LIKE '%habitant%' THEN 'habitant'
        WHEN LOWER(TRIM("signale_par")) LIKE '%patrouille JM%' THEN 'patrouille'
        WHEN LOWER(TRIM("signale_par")) LIKE '%email citoyen%' THEN 'email'
        WHEN LOWER(TRIM("signale_par")) LIKE '%un passant%' THEN 'passant'
        WHEN LOWER(TRIM("signale_par")) LIKE 'M. %' THEN TRIM(signale_par)
        WHEN LOWER(TRIM("signale_par")) LIKE 'Mme %' THEN TRIM(signale_par)
        WHEN LOWER(TRIM(public.unaccent("signale_par"))) LIKE '%concierge ecole%' THEN 'concierge'
        ELSE 'non spécifié'
     END ) AS signale_par_nettoye
FROM staging.signalements;
-- A FAIRE Nettoyage SIGNALEMENT

INSERT INTO signalement (date_signalement)
SELECT DISTINCT (
    CASE
        WHEN LOWER(TRIM("materiau")) LIKE '%bois%' THEN 'bois'
        WHEN LOWER(TRIM(unaccent("materiau"))) LIKE '%metal%' THEN 'metal'
        ELSE 'non spécifié'
     END ) AS date_signalement_nettoye
FROM staging.signalements;
-- A FAIRE Nettoyage SIGNALEMENT

INSERT INTO signalement (date_signalement)
SELECT DISTINCT (
    CASE
        WHEN LOWER(TRIM("materiau")) LIKE '%bois%' THEN 'bois'
        WHEN LOWER(TRIM(unaccent("materiau"))) LIKE '%metal%' THEN 'metal'
        ELSE 'non spécifié'
     END ) AS date_signalement_nettoye
FROM staging.signalements;
-- A FAIRE Nettoyage SIGNALEMENT
