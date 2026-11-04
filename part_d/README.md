## Model podataka – kartoni

### 1. Svaki karton - jedan red

Jedan red u `fact_card` predstavlja jedan red iz `match_events` koji sadrži kartonski događaj.
Za ovaj tip događaja obe tabele imaju **isti broj redova**.

### 2. Ključevi

| Dimenzija    | Ključ dimenzije | Kolona u `fact_card` |
|--------------|-----------------|----------------------|
| `dim_team`   | `team_id`       | `team_id`            |
| `dim_date`   | `date_key`      | `date_key`           |
| `dim_player` | `player_id`     | `player_id`          |
| `dim_referee`| `referee_id`    | `referee_id`         |

### 3. Zašto kartoni imaju svoju tabelu činjenica

- Svi kartoni su na jednom mestu, odvojeni od ostalih događaja.
- Analiza po datumu, sudiji, klubu ili igraču radi se jednostavnim spajanjem `fact_card` sa jednom dimenzijom i grupisanjem.
- Kartoni igrača kojih nema u tabeli `players` **ne nestaju**, jer dobijaju `player_id = -1` (nepoznat igrač).
