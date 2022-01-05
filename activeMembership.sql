with transfers AS 
(   
    ( 
       SELECT "to" AS wallet,
              'mint' AS action,
              "tokenId",
               1 AS value
       FROM erc721."ERC721_evt_Transfer"
       WHERE contract_address = '\x696115768BBEf67Be8bd408d760332A7EfbEE92D'
       AND "from" = '\x0000000000000000000000000000000000000000'
     )
UNION ALL
    (
        SELECT  "to" AS wallet,
                'gain' AS action,
                "tokenId",
                 1 AS value
        FROM erc721."ERC721_evt_Transfer"
        WHERE contract_address = '\x696115768BBEf67Be8bd408d760332A7EfbEE92D'
        AND "from" != '\x0000000000000000000000000000000000000000')
 UNION all 
    (
        SELECT  "from" AS wallet,
                'lose' AS action,
                "tokenId",
                -1 AS value
        FROM erc721."ERC721_evt_Transfer"
        WHERE contract_address = '\x696115768BBEf67Be8bd408d760332A7EfbEE92D'
        AND "from" != '\x0000000000000000000000000000000000000000'
    )
),

member_filter AS (
SELECT  wallet,
        action,
        "tokenId",
        CASE WHEN "tokenId" <=6363 THEN value ELSE 0 END AS leisure_value,
        CASE WHEN "tokenId" > 6363 THEN value ELSE 0 END AS global_value,
        value
FROM transfers
),

full_counts AS (
SELECT  wallet, 
        SUM(leisure_value) as leisure_count,
        SUM(global_value) as global_count,
        SUM(value) as total_memberships
FROM member_filter
GROUP BY wallet
ORDER BY leisure_count  desc
)

SELECT * FROM full_counts WHERE total_memberships != 0 








