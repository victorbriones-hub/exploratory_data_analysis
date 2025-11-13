SELECT
    ID,
    MerchantReferenceNumber,
    Amount,
    CAST(DATEADD (HOUR, -6, BatchDate) AS date) fecha,
    CAST(BatchDate AS date) fecha2,
    BinNumber,
    AuthorizationCode,
    AccountSuffix,
    ExpirationMonth,
    ExpirationYear,
    TypeDescription
FROM
    Cybersource
WHERE
    MerchantReferenceNumber <> 'cybs_test'






    
    -- T1 es la tabla que contiene la información de la compra de las membresías ( según yo)
    -- T2 tiene todo los demás pagos 
WITH
    T1 AS (
        SELECT
            A.id,
            bikeAccountNumber,
            DATE_FORMAT (
                CONVERT_TZ (
                    FROM_UNIXTIME (completionDateTime / 1000),
                    'UTC',
                    'America/Costa_Rica'
                ),
                '%Y-%m-%d'
            ) fecha1,
            DATE_FORMAT (
                CONVERT_TZ (
                    FROM_UNIXTIME (creationDateTime / 1000),
                    'UTC',
                    'America/Mexico_City'
                ),
                '%Y-%m-%d'
            ) fecha2,
            cardBinType,
            cardBinCountry,
            cardBin,
            amount / 10000 monto,
            B.localizedValue0 desc_mov,
            A.paymentBusinessContext_id,
            merchantTxId,
            C.localizedValue0 tipo,
            D.localizedValue0 result,
            reasonCode,
            CASE
                WHEN amount / 10000 IN (
                    100.29,
                    104.55,
                    108.8,
                    118,
                    121.77,
                    122.99,
                    127.99,
                    136.88
                ) THEN "1 Día"
                WHEN amount / 10000 IN (198.89, 208.25, 215.9, 234, 245, 253.99) THEN "3 Días"
                WHEN amount / 10000 IN (347.65, 361.25, 391, 409, 425, 332.35) THEN "7 Días"
                WHEN amount / 10000 IN (
                    49,
                    64.11,
                    69.65,
                    354.29,
                    376.42,
                    398.58,
                    416.81,
                    416.93,
                    432.99,
                    442.85,
                    463.25,
                    463.26,
                    481.1,
                    490.51,
                    491.9,
                    509.4,
                    518.45,
                    521.00,
                    544.99,
                    545.00,
                    565.99,
                    566.00,
                    481.09
                ) THEN "Anual"
                WHEN amount / 10000 IN (
                    89.9,
                    687.73,
                    701.8,
                    745.01,
                    764.15,
                    793.89,
                    809.1,
                    825.65,
                    840.59,
                    898.99,
                    899,
                    934,
                    829.6
                ) THEN "Anual Ecobici +"
                WHEN amount / 10000 IN (806.64, 844.1, 948.98, 949, '685.64') THEN "Ecobici HSBC"
                ELSE "Otro"
            END tipo_subs,
            CASE
                WHEN amount / 10000 IN (
                    100.29,
                    104.55,
                    108.8,
                    118,
                    121.77,
                    122.99,
                    127.99,
                    136.88,
                    198.89,
                    208.25,
                    215.9,
                    234,
                    245,
                    253.99,
                    347.65,
                    361.25,
                    391,
                    409,
                    425,
                    332.35
                ) THEN "Temporal"
                WHEN amount / 10000 IN (
                    49,
                    64.11,
                    69.65,
                    354.29,
                    376.42,
                    398.58,
                    416.81,
                    416.93,
                    432.99,
                    442.85,
                    463.25,
                    463.26,
                    481.1,
                    490.51,
                    491.9,
                    509.4,
                    518.45,
                    521.00,
                    544.99,
                    545.00,
                    565.99,
                    566.00,
                    89.9,
                    687.73,
                    701.8,
                    745.01,
                    764.15,
                    793.89,
                    809.1,
                    825.65,
                    840.59,
                    844.1,
                    898.99,
                    899,
                    934,
                    806.64,
                    948.98,
                    949,
                    481.09,
                    829.6,
                    685.64
                ) THEN "Anual"
            END temporalidad,
            A.paymentRequest_id,
            E.localizedValue0 Source_Type,
            F.localizedValue0 Payment_Type
        FROM
            BikePaymentFact A
            LEFT JOIN PaymentBusinessContextDim B ON B.id = A.paymentBusinessContext_id
            LEFT JOIN PaymentTypeDim C ON C.id = A.paymentType_id
            LEFT JOIN PaymentResultDim D ON D.id = A.paymentResult_id
            LEFT JOIN PaymentSourceTypeDim E ON A.paymentSourceType_id = E.id
            LEFT JOIN PaymentTypeDim F ON A.paymentType_id = F.id
        WHERE
            paymentBusinessContext_id IN (12644811, 12644812, 12644813)
            AND paymentResult_id IN (1, 5)
    )
SELECT
    T2.*,
    CASE
        WHEN temporalidad = 'Anual'
        AND conteo = 1 THEN 'Nuevo anual'
        WHEN temporalidad = 'Anual'
        AND conteo <> 1 THEN 'Renovado anual'
        WHEN temporalidad = 'Temporal'
        AND conteo = 1 THEN 'Nuevo temporal'
        WHEN temporalidad = 'Temporal'
        AND conteo <> 1 THEN 'Renovado temporal'
    END renovacion
FROM
    (
        SELECT
            T1.*,
            ROW_NUMBER() OVER (
                PARTITION BY
                    bikeAccountNumber,
                    temporalidad
                ORDER BY
                    fecha1 ASC
            ) conteo
        FROM
            T1
    ) T2
UNION ALL
SELECT
    A.id,
    bikeAccountNumber,
    DATE_FORMAT (
        CONVERT_TZ (
            FROM_UNIXTIME (completionDateTime / 1000),
            'UTC',
            'America/Costa_Rica'
        ),
        '%Y-%m-%d'
    ) fecha1,
    DATE_FORMAT (
        CONVERT_TZ (
            FROM_UNIXTIME (creationDateTime / 1000),
            'UTC',
            'America/Mexico_City'
        ),
        '%Y-%m-%d'
    ) fecha2,
    cardBinType,
    cardBinCountry,
    cardBin,
    amount / 10000 monto,
    B.localizedValue0 desc_mov,
    A.paymentBusinessContext_id,
    merchantTxId,
    C.localizedValue0 tipo,
    D.localizedValue0 result,
    reasonCode,
    NULL AS tipo_subs,
    NULL AS temporalidad,
    A.paymentRequest_id,
    E.localizedValue0 Source_Type,
    F.localizedValue0 Payment_Type,
    NULL AS conteo,
    NULL AS renovacion
FROM
    BikePaymentFact A
    LEFT JOIN PaymentBusinessContextDim B ON B.id = A.paymentBusinessContext_id
    LEFT JOIN PaymentTypeDim C ON C.id = A.paymentType_id
    LEFT JOIN PaymentResultDim D ON D.id = A.paymentResult_id
    LEFT JOIN PaymentSourceTypeDim E ON A.paymentSourceType_id = E.id
    LEFT JOIN PaymentTypeDim F ON A.paymentType_id = F.id
WHERE
    paymentBusinessContext_id NOT IN (12644811, 12644812, 12644813)
    AND paymentResult_id IN (1, 5);