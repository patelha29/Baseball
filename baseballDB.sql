-- Create database
CREATE DATABASE baseball_db;

-- Use database
USE baseball_db;

-- Create teams table
CREATE TABLE teams (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL
);

-- Create players table
CREATE TABLE players (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  team_id INT NOT NULL,
  FOREIGN KEY (team_id) REFERENCES teams(id)
);

-- Create pitchers table
CREATE TABLE pitchers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,  
  wins INT DEFAULT 0,
  losses INT DEFAULT 0,
  era DECIMAL(3,2) DEFAULT 0.00,
  strikeouts INT DEFAULT 0,
  FOREIGN KEY (player_id) REFERENCES players(id)
);

-- Create catchers table
CREATE TABLE catchers (
  id INT PRIMARY KEY AUTO_INCREMENT, 
  player_id INT NOT NULL,
  assists INT DEFAULT 0,
  putouts INT DEFAULT 0,
  FOREIGN KEY (player_id) REFERENCES players(id)
);

-- Create infielders table
CREATE TABLE infielders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,
  assists INT DEFAULT 0,
  putouts INT DEFAULT 0,
  errors INT DEFAULT 0,
  FOREIGN KEY (player_id) REFERENCES players(id)
);

-- Create outfielders table
CREATE TABLE outfielders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,
  assists INT DEFAULT 0, 
  putouts INT DEFAULT 0,
  errors INT DEFAULT 0,
  FOREIGN KEY (player_id) REFERENCES players(id)
);

-- Insert sample teams 
INSERT INTO teams (name, city)
VALUES
  ('Jets', 'New York'),
  ('Sharks', 'San Jose');

-- Insert sample players
INSERT INTO players (name, team_id)
VALUES
  ('Bill James', 1),
  ('Mike Schmidt', 1),
  ('Nolan Ryan', 1),
  ('Reggie Jackson', 1),
  ('Johnny Bench', 1),
  ('Ozzie Smith', 1),  
  ('Barry Bonds', 2),
  ('Willie Mays', 2),
  ('Buster Posey', 2),
  ('Dave Winfield', 2),
  ('Omar Vizquel', 2); 

-- Insert sample pitchers
INSERT INTO pitchers (player_id, wins, losses, era, strikeouts)
VALUES
  (3, 12, 4, 2.34, 182),
  (1, 15, 8, 3.12, 210);  

-- Insert sample catchers  
INSERT INTO catchers (player_id, assists, putouts)
VALUES
  (5, 450, 980),
  (9, 405, 950);

-- Insert sample infielders
INSERT INTO infielders (player_id, assists, putouts, errors) 
VALUES
  (6, 520, 400, 10),
  (2, 490, 415, 9);

-- Insert sample outfielders  
INSERT INTO outfielders (player_id, assists, putouts, errors)
VALUES
  (7, 15, 320, 3),
  (10, 18, 305, 1);

-- Create view to join all player info 
CREATE VIEW player_stats AS
  SELECT p.name, t.name AS team,
    p.id AS player_id,
    IFNULL(pt.wins, 0) AS pitcher_wins, 
    IFNULL(pt.losses, 0) AS pitcher_losses,
    IFNULL(pt.era, 0) AS pitcher_era,
    IFNULL(pt.strikeouts, 0) AS pitcher_strikeouts,
    IFNULL(c.assists, 0) AS catcher_assists,
    IFNULL(c.putouts, 0) AS catcher_putouts, 
    IFNULL(i.assists, 0) AS infielder_assists,
    IFNULL(i.putouts, 0) AS infielder_putouts,
    IFNULL(i.errors, 0) AS infielder_errors,
    IFNULL(o.assists, 0) AS outfielder_assists,
    IFNULL(o.putouts, 0) AS outfielder_putouts,
    IFNULL(o.errors, 0) AS outfielder_errors
  FROM players p
  LEFT JOIN teams t ON p.team_id = t.id
  LEFT JOIN pitchers pt ON p.id = pt.player_id
  LEFT JOIN catchers c ON p.id = c.player_id 
  LEFT JOIN infielders i ON p.id = i.player_id
  LEFT JOIN outfielders o ON p.id = o.player_id;

-- Create view for team stats
CREATE VIEW team_stats AS 
SELECT t.name AS team,
  SUM(pitcher_wins) AS total_pitcher_wins,
  SUM(pitcher_losses) AS total_pitcher_losses,
  SUM(catcher_putouts) AS total_catcher_putouts,
  SUM(infielder_putouts) AS total_infielder_putouts,
  SUM(outfielder_putouts) AS total_outfielder_putouts
FROM player_stats ps
JOIN teams t ON ps.team = t.name
GROUP BY team;