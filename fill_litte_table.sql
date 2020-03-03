delimiter //
CREATE PROCEDURE fill_team(
IN num INT)
BEGIN
DECLARE Stadium_id INT;
DECLARE name VARCHAR(45);
DECLARE numberOfPlayers INT;
DECLARE position INT;
DECLARE capitanName VARCHAR(45);

DECLARE rememberNum Int;

DECLARE done INT;
DECLARE StadiumCursor CURSOR FOR SELECT id FROM stadium;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN StadiumCursor;

SET rememberNum=num;
Team_Loop: LOOP
    IF done THEN
      LEAVE Team_Loop;
    END IF;
    SET num=rememberNum;
    WHILE num > 0 DO
    
	FETCH StadiumCursor INTO Stadium_id;
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

END //
delimiter ;

call fill_team(1);

drop procedure fill_stadium;

delimiter //
CREATE PROCEDURE fill_stadium(
IN num INT)
BEGIN
DECLARE name VARCHAR(45);
DECLARE capacity INT;
DECLARE city VARCHAR(45);

WHILE num > 0 DO
	SET capacity = FLOOR(100 + (RAND() * 90000));
	SET name = CONCAT('name',num);
    SET city = CONCAT('city',num);
    INSERT INTO stadium(name, city)
    VALUES (name, city);
    set num=num-1;
END WHILE;

END // 
delimiter ;

call fill_stadium(100000);

drop table stadium;

select name from stadium where id=1;
select * from stadium;