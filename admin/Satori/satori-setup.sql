-- Create a role for Posture Manager
CREATE ROLE SATORI_SCANNER_ROLE;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE SATORI_SCANNER_ROLE;
GRANT IMPORT SHARE ON ACCOUNT TO SATORI_SCANNER_ROLE;


-- Create a role for Satori
CREATE OR REPLACE ROLE SATORI_ROLE;
GRANT USAGE ON WAREHOUSE PAN_WH TO ROLE SATORI_ROLE;
GRANT ROLE SATORI_SCANNER_ROLE TO ROLE SATORI_ROLE;


-- Create a user for Satori
CREATE OR REPLACE USER SATORI_USER 
   RSA_PUBLIC_KEY='<rsa-key>' 
   default_role=SATORI_ROLE
   default_warehouse=PAN_WH;
   
-- Grant Satori role to Satori user  
GRANT ROLE SATORI_ROLE TO USER SATORI_USER;