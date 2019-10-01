--CREATE INDEX q1 on matches (vteam);


SELECT count(*) AS wins
FROM matches
WHERE (hteam = 'San Diego Sockers' AND hscore > vscore)
     OR (vteam = 'San Diego Sockers' AND hscore < vscore);

DROP INDEX IF EXISTS q1;