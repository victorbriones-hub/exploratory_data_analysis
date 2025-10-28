

SELECT 
    member_accountNumber,
    startStation_id,
    endStation_id,
    startDock_id,
    endDock_id,
    duration,
    bike_id,
    bikeDefect_id,
    distanceInMeters,
    member_birthday,
    member_country,
    member_gender,
    member_postalCode,
    subscriptionId,
    totalDurationMs
FROM BikeRentalFact
WHERE 
	creationTimeMs BETWEEN UNIX_TIMESTAMP(CONVERT_TZ("2025-03-01 00:00:00", "America/Mexico_City", 'UTC'))*1000
    AND UNIX_TIMESTAMP(CONVERT_TZ("2025-03-15 23:59:59", "America/Mexico_City", 'UTC'))*1000;