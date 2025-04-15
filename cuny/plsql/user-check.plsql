DECLARE
    existing_user_name VARCHAR2(128) := '&user_name';
    query_Password SYS.User$.PASSWORD%TYPE;
    query_Spare4 SYS.User$.SPARE4%TYPE;



BEGIN
    -- Trim whitespace and change case for input
    existing_user_name:= upper(trim(existing_user_name));
    
    -- Grab the first word of the string to prevent error
    existing_user_name:= REGEXP_SUBSTR(existing_user_name, '^\w+');
    
    SELECT
        PASSWORD, SPARE4
    INTO
        query_Password,
        query_Spare4
    FROM 
        SYS.User$
    WHERE 
        NAME = existing_user_name;

    -- Display Output    
    IF query_Password IS NULL AND query_Spare4 IS NOT NULL THEN
        dbms_output.put_line(query_Spare4); 
    ELSIF query_Password IS NOT NULL AND query_Spare4 IS NULL THEN
        dbms_output.put_line(query_Password); 
    ELSIF query_Password IS NOT NULL AND query_Spare4 IS NOT NULL THEN
        dbms_output.put_line(query_Spare4);
    ELSE 
        dbms_output.put_line('Oracle System Account');
    END IF;

END; 