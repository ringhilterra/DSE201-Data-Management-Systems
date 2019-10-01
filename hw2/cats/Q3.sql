DROP INDEX IF EXISTS q3_1;
DROP INDEX IF EXISTS q3_2;
DROP INDEX IF EXISTS q3_3;
CREATE INDEX q3_1 ON cats.likes(user_id);
CREATE INDEX q3_2 ON cats.watch(user_id);
CREATE INDEX q3_3 ON cats.friend(user_id);

DEALLOCATE Q3;
PREPARE Q3 (int) AS

	WITH my_friends AS (
    SELECT *
    FROM friend f
    WHERE f.user_id = $1
    ),

    f_of_f AS (
    SELECT *
    FROM friend f
    WHERE f.user_id IN
        (SELECT m.friend_id
         FROM my_friends m
        )
    ),

    total_f AS (
    SELECT friend_id FROM my_friends UNION
    SELECT friend_id FROM f_of_f
    ),

    total_f2 AS (
    SELECT *
    FROM total_f
    WHERE total_f.friend_id != $1
    ),

    f_likes AS (
    SELECT l.video_id, COALESCE(COUNT(like_id),0) as total_likes
    FROM likes l RIGHT OUTER JOIN total_f2 f
    ON l.user_id = f.friend_id
    GROUP BY l.video_id
    ORDER BY total_likes desc
    ),

    f2_likes AS (
    SELECT v.video_id, COALESCE(total_likes, 0) AS total_likes
    FROM video v LEFT OUTER JOIN f_likes f
	ON v.video_id = f.video_id
    ),

    liked AS (
	SELECT l.video_id
	FROM likes l
    WHERE l.user_id = $1
    ),

    watched AS (
	SELECT w.video_id
	FROM watch w
    WHERE w.user_id = $1
    ),

    f_table AS (
    SELECT
        v.video_id, v.total_likes,
        CAST(COALESCE(l.video_id,0) as boolean) as liked_already,
        CAST(COALESCE(w.video_id,0) as boolean) as watched_already
    FROM f2_likes v
    FULL OUTER JOIN liked l
	ON v.video_id = l.video_id
    FULL OUTER JOIN watched w
    ON v.video_id = w.video_id
    ORDER BY liked_already ASC, watched_already ASC, total_likes DESC
    )

    SELECT video_id as vid, total_likes as rank
    FROM f_table
    LIMIT 10;

EXPLAIN ANALYSE EXECUTE Q3(1);