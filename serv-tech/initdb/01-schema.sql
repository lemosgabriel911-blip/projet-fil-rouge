-------------- TABLES DE REFERENCE --------------
CREATE TABLE type_mobilier (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE type_materiel (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE type_interv (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE signal_urgence (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE signal_statut (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE type_materiau(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE etat_inventaire(
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL UNIQUE
);

-------------- TABLES SERVTECH --------------

CREATE TABLE fournisseur (
    id SERIAL PRIMARY KEY,
    entreprise VARCHAR(80) NOT NULL UNIQUE,
    contact VARCHAR(80) NOT NULL UNIQUE,
    telephone INTEGER NOT NULL UNIQUE,
    email VARCHAR(80) NOT NULL UNIQUE,
    remarques VARCHAR(255),
    id_type_materiel INTEGER NOT NULL REFERENCES type_materiel(id)
);

CREATE TABLE inventaire (
    id SERIAL PRIMARY KEY,
    lieu VARCHAR(80) NOT NULL,
    latitude DECIMAL(10, 5) NOT NULL,
    longitude DECIMAL(10, 5) NOT NULL,
    date_installation DATE NOT NULL,
    remarques VARCHAR(255),
    id_type_mobilier INTEGER NOT NULL REFERENCES type_mobilier(id),
    id_type_materiau INTEGER NOT NULL REFERENCES type_materiau(id),
    id_etat_inventaire INTEGER NOT NULL REFERENCES etat_inventaire(id),
    id_fournisseur INTEGER NOT NULL REFERENCES fournisseur(id)
);


CREATE TABLE interventions (
    id SERIAL PRIMARY KEY,
    date_intervention DATE NOT NULL,
    objet VARCHAR(80) NOT NULL,
    technicien VARCHAR(80) NOT NULL,
    duree TIME NOT NULL,
    cout_materiel INTEGER NOT NULL,
    remarques VARCHAR(255),
    id_type_interv INTEGER NOT NULL REFERENCES type_interv(id),
    id_inventaire INTEGER NOT NULL REFERENCES inventaire(id)
);

CREATE TABLE signalement (
    id SERIAL PRIMARY KEY,
    date_signalement DATE NOT NULL,
    signale_par VARCHAR(80),
    objet VARCHAR (190),
    description VARCHAR(80) NOT NULL,
    id_signal_urgence INTEGER NOT NULL REFERENCES signal_urgence(id),
    id_signal_statut INTEGER NOT NULL REFERENCES signal_statut(id)
);

-------------- TABLES DE LIAISON --------------

CREATE TABLE interv_signal (
    id SERIAL PRIMARY KEY,
    id_signalement INTEGER NOT NULL REFERENCES signalement(id),
    id_interventions INTEGER NOT NULL REFERENCES interventions(id)
);

CREATE TABLE signal_invent (
    id SERIAL PRIMARY KEY,
    id_signalement INTEGER NOT NULL REFERENCES signalement(id),
    id_inventaire INTEGER NOT NULL REFERENCES inventaire(id)
);