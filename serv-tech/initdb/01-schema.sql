-------------- TABLES DE REFERENCE --------------

CREATE TABLE fournisseur (
    id SERIAL PRIMARY KEY,
    entreprise VARCHAR(80) NOT NULL UNIQUE
    contact
    telephone
    email
    type_materiel
    remarques
);

CREATE TABLE interventions (
    SERIAL PRIMARY KEY,
    type VARCHAR(80) NOT NULL UNIQUE
    date 
    objet
    type_intervention
    technicien
    duree
    materiel
    remarques
);

CREATE TABLE inventaire (
    SERIAL PRIMARY KEY,
    type VARCHAR(80) NOT NULL UNIQUE
    materiau
    lieu
    latitude
    longitude
    date_installation
    etat
    remarques
);

CREATE TABLE signalement (
    SERIAL PRIMARY KEY,
    type VARCHAR(80) NOT NULL UNIQUE
    data
    signale_par
    objet
    description
    urgence
    statut
);

-------------- TABLES DE NORMALISATION --------------

