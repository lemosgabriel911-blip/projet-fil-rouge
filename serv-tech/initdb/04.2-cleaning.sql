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
-- VISUALISATION DANS "VIEWS" DE CHAQUE ENTREPRISE AVEC LE MATERIEL FOURNI LIGNE PAR LIGNE

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