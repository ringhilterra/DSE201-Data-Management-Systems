DROP INDEX IF EXISTS q1;
DROP INDEX IF EXISTS q1_2;
CREATE INDEX q1 ON cats.likes(user_id);
CREATE INDEX q1_2 ON cats.watch(user_id);

DEALLOCATE Q1;
PREPARE Q1 (int) AS
 	WITH video_likes AS (
	SELECT v.video_id, COALESCE(COUNT(like_id),0) as total_likes
	FROM video v LEFT OUTER JOIN likes l
    ON v.video_id = l.video_id
    GROUP BY v.video_id
    ORDER BY total_likes desc
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
    FROM video_likes v
    FULL OUTER JOIN liked l
	ON v.video_id = l.video_id
    FULL OUTER JOIN watched w
    ON v.video_id = w.video_id
    ORDER BY liked_already ASC, watched_already ASC, total_likes DESC
    )

    SELECT video_id as vid, total_likes as rank
    FROM f_table
    LIMIT 10;

EXPLAIN ANALYSE EXECUTE Q1(1);