WITH homeLosses AS (
   SELECT
     hteam    AS name,
     COUNT(*) AS losses
   FROM matches
   WHERE hscore < vscore
   GROUP BY hteam
),

   awayLosses AS (
     SELECT
       vteam    AS name,
       COUNT(*) AS losses
     FROM matches
     WHERE hscore > vscore
     GROUP BY vteam
 ),

   totalLosses AS (
    SELECT *
    FROM homeLosses
    UNION ALL
    SELECT *
    FROM awayLosses

 ),

   totalLosses2 AS (
     SELECT
       t.name,
       t.coach,
       COALESCE(l.losses, 0) AS losses
     FROM teams t LEFT JOIN totalLosses l
         ON t.name = l.name
 )

SELECT coach
FROM totalLosses2
WHERE losses = 0;
