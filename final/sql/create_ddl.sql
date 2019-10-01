CREATE TABLE teams (
  name  TEXT PRIMARY KEY,
  coach TEXT UNIQUE
);

CREATE TABLE matches (
  hTeam  TEXT REFERENCES Teams (name) NOT NULL,
  vTeam  TEXT REFERENCES Teams (name) NOT NULL,
  hScore INT                          NOT NULL,
  vScore INT                          NOT NULL,
  PRIMARY KEY (hTeam, vTeam)
);
