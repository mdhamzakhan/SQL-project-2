select * from ae
order by Year

select * from nr

--- Query 1 Number of  olympics happened till date
select distinct(count(games))
from ae

-- Query 2  List of distinct sports played throughout each olympics games
select (games)
from ae

--Query 3 List of teams that participated in each olympics
select Games,count(distinct(team))
from ae
group by Games
order by Games

--- Query 4 Max and MIn teams throughout history
with cte1 as (select Games, count(distinct(team)) as nteams
from ae
group by Games)

select * from cte1 where nteams =(select MIN(nteams) from cte1)
union
select * from cte1 where nteams =(select max(nteams) from cte1)

--Query 6 Sports that are played in every Olympics Games
with g as (
select count(distinct games) as no_games_summ from ae where season = 'Summer' ),
 sp as 
	(select distinct sport,Games from ae where Season = 'Summer'  ),
 t3 as 
	( select sport, COUNT(games) as snum from sp group by sport)
select * 
from t3 join g on t3.snum =g.no_games_summ

      with t1 as
          	(select count(distinct games) as total_games
          	from ae where season = 'Summer'),
          t2 as
          	(select distinct games, sport
          	from ae where season = 'Summer'),
          t3 as
          	(select sport, count(1) as no_of_games
          	from t2
          	group by sport)
      select *
      from t3
      join t1 on t1.total_games = t3.no_of_games;


-- Query 7 
with cte as (	
	select sport, count(Sport) as ct
	from ae
	group by sport)
select sport, cte.ct
from cte where ct = 1

-- Query 8
select distinct games, COUNT(distinct(sport)) as no_sports
from ae 
group by Games

--query 9 Info of oldest candidates winning gold 

select Name, Team, Medal from ae where Age = (select max(Age) from ae) and Medal ='GOLD' and Age <> 'Null'

-- Query 10  Number of male and female candidates
with t1 as 
	(select games, COUNT(sex) m from ae where sex ='m'
	group by Games),
t2 as 
	( select games, COUNT(sex) f from ae where sex ='f'
	group by Games)
select t1.Games,m/f as ratio from t1 join t2 on t1.Games = t2.Games
order by t1.Games

-- Query 11 Info of people who Highest Number of Medals in Olympics history
with cte as
(select name ,count(medal) as num
from ae
where medal = 'Gold'
group by name),
t2 as (select name,num , dense_rank() over(partition by name order by num) as rnk  from cte where num>10)
select name,num , rnk from t2 where rnk <6





