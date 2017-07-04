
/*
    Recreate database and populate with baseline data
*/
DROP DATABASE IF EXISTS news;
CREATE DATABASE news;
\c news
\i newsdata.sql


/*
    Helper view to retrieve document details
    for GETS the returned genuine documents
*/
CREATE OR REPLACE VIEW viewed_articles AS
SELECT name,
       hits,
       author,
       title
FROM
  (SELECT regexp_replace(path,'.*article/','') AS name,
          count(*) AS hits
   FROM log
   WHERE path LIKE '%/article/%'
     AND status = '200 OK'
   GROUP BY log.path) hits
JOIN articles ON hits.name = articles.slug ;

 
/*
    Report 1 - What are the most popular three articles of all time?

    Simple group/ordering using the helper view
*/
CREATE OR REPLACE VIEW report1 AS
SELECT '"'||title||'" - '||hits||' views' AS txt
FROM viewed_articles
ORDER BY hits DESC
LIMIT 3;


/*
    Report 2 - Who are the most popular article authors of all time?

    Simple group then join using the helper view
*/
CREATE OR REPLACE VIEW report2 AS
SELECT name ||' - '|| views ||' views' AS txt
FROM
  (SELECT author,
          SUM(hits) AS views
   FROM viewed_articles
   GROUP BY author) hits
JOIN authors ON author = id
ORDER BY views DESC;


/*
    Report 3 - On which days did more than 1% of requests lead to errors?

    Format the date/time to a specific day and then group to get daily hits
    Do the same but for when there were errors
    Divide errors by total gets, converting to float type to prevent integer rounding
*/
CREATE OR REPLACE VIEW report3 AS
SELECT DAY || ' - ' || trim(to_char(100*bad.hits/total.hits::float,'90d9%')) || ' errors' AS txt
FROM
  (SELECT to_char(TIME,'FMMonth DD, YYYY') AS DAY,
          count(*) hits
   FROM log
   GROUP BY DAY) total
JOIN
  (SELECT to_char(TIME,'FMMonth DD, YYYY') AS DAY,
          count(*) hits
   FROM log
   WHERE status <> '200 OK'
   GROUP BY DAY) bad USING (DAY)
WHERE (100*bad.hits/total.hits::float) > 1;

