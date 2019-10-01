CREATE FUNCTION update_scoreboard() RETURNS trigger AS $update_scoreboard$
    BEGIN


        UPDATE scoreboard SET points = points + 2 WHERE name = NEW.hteam and NEW.hscore > NEW.vscore;
        UPDATE scoreboard SET points = points + 3 WHERE name = NEW.vteam and NEW.hscore < NEW.vscore;
        UPDATE scoreboard SET points = points + 1 WHERE name = NEW.hteam and NEW.hscore = NEW.vscore;
        UPDATE scoreboard SET points = points + 1 WHERE name = NEW.vteam and NEW.hscore = NEW.vscore;

        RETURN NEW;

    END;
$update_scoreboard$ LANGUAGE plpgsql;

CREATE TRIGGER update_scoreboard AFTER INSERT ON matches
    FOR EACH ROW EXECUTE PROCEDURE update_scoreboard();
