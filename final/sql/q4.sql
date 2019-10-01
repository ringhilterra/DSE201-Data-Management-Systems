WITH homeWinPoints AS (
    SELECT
      hteam        AS name,
      COUNT(*) * 2 AS points
    FROM matches m
    WHERE hscore > vscore
    GROUP BY hteam
),
    awayWinPoints AS (
      SELECT
        vteam        AS name,
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
  ),
    totalPoints2 AS (
      SELECT
        t.name                     AS name,
        COALESCE(SUM(a.points), 0) AS points
      FROM teams t LEFT JOIN allPoints a
          ON t.name = a.name
      GROUP BY t.name

  ),
    leaders AS (
      SELECT *
      FROM totalPoints2
      WHERE points = (SELECT MAX(points)
                      FROM totalPoints2)
  ),

    defeatedByLeaders AS (
    (SELECT hteam AS name
     FROM matches
     WHERE vscore > hscore
           AND vteam IN (
       SELECT name
       FROM leaders
     )
    )
    UNION
    (SELECT vteam AS name
     FROM matches
     WHERE vscore < hscore
           AND hteam IN (
       SELECT name
       FROM leaders
     )
    )
  )

SELECT *
FROM defeatedByLeaders;