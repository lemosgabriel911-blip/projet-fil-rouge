COPY staging.fournisseur
FROM '/data/fournisseurs_contacts.csv'
WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ';',
        ENCODING 'UTF8'
    );

COPY staging.inventaire
FROM '/data/inventaire_mobilier.csv'
WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ';',
        ENCODING 'UTF8'
    );

COPY staging.interventions
FROM '/data/interventions.csv'
WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ';',
        ENCODING 'UTF8'
    );

COPY staging.signalements
FROM '/data/signalements.csv'
WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ';',
        ENCODING 'UTF8'
    );