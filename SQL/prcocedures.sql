-- SELECT * FROM anime_project.users;

-- DROP FUNCTION IF EXISTS loginInfo;
-- DELIMITER %%
-- CREATE FUNCTION loginInfo(p_username VARCHAR(50), p_password VARCHAR(50) )
-- RETURNS INT
-- READS SQL DATA
-- BEGIN 
-- 	DECLARE idNum INT;
-- 	SELECT user_id INTO idNum
--     FROM users 
--     WHERE p_username = username 
--     AND p_password = user_password;
--     IF idNum IS NULL
--     THEN 
-- 		RETURN -999;
--     ELSE
-- 		RETURN idNum;
-- 	END IF;
-- END%%
-- DELIMITER ;
    
-- SELECT loginInfo('Chris27153', 248778 );    

-- DROP FUNCTION IF EXISTS signupAccount;
-- DELIMITER %%
-- CREATE FUNCTION signupAccount(p_username VARCHAR(50), p_password VARCHAR(50) )
-- RETURNS INT
-- READS SQL DATA
-- BEGIN 
-- 	DECLARE idNum INT;
--     DECLARE curCount INT;
--     
--     -- check if user is already in use
--     SELECT COUNT(*) INTO curCount
--     FROM users
--     WHERE p_username = username;
--     IF curCount > 0
--     THEN 
-- 		RETURN -999;
-- 	END IF;
--     
--     -- insert user into table
--     INSERT INTO users(username, user_password)
--     VALUE(p_username , p_password );
--     
--     -- return the id number
-- 	SELECT user_id INTO idNum
--     FROM users 
--     WHERE p_username = username 
--     AND p_password = user_password;
-- 	RETURN idNum;
-- 	
-- 	
-- END%%
-- DELIMITER ;

  

DROP PROCEDURE IF EXISTS loginInfo;
DROP PROCEDURE IF EXISTS signupAccount;
DROP PROCEDURE IF EXISTS getDays;
DROP PROCEDURE IF EXISTS getTotalShows;
DROP PROCEDURE IF EXISTS getTotalEpisodes;
DROP PROCEDURE IF EXISTS getYearGraph;
DROP PROCEDURE IF EXISTS getGenreGraph;
DROP PROCEDURE IF EXISTS getSourceGraph;
DROP PROCEDURE IF EXISTS getSearch;

DELIMITER %%
CREATE PROCEDURE loginInfo(p_username VARCHAR(50), p_password VARCHAR(50) )
READS SQL DATA
BEGIN 
	DECLARE idNum INT;
	SELECT user_id INTO idNum
    FROM users 
    WHERE p_username = username 
    AND p_password = user_password;
    IF idNum IS NULL
    THEN 
		SELECT -999;
    ELSE
		SELECT idNum;
	END IF;
END%%

CREATE PROCEDURE signupAccount(p_username VARCHAR(50), p_password VARCHAR(50) )
READS SQL DATA
acc: BEGIN 
	DECLARE idNum INT;
    DECLARE curCount INT;
    
    -- check if user is already in use
    SELECT COUNT(*) INTO curCount
    FROM users
    WHERE p_username = username;
    IF curCount > 0
    THEN 
		SELECT -999;
        LEAVE acc;
	END IF;
    
    -- insert user into table
    INSERT INTO users(username, user_password)
    VALUE(p_username , p_password );
    
    -- return the id number
	SELECT user_id INTO idNum
    FROM users 
    WHERE p_username = username 
    AND p_password = user_password;
	SELECT idNum;
	
	
END%%

CREATE PROCEDURE getDays(p_id INT)
READS SQL DATA
BEGIN
	SELECT ROUND(SUM(my_watched_episodes * duration_min) / 60 / 24, 2)
    FROM myanimelist, entries, users
    WHERE users.user_id = entries.user_id
    AND entries.anime_id = myanimelist.anime_id
    AND users.user_id = p_id;
END%%

CREATE PROCEDURE getTotalShows(p_id INT)
READS SQL DATA
BEGIN
	SELECT COUNT(*)
    FROM entries, users
    WHERE users.user_id = entries.user_id
	AND users.user_id = p_id
    AND my_status = 2;
END%%

CREATE PROCEDURE getTotalEpisodes(p_id INT)
READS SQL DATA
BEGIN
	SELECT SUM(my_watched_episodes)
    FROM myanimelist, entries, users
    WHERE users.user_id = entries.user_id
    AND entries.anime_id = myanimelist.anime_id
    AND users.user_id = p_id;
END%%

CREATE PROCEDURE getYearGraph(p_id INT)
READS SQL DATA
BEGIN
	SELECT aired_from_year, COUNT(*)
    FROM myanimelist, entries, users
    WHERE users.user_id = entries.user_id
    AND entries.anime_id = myanimelist.anime_id
    AND users.user_id = p_id
	AND my_status = 2
    GROUP BY aired_from_year
    ORDER BY aired_from_year ASC;
    
END%%

CREATE PROCEDURE getGenreGraph(p_id INT)
READS SQL DATA
BEGIN
	SELECT genre_lookup.genre, count(*) AS frequency
    FROM myanimelist, entries, users, genre_lookup
    WHERE users.user_id = entries.user_id
    AND entries.anime_id = myanimelist.anime_id
    AND myanimelist.anime_id = genre_lookup.anime_id
    AND users.user_id = p_id
	AND my_status = 2
    GROUP BY genre_lookup.genre
    ORDER BY frequency DESC
    LIMIT 5;
    
END%%

CREATE PROCEDURE getSourceGraph(p_id INT)
READS SQL DATA
BEGIN
	SELECT source_material, COUNT(*)
    FROM myanimelist, entries, users
    WHERE users.user_id = entries.user_id
    AND entries.anime_id = myanimelist.anime_id
    AND users.user_id = p_id
	AND my_status = 2
    GROUP BY source_material
    ORDER BY COUNT(*) DESC
    Limit 6;
    
END%%

CREATE PROCEDURE getSearch(p_id INT)
READS SQL DATA
BEGIN
    SELECT title, score, rank_num, airing, anime_id, source_material
    FROM myanimelist
    WHERE score = p_id;
END%%
DELIMITER ;
   
   
   
CALL loginInfo('Chris27153', 248778 );   
CALL signupAccount('Chris2715', 248778 );   
CALL getDays(1);
CALL getTotalShows(1);
CALL getTotalEpisodes(1);
CALL getYearGraph(1);
CALL getGenreGraph(1);
CALL getSourceGraph(1);

CALL getSearch(1);


    
    
    
    
    