

create or replace view viewed_articles
as
select name, ip, author, title
from (
SELECT regexp_replace(path,'.*article/','') as name,
             ip
      FROM log
      WHERE path<>'/'
        AND status = '200 OK') hits
join articles on hits.name = articles.slug
;


 
/* Report 1 */
create or replace view report1 as
SELECT '"'||title||'" - '||hits||' views' as txt
FROM
  (SELECT title,
          count(*) AS hits
   FROM viewed_articles
   GROUP BY title
   ORDER BY hits DESC
   LIMIT 3) top_hits;


/* Report 2 */
create or replace view report2 as
select name ||' - '|| views ||' views' as txt
from (
select author,count(*) as views 
from viewed_articles
group by author) hits
join authors on author = id
order by views desc;


/* Report 3 */
create or replace view report3 as
select day || ' - ' || trim(to_char(100*bad.hits/total.hits::float,'90d9%')) || ' errors' as txt
from (
select to_char(time,'FMMonth DD, YYYY') as day, count(*) hits
 from log
group by day
) total
join (
select to_char(time,'FMMonth DD, YYYY') as day, count(*) hits
 from log
where status <> '200 OK'
group by day
) bad
using (day)
where (100*bad.hits/total.hits::float) > 1;
