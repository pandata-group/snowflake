-- Setup Email Integration Service:
CREATE OR REPLACE NOTIFICATION INTEGRATION EMAIL_INT
  TYPE = EMAIL
  ENABLED = TRUE
  --ALLOWED_RECIPIENTS = ( 'example@pandatagroup.com' )
  DEFAULT_SUBJECT = 'Snowflake Email Test'
  ;

-- ALLOWED_RECIPIENTS needs to be an email of a user in the Snowflake instance
-- Can create a 'dummy' user with email attached to it's profile to send to if not tied to a users account already

-- OPTIONAL: Setup Stage
CREATE SCHEMA <DATABASE>.CSV_FILES;
CREATE OR REPLACE STAGE <DATABASE>.CSV_FILES.PUBLIC_FILES ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Show Stages for confirmation
SHOW STAGES;