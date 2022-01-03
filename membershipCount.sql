WITH mint AS (
SELECT  t.block_time AS time,
        t.success,
        t."to" AS to_address,
        t."from" AS from_address,
        t.value/10e17 as value,
        t.gas_price
FROM ethereum.transactions t
WHERE t."to" = '\x696115768BBEf67Be8bd408d760332A7EfbEE92D' AND success = TRUE
),

split AS (
SELECT *,
CASE    WHEN value/0.72 = 1 THEN 1 
        WHEN (value-.18)/.72=1 THEN 1 
        WHEN (value-0.36)/.72 = 1 THEN 1 
        WHEN (value-0.54)/.72 = 1 THEN 1 
        ELSE 0 END AS global_count,
CASE    WHEN value/0.18 = 1 THEN 1 
        WHEN value/0.18 = 2 THEN 2 
        WHEN value/0.18 = 3 THEN 3 
        WHEN (value-.72)/.18 = 1 THEN 1 
        WHEN (value-.72)/.18 = 2 THEN 1 
        WHEN (value-.72)/.18 = 3 THEN 1 
        ELSE 0 END AS Leisure
FROM mint
)


SELECT from_address, SUM(global_count) as Global, SUM(leisure) as Leisure
FROM split
GROUP BY from_address
