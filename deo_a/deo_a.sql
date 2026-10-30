-- 1. Колико утакмица је одиграно у фебруару 2025?
select count(*)
from matches
where kickoff_ts between '2025-02-01' and '2025-03-01';

-- A1 --> 40 utakmica

------------------------------------------------------------------------------------------------------------------------

-- 2. Који стадион има највећи капацитет, а који је највећи стадион неког клуба?

select *
from stadiums
order by capacity desc;

-- Najveći kapacitet Nacionalni Stadion 80000

select
    t.*,
    s.capacity,
    s.stadium_name
from teams t
join stadiums s on t.stadium_id = s.stadium_id
order by capacity desc;

-- Najveci stadion je od kluba Northport United, a kapacitet je 52000


------------------------------------------------------------------------------------------------------------------------

-- 3. Колико играча у лиги има српско држављанство (nationality = 'Serbia')?

select count(*)
from players
where nationality = 'Serbia';

-- 42 igraca ima srpsko drzavljanstvo

------------------------------------------------------------------------------------------------------------------------

-- 4. Колико утакмица је завршено резултатом 1:1?

select count(*) as total_games
from matches
where home_goals = 1 
    and away_goals = 1;

-- 94 utakmice su imale rezultat 1:1

------------------------------------------------------------------------------------------------------------------------

-- 5. Колика је просечна посета по сезони?

select
    season,
    round(avg(attendance)) as prosecna_poseta
from matches
where status = 'played'
group by season;

------------------------------------------------------------------------------------------------------------------------

-- 6. Колико голова је дато из пенала по сезони?

select
    m.season,
    count(*) as total_games
from match_events me
join matches m on me.match_id = m.match_id
where me.event_type = 'penalty_goal'
group by m.season

-- 2023/24 --> 104 gola
-- 2024/25 --> 109 gola

------------------------------------------------------------------------------------------------------------------------

-- 7. Колико различитих играча је дало бар један гол у сезони 2024/25?

select
    count(distinct me.player_id)
from match_events me
join matches m on me.match_id = m.match_id
where me.event_type in ('goal', 'penalty_goal')
    and m.season = '2024/25'

-- 308 igrača je dalo bar gol, računao sam bez autogolova.

------------------------------------------------------------------------------------------------------------------------

-- 8. Који судија је највише пута судио утакмице клуба Northport United?

select
    r.referee_name,
    count(*) as total
from matches m
join teams t on m.away_team_id = t.team_id
    or m.home_team_id = t.team_id
join referees r on m.referee_id = r.referee_id
where t.team_name = 'Northport United' 
group by referee_name
order by total desc;  

-- referee_name	    total
-- Peter Lindgren	  9

------------------------------------------------------------------------------------------------------------------------





