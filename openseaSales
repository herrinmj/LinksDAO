SELECT  block_time,
        CASE WHEN CAST(nft_token_id AS INT) <= 6363 THEN 'LEISURE' ELSE 'GLOBAL' END AS Membership,
        original_amount as price,
        original_currency as currency,
        usd_amount,
        CAST(nft_token_id AS INT) AS membership_id,
        seller,
        buyer
FROM nft."trades"
WHERE nft_contract_address = '\x696115768BBEf67Be8bd408d760332A7EfbEE92D'
ORDER BY block_time DESC
