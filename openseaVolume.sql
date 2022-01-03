WITH days AS (SELECT generate_series('2021-12-31', date_trunc('day', NOW()), '1 day') AS DAY ),

sales_data AS 
(
  SELECT  date_trunc('day',evt_block_time) AS day,
          SUM(price/1e18) AS total_volume,
          COUNT(*) AS total_sales,
          COUNT(distinct maker) AS unique_sellers,
          COUNT(distinct taker) AS unique_buyers
  FROM opensea."WyvernExchange_evt_OrdersMatched"
  WHERE opensea."WyvernExchange_evt_OrdersMatched".evt_tx_hash IN
       (
         SELECT  call_tx_hash
         FROM opensea."WyvernExchange_call_atomicMatch_"
         WHERE addrs[5] = '\x696115768BBEf67Be8bd408d760332A7EfbEE92D'
               AND call_success IS TRUE 
       )
  GROUP BY day
)
    
SELECT  days.day,
        total_sales,
        ROUND(total_volume, 2) as "Total Volume",
        unique_sellers,
        unique_buyers
FROM days 
LEFT JOIN sales_data ON days.day = sales_data.day
ORDER BY days.day DESC
