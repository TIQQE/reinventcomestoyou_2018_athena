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
