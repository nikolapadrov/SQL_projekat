---------------------------------------------
-- DEO D Modeliranje: Zvezda za disciplinu --
---------------------------------------------
create schema if not exists bootcamp.sandbox;

-- Svi klubovi iz teams u dim.team --
create or replace table bootcamp.sandbox.dim_team as
select * from bootcamp.northern_star.teams;

select *
from bootcamp.sandbox.dim_team;

-- Kalendar u dim_date --
create or replace table bootcamp.sandbox.dim_date as
select cast(date_format(d, 'yyyyMMdd') as int) as date_key,
       d                                       as full_date,
       date_format(d, 'EEEE')                  as weekday_name,
       dayofweek(d) in (1, 7)                  as is_weekend,
       case when month(d) >= 7 then concat(year(d), '/', substring(cast(year(d) + 1 as string), 3, 2))
            else concat(year(d) - 1, '/', substring(cast(year(d) as string), 3, 2))
       end                                     as season
from (select explode(sequence(date'2023-07-01', date'2025-06-30', interval 1 day)) as d);

select * from bootcamp.sandbox.dim_date;

-- Svi igrači iz players (plus player_id = -1) u dim_player --
create or replace table bootcamp.sandbox.dim_player as
select player_id, first_name, last_name, nationality, position
from bootcamp.northern_star.players
union
select -1, 'nepoznato', 'nepoznato', null, null;

select * from bootcamp.sandbox.dim_player
where player_id = -1;

-- Sve sudije iz referees u dim_referee --
create or replace table bootcamp.sandbox.dim_referee as
select * from bootcamp.northern_star.referees;

select *
from bootcamp.sandbox.dim_referee;


-- iz match_events -- 
select e.event_id, e.match_id, e.team_id, e.player_id, e.event_type
from bootcamp.northern_star.match_events e
where e.event_type in ('yellow_card', 'second_yellow', 'red_card');

-- date_key kao u dim_date --
select e.event_id,
       e.match_id,
       cast(date_format(m.kickoff_ts, 'yyyyMMdd') as int) as date_key,
       e.team_id,
       e.player_id,
       m.referee_id,
       e.event_type
from bootcamp.northern_star.match_events e
join bootcamp.northern_star.matches m on e.match_id = m.match_id
where e.event_type in ('yellow_card', 'second_yellow', 'red_card');


-- select e.event_id,
--        e.match_id,
--        cast(date_format(m.kickoff_ts, 'yyyyMMdd') as int) as date_key,
--        e.team_id,
--        coalesce(dim_p.player_id, -1) as player_id,
--        m.referee_id,
--        e.event_type as card_type
-- from bootcamp.northern_star.match_events e
-- join bootcamp.northern_star.matches m on e.match_id = m.match_id
-- left join bootcamp.sandbox.dim_player dim_p on e.player_id = dim_p.player_id
-- where e.event_type in ('yellow_card', 'second_yellow', 'red_card')
--     order by dim_p.player_id; 


-- fact_card sa potrebnim kolonama -- 
create or replace table bootcamp.sandbox.fact_card as
select e.event_id,
       e.match_id,
       cast(date_format(m.kickoff_ts, 'yyyyMMdd') as int) as date_key,
       e.team_id,
       coalesce(dim_p.player_id, -1) as player_id,
       m.referee_id,
       e.event_type as card_type
from bootcamp.northern_star.match_events e
join bootcamp.northern_star.matches m on e.match_id = m.match_id
left join bootcamp.sandbox.dim_player dim_p on e.player_id = dim_p.player_id
where e.event_type in ('yellow_card', 'second_yellow', 'red_card');

select * from bootcamp.sandbox.fact_card
order by player_id
limit 10;
