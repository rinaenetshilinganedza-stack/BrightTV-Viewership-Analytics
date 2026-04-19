-- =========================================
-- 1. VIEW DATA
-- =========================================

SELECT * FROM viewership;
SELECT * FROM user_profiles;


-- =========================================
-- 2. DATA CLEANING
-- Convert UTC → South Africa Time
-- =========================================

SELECT 
    UserID,
    Channel,
    RecordDate,
    from_utc_timestamp(RecordDate, 'Africa/Johannesburg') AS SA_Time,
    Duration
FROM viewership;


-- =========================================
-- 3. CREATE CLEANED VIEW
-- =========================================

CREATE OR REPLACE TEMP VIEW viewership_clean AS
SELECT 
    UserID,
    Channel,
    from_utc_timestamp(RecordDate, 'Africa/Johannesburg') AS SA_Time,
    Duration
FROM viewership;


-- =========================================
-- 4. JOIN DATASETS (MAIN DATASET)
-- =========================================

CREATE OR REPLACE TEMP VIEW full_data AS
SELECT 
    A.UserID,
    B.Name,
    B.Surname,
    B.Gender,
    B.Age,
    B.Province,
    A.Channel,
    A.SA_Time,
    A.Duration
FROM viewership_clean AS A
INNER JOIN user_profiles AS B
ON A.UserID = B.UserID;


-- =========================================
-- 5. USER ACTIVITY (DAILY)
-- =========================================

SELECT 
    DATE(SA_Time) AS activity_date,
    COUNT(DISTINCT UserID) AS active_users
FROM full_data
GROUP BY activity_date
ORDER BY activity_date;


-- =========================================
-- 6. PEAK VIEWING HOURS
-- =========================================

SELECT 
    HOUR(SA_Time) AS hour,
    COUNT(*) AS total_views
FROM full_data
GROUP BY hour
ORDER BY total_views DESC;


-- =========================================
-- 7. VIEWS BY DAY OF WEEK
-- =========================================

SELECT 
    date_format(SA_Time, 'EEEE') AS day_of_week,
    COUNT(*) AS total_views
FROM full_data
GROUP BY day_of_week
ORDER BY total_views DESC;


-- =========================================
-- 8. MOST POPULAR CHANNELS
-- =========================================

SELECT 
    Channel,
    COUNT(*) AS total_views
FROM full_data
GROUP BY Channel
ORDER BY total_views DESC;


-- =========================================
-- 9. VIEWERSHIP BY GENDER
-- =========================================

SELECT 
    Gender,
    COUNT(*) AS total_views
FROM full_data
GROUP BY Gender
ORDER BY total_views DESC;


-- =========================================
-- 10. VIEWERSHIP BY PROVINCE
-- =========================================

SELECT 
    Province,
    COUNT(*) AS total_views
FROM full_data
GROUP BY Province
ORDER BY total_views DESC;


-- =========================================
-- 11. AVERAGE SESSION DURATION
-- =========================================

SELECT 
    AVG(Duration) AS avg_duration
FROM full_data;


-- =========================================
-- 12. LOW ENGAGEMENT DAYS
-- =========================================

SELECT 
    date_format(SA_Time, 'EEEE') AS day_of_week,
    COUNT(*) AS total_views
FROM full_data
GROUP BY day_of_week
ORDER BY total_views ASC;


-- =========================================
-- 13. TOP ACTIVE USERS
-- =========================================

SELECT 
    UserID,
    COUNT(*) AS sessions
FROM full_data
GROUP BY UserID
ORDER BY sessions DESC
LIMIT 10;


-- =========================================
-- 14. CONTENT CONSUMPTION PATTERN
-- =========================================

SELECT 
    Channel,
    COUNT(DISTINCT UserID) AS unique_users
FROM full_data
GROUP BY Channel
ORDER BY unique_users DESC;
