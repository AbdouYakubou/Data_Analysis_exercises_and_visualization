 CREATE TABLE user_submissions (
     id SERIAL PRIMARY KEY,
     user_id BIGINT,
     question_id INT,
     points INT,
     submitted_at TIMESTAMP, 
     username VARCHAR(50)
     );

INSERT INTO user_submissions (user_id, question_id, points, submitted_at, username) VALUES
(1001, 1, 8, '2023-10-01 09:00:00', 'alice123'),
(1002, 2, 7, '2023-10-01 09:05:00', 'bob456'),
(1003, 3, 9, '2023-10-01 09:10:00', 'charlie789'),
(1004, 4, 6, '2023-10-01 09:15:00', 'dave101'),
(1005, 5, 10, '2023-10-01 09:20:00', 'eve202'),
(1006, 6, 5, '2023-10-01 09:25:00', 'frank303'),
(1007, 7, 8, '2023-10-01 09:30:00', 'grace404'),
(1008, 8, 7, '2023-10-01 09:35:00', 'henry505'),
(1009, 9, 9, '2023-10-01 09:40:00', 'ivy606'),
(1010, 10, 6, '2023-10-01 09:45:00', 'jack707'),
(1011, 11, 10, '2023-10-01 09:50:00', 'kate808'),
(1012, 12, 5, '2023-10-01 09:55:00', 'leo909'),
(1013, 13, 8, '2023-10-01 10:00:00', 'mia1010'),
(1014, 14, 7, '2023-10-01 10:05:00', 'noah1111'),
(1015, 15, 9, '2023-10-01 10:10:00', 'olivia1212'),
(1016, 16, 6, '2023-10-01 10:15:00', 'peter1313'),
(1017, 17, 10, '2023-10-01 10:20:00', 'quinn1414'),
(1018, 18, 5, '2023-10-01 10:25:00', 'rachel1515'),
(1019, 19, 8, '2023-10-01 10:30:00', 'steve1616'),
(1020, 20, 7, '2023-10-01 10:35:00', 'tina1717'),
(1021, 21, 9, '2023-10-01 10:40:00', 'uma1818'),
(1022, 22, 6, '2023-10-01 10:45:00', 'vince1919'),
(1023, 23, 10, '2023-10-01 10:50:00', 'wendy2020'),
(1024, 24, 5, '2023-10-01 10:55:00', 'xander2121'),
(1025, 25, 8, '2023-10-01 11:00:00', 'yara2222'),
(1026, 26, 7, '2023-10-01 11:05:00', 'zack2323');


 SELECT * FROM user_submissions;

####FIND DISTINCT NAMES,TOTAL SUBMISSIONS AND POINTS EARNED
 SELECT 
 	username,
 	COUNT(id) as total_submissions,
 	SUM(points) as points_earned
 FROM user_submissions
 GROUP BY username
 ORDER BY total_submissions DESC;
 
 select*
 from user_submissions;

###FINDING THE AVERAGE POINTS FOR EACH USER
SELECT 
 	username,
 	AVG(points) as daily_avg_points
 FROM user_submissions
 GROUP BY 1
 ORDER BY username;
 
 #FINDING NUMBER OF SUBMISSION PER USER
WITH daily_submissions AS (
    SELECT 
        DATE(submitted_at) AS daily, -- Extract the date from submitted_at
        username,
        SUM(CASE 
            WHEN points > 0 THEN 1 ELSE 0
        END) AS correct_submissions
    FROM user_submissions
    GROUP BY DATE(submitted_at), username 
),
users_rank AS (
    SELECT 
        daily,
        username,
        correct_submissions,
        DENSE_RANK() OVER(PARTITION BY daily ORDER BY correct_submissions DESC) AS "rank" 
    FROM daily_submissions
)
SELECT 
    daily,
    username,
    correct_submissions
FROM users_rank
WHERE "rank" <= 3; 
 
 ####FINDING USERS WITH INCORRECT SUBMISSION
 
 SELECT 
 	username,
 	SUM(CASE 
 		WHEN points < 0 THEN 1 ELSE 0
 	END) as incorrect_submissions,
 	SUM(CASE 
 			WHEN points > 0 THEN 1 ELSE 0
 		END) as correct_submissions,
 	SUM(CASE 
 		WHEN points < 0 THEN points ELSE 0
 	END) as incorrect_submissions_points,
 	SUM(CASE 
 			WHEN points > 0 THEN points ELSE 0
 		END) as correct_submissions_points_earned,
 	SUM(points) as points_earned
 FROM user_submissions
 GROUP BY 1
 ORDER BY incorrect_submissions DESC;
 
 ####USERS BASED ON HIGHEST POINT
 SELECT *  
 FROM
 (
 	SELECT 
	
 		EXTRACT(day FROM submitted_at) as 'day',
 		username,
 		SUM(points) as total_points_earned,
 		DENSE_RANK() OVER(PARTITION BY EXTRACT(day FROM submitted_at) ORDER BY SUM(points) DESC) as 'rank'
 	FROM user_submissions
 	GROUP BY 1, 2
 	ORDER BY 'day', total_points_earned DESC
 ) AS highest_rank
 WHERE 'rank' <= 10;
 
 
 
 
 
 

