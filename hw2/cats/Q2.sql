DROP INDEX IF EXISTS q2_1;
DROP INDEX IF EXISTS q2_2;
DROP INDEX IF EXISTS q2_3;
CREATE INDEX q2_1 ON cats.likes(user_id);
CREATE INDEX q2_2 ON cats.watch(user_id);
CREATE INDEX q2_3 ON cats.friend(user_id);

DEALLOCATE Q2;
PREPARE Q2 (int) AS
    
    WITH f_likes AS (
    SELECT l.video_id, COALESCE(COUNT(like_id),0) as total_likes
    FROM likes l FULL OUTER JOIN friend f
    ON l.user_id = f.friend_id
    WHERE f.user_id = $1
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

EXPLAIN ANALYSE EXECUTE Q2(1);