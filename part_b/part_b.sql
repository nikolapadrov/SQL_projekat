
--  Преглед сезоне: број утакмица и голова, просечан број голова по утакмици, удео победа
--  домаћина, нерешених и победа гостију

select * from matches;

select 
    count(*) as broj_utakmica,
    sum(home_goals + away_goals) as broj_golova,
    round(sum(home_goals + away_goals) / count(*),2) as avg_gol_po_utakmici,
    round(count_if(home_goals > away_goals) / count(*) * 100.0,2) as prc_domacin,
    round(count_if(home_goals = away_goals) / count(*) * 100.0,2) as prc_nereseno,
    round(count_if(home_goals < away_goals) / count(*) * 100.0,2) as prc_izgubljenih
from matches
WHERE season = '2024/25'
    and status = 'played';


-- 2. По месецима: број утакмица и голова по месецима, и просечан број голова по утакмици у
--    сваком месецу. Који месец се издваја?

select
    date_format(kickoff_ts, 'MMMM') as mesec,
    count(*) as broj_utakmica,
    sum(home_goals + away_goals) as broj_golova,
    round(sum(home_goals + away_goals) / count(*),2) as prosek_golovi
from matches
group by mesec
order by prosek_golovi desc;


-- 3. Публика: просечна посета и попуњеност по стадиону; утакмице без податка о посети и
-- утакмица без публике.

select
    s.stadium_name,
    s.capacity,
    round(avg(m.attendance)) as avg_poseta,
    round(avg(m.attendance) / s.capacity * 100.0,2) as prc_per_stadium 
from matches m
join stadiums s on m.stadium_id = s.stadium_id
where season = '2024/25'
    and status = 'played'
group by  s.stadium_name, s.capacity
order by prc_per_stadium desc;


select count(*)
from matches
where attendance is null
    and season = '2024/25'

-- 9 utakmica sa nepoznatom posetom 


select count(*)
from matches
where attendance = 0
    and season = '2024/25'

-- nema utakmica bez posete 


-- 4. Судије: за сваког судију број утакмица и картони по утакмици.

with mec as (
select
    m.match_id,
    m.referee_id,
    count(me.event_type) as kartoni
from matches m
left join match_events me on m.match_id = me.match_id 
    and me.event_type in ('yellow_card','second_yellow','red_card')
where m.status = 'played'
group by m.match_id, m.referee_id
)
select
    mec.referee_id,
    count(mec.match_id) as total_games,
    sum(kartoni) as total_kartoni,
    round(sum(kartoni) / count(mec.match_id),2) as kartoni_po_utkamici
from mec
group by mec.referee_id
order by kartoni_po_utkamici desc;


-- 5. Играчи: пет најбољих стрелаца и пет најбољих асистената.


with igraci as(
select
    me.player_id,
    count_if(event_type in ('goal', 'penalty_goal')) as total_goals
from match_events me
join matches m on me.match_id = m.match_id
where event_type in ('goal', 'penalty_goal')
    and m.status = 'played'
group by me.player_id
)
select
    p.first_name,
    p.last_name,
    i.total_goals    
from igraci i
join players p on i.player_id = p.player_id
order by total_goals desc
limit 5;


with asistenti as(
select
    me.related_player_id,
    count_if(event_type in ('goal')) as total_assists
from match_events me
join matches m on me.match_id = m.match_id
where event_type in ('goal')
    and m.status = 'played'
    and me.related_player_id is not null
group by me.related_player_id
)
select
    p.first_name,
    p.last_name,
    a.total_assists    
from asistenti a
join players p on a.related_player_id = p.player_id
order by total_assists desc
limit 5;


-- 6. Квалитет података: бар два проблема на која сте наишли у подацима (на пример утакмица
-- чији резултат се не слаже са догађајима, догађаји са непостојећим играчем, дан без
-- тренера), са упитима који их проналазе.

select
    me.event_id,
    me.match_id,
    me.team_id,
    me.player_id
from match_events me
left join players p on me.player_id = p.player_id
where p.player_id is null;

select * from players where player_id = 99999;


select
    t.team_id,
    t.team_name,
    m.match_id,
    m.season,
    m.status
from teams t
left join matches m on t.team_id = m.home_team_id
    or m.away_team_id = t.team_id
where m.match_id is null;

select * from matches where match_id is null;


