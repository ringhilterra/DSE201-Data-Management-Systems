DROP INDEX IF EXISTS q4_1;
DROP INDEX IF EXISTS q4_2;
DROP INDEX IF EXISTS q4_3;
CREATE INDEX q4_1 ON cats.likes(user_id);
CREATE INDEX q4_2 ON cats.watch(user_id);
CREATE INDEX q4_3 ON cats.likes(video_id);

DEALLOCATE Q4;
PREPARE Q4 (int) AS

    WITH liked AS (
	SELECT l.video_id
	FROM likes l
    WHERE l.user_id = $1
    ),

    users_liked AS (
    SELECT DISTINCT(l2.user_id)
    FROM liked l1 INNER JOIN likes l2
    ON l1.video_id = l2.video_id
    ),

    f_likes AS (
    SELECT l.video_id, COALESCE(COUNT(like_id),0) as total_likes
    FROM likes l RIGHT OUTER JOIN users_liked u
    ON l.user_id = u.user_id
    GROUP BY l.video_id
    ORDER BY total_likes desc
    ),

    f2_likes AS (
    SELECT v.video_id, COALESCE(total_likes, 0) AS total_likes
    FROM video v LEFT OUTER JOIN f_likes f
	ON v.video_id = f.video_id
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

EXPLAIN ANALYSE EXECUTE Q4(1);