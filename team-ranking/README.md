# Tournament ladder for Australian Jugger Leage

## Ranking Ladder Spreadsheet

Viewer access to google sheet to manage team rankings
https://docs.google.com/spreadsheets/d/19ccAh91r1MnGxJCbEfG4Q2qUT7xfoK0KyhUpSPE0Nkc/edit?gid=0#gid=0

## Ranking Ladder Requirements

The ladder needs to be able to handle incomplete data and inconsistent teams.
  - Not all teams can afford to travel to all tournaments.
  - Not all players on a team can afford to travel to tournaments and mercs can significantly impact the skill level of a team.

Self-normalising ranking ladders where points are transferred from the losing team to the winning team do not suit the nature of Jugger tournaments.
  - Teams retire / reform under new names with changes to the lineup.
  - Seeding new teams is difficult to impossible due to a mix of new players and veteran players.
    
The ranking ladder should balance encouraging players to organise and attend more tournaments without allowing a team that organises/travels the most to rise to the top of the ladder unless they also demonstrate skill.
  - Limit the tournaments counted to the 5 "best" recent tournaments
  - Older tournaments scores will have a "time decay" to prevent retired teams staying at the top of the ladder forever
  - Certain tournaments will be worth more points to encourage players to priorise attending more prestigous tournaments

The additional work for tournament organisers should be minimal.
  - Tournament organisers are free to choose the method of determining final placings, but must actually place all teams and not just the finalists.
  - Recommendations for the number of points a tournament is worth should be provided to tournament organisers for approval.
  - A central person should coordinate data entry and publication for the tournament ranking ladder to minimise overhead on individual tournament organisers.
    
## Instructions on Use

### Update tournament data
* Tournament results are to be entered on tab `All Ranking Results`.
* Select rows 10:18 and insert rows above
* Copy A19:A27 into A10:A18
* Fill in tournament name, date, max points and final tournament placing for each team that played in the tournament.
    - Max points is determined by the tournament organiser ahead of the tournament. Larger, more prestigous tournaments (e.g. Down Under International, Annual AJL Open) are recommended to have 16 points. Local tournaments recommended to have 8 points. Game days (3 or fewer teams) are recommended to have no more than 4 points.
* To add a new team, insert a new column in B with Team and City/Country (optional) and copy formula from C3:C9 into B3:B9
* Copy the formulae for number of teams, points interval, points and time modifier from a previous tournament to the teams for the new tournament
* Make sure score for new tournament is picked up by the scores section by amending the formula in B5 and drag/drop across the rest of the scores section
    - add `<col>%18` into the arrays in the formula, for example: `=IF(ISNUMBER(LARGE({B$18,B$27,B$36,B$45,B$63,B$72,B$54},ROWS(B$5:B5))),LARGE({B$18,B$27,B$36,B$45,B$63,B$72,B$54},ROWS(B$5:B5)),0)`

### Extract rankings ladder
* Copy rows 1:9 from `All Ranking Results` and paste values into I1 a new tab
* Copy data from I1:<??>4 and paste transpose into A1
* Copy formula from `Ranking_Ladder_Sorted_2018` E:G into your new tab
* Apply formatting
* Two ranking options are presented (overall weighted score and tournament weighted average)
  - A trial of 2 years of tournament data indicated that overall weighted score is the more accepted ranking
 
## Possible Future development
If the the trial of the ranking ladder is successful, efforts should be made to make the spreadsheet more user friendly. 
- For example, use VBA/macros to create buttons for "add new tournament", "add new team" & "extract current ladder" to replace the manual steps in the instructions.
- Reduce the limitations from using a wide spreadsheet to track teams by creating an app (possibly in python) that can handle the data entry and calculations.

## Final outcome
The push for competitive Jugger and multiple tournaments per year in Australia died down and there were insufficient games being played to sustain a rankings ladder. The ladder was published to the website for a year, with positive feedback, and then retired as tournaments dried up.
