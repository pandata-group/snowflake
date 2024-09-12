--Run this script as Account Admin as it involves creation of a new user and role

-- Create temporary access on db to a temporary user with a role created with required privileges

--Create a Role for DEMO_DATABASE user
create ROLE DEMO_DATABASE_GUEST_ROLE;

--Grant required permissions to the role
grant role DEMO_DATABASE_GUEST_ROLE to role sysadmin;
GRANT USAGE ON DATABASE DEMO_DATABASE TO ROLE DEMO_DATABASE_GUEST_ROLE;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE DEMO_DATABASE_GUEST_ROLE;
GRANT USAGE ON ALL SCHEMAS IN DATABASE DEMO_DATABASE TO ROLE DEMO_DATABASE_GUEST_ROLE;
GRANT SELECT ON ALL TABLES IN DATABASE DEMO_DATABASE TO ROLE DEMO_DATABASE_GUEST_ROLE;
GRANT USAGE ON STREAMLIT DEMO_DATABASE.BILLS.DEMO_DATABASE_APP TO ROLE DEMO_DATABASE_GUEST_ROLE;
GRANT READ ON GIT REPOSITORY DEMO_DATABASE.GIT.DEMO_DATABASE_APP TO ROLE DEMO_DATABASE_GUEST_ROLE;

--Use this Script to Generate a new user. This means <WH_NAME> -> 'EXAMPLE_WH'

CREATE USER <TEMP_USER_NAME>
    PASSWORD = <password>
    DISPLAY_NAME = <DISPLAY_NAME>
    MUST_CHANGE_PASSWORD = TRUE
    DAYS_TO_EXPIRY = <DAYS_TO_EXPIRY>
    DEFAULT_WAREHOUSE = <WH_NAME>
    DEFAULT_NAMESPACE = DEMO_DATABASE
    DEFAULT_ROLE = DEMO_DATABASE_GUEST_ROLE
    TYPE = 'LEGACY_SERVICE'
    COMMENT = 'Temporary user for 1 day';


-- SQL to alter the user
--Need to Recall this as the guest role is not getting attached
grant role DEMO_DATABASE_GUEST_ROLE to user user_temp_legacy_service_test;


--Only Security Admin or user with auth policy access can run this script
ALTER USER <demo_TEMP_USER_NAME> SET AUTHENTICATION POLICY CLIENT_AUTH_POLICY;

----------------------------------------------------------------------------------------------------------------------
--Generic Stored Procedure to Create a temporary User / Can be done with normal SQL also
--There is no real need of Stored Procedure as this is not an automatic and an account admin is needed to execute this
CREATE OR REPLACE PROCEDURE DEMO_DATABASE.PUBLIC.SP_CREATE_TEMP_USER_DEMO_DATABASE(
    TEMP_USER_NAME STRING,
    USER_PASSWORD STRING,
    DEFAULT_WAREHOUSE STRING,
    DEFAULT_NAMESPACE STRING,
    DEFAULT_ROLE STRING,
    DAYS_TO_EXPIRY INTEGER,
    MUST_CHANGE_PASSWORD BOOLEAN,
	TYPE STRING)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
  EXECUTE IMMEDIATE 
    'CREATE USER ' || TEMP_USER_NAME || '
    PASSWORD = ''' || USER_PASSWORD || '''
    DISPLAY_NAME = ''' || TEMP_USER_NAME || '''
    MUST_CHANGE_PASSWORD = ' || CASE WHEN MUST_CHANGE_PASSWORD THEN 'TRUE' ELSE 'FALSE' END || '
    DAYS_TO_EXPIRY = ' || DAYS_TO_EXPIRY || '
    DEFAULT_WAREHOUSE = ''' || DEFAULT_WAREHOUSE || '''
    DEFAULT_NAMESPACE = ''' || DEFAULT_NAMESPACE || '''
    DEFAULT_ROLE = ''' || DEFAULT_ROLE || '''
    TYPE = ''' || TYPE || '''
    COMMENT = ''Temporary user for ' || DAYS_TO_EXPIRY || ' ''';

  RETURN 'User ' || TEMP_USER_NAME || ' created successfully with expiry in ' || DAYS_TO_EXPIRY || ' days';
END;
$$;

--Function call to execute and create a temporary user for DEMO_DATABASE
CALL DEMO_DATABASE.PUBLIC.SP_CREATE_TEMP_USER_DEMO_DATABASE(
    'DEMO_DATABASE_demo_user_ws',
    'temp_pass',
    'WH_NAME',
    'DEMO_DATABASE',
    'DEMO_DATABASE_GUEST_ROLE',
    7,
    TRUE,
    'LEGACY_SERVICE'
);

--

