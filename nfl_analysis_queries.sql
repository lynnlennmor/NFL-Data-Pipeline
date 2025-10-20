/*
Author: Lynn
Project: NFL Weekly Team Performance Analysis
Goal: Join team and opponent stats to compute combined and derived metrics for each game.
Highlights:
 - Uses self-join to pair opponents
 - Aggregates rushing/passing data
 - Includes derived averages and totals
*/

-- ===========================
--	1. Base matchup data
-- ===========================

WITH base_data AS (
	SELECT 
		t1.season,
		t1.week,
		t1.team,
		t1.opponent_team,
		t1.passing_yards,
		t1.sack_yards_lost,
		t1.completions,
		t1.attempts,
		t1.passing_first_downs,
		t1.passing_tds,
		t1.passing_interceptions,
		t1.carries,
		t1.rushing_first_downs,
		t1.rushing_yards,
		t1.rushing_tds,
		t1.rushing_fumbles,
		t1.def_tds,
		t1.special_teams_tds,
		t1.sacks_suffered,
		t1.fg_made,
		t1.fg_att
	FROM nfl_team_stats as t1
	JOIN nfl_team_stats as t2
		ON t1.week = t2.week
		AND t1.team = t2.opponent_team
		AND t1.opponent_team = t2.team
	WHERE t1.team = 'PHI' OR t1.opponent_team = 'PHI' -- Only using Eagles Data for this paricular project
),

-- ===========================
--	2. Rushing metrics
-- ===========================

rushing_data AS (
	SELECT
		season,
		week,
		team,
		opponent_team,
		carries as rushing_attempts,
		rushing_yards as total_rushing_yards,
		CASE
			WHEN carries > 0
			THEN rushing_yards * 1.0/ carries
		END AS avg_rushing_yards_carry,
		rushing_tds,
		rushing_fumbles,
		rushing_first_downs
	FROM base_data
),

-- ===========================
--	3. Passing metrics
-- ===========================

passing_data AS (
	SELECT
		season,
		week,
		team,
		opponent_team,
		(passing_yards+sack_yards_lost) AS total_net_passing_yards,
		CASE
			WHEN attempts > 0 
			THEN (passing_yards+sack_yards_lost)*1.0/attempts
		END AS avg_passing_yards_per_attempts,
		CAST(completions AS FLOAT) AS passing_completions,
		CAST(attempts AS FLOAT) AS passing_attempts,
		passing_tds,
		passing_interceptions,
		passing_first_downs,
		sack_yards_lost
	FROM base_data
),

-- ===========================
--	4. Combined totals
-- ===========================

totals AS (
	SELECT 
		bd.season,
		bd.week,
		bd.team,
		bd.opponent_team,
		-- Totals
		(bd.passing_yards+bd.sack_yards_lost) + bd.rushing_yards AS total_yards,
		(bd.passing_first_downs + bd.rushing_first_downs) AS total_first_downs,
		(bd.passing_tds + bd.rushing_tds + bd.def_tds + bd.special_teams_tds) AS total_touchdowns,
		bd.sacks_suffered,
		bd.fg_made AS fgs_made,
		bd.fg_att AS fg_attempts
	FROM base_data AS bd
)


-- ===========================
--	5. Final output
-- ===========================

SELECT
	-- General
	t.season,
	t.week,
	t.team,
	t.opponent_team,

	-- Totals
	t.total_yards,
	t.total_first_downs,
	t.total_touchdowns,
	t.sacks_suffered,
	t.fgs_made,
	t.fg_attempts,

	-- Rushing
	rushing_attempts,
	total_rushing_yards,
	avg_rushing_yards_carry,
	rushing_tds,
	rushing_fumbles,
	rushing_first_downs,

	-- Passing
	total_net_passing_yards,
	avg_passing_yards_per_attempts,
	passing_completions,
	passing_attempts,
	passing_tds,
	passing_interceptions,
	passing_first_downs
FROM totals AS t
JOIN rushing_data AS r
	ON t.team = r.team 
	AND t.week = r.week
JOIN passing_data AS p
	ON t.team = p.team
	AND	t.week = p.week
ORDER BY t.week;

-- =============================================================================
--	Extra Query for Weekly differences in yards (Eagles only) 
--	Could have included this in the main fianl query, but seperating for clarity
-- =============================================================================

SELECT
	-- General
	t.season,
	t.week,
	t.team,
	t.opponent_team,

	-- Totals
	t.total_yards,
	ISNULL(t.total_yards - LAG(t.total_yards, 1) OVER (ORDER BY t.week ASC),0) AS total_yard_difference,

	-- Rushing
	r.total_rushing_yards,
	ISNULL(r.total_rushing_yards - LAG(r.total_rushing_yards, 1) OVER (ORDER BY t.week ASC),0) AS rushing_yards_difference,

	-- Passing
	p.total_net_passing_yards,
	ISNULL(p.total_net_passing_yards - LAG(p.total_net_passing_yards, 1) OVER (ORDER BY t.week ASC),0) AS passing_yards_difference

FROM totals AS t
JOIN rushing_data AS r
	ON t.team = r.team 
	AND t.week = r.week
JOIN passing_data AS p
	ON t.team = p.team
	AND	t.week = p.week
WHERE t.team = 'PHI'
ORDER BY t.week;
