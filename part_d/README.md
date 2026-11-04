1. Jedan red u fact_card predstavlja jedan red iz match_events koji sadrži kartonski događaj.
   Obe tabele sa ovim tipom događaja imaju isti broj redova.
2. Ključevi:
   dim_team.team_id         -->     team_id
   dim_date.date_key        -->     date_key
   dim_player.player_id     -->     player_id
   dim_referee.referee_id   -->     referee_id
3. Kartoni imaju svoju tabelu činjenica jer su tako svi na jednom mestu, odvojeni od ostalih događaja. 
   Analiza po datumu, sudiji, klubu ili igraču se izvodi jednostavno spajanjem fact_card tabele sa jednom dimenzijom i grupisanjem. U slučaju sa nepoznatim igračem (player_id = -1) kod ovakvog modeliranja ne nestaju kartoni igrača kojih nema u tabeli players.

