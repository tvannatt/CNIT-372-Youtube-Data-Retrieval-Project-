-- Question #1
CREATE OR REPLACE PROCEDURE QUESTION1 
(
 date1 IN varchar2, date2 IN varchar2
)   
AS
v_channel varchar2(128);
BEGIN

SELECT STATS_MODE(CHANNEL_NAME) INTO v_channel FROM WATCH_HISTORY
WHERE TO_DATE(SUBSTR(DATE_TIME, 1, 10), 'YYYY-MM-DD') BETWEEN TO_DATE(date1, 'YYYY-MM-DD') AND TO_DATE(date2, 'YYYY-MM-DD');

DBMS_OUTPUT.PUT_LINE(v_channel);

END;

-- Question #2
  CREATE OR REPLACE PROCEDURE QUESTION2
  AS
  CURSOR top4_channel IS
      SELECT COUNT(channel_name), channel_name FROM WATCH_HISTORY
      GROUP BY channel_name
      ORDER BY count(channel_name) DESC
      FETCH FIRST 4 ROWS ONLY;

  BEGIN

  DBMS_OUTPUT.PUT_LINE('The top 4 channels visited in this dataset are: ');

  for channel IN top4_channel
  LOOP
  DBMS_OUTPUT.PUT_LINE(channel.channel_name);
  END LOOP;

  END;

-- Question #3
--(Which subscribed channel was watched the most?)
CREATE OR REPLACE PROCEDURE QUESTION3
AS

v_channel watch_history.channel_name%type;

BEGIN

    select stats_mode(channel_name) into v_channel FROM WATCH_HISTORY
    WHERE (SELECT count(channel_ID) FROM subscriptions WHERE channel_id = channel_name) > 0;
    
    if (v_channel IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('The user was not subscribed to any channels they visited in this dataset.');
    
    ELSE
    DBMS_OUTPUT.PUT_LINE(v_channel);
    
    END IF;

END;


-- Question #4
--(Has the user placed or received more comments?)
  CREATE OR REPLACE PROCEDURE QUESTION4
  AS
  count_comments number;
  count_replies number;
  BEGIN

  SELECT COUNT(TEXT) INTO count_comments
  FROM MY_COMMENTS
  WHERE TEXT = 'comment';

  SELECT COUNT(TEXT) INTO count_replies
  FROM MY_COMMENTS
  WHERE TEXT = 'replied';

  IF (count_replies > count_comments) THEN

  DBMS_OUTPUT.PUT_LINE('The user has received more comments than they have placed.');
  DBMS_OUTPUT.PUT_LINE('Placed: ' || count_comments || ' | Received: ' || count_replies);

  ELSIF (count_comments > count_replies) THEN
  DBMS_OUTPUT.PUT_LINE('The user has place more comments than they have received.');
  DBMS_OUTPUT.PUT_LINE('Placed: ' || count_comments || ' | Received: ' || count_replies);

  ELSE 
  DBMS_OUTPUT.PUT_LINE('The user has placed the same amount of comments as they have received.');
  DBMS_OUTPUT.PUT_LINE('Placed: ' || count_comments || ' | Received: ' || count_replies);

  END IF;

  END;

-- Question #5

 create or replace procedure QUESTION5
as
 num_of_subbed number:=0;
 videos_watched number:=0;
 percentage_count number:=0;
 begin
  select count(channel_name) into num_of_subbed from watch_history where channel_name in
 (select channel_id from subscriptions);
 
select count(channel_name) into videos_watched from watch_history;
 percentage_count:=to_char(num_of_subbed / videos_watched, 'FM9999999990.000');

dbms_output.put_line('The user is subscribed to '|| percentage_count ||'% of his watched videos');
 end;


 -- Question #6

create or replace procedure question6
as
counter number:=0;

begin

select count(title_url) into counter from watch_history where title_url in (select url from my_comments);

if counter=0 then
    dbms_output.put_line('There are no videos commented that have also been watched');

else
    dbms_output.put_line('There are ' || counter ||  ' videos that have been commented on and watched');

end if;
end;

-- Question #7

create or replace procedure QUESTION7
as

 current_date date;
 convert_date date;
 tracker date;
 cursor all_dates is
    select substr(date_time, 0, 10) as each_date from watch_history;
    
 begin
  select SYSDATE into current_date  from dual;
    tracker:=to_date('0001-01-01', 'YYYY-MM-DD');
 
for p_dates in all_dates loop
        convert_date:=to_date(p_dates.each_date, 'YYYY-MM-DD');
    if convert_date > tracker and convert_date < current_date then
        tracker:=convert_date;
    end if;
    end loop;
    dbms_output.put_line('The last day that a youtube video was watched was on ' || tracker);
 end;

 -- Question #8

 CREATE OR REPLACE PROCEDURE QUESTION8
 AS
 v_output NUMBER;
 BEGIN
  SELECT COUNT(*) into v_output
  FROM watch_history
  WHERE date_time LIKE '2023-02%';

  DBMS_OUTPUT.PUT_LINE('The total videos watched in February are: ' || v_output);

END;

-- Question #9
CREATE OR REPLACE PROCEDURE QUESTION9
AS
v_output varchar2(128);
BEGIN 
  SELECT stats_mode(channel_name) into v_output
  FROM watch_history
  WHERE date_time LIKE '2023%';

  DBMS_OUTPUT.PUT_LINE('The most common channel viewed in this dataset: ' || v_output);

END;

-- Question #10
CREATE OR REPLACE PROCEDURE QUESTION10
AS
v_output number; 
BEGIN
  SELECT count(*) into v_output
  FROM watch_history
  WHERE title LIKE '%GTA%';

  DBMS_OUTPUT.PUT_LINE('The number of Grand Theft Auto videos watched: ' || v_output);
END;

-- Triggers
CREATE OR REPLACE TRIGGER TRIG_MS3
  BEFORE INSERT OR DELETE OR UPDATE ON WATCH_HISTORY 
    FOR EACH ROW
BEGIN

raise_application_error
(
    -20111,
    'Please do not modify this data.'

);

END;

CREATE OR REPLACE TRIGGER TRIG_MS1
  BEFORE INSERT OR DELETE OR UPDATE ON MY_COMMENTS
    FOR EACH ROW
BEGIN

raise_application_error
(
    -20111,
    'Please do not modify this data.'

);

END;

CREATE OR REPLACE TRIGGER TRIG_MS2
  BEFORE INSERT OR DELETE OR UPDATE ON SUBSCRIPTIONS
    FOR EACH ROW
BEGIN

raise_application_error
(
    -20111,
    'Please do not modify this data.'

);

END;

CREATE OR REPLACE TRIGGER TRIG_MS4
  BEFORE INSERT OR DELETE OR UPDATE ON SEARCH_HISTORY
    FOR EACH ROW
BEGIN

raise_application_error
(
    -20111,
    'Please do not modify this data.'

);

END;


-- Package

CREATE OR REPLACE PACKAGE CNIT372PROJECT IS

PROCEDURE QUESTION1 (date1 IN VARCHAR2, date2 IN VARCHAR2);

PROCEDURE QUESTION2;

PROCEDURE QUESTION3;

PROCEDURE QUESTION4;

PROCEDURE QUESTION5;

PROCEDURE QUESTION6;

PROCEDURE QUESTION7;

PROCEDURE QUESTION8;

PROCEDURE QUESTION9;

PROCEDURE QUESTION10;

END CNIT372PROJECT;


CREATE OR REPLACE PACKAGE BODY CNIT372PROJECT IS

PROCEDURE QUESTION1 
(
 date1 IN varchar2, date2 IN varchar2
)   
AS
v_channel varchar2(128);
BEGIN

SELECT STATS_MODE(CHANNEL_NAME) INTO v_channel FROM WATCH_HISTORY
WHERE TO_DATE(SUBSTR(DATE_TIME, 1, 10), 'YYYY-MM-DD') BETWEEN TO_DATE(date1, 'YYYY-MM-DD') AND TO_DATE(date2, 'YYYY-MM-DD');

DBMS_OUTPUT.PUT_LINE(v_channel);

END;

PROCEDURE QUESTION2
AS
CURSOR top4_channel IS
    SELECT COUNT(channel_name), channel_name FROM WATCH_HISTORY
    GROUP BY channel_name
    ORDER BY count(channel_name) DESC
    FETCH FIRST 4 ROWS ONLY;

BEGIN

DBMS_OUTPUT.PUT_LINE('The top 4 channels visited in this dataset are: ');

for channel IN top4_channel
LOOP
DBMS_OUTPUT.PUT_LINE(channel.channel_name);
END LOOP;

END;

PROCEDURE QUESTION3
AS

v_channel watch_history.channel_name%type;

BEGIN

    select stats_mode(channel_name) into v_channel FROM WATCH_HISTORY
    WHERE (SELECT count(channel_ID) FROM subscriptions WHERE channel_id = channel_name) > 0;
    
    if (v_channel IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('The user was not subscribed to any channels they visited in this dataset.');
    
    ELSE
    DBMS_OUTPUT.PUT_LINE(v_channel);
    
    END IF;

END;

PROCEDURE QUESTION4
AS
count_comments number;
count_replies number;
BEGIN

SELECT COUNT(TEXT) INTO count_comments
FROM MY_COMMENTS
WHERE TEXT = 'comment';

SELECT COUNT(TEXT) INTO count_replies
FROM MY_COMMENTS
WHERE TEXT = 'replied';

IF (count_replies > count_comments) THEN

DBMS_OUTPUT.PUT_LINE('The user has received more comments than they have placed.');
DBMS_OUTPUT.PUT_LINE('Placed: ' || count_comments || ' | Received: ' || count_replies);

ELSIF (count_comments > count_replies) THEN
DBMS_OUTPUT.PUT_LINE('The user has place more comments than they have received.');
DBMS_OUTPUT.PUT_LINE('Placed: ' || count_comments || ' | Received: ' || count_replies);

ELSE 
DBMS_OUTPUT.PUT_LINE('The user has placed the same amount of comments as they have received.');
DBMS_OUTPUT.PUT_LINE('Placed: ' || count_comments || ' | Received: ' || count_replies);

END IF;

END;

procedure QUESTION5
as
 num_of_subbed number:=0;
 videos_watched number:=0;
 percentage_count number:=0;
 begin
  select count(channel_name) into num_of_subbed from watch_history where channel_name in
 (select channel_id from subscriptions);
 
select count(channel_name) into videos_watched from watch_history;
 percentage_count:=to_char(num_of_subbed / videos_watched, 'FM9999999990.000');

dbms_output.put_line('The user is subscribed to '|| percentage_count ||'% of his watched videos');
 end;


procedure question6
as
counter number:=0;

begin

select count(title_url) into counter from watch_history where title_url in (select url from my_comments);

if counter=0 then
    dbms_output.put_line('There are no videos commented that have also been watched');

else
    dbms_output.put_line('There are ' || counter ||  ' videos that have been commented on and watched');

end if;
end;


procedure QUESTION7
as

 current_date date;
 convert_date date;
 tracker date;
 cursor all_dates is
    select substr(date_time, 0, 10) as each_date from watch_history;
    
 begin
  select SYSDATE into current_date  from dual;
    tracker:=to_date('0001-01-01', 'YYYY-MM-DD');
 
for p_dates in all_dates loop
        convert_date:=to_date(p_dates.each_date, 'YYYY-MM-DD');
    if convert_date > tracker and convert_date < current_date then
        tracker:=convert_date;
    end if;
    end loop;
    dbms_output.put_line('The last day that a youtube video was watched was on ' || tracker);
 end;

PROCEDURE QUESTION8
 AS
 v_output NUMBER;
 BEGIN
  SELECT COUNT(*) into v_output
  FROM watch_history
  WHERE date_time LIKE '2023-02%';

  DBMS_OUTPUT.PUT_LINE('The total videos watched in February are: ' || v_output);

END;

PROCEDURE QUESTION9
AS
v_output varchar2(128);
BEGIN 
  SELECT stats_mode(channel_name) into v_output
  FROM watch_history
  WHERE date_time LIKE '2023%';

  DBMS_OUTPUT.PUT_LINE('The most common channel viewed in this dataset: ' || v_output);

END;

PROCEDURE QUESTION10
AS
v_output number; 
BEGIN
  SELECT count(*) into v_output
  FROM watch_history
  WHERE title LIKE '%GTA%';

  DBMS_OUTPUT.PUT_LINE('The number of Grand Theft Auto videos watched: ' || v_output);
END;

END CNIT372PROJECT;


-- Package utility

set serveroutput on;

DECLARE
v_count number;
BEGIN

v_count := 1;

FOR v_count IN 1 .. 10 LOOP

    if v_count = 1 then
    CNIT372PROJECT.QUESTION1('2023-01-06', '2023-02-24');
    elsif v_count = 2 then
    CNIT372PROJECT.QUESTION2();
    elsif v_count = 3 then
    CNIT372PROJECT.QUESTION3();
     elsif v_count = 4 then
    CNIT372PROJECT.QUESTION4();
     elsif v_count = 5 then
    CNIT372PROJECT.QUESTION5();
     elsif v_count = 6 then
    CNIT372PROJECT.QUESTION6();
     elsif v_count = 7 then
    CNIT372PROJECT.QUESTION7();
     elsif v_count = 8 then
    CNIT372PROJECT.QUESTION8();
     elsif v_count = 9 then
    CNIT372PROJECT.QUESTION9();
     elsif v_count = 10 then
    CNIT372PROJECT.QUESTION10();
    

    end if;
    end loop;
end;





