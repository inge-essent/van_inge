-- Na het inlezen van de MCF data, maken we een groepering naar
-- Maand, 1P
-- Maand 2P
-- Gasdag 1P
-- Gasdag 2P


DROP TABLE DATA_SCIENCE.MHI_MCF_WEIGHTED_GASDAG_2P;

CREATE TABLE DATA_SCIENCE.MHI_MCF_WEIGHTED_GASDAG_2P as

SELECT
    GASDAG
    , POSTCODE_2P
    , sum(SUMOFALLOCATIE) as SUMOFALLOCATIE
    , sum(SUMOFVGV) as SUMOFVGV 
    , sum(SUMOFALLOCATIE)/sum(SUMOFVGV) as MCF
    ,   count(*) as AANTAL
FROM
    (
    SELECT 
        a.GOS
        , SUMOFALLOCATIE
        , SUMOFVGV
        , b.POSTCODE_2P
        , to_char(to_date(GASDAG, 'dd-mm-yy'), 'YYYY-MM-DD') as GASDAG
        , to_char(to_date(GASDAG, 'dd-mm-yy'), 'yyyy-mm') as MAAND
    FROM DATA_SCIENCE.MHI_MCF_DATA a
    LEFT OUTER JOIN 
    (
        SELECT 
            GOS
            ,   POSTCODE_2P
        FROM DATA_SCIENCE.MHI_GOSSEN_MAPPING
    ) b
    On a.GOS * 1 = b.GOS * 1
    )

WHERE SUMOFVGV is not null AND SUMOFVGV <> 0

GROUP BY GASDAG, POSTCODE_2P
ORDER BY GASDAG, POSTCODE_2P
;

