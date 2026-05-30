CREATE OR REPLACE VIEW vue_fournisseur_materiel AS
SELECT
  f.id,
  f.entreprise,
  f.contact,
  f.telephone,
  f.email,
  tm.libelle AS materiel
FROM public.fournisseur_materiel fm
JOIN public.fournisseur f ON f.id = fm.id_fournisseurs
JOIN public.type_materiel tm ON tm.id = fm.id_type_materiel
ORDER BY f.entreprise, tm.libelle;
-- VISUALISATION DANS "VIEWS" DE CHAQUE ENTREPRISE AVEC LE MATERIEL FOURNI LIGNE PAR LIGNE (Aide IA)

UPDATE public.interventions iv
SET id_inventaire = si.id_inventaire
FROM public.interv_signal its
JOIN public.signal_invent si ON si.id_signalement = its.id_signalement
WHERE its.id_interventions = iv.id
AND iv.id_inventaire IS NULL;
--MISE A JOUR IDS INVENTAIRE DANS INTERVENTION

UPDATE public.inventaire inv
SET id_fournisseur = fm.id_fournisseurs
FROM public.fournisseur_materiel fm
JOIN public.type_materiel tm ON tm.id = fm.id_type_materiel
JOIN public.type_mobilier tmob ON LOWER(tmob.libelle) LIKE '%' || LOWER(tm.libelle) || '%'
   OR LOWER(tm.libelle) LIKE '%' || LOWER(tmob.libelle) || '%'
WHERE inv.id_type_mobilier = tmob.id
AND inv.id_fournisseur IS NULL;
--MISE A JOUR ID FOURNISSEUR DANS INVENTAIRE

UPDATE public.inventaire inv
SET id_fournisseur = fm.id_fournisseurs
FROM public.type_mobilier tmob
JOIN public.type_materiel tm ON (
   (tmob.libelle = 'lampadaire' AND tm.libelle IN ('eclairage', 'eclairage led'))
   OR
   (tmob.libelle = 'borne recharge EV' AND tm.libelle = 'bornes recharge EV')
)
JOIN public.fournisseur_materiel fm ON fm.id_type_materiel = tm.id
WHERE inv.id_type_mobilier = tmob.id
AND inv.id_fournisseur IS NULL;
--CORRECTION ID FOURNISSEUR DANS INVENTAIRE

-- CRÉATION DES RÔLES

CREATE ROLE administrateur;
CREATE ROLE technicien;
CREATE ROLE citoyen;

-- ADMINISTRATEUR : tous les droits

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrateur;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO administrateur;
GRANT ALL PRIVILEGES ON SCHEMA public TO administrateur;

-- TECHNICIEN : lecture + écriture sur ses tables

GRANT SELECT, INSERT, UPDATE, DELETE
ON public.inventaire, public.signalement, public.interventions,
   public.signal_invent, public.interv_signal
TO technicien;

-- Accès en lecture seule aux tables de référence (nécessaires pour les JOINs)
GRANT SELECT
ON public.type_mobilier, public.type_materiau, public.etat_inventaire,
   public.type_interv, public.signal_urgence, public.signal_statut,
   public.type_materiel, public.fournisseur, public.fournisseur_materiel
TO technicien;

-- Accès aux séquences pour les INSERT
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO technicien;

-- CITOYEN : lecture restreinte par colonnes
-- inventaire : toutes les colonnes (pas de restriction)
GRANT SELECT ON public.inventaire TO citoyen;

-- interventions : toutes les colonnes SAUF technicien
GRANT SELECT (
   id, date_intervention, objet, duree,
   cout_materiel, remarques, id_type_interv, id_inventaire
) ON public.interventions TO citoyen;

-- signalement : toutes les colonnes SAUF signale_par
GRANT SELECT (
   id, date_signalement, objet, description,
   id_signal_urgence, id_signal_statut
) ON public.signalement TO citoyen;

CREATE OR REPLACE VIEW vue_inventaire_synthese AS
SELECT
   tm.libelle    AS type_mobilier,
   tma.libelle   AS type_materiau,
   ei.libelle    AS etat_inventaire,
   COUNT(inv.id) AS total
FROM public.inventaire inv
JOIN public.type_mobilier   tm  ON tm.id  = inv.id_type_mobilier
JOIN public.type_materiau   tma ON tma.id = inv.id_type_materiau
JOIN public.etat_inventaire ei  ON ei.id  = inv.id_etat_inventaire
GROUP BY
   tm.libelle,
   tma.libelle,
   ei.libelle
ORDER BY
   tm.libelle,
   tma.libelle,
   ei.libelle;
-- Vue synthétique mobilier : type, matériau, état et total (Aide IA)

CREATE OR REPLACE VIEW vue_duree_par_type_interv AS
SELECT
    ti.libelle                              AS type_interv,
    COUNT(i.id)                             AS nb_interventions,
    AVG(
        CASE
            WHEN i.duree = '00:30:00' THEN 0.5
            WHEN i.duree = '01:00:00' THEN 1.0
            WHEN i.duree = '01:30:00' THEN 1.5
            WHEN i.duree = '02:00:00' THEN 2.0
            WHEN i.duree = '03:00:00' THEN 3.0
            ELSE EXTRACT(EPOCH FROM i.duree) / 3600.0
        END
    )::NUMERIC(4,2)                         AS duree_moy_h,
    SUM(
        EXTRACT(EPOCH FROM i.duree) / 3600.0
    )::NUMERIC(6,2)                         AS duree_tot_h
FROM public.interventions i
JOIN public.type_interv ti ON ti.id = i.id_type_interv
GROUP BY ti.libelle
ORDER BY duree_moy_h DESC;
-- Vue du temps par type_interv (Aide IA)
