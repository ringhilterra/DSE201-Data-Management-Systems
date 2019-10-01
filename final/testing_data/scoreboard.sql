DELETE FROM matches where hteam = 'ryan_team' and vteam = 'team1' and hscore = 3 and vscore = 3 ;


DELETE FROM matches where hteam = 'team30' and vteam = 'team1' and hscore = 2 and vscore = 0 ;
DELETE FROM matches where hteam = 'team30' and vteam = 'team2' and hscore = 0 and vscore = 2 ;
DELETE FROM matches where hteam = 'team30' and vteam = 'team31' and hscore = 2 and vscore = 2 ;

DELETE FROM matches where vteam = 'team30' and hteam = 'team4' and hscore = 0 and vscore = 3 ;
DELETE FROM matches where vteam = 'team30' and hteam = 'team5' and hscore = 3 and vscore = 0 ;
DELETE FROM matches where vteam = 'team30' and hteam = 'team6' and hscore = 3 and vscore = 3 ;


DROP TABLE IF EXISTS scoreboard;

CREATE TABLE scoreboard as (
WITH homeWinPoints AS (
   SELECT
     hteam as name,
     COUNT(*) * 2 AS points
   FROM  matches m
   WHERE hscore > vscore
   GROUP BY hteam
),
   awayWinPoints AS (
     SELECT
       vteam as name,
       COUNT(*) * 3 AS points
     FROM matches m
     WHERE hscore < vscore
     GROUP BY vteam
 ),
   homeTiePoints AS (
     SELECT
       hteam    AS name,
       COUNT(*) AS points
     FROM matches
     WHERE hscore = vscore
     GROUP BY hteam
 ),
   awayTiePoints AS (
     SELECT
       vteam    AS name,
       COUNT(*) AS points
     FROM matches
     WHERE hscore = vscore
     GROUP BY vteam
 ),
  allPoints AS (
    SELECT *
    FROM awayWinPoints
    UNION ALL
    SELECT *
    FROM awayTiePoints
    UNION ALL
    SELECT *
    FROM homeWinPoints
    UNION ALL
    SELECT *
    FROM homeTiePoints
  )

  SELECT t.name as name, COALESCE(SUM(a.points),0) as points
  FROM teams t LEFT JOIN allPoints a
  ON t.name = a.name
  GROUP BY t.name
);

SELECT * FROM scoreboard where name = 'ryan_team';
--SELECT * FROM matches where hteam = 'ryan_team' or vteam = 'ryan_team'

--SELECT * FROM matches where vteam = 'team30' and hscore <= vscore;

--SELECT * FROM matches where hteam = 'team30' and vteam = 'team31' ;