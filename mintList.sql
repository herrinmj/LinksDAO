WITH erc721 AS (
    SELECT *
    FROM erc721."ERC721_evt_Transfer"
    WHERE contract_address= '\x696115768BBEf67Be8bd408d760332A7EfbEE92D'
),

mints AS(
    SELECT * FROM erc721
    WHERE erc721."from" = '\x0000000000000000000000000000000000000000'
    ORDER BY evt_block_time DESC
),

distinct_mints AS (
SELECT COUNT(DISTINCT mints."to") 
FROM mints
),

mint_memberships AS(
SELECT  mints."from" as from_address,
        mints."to" as to_address, 
        mints."tokenId",
        CASE WHEN mints."tokenId" <= 6363 THEN 'LEISURE' ELSE 'GLOBAL' END AS membership,
        evt_tx_hash,
        evt_block_time,
        CASE WHEN mints."tokenId" <=6363 THEN 1 ELSE 0 END AS leisure_counter,
        CASE WHEN mints."tokenId" > 6363 THEN 1 ELSE 0 END AS global_counter
FROM mints
)


SELECT  to_address as walletId, 
        SUM(global_counter) AS global_total,
        SUM(leisure_counter) AS leisure_total
        
FROM mint_memberships
GROUP BY to_address





