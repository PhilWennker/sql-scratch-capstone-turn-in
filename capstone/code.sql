
--- 1

SELECT COUNT(DISTINCT utm_campaign) as campaigns
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) as sources
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

--- 2

SELECT DISTINCT page_name
FROM page_visits;

--- 3
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign as 'campaign',
  COUNT(ft.first_touch_at) as 'count'
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY COUNT(ft.first_touch_at) DESC;


--- 4
WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign as 'campaign',
COUNT(lt.last_touch_at) as 'count'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign
ORDER BY COUNT(lt.last_touch_at) DESC;
/

--- 5
SELECT COUNT(DISTINCT user_id) as 'Vistors with purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

--- 6
WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign as 'campaign',
COUNT(lt.last_touch_at) as 'count'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
WHERE pv.page_name = '4 - purchase'
GROUP BY pv.utm_campaign
ORDER BY COUNT(lt.last_touch_at) DESC;


--- unique users single touch point
WITH last_touch_purchase AS 
  (
    SELECT user_id,
           utm_campaign,
                 timestamp
    FROM page_visits
    WHERE page_name = '4 - purchase' 
  ), 
first_touch_campaign AS 
  (
    SELECT user_id,
           utm_campaign,
                 timestamp
    FROM page_visits
    WHERE page_name = '1 - landing_page' 
  )
SELECT COUNT(DISTINCT first.user_id) AS 'Unique Users with single touchpoint'
FROM last_touch_purchase AS last 
LEFT JOIN first_touch_campaign AS first
     ON last.user_id = first.user_id
     AND last.utm_campaign = first.utm_campaign 

LEFT JOIN page_visits AS pv
     ON last.user_id = pv.user_id
     AND last.utm_campaign = pv.utm_campaign 
WHERE first.user_id IS NOT NULL;



