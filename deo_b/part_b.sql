
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
