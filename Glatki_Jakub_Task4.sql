-- number of games where the score was 3-3, 
-- the player that was involved in the game event has nr 90 or higher,
-- has less than 2 goals in whole year 
-- and the average minute of event in the game is lesser than 45

explain SELECT count(g.id) as NrOfGames
FROM game g
JOIN gameevent ge on g.id=ge.game_id
JOIN player p on p.id=ge.player_id
JOIN playerstats ps on p.id=ps.Player_id
WHERE g.homeGoals=3
and g.awayGoals=3
and p.number>95
and ps.goals<2
group by g.homeGoals
having avg(ge.minute)<45;

create index numberIndex on player(number);
create index goalsIndex on playerstats(goals);
create index homeIndex on game(homeGoals);
create index awayIndex on game(awayGoals);
create index homeAwayIndex on game(homeGoals, awayGoals);

drop index numberIndex on player;
drop index goalsIndex on playerstats;
drop index homeIndex on game;
drop index awayIndex on game;


-- name of a countries that have bigger average number of teams than country1
-- has a league of level 10
-- and hasn't got a game that was played after november 2019
explain select l.country
from league l
join game g on g.League_id = l.id
where g.date <'2019-12-01 00:00:00'
and exists
(
 select ll.level
 from league ll
 where ll.level = 10
)
group by l.country
having avg(numberOfTeams)>(
select avg(numberOfTeams)
from league lll
where lll.country LIKE 'country1'
);

create index numberOfTeamsIndex on league(numberOfTeams);
create index dateIndex on game(date);
create index levelIndex on league(level);


-- surname and role of coaches that don't have any team but still their contract expires in 2025
explain select c.surname
from coach c
where c.contractLength > '2025-01-01 00:00:00'
and c.contractLength < '2025-12-31 23:59:59'
and not exists
(
select null
from team tt
where c.Team_id=tt.id)
group by c.salary;

create index salaryIndex on coach(salary);
create index contractLenghtIndex on coach(contractLength);

drop index salaryIndex on coach;
drop index contractLenghtIndex on coach;


-- name of the stadium of capacity lesser than 1000, 
-- that has a team that plays there and is in top 3 of it's league
-- and has at least 90 points

explain select s.name
from stadium s
join team t on t.Stadium_id=s.id
join teamstats ts on ts.Team_id=t.id
where s.capacity <1000
and t.position>3
and ts.points>90
group by s.name;

create index capacityIndex on stadium(capacity);
create index positionIndex on team(position);
create index pointsIndex on teamstats(points);

drop index capacityIndex on stadium;