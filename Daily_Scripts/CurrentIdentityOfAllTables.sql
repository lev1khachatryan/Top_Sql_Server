SELECT
    TABLE_NAME AS [Table],
    IDENT_CURRENT(TABLE_SCHEMA + '.' + TABLE_NAME) AS Id,
    IDENT_SEED(TABLE_SCHEMA + '.' + TABLE_NAME) AS Seed,
    IDENT_INCR(TABLE_SCHEMA + '.' + TABLE_NAME) AS Increment
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    OBJECTPROPERTY(OBJECT_ID(TABLE_SCHEMA + '.' + TABLE_NAME), 'TableHasIdentity') = 1
AND
    TABLE_TYPE = 'BASE TABLE'
AND TABLE_NAME LIKE 'C!_%' ESCAPE '!'
ORDER BY Id DESC
