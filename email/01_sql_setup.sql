-- Create Email Integration Service:
CREATE OR REPLACE NOTIFICATION INTEGRATION EMAIL_INT
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ( 'example@pandatagroup.com' )   -- Optional
  DEFAULT_SUBJECT = 'Snowflake Email Test'              -- Optional
  ;

-- ALLOWED_RECIPIENTS needs to be an email of a user in the Snowflake instance
-- Can create a 'dummy' user with email attached to it's profile to send to if not tied to a users account already

-- Create Stage if needed
CREATE SCHEMA <DATABASE>.<SCHEMA>;
CREATE OR REPLACE STAGE <DATABASE>.<SCHEMA>.<STAGE> ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Show Stages for confirmation
SHOW STAGES;

-- Create Stored Procedure for it
CREATE OR REPLACE PROCEDURE <DATABASE>.<SCHEMA>.SEND_REPORT_EMAIL()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('snowflake-snowpark-python', 'pandas')
  HANDLER = 'main'
AS
$$
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col
import tempfile
import pandas as pd
import datetime


def main(session: snowpark.Session): 

    # Print a sample of the dataframe to standard output.
    file_name, file_url = send_full_reports(session)
    email_body = f'please find attached report <a href="{file_url}">{file_name}</a>'
    to_email = 'example@pandatagroup.com'
    email_subject = 'Snowflake Automated Report - {}'.format(datetime.datetime.utcnow().strftime('%Y-%m-%d'))
    
    session.sql("CALL SYSTEM$SEND_EMAIL('EMAIL_INT', '{}', '{}', '{}', '{}');".format(to_email,
                                                                                      email_subject,
                                                                                      email_body,
                                                                                      "text/html")).collect()
    return 'Email sent successfully.'

def send_full_reports(session):
    try:
        view_name = '<DATABASE>.<SCHEMA>.<TABLE or View>' #Provide Fully Qualified Name of the View or Table.
        df =  session.table(view_name).toPandas()
        stage_name = "@<DATABASE>.<SCHEMA>.<STAGE>"
        file_name = f'table_or_view_example_' #Change the FileName Here.
        with tempfile.NamedTemporaryFile(mode="w+t", prefix=file_name, suffix=".csv", delete=False) as t:
            df.to_csv(t.name, index=None)
            session.file.put(t.name, stage_name,auto_compress=False)
            exported_file_name = t.name.split("/")[-1]
            file_sql = f"select GET_PRESIGNED_URL(@<DATABASE>.<SCHEMA>.<STAGE>, '{exported_file_name}',604800) as signed_url;"
            print(file_sql)
            signed_url = session.sql(file_sql).collect()[0]['SIGNED_URL']
            return exported_file_name, signed_url
    except Exception as e:
        print(str(e))
    $$;

-- Stored Proc Call
CALL <DATABASE>.<SCHEMA>.SEND_REPORT_EMAIL();