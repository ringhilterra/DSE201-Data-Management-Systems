--final consolidated indexes added to tables in cat schema to improve performance

CREATE INDEX index1 ON cats.likes(user_id); --imporves performance for q1,q2,q3,q4
CREATE INDEX index2 ON cats.watch(user_id); --improves performance for q1,q2,q3,q4
CREATE INDEX index3 ON cats.friend(user_id); --improves performance for q2, q3
CREATE INDEX index4 ON cats.likes(video_id); --improves performance for q4
