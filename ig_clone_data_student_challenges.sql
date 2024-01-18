Use ig_clone;

-- 1. Find the 5 oldest users 
-- my attempt
SELECT * FROM users GROUP BY username ORDER BY created_at;

-- instructor_solution
select * FROM users ORDER BY created_at LIMIT 5;

-- 2. What day of the week do most users register on?
-- my solution 
SELECT DAYOFWEEK(created_at), COUNT(*) FROM users GROUP BY DAYOFWEEK(created_at);
-- Thursday and Sunday
-- instructor_solution
SELECT DAYNAME(created_at) as day, COUNT(*) as total FROM users GROUP BY day ORDER BY total DESC;

-- 3. Find the users who have never posted a photo
-- my solution
SELECT * FROM users LEFT JOIN photos ON users.id != photos.user_id;
-- I understand now why this didn't work--even though a foreign key references another fieldname in a table, they do not 
-- necessarily equal value. photos.user_id is a foreign key in photos table that references uers.id. References 
-- are not the same thing as sharing the same value.

-- instructor_solution
SELECT username FROM users 
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;

-- 4. Find the photo with the most likes and who it belongs to
-- my solutions
SELECT photo_id, COUNT(photo_id) as most_votes FROM likes 
GROUP BY photo_id
ORDER BY most_votes DESC;
-- photo_id 145 has most votes at 48 likes.
-- could have also done COUNT(*)-- 

SELECT users.username, photos.user_id, photos.id FROM users
JOIN photos ON users.id = photos.user_id
WHERE photos.id = 145;

-- instructor_solution
SELECT 
	username,
	photos.id, 
	photos.image_url, 
    COUNT(*) as total
FROM photos 
INNER JOIN likes ON likes.photo_id = photos.id
INNER JOIN users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;

-- #5 how many times does the average user post?-- 

-- instructor_solution using subqueries
-- total number of photos/ total number of users
SELECT (SELECT COUNT(*) FROM photos) / (SELECT COuNT(*) FROM USERS) as avg;

-- #6 What are the top 5 most used hashtags?
-- my initial try
SELECT tag_id, tag_name FROM photo_tags
JOIN tags ON photo_tags.tag_id = tags.id
ORDER by tags.id DESC;


-- instructor_solution
SELECT tags.tag_name, COUNT(*) as total FROM photo_tags
JOIN tags ON photo_tags.tag_id = tags.id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;

#7 Find users who have liked all photos on the side (probably a bot)
SELECT users.username, COUNT(likes.photo_id) as total_likes FROM users
JOIN likes ON likes.user_id = users.id
GROUP BY username
ORDER by total_likes DESC;
-- Now I realize that when I use GROUP BY I have to have that GROUP BY object in the SELECT
-- clause, AND if any other objects are selected they must also either be in the GROUP By
-- clause  OR they must be inside an aggregate function within the select claus! At least in MySQL8 using the 
-- default sql_mode

-- instructor_solution
SELECT username, COUNT(*) as num_likes FROM users
JOIN likes ON likes.user_id = users.id
GROUP BY likes.user_id
HAVING num_likes = 257;
-- where clauses go before GROUP BY
-- To make dynamic use subquery
SELECT username, COUNT(*) as num_likes FROM users
JOIN likes ON likes.user_id = users.id
GROUP BY likes.user_id
HAVING num_likes = (SELECT COUNT(*) FROM photos);
