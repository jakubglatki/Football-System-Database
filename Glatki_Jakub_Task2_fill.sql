-- drop schema fldb;

-- drop procedure fill_league;

delimiter //
CREATE PROCEDURE fill_league(
IN num INT)
BEGIN
DECLARE name VARCHAR(45);
DECLARE numberOfTeams INT;
DECLARE level INT;
DECLARE country VARCHAR(45);
DECLARE cNum INT;
SET cNum=1;

START TRANSACTION;
WHILE num > 0 DO
	SET name= CONCAT('name', num);
    SET numberOfTeams = FLOOR(4 + (RAND() * 20));
    IF MOD (num, 10)=0 THEN
		SET country = CONCAT('country',cNum);
        SET level= 1;
	END IF;
    IF MOD (num, 10)=9 THEN
		SET country = CONCAT('country',cNum);
        SET level= 2;
	END IF;
    IF MOD (num, 10)=8 THEN
		SET country = CONCAT('country',cNum);
        SET level= 3;
	END IF;
    IF MOD (num, 10)=7 THEN
		SET country = CONCAT('country',cNum);
        SET level= 4;
	END IF;
    IF MOD (num, 10)=6 THEN
		SET country = CONCAT('country',cNum);
        SET level= 5;
	END IF;
    IF MOD (num, 10)=5 THEN
		SET country = CONCAT('country',cNum);
        SET level= 6;
	END IF;
    IF MOD (num, 10)=4 THEN
		SET country = CONCAT('country',cNum);
        SET level= 7;
	END IF;
    IF MOD (num, 10)=3 THEN
		SET country = CONCAT('country',cNum);
        SET level= 8;
	END IF; 
    IF MOD (num, 10)=2 THEN
		SET country = CONCAT('country',cNum);
        SET level= 9;
	END IF; 
    IF MOD (num, 10)=1 THEN
		SET country = CONCAT('country',cNum);
        SET level= 10;
		SET cNum = cNum+1;
	END IF;
    INSERT INTO league(name, numberOfTeams, level, country)
    VALUES (name, numberOfTeams, level, country);
    SET num = num - 1;
END WHILE;
COMMIT;

END //
delimiter ;

INSERT INTO league (name, numberOfTeams, level, country)
VALUES ('Ekstraklasa', 16, 1, 'Polska');


select * from league;


delimiter //
CREATE PROCEDURE fill_stadium(
IN num INT)
BEGIN
DECLARE name VARCHAR(45);
DECLARE capacity INT;
DECLARE city VARCHAR(45);

START TRANSACTION;
WHILE num > 0 DO
    SET capacity = FLOOR(100 + (RAND() * 90000));
	SET name = CONCAT('name',num);
    SET city = CONCAT('city',num);
    INSERT INTO stadium(name, capacity, city)
    VALUES (name, capacity, city);
    SET num = num - 1;
END WHILE;
COMMIT;

END //
delimiter ;


select * from stadium;

-- drop procedure fill_team;

delimiter //
CREATE PROCEDURE fill_team(
IN num INT)
BEGIN
DECLARE League_id INT;
DECLARE Stadium_id INT;
DECLARE name VARCHAR(45);
DECLARE numberOfPlayers INT;
DECLARE position INT;
DECLARE capitanName VARCHAR(45);

DECLARE rememberNum Int;

DECLARE done INT;
DECLARE LeagueCursor CURSOR FOR SELECT id FROM league;
DECLARE StadiumCursor CURSOR FOR SELECT id FROM stadium;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN LeagueCursor;
OPEN StadiumCursor;

SET rememberNum=num;
    START TRANSACTION;
Team_Loop: LOOP
FETCH LeagueCursor INTO League_id;
	FETCH StadiumCursor INTO Stadium_id;
	
    IF done THEN
      LEAVE Team_Loop;
    END IF;
    SET num=rememberNum;
    
    WHILE num > 0 DO
    
    Set name = CONCAT('name',num);
    Set capitanName = CONCAT('Captain',num);
	SET position = FLOOR(1 + (RAND() * 23));
    SET numberOfPlayers= 20;
    
    INSERT INTO team(League_id, Stadium_id, name, numberOfPlayers, position, capitanName)
    VALUES (League_id, Stadium_id, name, numberOfPlayers, position, capitanName);
    SET num = num - 1;
    
	END WHILE;
END LOOP;

CLOSE LeagueCursor;
CLOSE StadiumCursor;

    COMMIT;
END //
delimiter ;

select * from team;

    INSERT INTO team(League_id, Stadium_id, name, numberOfPlayers, position, capitanName)
    VALUES (1, 1, 'Korona Kielce', 23, 14, 'Andan Kovacevic');

delimiter //
CREATE PROCEDURE fill_teamStats(
IN num INT)
BEGIN
DECLARE TeamID INT;
DECLARE points INT;
DECLARE goalsScored INT;
DECLARE goalsAgainst INT;
DECLARE goalsDifference INT;
DECLARE cleanSheets INT;
DECLARE rememberNum INT;


DECLARE done INT;
DECLARE TeamStatsCursor CURSOR FOR SELECT id FROM team;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN TeamStatsCursor;

set rememberNum =num;

    START TRANSACTION;
TeamStats_Loop: LOOP
	FETCH TeamStatsCursor INTO TeamID;
    IF done THEN
      LEAVE TeamStats_Loop;
    END IF;
set num=remembernum;
    WHILE num > 0 DO
    
	SET points = FLOOR(0 + (RAND() * 114));
	SET goalsScored = FLOOR(0 + (RAND() * 150));
    SET goalsAgainst= FLOOR(0 + (RAND() * 150));
	SET goalsDifference = goalsScored-goalsAgainst;
    SET cleanSheets= FLOOR(0 + (RAND() * 38));
    
    
    INSERT INTO teamstats(Team_id, points, goalsScored, goalsAgainst, goalsDifference, cleanSheets)
    VALUES (TeamID, points, goalsScored, goalsAgainst, goalsDifference, cleanSheets);
    SET num = num - 1;
    
	END WHILE;
END LOOP;

CLOSE TeamStatsCursor;

    COMMIT;
END //
delimiter ;

-- drop procedure fill_owner;
 
delimiter //
CREATE PROCEDURE fill_owner(
IN num INT)
BEGIN
DECLARE TeamID INT;
DECLARE name VARCHAR(45);
DECLARE surname VARCHAR(45);
DECLARE date_of_birth DATETIME;
DECLARE value INT;
declare rememberNum INT;

DECLARE done INT;
DECLARE OwnerCursor CURSOR FOR SELECT id FROM team;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN OwnerCursor;


SET @MIN = '1960-01-01 00:00:00';
SET @MAX = '2001-12-30 00:00:00';

set rememberNum=num;
    START TRANSACTION;
Owner_Loop: LOOP
	FETCH OwnerCursor INTO TeamID;
    IF done THEN
      LEAVE Owner_Loop;
    END IF;
    set num=rememberNum;
    WHILE num > 0 DO
    
    Set name = CONCAT('name',num);
    Set surname = CONCAT('surname',num);
    SET date_of_birth  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
	SET value = FLOOR(100 + (RAND() * 50000000));
    
    
    INSERT INTO owner(Team_id, name, surname, date_of_birth, value)
    VALUES (TeamID, name, surname, date_of_birth, value);
    SET num = num - 1;
    
	END WHILE;
END LOOP;
    COMMIT;

CLOSE OwnerCursor;

END //
delimiter ;

select * from owner;

-- drop procedure fill_coach;

delimiter //
CREATE PROCEDURE fill_coach(
IN num INT)
BEGIN
DECLARE TeamID INT;
DECLARE name VARCHAR(45);
DECLARE surname VARCHAR(45);
DECLARE role VARCHAR(45);
DECLARE date_of_birth DATETIME;
DECLARE salary INT;
DECLARE contractLength DATETIME;
DECLARE rememberNum INT;

DECLARE done INT;
DECLARE CoachCursor CURSOR FOR SELECT id FROM team;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN CoachCursor;


SET @MIN1 = '1960-01-01 00:00:00';
SET @MAX1 = '1996-12-30 00:00:00';

SET @MIN2 = '2020-01-01 00:00:00';
SET @MAX2 = '2025-12-30 00:00:00';

SET rememberNum=num;
    START TRANSACTION;
Coach_Loop: LOOP
	FETCH CoachCursor INTO TeamID;
    IF done THEN
      LEAVE Coach_Loop;
    END IF;
    SET num=rememberNum;
    WHILE num > 0 DO
    
    Set name = CONCAT('name',num);
    Set surname = CONCAT('surname',num);
    SET date_of_birth  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN1, @MAX1)), @MIN1);
	SET salary = FLOOR(100 + (RAND() * 200000));
    SET contractLength  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN2, @MAX2)), @MIN2);
    
    IF MOD (num, 3)=2 THEN
        SET role= 'Main coach';
	END IF; 
    IF MOD (num, 3)=1 THEN
        SET role= 'Assistant coach';
	END IF; 
    IF MOD (num, 3)=0 THEN
        SET role= 'Goalkeeper coach';
	END IF;
    
    INSERT INTO coach (Team_id, name, surname, role, date_of_birth, salary, contractLength)
    VALUES (TeamID, name, surname, role, date_of_birth, salary, contractLength);
    SET num = num - 1;
    
	END WHILE;
END LOOP;

CLOSE CoachCursor;

    COMMIT;
END //
delimiter ;


select * from coach;

-- drop procedure fill_player;

delimiter //
CREATE PROCEDURE fill_player(
IN num INT)
BEGIN
DECLARE name VARCHAR(45);
DECLARE surname VARCHAR(45);
DECLARE date_of_birth DATETIME;
DECLARE number INT;
DECLARE salary INT;
DECLARE rememberNum INT;
DECLARE Team_id INT;
DECLARE nr INT;

DECLARE done INT;
DECLARE PlayerCursor CURSOR FOR SELECT id FROM team;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN PlayerCursor;

SET @MIN = '1979-01-01 00:00:00';
SET @MAX = '2002-12-30 00:00:00';

SET RememberNum=num;

    START TRANSACTION;
Player_Loop: LOOP
	FETCH PlayerCursor INTO Team_ID;
    IF done THEN
      LEAVE Player_Loop;
    END IF;
    
    SET num=RememberNum;
   
    WHILE num > 0 DO
    
    SET nr = FLOOR(1 + (RAND() * 10000));
    Set name = CONCAT('name',nr);
    Set surname = CONCAT('surname',nr);
    SET date_of_birth  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
	SET salary = FLOOR(100 + (RAND() * 500000));
    SET number= FLOOR(1 + (RAND() * 99));
    
	INSERT INTO player(Team_id, name, surname, date_of_birth, number, salary)
	VALUES (Team_id, name, surname, date_of_birth, number, salary);

    SET num = num - 1;
    
	END WHILE;
END LOOP;

CLOSE PlayerCursor;
    COMMIT;

END //
delimiter ;
    
select * from player;

-- drop procedure fill_playerStats;

delimiter //
CREATE PROCEDURE fill_playerStats(
IN num INT)
BEGIN
DECLARE PlayerID INT;
DECLARE contractLenght DATETIME;
DECLARE apperances INT;
DECLARE minutesPlayed INT;
DECLARE goals INT;
DECLARE assists INT;
DECLARE yellowCards INT;
DECLARE redCards INT;
DECLARE minutesInGame INT;
DECLARE RememberNum INT;


DECLARE done INT;
DECLARE PlayerStatsCursor CURSOR FOR SELECT id FROM player;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN PlayerStatsCursor;

SET @MIN = '2020-06-30 00:00:00';
SET @MAX = '2025-12-30 00:00:00';

SET RememberNum=num;
    START TRANSACTION;

PlayerStats_Loop: LOOP
	FETCH PlayerStatsCursor INTO PlayerID;
    IF done THEN
      LEAVE PlayerStats_Loop;
    END IF;
    
    set num=rememberNum;
    
    WHILE num > 0 DO
    
    SET contractLenght  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
	SET goals = FLOOR(0 + (RAND() * 30));
    SET assists= FLOOR(0 + (RAND() * 20));
	SET apperances = FLOOR(0 + (RAND() * 38));
    SET minutesInGame= FLOOR(60 + (RAND() * 90));
    SET minutesPlayed= apperances*minutesInGame;
	SET yellowCards = FLOOR(0 + (RAND() * 20));
    SET redCards= FLOOR(0 + (RAND() * 10));
    
    
    
    INSERT INTO playerstats(Player_id, apperances, minutesPlayed, goals, assists, contractLenght, yellowCards, redCards)
    VALUES (PlayerID, apperances, minutesPlayed, goals, assists, contractLenght, yellowCards, redCards);
    SET num = num - 1;
    
	END WHILE;
END LOOP;

CLOSE PlayerStatsCursor;
    COMMIT;

END //
delimiter ;


select * from playerStats;


-- drop procedure fill_game;

delimiter //
CREATE PROCEDURE fill_game(
IN num INT)
BEGIN
DECLARE Team_home_id INT;
DECLARE Team_away_id INT;
DECLARE League_id INT;
DECLARE homeGoals INT;
DECLARE awayGoals INT;
DECLARE date DATETIME;
DECLARE rememberNum INT;


DECLARE done INT;
DECLARE LeagueCursor CURSOR FOR SELECT id FROM league;
DECLARE HomeTeamCursor CURSOR FOR SELECT id FROM team where mod(id,2)=1;
DECLARE AwayTeamCursor CURSOR FOR SELECT id FROM team where mod(id,1)=0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN LeagueCursor;
OPEN HomeTeamCursor;
OPEN AwayTeamCursor;


SET @MIN = '2019-08-08 00:00:00';
SET @MAX = '2020-06-30 00:00:00';

SET rememberNum=num;

    START TRANSACTION;
game_Loop: LOOP
	FETCH LeagueCursor INTO League_id;
	FETCH HomeTeamCursor INTO Team_home_id;
	FETCH AwayTeamCursor INTO Team_away_id;
    IF done THEN
      LEAVE game_Loop;
    END IF;
	SET num=rememberNum;
    
    WHILE num > 0 DO
		

	SET homeGoals = FLOOR(0 + (RAND() * 4));
	SET awayGoals = FLOOR(0 + (RAND() * 4));
    SET date  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
    
    INSERT INTO game(Team_home_id, Team_away_id, League_id, homeGoals, awayGoals, date)
    VALUES (Team_home_id, Team_away_id, League_id, homeGoals, awayGoals, date);
    SET num = num - 1;
    
	END WHILE;
END LOOP;

CLOSE LeagueCursor;
CLOSE HomeTeamCursor;
CLOSE AwayTeamCursor;

    COMMIT;
END //
delimiter ;


select * from game;

-- drop procedure fill_gameevent;

delimiter //
CREATE PROCEDURE fill_gameevent(
IN num INT)
BEGIN
DECLARE Game_id INT;
DECLARE Player_id INT;
DECLARE name VARCHAR(45);
DECLARE minute INT;
DECLARE min INT;
DECLARE rememberNum INT;

DECLARE done INT;
DECLARE GameCursor CURSOR FOR SELECT id FROM game;
DECLARE PlayerCursor CURSOR FOR SELECT id FROM player;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN GameCursor;
OPEN PlayerCursor;

SET rememberNum=num;
    START TRANSACTION;
    match_Loop: LOOP
	FETCH GameCursor INTO Game_id;
    IF done THEN
      LEAVE match_Loop;
    END IF;
	SET num=rememberNum;
    
    WHILE num > 0 DO
	FETCH PlayerCursor INTO Player_id;

	IF MOD (num, 5)=2 THEN
	SET name= 'Goal scored';
	END IF; 
    IF MOD (num, 5)=1 THEN
        SET name= 'Yellow card';
	END IF; 
    IF MOD (num, 5)=0 THEN
        SET name= 'Red card';
	END IF;
    IF MOD (num, 5)=4 THEN
        SET name= 'Substitution on';
	END IF;
    IF MOD (num, 5)=3 THEN
        SET name= 'Substitution off';
	END IF;
    
	SET minute = FLOOR(0 + (RAND() * 90));
    
    
    
    
    
    INSERT INTO gameevent(Game_id, Player_id, name, minute)
    VALUES (Game_id, Player_id, name, minute);
    SET num = num - 1;
    
	END WHILE;
END LOOP;

CLOSE GameCursor;
CLOSE PlayerCursor;
    COMMIT;

END //
delimiter ;


delimiter //
CREATE procedure fill_tables()
BEGIN
call fill_league(100000);
call fill_stadium(100000);
call fill_team(1);
call fill_coach(1);
call fill_owner(1);
call fill_teamstats(1);
call fill_player(1);
call fill_playerstats(1);
call fill_game(1);
call fill_gameevent(1);
end //
delimiter ;

call fill_tables();

select * from coach;
select * from game;
select * from league;
select * from owner;
select * from player;
select * from gameevent;
select * from playerstats;
select * from team;
select * from teamstats;
select * from stadium;
