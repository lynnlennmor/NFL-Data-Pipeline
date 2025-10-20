# NFL-Data-Pipeline

### NFL Data Pipeline: Eagles Weekly Performance

End-to-end data project showcasing a full analytics workflow — from Python data extraction to SQL transformation and Tableau visualization — using real NFL data.

### Project Overview

This project demonstrates how I built a simple data pipeline for analyzing NFL team performance.
Using the Philadelphia Eagles as a case study, the pipeline extracts, cleans, transforms, and visualizes weekly team statistics.

_(Disclaimer: I don't own any of this data, this was only done for learning purposes and interest.)_

### Process:

Step 1 — Data Extraction (Python): NFL team and player statistics are pulled directly using the NFLReadPy package, then written into SQL Server tables.

Step 2 — Cleaning & Transformation (Pandas + SQL):
- Data is cleaned and verified (normalizing column types) (Pandas).
- Derived metrics like total yards, average yards per carry, and total touchdowns are created (sql).
- Team vs opponent data is joined for side-by-side comparisons (sql).

Step 3 — Analysis & Visualization (Tableau): The cleaned dataset is visualized in Tableau to show:
- Weekly offensive performance (passing, rushing, total yards)
- Overall total, touchdowns, first downs, yards & avgerage yards per game
- Comparison between Eagles and opponents

[View Tableau Dashboard](https://public.tableau.com/app/profile/lynn.lennmor/viz/NFL_Weekly_Team_stats/Dashboard1?publish=yes)

### Outcome
- End-to-end data pipeline (Python → SQL → Tableau)
- Modular, readable SQL queries using CTEs
- NFL team-level weekly data with derived performance metrics
- Clean integration between Python (extraction) and SQL Server (storage/analysis)
- Interactive Tableau visualization for storytelling

### Tools:
| Category      | Tools                                                           |
| ------------- | --------------------------------------------------------------- |
| Programming   | Python, Pandas                                                  |
| Data Source   | [NFLReadPy](https://nflreadpy.nflverse.com/api/load_functions/) |
| Database      | SQL Server (T-SQL)                                              |
| Visualization | Tableau                                                         |
| Other         | SQLAlchemy, Jupyter Notebooks, Git & GitHub                     |
