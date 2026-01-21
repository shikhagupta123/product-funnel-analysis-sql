-- =========================================
-- Product Metrics & Funnel Analysis Project
-- Author: Shikha Gupta
-- =========================================

-- Create Database
CREATE DATABASE funnel_project;
USE funnel_project;

-- Create Events Table
CREATE TABLE user_events (
 user_id INT,
 event_type VARCHAR(50),
 event_time DATETIME,
 platform VARCHAR(20),
 country VARCHAR(50)
);

-- Insert Sample User Event Data
INSERT INTO user_events VALUES
(1,'visit','2025-01-01 10:00:00','web','India'),
(1,'signup','2025-01-01 10:05:00','web','India'),
(1,'purchase','2025-01-02 11:00:00','web','India'),

(2,'visit','2025-01-01 11:00:00','mobile','India'),
(2,'signup','2025-01-01 11:10:00','mobile','India'),

(3,'visit','2025-01-01 12:00:00','web','USA'),
(3,'signup','2025-01-01 12:15:00','web','USA'),
(3,'purchase','2025-01-03 14:00:00','web','USA'),

(4,'visit','2025-01-02 09:00:00','mobile','India'),

(5,'visit','2025-01-02 10:00:00','web','India'),
(5,'signup','2025-01-02 10:10:00','web','India'),
(5,'purchase','2025-01-02 13:00:00','web','India');

-- View Raw Data
SELECT * FROM user_events;

-- Funnel Stage User Count
SELECT 
 event_type,
 COUNT(DISTINCT user_id) AS users
FROM user_events
GROUP BY event_type;

-- Funnel Conversion Rate Analysis Using CTE and Window Function
WITH funnel AS (
 SELECT 
  event_type,
  COUNT(DISTINCT user_id) AS users
 FROM user_events
 GROUP BY event_type
)

SELECT 
 event_type,
 users,
 ROUND(
  users * 100.0 / LAG(users) OVER (ORDER BY users DESC),
  2
 ) AS conversion_rate
FROM funnel;

-- Drop-off Analysis
SELECT 
 event_type,
 COUNT(DISTINCT user_id) AS users
FROM user_events
GROUP BY event_type
ORDER BY users;

-- Platform-wise User Distribution
SELECT 
 platform,
 COUNT(DISTINCT user_id) AS users
FROM user_events
GROUP BY platform;

-- Cohort Analysis (Signup Date Based)
SELECT 
 DATE(event_time) AS signup_date,
 COUNT(DISTINCT user_id) AS users
FROM user_events
WHERE event_type = 'signup'
GROUP BY signup_date
ORDER BY signup_date;
