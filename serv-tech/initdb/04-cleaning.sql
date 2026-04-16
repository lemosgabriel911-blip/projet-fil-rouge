CREATE EXTENSION IF NOT EXISTS unaccent;

INSERT INTO
    public.fournisseur (telephone)
SELECT telephone
FROM (
        SELECT DISTINCT
            CASE
                WHEN lower(trim(telephone)) LIKE '%+41 21 456 78 90%' then 214567890
                ELSE NULL
            END AS telephone
        FROM staging.fournisseur
    )
WHERE
    telephone IS NOT NULL;

