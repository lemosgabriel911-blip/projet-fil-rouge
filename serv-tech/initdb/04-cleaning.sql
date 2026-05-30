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

INSERT INTO
    type_mobilier (libelle)
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
        END
    ) AS type_mobilier_nettoye
FROM staging.inventaire;
-- Nettoyage inventaire mobilier

INSERT INTO
    type_materiau (libelle)
SELECT DISTINCT (
        CASE
            WHEN LOWER(TRIM("materiau")) LIKE '%bois%' THEN 'bois'
            WHEN LOWER(TRIM(unaccent ("materiau"))) LIKE '%metal%' THEN 'metal'
            WHEN LOWER(TRIM("materiau")) LIKE '%sodium%' THEN 'sodium'
            WHEN LOWER(TRIM("materiau")) LIKE '%led%' THEN 'led'
            WHEN LOWER(TRIM("materiau")) LIKE '%pierre%' THEN 'pierre'
            WHEN LOWER(TRIM(unaccent ("materiau"))) LIKE '%beton%' THEN 'beton'
            ELSE 'non spécifié'
        END
    ) AS type_materiau_nettoye
FROM staging.inventaire;
-- Nettoyage inventaire materiau

INSERT INTO
    etat_inventaire (libelle)
SELECT DISTINCT (
        CASE
            WHEN LOWER(TRIM("etat")) LIKE '%bon%' THEN 'bon'
            WHEN LOWER(TRIM(unaccent ("etat"))) LIKE '%a remplacer%' THEN 'a remplacer'
            WHEN LOWER(TRIM(unaccent ("etat"))) LIKE '%use%' THEN 'use'
            ELSE 'non spécifié'
        END
    ) AS etat_inventaire_nettoye
FROM staging.inventaire;
-- Nettoyage inventaire etat

INSERT INTO
    type_materiel (libelle)
SELECT DISTINCT
    CASE
        WHEN LOWER(TRIM(materiel_value)) LIKE '%bancs bois%' THEN 'bancs bois'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%bancs%' THEN 'bancs'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%poubelles%' THEN 'poubelles'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%peinture%' THEN 'peinture'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%bornes%' THEN 'bornes recharge EV'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%nettoyage%' THEN 'nettoyage'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%panneaux%' THEN 'panneaux'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%visserie%' THEN 'visserie'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%tables%' THEN 'tables'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%plantations%' THEN 'plantations'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%abris bus%' THEN 'abris bus'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%reprise%' THEN 'reprise mobilier'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%tags%' THEN 'tags'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%fontaines%' THEN 'fontaines'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%conduites%' THEN 'conduites'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%vasques%' THEN 'vasques'
        WHEN LOWER(
            TRIM(
                public.unaccent (materiel_value)
            )
        ) LIKE '%bancs metal%' THEN 'bancs metal'
        WHEN LOWER(
            TRIM(
                public.unaccent (materiel_value)
            )
        ) LIKE '%eclairage led%' THEN 'eclairage led'
        WHEN LOWER(
            TRIM(
                public.unaccent (materiel_value)
            )
        ) LIKE '%eclairage%' THEN 'eclairage'
        WHEN LOWER(
            TRIM(
                public.unaccent (materiel_value)
            )
        ) LIKE '%petites pieces%' THEN 'petites pieces'
        ELSE 'non spécifié'
    END AS libelle
FROM staging.fournisseur f, UNNEST(
        regexp_split_to_array(f.materiel, ',\s*')
    ) AS materiel_value
WHERE
    f.materiel IS NOT NULL;

-- -- A FAIRE nettoyage, éclatement et liaison fournisseur materiel

INSERT INTO
    signal_urgence (libelle)
SELECT DISTINCT (
        CASE
            WHEN urgence IS NULL
            OR TRIM("urgence") = '' THEN 'non urgent'
            WHEN LOWER(TRIM("urgence")) LIKE '%normal%' THEN 'urgence moderee'
            WHEN LOWER(TRIM("urgence")) LIKE '%urgent%' THEN 'urgence majeure'
            ELSE 'non spécifié'
        END
    ) AS signal_urgence_nettoye
FROM staging.signalements;
-- Nettoyage signal_urgence urgence

INSERT INTO
    signal_statut (libelle)
SELECT DISTINCT (
        CASE
            WHEN statut IS NULL
            OR TRIM("statut") = '' THEN 'a planifier'
            WHEN LOWER(TRIM("statut")) LIKE '%en attente%' THEN 'en attente'
            WHEN LOWER(TRIM("statut")) LIKE '%en cours%' THEN 'en cours'
            WHEN LOWER(TRIM("statut")) LIKE '%fait%' THEN 'fait'
            ELSE 'non spécifié'
        END
    ) AS signal_statut_nettoye
FROM staging.signalements;
-- Nettoyage signal_statut urgence

INSERT INTO
    type_interv (libelle)
SELECT DISTINCT (
        CASE
            WHEN LOWER(TRIM("type_intervention")) LIKE '%remplacement%' THEN 'remplacement'
            WHEN LOWER(TRIM("type_intervention")) LIKE '%remise en service%' THEN 'remise en service'
            WHEN LOWER(TRIM("type_intervention")) LIKE '%peinture%' THEN 'peinture'
            WHEN LOWER(TRIM("type_intervention")) LIKE '%nettoyage%' THEN 'nettoyage'
            WHEN LOWER(TRIM("type_intervention")) LIKE '%mise%jour%logiciel%' THEN 'mise a jour logiciel'
            WHEN LOWER(TRIM("type_intervention")) LIKE '%hivernage%' THEN 'hivernage'
            WHEN LOWER(TRIM(public.unaccent ("type_intervention"))) LIKE '%detartrage%' THEN 'detartrage'
            WHEN LOWER(TRIM(public.unaccent ("type_intervention"))) LIKE '%reparation%' THEN 'reparation'
            WHEN LOWER(TRIM(public.unaccent ("type_intervention"))) LIKE '%redressage mat%' THEN 'redressage mat'
            ELSE 'non spécifié'
        END
    ) AS type_inter_nettoye
FROM staging.interventions;

------------------------------------------TABLES NORMALES---------------------------------------
INSERT INTO
    public.fournisseur (
        entreprise,
        contact,
        telephone,
        email,
        remarques
    )
SELECT DISTINCT
    TRIM(f.entreprise),
    CASE
        WHEN f.contact IS NULL
        OR TRIM(f.contact) = '' THEN 'Non spécifié'
        ELSE TRIM(f.contact)
    END,
    CASE
        WHEN TRIM(f.telephone) ~ '^\+41 \d{2} \d{3} \d{2} \d{2}$' THEN (
            '0' || regexp_replace(
                TRIM(f.telephone),
                '^\+41 (\d{2}) (\d{3}) (\d{2}) (\d{2})$',
                '\1\2\3\4'
            )
        )::BIGINT
        WHEN TRIM(f.telephone) ~ '^\d{2} \d{3} \d{2} \d{2}$' THEN (
            '0' || regexp_replace(
                TRIM(f.telephone),
                ' ',
                '',
                'g'
            )
        )::BIGINT
        WHEN TRIM(f.telephone) ~ '^\d{3} \d{3} \d{2} \d{2}$' THEN regexp_replace(
            TRIM(f.telephone),
            ' ',
            '',
            'g'
        )::BIGINT
        WHEN TRIM(f.telephone) ~ '^\d{10}$' THEN TRIM(f.telephone)::BIGINT
        ELSE NULL
    END,
    CASE
        WHEN f.email IS NULL
        OR TRIM(f.email) = '' THEN 'Non spécifié'
        ELSE TRIM(f.email)
    END,
    CASE
        WHEN f.remarques IS NULL
        OR TRIM(f.remarques) = '' THEN 'Non spécifié'
        ELSE TRIM(f.remarques)
    END
FROM staging.fournisseur f
WHERE
    f.entreprise IS NOT NULL;
--Table fournisseurs faite

INSERT INTO
    public.signalement (
        date_signalement,
        signale_par,
        objet,
        description,
        id_signal_urgence,
        id_signal_statut
    )
SELECT DISTINCT
    CASE
        WHEN st.date LIKE '%.%.%' THEN to_date(st.date, 'DD.MM.YYYY')
        WHEN st.date LIKE '%-%-%' THEN to_date(st.date, 'YYYY-MM-DD')
    END AS date_signalement,
    CASE
        WHEN st.signale_par IS NULL
        OR TRIM(st.signale_par) = '' THEN 'inconnu'
        WHEN LOWER(TRIM(st.signale_par)) LIKE '%habitant%' THEN 'habitant'
        WHEN LOWER(TRIM(st.signale_par)) LIKE '%patrouille jm%' THEN 'patrouille'
        WHEN LOWER(TRIM(st.signale_par)) LIKE '%email citoyen%' THEN 'email'
        WHEN LOWER(TRIM(st.signale_par)) LIKE '%un passant%' THEN 'passant'
        WHEN TRIM(st.signale_par) LIKE 'M. %' THEN TRIM(st.signale_par)
        WHEN TRIM(st.signale_par) LIKE 'Mme %' THEN TRIM(st.signale_par)
        WHEN LOWER(
            public.unaccent (TRIM(st.signale_par))
        ) LIKE '%concierge ecole%' THEN 'concierge'
        ELSE 'non spécifié'
    END AS signale_par,
    TRIM(st.objet) AS objet,
    TRIM(st.description) AS description,
    su.id AS id_signal_urgence,
    ss.id AS id_signal_statut
FROM
    staging.signalements st
    JOIN signal_urgence su ON su.libelle = CASE
        WHEN st.urgence IS NULL
        OR TRIM(st.urgence) = '' THEN 'non urgent'
        WHEN LOWER(TRIM(st.urgence)) LIKE '%normal%' THEN 'urgence moderee'
        WHEN LOWER(TRIM(st.urgence)) LIKE '%urgent%' THEN 'urgence majeure'
        ELSE 'non spécifié'
    END
    JOIN signal_statut ss ON ss.libelle = CASE
        WHEN st.statut IS NULL
        OR TRIM(st.statut) = '' THEN 'a planifier'
        WHEN LOWER(TRIM(st.statut)) LIKE '%en attente%' THEN 'en attente'
        WHEN LOWER(TRIM(st.statut)) LIKE '%en cours%' THEN 'en cours'
        WHEN LOWER(TRIM(st.statut)) LIKE '%fait%' THEN 'fait'
        ELSE 'non spécifié'
    END
WHERE
    st.date IS NOT NULL;
-- Nettoyage table signalement

INSERT INTO public.interventions (date_intervention, objet, technicien, duree, cout_materiel, remarques, id_type_interv)
SELECT
  CASE
    WHEN i.date LIKE '%.%.%' THEN to_date(i.date, 'DD.MM.YYYY')
    WHEN i.date LIKE '%-%-%' THEN to_date(i.date, 'YYYY-MM-DD')
  END AS date_intervention,
  TRIM(i.objet) AS objet,
  CASE
    WHEN TRIM(i.technicien) IN ('JM', 'Jean-Marc', 'Jean-Marc Bonvin') THEN 'Jean-Marc Bonvin'
    WHEN TRIM(i.technicien) IN ('Alves Pedro', 'Pedro', 'P. Alves')    THEN 'Pedro Alves'
    WHEN TRIM(i.technicien) = 'Koffi Marc'                             THEN 'Marc Koffi'
    WHEN LOWER(TRIM(i.technicien)) = 'stagiaire'                       THEN 'stagiaire'
    ELSE TRIM(i.technicien)
  END AS technicien,
  CASE
    WHEN LOWER(TRIM(i.duree)) LIKE '%journée%'  THEN '08:00'::TIME
    WHEN LOWER(TRIM(i.duree)) LIKE '%matinée%'  THEN '04:00'::TIME
    WHEN TRIM(i.duree) ~ '^\d+h\d+$'            THEN (REGEXP_REPLACE(TRIM(i.duree), '(\d+)h(\d+)', '\1:\2'))::TIME
    WHEN TRIM(i.duree) ~ '^\d+h$'               THEN (REGEXP_REPLACE(TRIM(i.duree), '(\d+)h', '\1:00'))::TIME
    WHEN TRIM(i.duree) ~ '^\d+ min$'            THEN ('00:' || LPAD(REGEXP_REPLACE(TRIM(i.duree), '(\d+) min', '\1'), 2, '0'))::TIME
    ELSE NULL
  END AS duree,
  CASE
    WHEN TRIM(i.cout_materiel) = '0'                             THEN 0
    WHEN LOWER(TRIM(i.cout_materiel)) IN ('gratuit', 'garantie') THEN 0
    WHEN i.cout_materiel IS NULL OR TRIM(i.cout_materiel) = ''   THEN 0
    WHEN TRIM(i.cout_materiel) ~ '^CHF \d+\.-$'                  THEN REGEXP_REPLACE(TRIM(i.cout_materiel), 'CHF (\d+)\.-', '\1')::INTEGER
    WHEN TRIM(i.cout_materiel) ~ '^\d+\.-$'                      THEN REGEXP_REPLACE(TRIM(i.cout_materiel), '(\d+)\.-', '\1')::INTEGER
    WHEN TRIM(i.cout_materiel) ~ '^\d+$'                         THEN TRIM(i.cout_materiel)::INTEGER
    ELSE 0
  END AS cout_materiel,
  CASE
    WHEN i.remarques IS NULL OR TRIM(i.remarques) = '' THEN 'non spécifié'
    ELSE TRIM(i.remarques)
  END AS remarques,
  ti.id AS id_type_interv
FROM staging.interventions i
JOIN public.type_interv ti ON ti.libelle = CASE
  WHEN LOWER(TRIM(i.type_intervention)) LIKE '%remise en service%'               THEN 'remise en service'
  WHEN LOWER(TRIM(i.type_intervention)) LIKE '%remplacement%'                    THEN 'remplacement'
  WHEN LOWER(TRIM(i.type_intervention)) LIKE '%peinture%'                        THEN 'peinture'
  WHEN LOWER(TRIM(i.type_intervention)) LIKE '%nettoyage%'                       THEN 'nettoyage'
  WHEN LOWER(TRIM(i.type_intervention)) LIKE '%mise%jour%logiciel%'              THEN 'mise a jour logiciel'
  WHEN LOWER(TRIM(i.type_intervention)) LIKE '%hivernage%'                       THEN 'hivernage'
  WHEN LOWER(TRIM(public.unaccent(i.type_intervention))) LIKE '%detartrage%'     THEN 'detartrage'
  WHEN LOWER(TRIM(public.unaccent(i.type_intervention))) LIKE '%reparation%'     THEN 'reparation'
  WHEN LOWER(TRIM(public.unaccent(i.type_intervention))) LIKE '%redressage mat%' THEN 'redressage mat'
  ELSE 'non spécifié'
END
WHERE i.date IS NOT NULL;

--A FAIRE INTERVENTION

INSERT INTO public.inventaire (lieu, latitude, longitude, date_installation, remarques, id_type_mobilier, id_type_materiau, id_etat_inventaire)
SELECT
  TRIM(i.lieu),
  CASE WHEN i.latitude IS NULL OR TRIM(i.latitude) = '' THEN 46.77839 ELSE TRIM(i.latitude)::DECIMAL(10,5) END,
  CASE WHEN i.longitude IS NULL OR TRIM(i.longitude) = '' THEN 6.64118 ELSE TRIM(i.longitude)::DECIMAL(10,5) END,
  CASE
    WHEN i.date_installation ~ '^\d{2}\.\d{2}\.\d{4}$' THEN to_date(i.date_installation, 'DD.MM.YYYY')
    WHEN i.date_installation ~ '^\d{4}-\d{2}-\d{2}$'   THEN to_date(i.date_installation, 'YYYY-MM-DD')
    WHEN i.date_installation ~ '^\d{4}$'                THEN to_date(i.date_installation || '-01-01', 'YYYY-MM-DD')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^janvier \d{4}$'   THEN to_date('01-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^fevrier \d{4}$'   THEN to_date('02-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^mars \d{4}$'      THEN to_date('03-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^avril \d{4}$'     THEN to_date('04-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^mai \d{4}$'       THEN to_date('05-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^juin \d{4}$'      THEN to_date('06-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^juillet \d{4}$'   THEN to_date('07-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^aout \d{4}$'      THEN to_date('08-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^septembre \d{4}$' THEN to_date('09-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^octobre \d{4}$'   THEN to_date('10-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^novembre \d{4}$'  THEN to_date('11-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    WHEN lower(public.unaccent(i.date_installation)) ~ '^decembre \d{4}$'  THEN to_date('12-' || split_part(i.date_installation, ' ', 2), 'MM-YYYY')
    ELSE NULL
  END,
  CASE WHEN i.remarques IS NULL OR TRIM(i.remarques) = '' THEN NULL ELSE TRIM(i.remarques) END,
  tm.id, tma.id, ei.id
FROM staging.inventaire i
JOIN type_mobilier tm ON tm.libelle = CASE
  WHEN LOWER(TRIM(i.type)) LIKE '%banc%'       THEN 'banc'
  WHEN LOWER(TRIM(i.type)) LIKE '%lampadaire%' THEN 'lampadaire'
  WHEN LOWER(TRIM(i.type)) LIKE '%corbeille%'  THEN 'poubelle'
  WHEN LOWER(TRIM(i.type)) LIKE '%poubelle%'   THEN 'poubelle'
  WHEN LOWER(TRIM(i.type)) LIKE '%fontaine%'   THEN 'fontaine'
  WHEN LOWER(TRIM(i.type)) LIKE '%borne%'      THEN 'borne recharge EV'
  WHEN LOWER(TRIM(i.type)) LIKE '%panneau%'    THEN 'panneau'
  ELSE 'non spécifié' END

JOIN type_materiau tma ON tma.libelle = CASE
    WHEN LOWER(TRIM(i.materiau)) LIKE '%bois%' THEN 'bois'
    WHEN LOWER(
        public.unaccent (TRIM(i.materiau))
    ) LIKE '%metal%' THEN 'metal'
    WHEN LOWER(TRIM(i.materiau)) LIKE '%sodium%' THEN 'sodium'
    WHEN LOWER(TRIM(i.materiau)) LIKE '%led%' THEN 'led'
    WHEN LOWER(TRIM(i.materiau)) LIKE '%pierre%' THEN 'pierre'
    WHEN LOWER(
        public.unaccent (TRIM(i.materiau))
    ) LIKE '%beton%' THEN 'beton'
    ELSE 'non spécifié'
END
JOIN etat_inventaire ei ON ei.libelle = CASE
    WHEN LOWER(TRIM(i.etat)) LIKE '%bon%' THEN 'bon'
    WHEN LOWER(
        public.unaccent (TRIM(i.etat))
    ) LIKE '%a remplacer%' THEN 'a remplacer'
    WHEN LOWER(
        public.unaccent (TRIM(i.etat))
    ) LIKE '%use%' THEN 'use'
    ELSE 'non spécifié'
END
WHERE
    i.lieu IS NOT NULL
    AND i.date_installation IS NOT NULL;

-----------------TABLES DE LIAISON-------------------------------

-- (Pour certaines liaisons nous avons utilisé l'aide de l'IA)

INSERT INTO
    public.fournisseur_materiel (
        id_fournisseurs,
        id_type_materiel
    )
SELECT DISTINCT
    pf.id,
    tm.id
FROM
    staging.fournisseur f
    CROSS JOIN LATERAL UNNEST(
        regexp_split_to_array(f.materiel, ',\s*')
    ) AS materiel_value
    JOIN public.fournisseur pf ON pf.entreprise = TRIM(f.entreprise)
    JOIN public.type_materiel tm ON tm.libelle = CASE
        WHEN LOWER(TRIM(materiel_value)) LIKE '%bancs bois%' THEN 'bancs bois'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%bancs%' THEN 'bancs'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%poubelles%' THEN 'poubelles'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%peinture%' THEN 'peinture'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%bornes%' THEN 'bornes recharge EV'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%nettoyage%' THEN 'nettoyage'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%panneaux%' THEN 'panneaux'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%visserie%' THEN 'visserie'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%tables%' THEN 'tables'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%plantations%' THEN 'plantations'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%abris bus%' THEN 'abris bus'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%reprise%' THEN 'reprise mobilier'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%tags%' THEN 'tags'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%fontaines%' THEN 'fontaines'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%conduites%' THEN 'conduites'
        WHEN LOWER(TRIM(materiel_value)) LIKE '%vasques%' THEN 'vasques'
        WHEN LOWER(
            TRIM(
                public.unaccent (materiel_value)
            )
        ) LIKE '%bancs metal%' THEN 'bancs metal'
        WHEN LOWER(
            TRIM(
                public.unaccent (materiel_value)
            )
        ) LIKE '%eclairage led%' THEN 'eclairage led'
        WHEN LOWER(
            TRIM(
                public.unaccent (materiel_value)
            )
        ) LIKE '%eclairage%' THEN 'eclairage'
        WHEN LOWER(
            TRIM(
                public.unaccent (materiel_value)
            )
        ) LIKE '%petites pieces%' THEN 'petites pieces'
        ELSE 'non spécifié'
    END
WHERE
    f.materiel IS NOT NULL;

TRUNCATE public.interv_signal;

INSERT INTO public.interv_signal (id_signalement, id_interventions)
SELECT DISTINCT s.id, iv.id
FROM public.signalement s
JOIN public.interventions iv 
   ON LOWER(TRIM(iv.objet)) = LOWER(TRIM(s.objet));
-- Table de liaison interv_signal faite

TRUNCATE public.signal_invent;

INSERT INTO public.signal_invent (id_signalement, id_inventaire)
SELECT DISTINCT
   s.id AS id_signalement,
   (
      SELECT inv.id
      FROM public.inventaire inv
      JOIN public.type_mobilier tm ON inv.id_type_mobilier = tm.id
      WHERE LOWER(TRIM(st.objet)) LIKE '%' || tm.libelle || '%'
      ORDER BY inv.id
      LIMIT 1
   ) AS id_inventaire
FROM staging.signalements st
JOIN public.signalement s
   ON s.objet = TRIM(st.objet)
   AND s.date_signalement = CASE
      WHEN st.date LIKE '%.%.%' THEN to_date(st.date, 'DD.MM.YYYY')
      WHEN st.date LIKE '%-%-%' THEN to_date(st.date, 'YYYY-MM-DD')
   END
WHERE
   st.date IS NOT NULL
   AND st.objet IS NOT NULL
   AND EXISTS (
      SELECT 1
      FROM public.inventaire inv
      JOIN public.type_mobilier tm ON inv.id_type_mobilier = tm.id
      WHERE LOWER(TRIM(st.objet)) LIKE '%' || tm.libelle || '%'
   );
-- Table de liaison signal_invent faite