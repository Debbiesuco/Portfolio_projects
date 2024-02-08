-- 1.a 
/*Which cross-section of age and gender travels the most?*/

SELECT
		DATE_PART('YEAR', AGE(CURRENT_DATE, u.birthdate)) AS age,
    u.gender,
    COUNT(DISTINCT f.trip_id) AS travel_count
FROM
    users u
LEFT JOIN
    sessions s ON u.user_id = s.user_id
LEFT JOIN
    flights f ON s.trip_id = f.trip_id
GROUP BY
    age, u.gender
ORDER BY
    travel_count DESC
LIMIT 5
;


-- 1.b 
/*How does the travel behavior of customers married with children
	compare to childless single customers?*/

SELECT
      (SELECT COUNT(f.trip_id) AS num_of_trips
      FROM
        users u
      LEFT JOIN
          sessions s ON u.user_id = s.user_id
      LEFT JOIN
          flights f ON s.trip_id = f.trip_id
      WHERE u.married IS TRUE AND u.has_children IS TRUE) AS trips_for_married_with_children,

      (SELECT COUNT(f.trip_id) AS num_of_trips
      FROM
        users u
      LEFT JOIN
          sessions s ON u.user_id = s.user_id
      LEFT JOIN
          flights f ON s.trip_id = f.trip_id
      WHERE u.married IS FALSE AND u.has_children IS FALSE) AS trips_for_single_without_children


-- 2.a
/*How much session abandonment do we see?
    Session abandonment means they browsed but did not book anything.*/

SELECT
	COUNT(session_id) AS num_of_abandoned_session
FROM
	sessions
WHERE trip_id IS NULL
;


-- 2.b
/*Which demographics abandon sessions disproportionately more than average?*/

WITH abandon_table AS (

    SELECT
        DATE_PART('YEAR', AGE(CURRENT_DATE, u.birthdate)) AS age,
        u.gender,
        COUNT(session_id) AS num_of_abandoned_session
    FROM
        users u
    LEFT JOIN
        sessions s ON u.user_id = s.user_id
    WHERE s.flight_booked IS FALSE AND s.hotel_booked IS FALSE
  	GROUP BY 1,2
  	ORDER BY num_of_abandoned_session DESC
)

SELECT *
FROM abandon_table
WHERE num_of_abandoned_session > (SELECT AVG(num_of_abandoned_session) FROM abandon_table)
;


-- 3.a
/*Explore how customer origin (e.g. home city) influences travel preferences*/
/*I've counted the number of trips by home city, home country, and home airport to paint a
more complete picture*/

/*home city*/
SELECT
    u.home_city,
    f.destination,
    f.trip_airline,
    COUNT(f.trip_id) AS trip_count
FROM
    users u
INNER JOIN
    sessions s ON u.user_id = s.user_id
INNER JOIN
    flights f ON s.trip_id = f.trip_id
GROUP BY
    u.home_city, f.destination, f.trip_airline
ORDER BY
    trip_count DESC
;

/*home country*/
SELECT
    u.home_country,
    f.destination,
    f.trip_airline,
    COUNT(f.trip_id) AS trip_count
FROM
    users u
INNER JOIN
    sessions s ON u.user_id = s.user_id
INNER JOIN
    flights f ON s.trip_id = f.trip_id
GROUP BY
    u.home_country, f.destination, f.trip_airline
ORDER BY
    trip_count DESC
;

/*home airport*/
SELECT
    u.home_airport,
    f.destination,
    f.trip_airline,
    COUNT(f.trip_id) AS trip_count
FROM
    users u
INNER JOIN
    sessions s ON u.user_id = s.user_id
INNER JOIN
    flights f ON s.trip_id = f.trip_id
GROUP BY
    u.home_airport, f.destination, f.trip_airline
ORDER BY
    trip_count DESC
;


-- 4.a

/* 4.a

Based on my examination, individuals identifying as male within the age range of late thirties to
early forties exhibit the highest travel frequency. The destinations with the most substantial trip
counts are New York and Los Angeles, suggesting a likelihood of these trips being business-related.
Additionally, unmarried and childless customers tend to travel more in comparison to married
customers with children. In summary, the analysis suggests that travel frequency is influenced by 
factors such as gender, age, destination choices, and marital/parental status.

*/












