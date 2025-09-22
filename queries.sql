--Retrieve all citizens who have Annual subscriptions.
SELECT c.firstname, c.lastname, c.district
FROM citizens AS c
INNER JOIN transport_subscriptions AS ts ON c.citizen_id = ts.citizen_id
WHERE ts.subscription_type = 'Annual'
ORDER BY c.firstname;

--Count how many citizens are senior or student subscribers.
SELECT subscription_type, COUNT (subscription_type)
FROM transport_subscriptions 
WHERE subscription_type IN ('Senior', 'Student')
GROUP BY subscription_type;

--List all transport usage records along with citizen names.
SELECT c.firstname, c.lastname, tu.citizen_id, tu.transport_type, tu.usage_date, tu.distance_km, tu.fare_paid, tu.route, tu.payment_method, tu.peak_hour
FROM citizens AS c
INNER JOIN transport_usage AS tu ON c.citizen_id = tu.citizen_id
ORDER BY c.firstname, c.lastname;

--Find the total fare collected per transport type.
SELECT transport_type, SUM (fare_paid) AS total_fare
FROM transport_usage
GROUP BY transport_type
ORDER BY total_fare DESC;


--Extract all routes starting from "Station D" and count how many rides have 5 stops.

WITH route_station_D AS (SELECT route
FROM transport_usage
WHERE route ->> 'from' = 'Station D')


SELECT route, COUNT (route) AS "5_stops_route"
FROM route_station_D
WHERE route ->> 'stops' = '5'
GROUP BY route;


-- Count unresolved complaints by category per month. 
SELECT category,  EXTRACT (MONTH FROM complaint_date) AS complaint_month, COUNT (category) AS total_complaints
FROM complaints AS c
WHERE resolved = FALSE
GROUP BY category, EXTRACT (MONTH FROM complaint_date)
ORDER BY complaint_month, category;

--Find rides during peak hours for the last month.

WITH last_month AS (SELECT citizen_id, MAX (EXTRACT (MONTH FROM usage_date) ) AS month
FROM transport_usage
GROUP BY citizen_id)

SELECT tu.citizen_id, tu.route, tu.usage_date
FROM transport_usage AS tu
INNER JOIN last_month AS lm ON tu.citizen_id= lm.citizen_id
WHERE tu.peak_hour = TRUE
AND EXTRACT (MONTH FROM usage_date) = lm.month
ORDER BY citizen_id;


