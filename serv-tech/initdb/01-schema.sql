-------------- TABLES DE REFERENCE --------------
CREATE TABLE type_mobilier(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100)
)

CREATE TABLE type_materiel(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100)
)

CREATE TABLE type_interv(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100)
)

CREATE TABLE signal_urgence(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50)
)

CREATE TABLE signal_statut(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50)
)

-------------- TABLES SERVTECH --------------

CREATE TABLE fournisseur (
    id SERIAL PRIMARY KEY,
    entreprise VARCHAR(80) NOT NULL UNIQUE
    contact VARCHAR(80) NOT NULL UNIQUE
    telephone INTEGER NOT NULL UNIQUE
    email VARCHAR (80)NOT NULL UNIQUE
    remarques VARCHAR (255)
    # FK ID à mettre
);

CREATE TABLE interventions (
    SERIAL PRIMARY KEY,
    date_intervention DATE NOT NULL
    objet
    technicien
    duree
    materiel
    remarques
    # FK ID à mettre
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

