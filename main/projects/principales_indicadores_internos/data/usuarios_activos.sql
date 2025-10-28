

SET SESSION net_read_timeout = 600;
SET SESSION net_write_timeout = 600;

SET @fecha_inicio = "2025-09-22 00:00:00";
SET @fecha_final = "2025-10-22 23:59:59";
SET @zona_horaria = "America/Mexico_City";

SELECT COUNT(DISTINCT member_accountNumber) as total_usuarios_unicos
FROM mex_datawarehouse_bss4.BikeRentalFact
WHERE 
    (startTimeMs BETWEEN UNIX_TIMESTAMP(CONVERT_TZ(@fecha_inicio, @zona_horaria, 'UTC'))*1000 
    AND UNIX_TIMESTAMP(CONVERT_TZ(@fecha_final, @zona_horaria, 'UTC'))*1000)
    AND NOT ((startStation_id = endStation_id) AND (duration/60 < 2));