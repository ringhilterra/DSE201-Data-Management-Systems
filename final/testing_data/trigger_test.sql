SELECT * from scoreboard where name = 'team30';

INSERT INTO matches (hteam, vteam, hscore, vscore) VALUES ('team30','team1', 2, 0);
INSERT INTO matches (hteam, vteam, hscore, vscore) VALUES ('team30','team2', 0, 2);
INSERT INTO matches (hteam, vteam, hscore, vscore) VALUES ('team30','team31', 2, 2);

INSERT INTO matches (hteam, vteam, hscore, vscore) VALUES ('team4','team30', 0, 3);
INSERT INTO matches (hteam, vteam, hscore, vscore) VALUES ('team5','team30', 3, 0);
INSERT INTO matches (hteam, vteam, hscore, vscore) VALUES ('team6','team30', 3, 3);


SELECT * from scoreboard where name = 'team30';


--INSERT INTO matches (hteam, vteam, hscore, vscore) VALUES ('ryan_team','team1', 3, 3);

--SELECT * from scoreboard where name = 'ryan_team';