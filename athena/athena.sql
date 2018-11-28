DROP DATABASE demo;

CREATE DATABASE demo;

DROP TABLE demo.HistoricalEvents;

CREATE EXTERNAL TABLE demo.HistoricalEvents (
  event struct<
    date:STRING,
    description:STRING,
    lang:STRING,
    category1:STRING,
    category2:STRING,
    granularity:STRING
  >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://reinventcomestoyou-test/processed/';

-- Select everything, cusomt query to use in QuickSight
SELECT
  CAST(SPLIT_PART(event.date, '/', 1) AS INTEGER) AS year,
  REPLACE(event.date, '/', '-') AS date,
  event.description,
  event.lang,
  event.category1,
  event.category2,
  event.granularity
FROM
  demo.HistoricalEvents;

-- Find all events during certain years
SELECT
  CAST(SPLIT_PART(event.date, '/', 1) AS INTEGER) AS year,
  REPLACE(event.date, '/', '-') AS date,
  event.description,
  event.lang,
  event.category1,
  event.category2,
  event.granularity
FROM
  demo.HistoricalEvents
WHERE
  CAST(SPLIT_PART(event.date, '/', 1) AS INTEGER) BETWEEN 320 AND 350 AND
  event.category1 = 'By topic' AND
  event.category2 = 'Art';


-- Example for a more complex query used in the field, to find turnover for a month
SELECT
  'Sept 2018' AS DATE_INTERVAL,
  COUNT(DISTINCT cartId) AS NR_PURCHASES,
  COUNT(1) AS NR_ORDER_ITEMS,
  SUM(itemAmount)/100 AS TOTAL_SEK_AMOUNT
FROM
  NordicPayment.NordicPaymentCartItems
WHERE
  cartId LIKE 'ST%' AND
  content.validFrom = 'SE' AND
  paymentDate IS NOT NULL AND
  paymentDate BETWEEN '2018-09-01' AND '2018-09-30';
