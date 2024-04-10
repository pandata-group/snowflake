    USE ROLE accountadmin;

-- Create Secret for a Private repo
    CREATE OR REPLACE SECRET git_secret
    TYPE = password
    USERNAME = 'username'
    PASSWORD = 'ghp_token';

-- Create API Integration
    CREATE OR REPLACE API INTEGRATION git_integration
    API_PROVIDER = git_https_api
    API_ALLOWED_PREFIXES = ('https://github.com/pandata-group/')
    --ALLOWED_AUTHENTICATION_SECRETS = (git_secret)
    ENABLED = TRUE;

-- Check API Integration
    show api integrations;

-- Create GIT Database
    CREATE DATABASE GIT;

-- Create GIT Repo in Snowflake
    USE DATABASE GIT;
    USE SCHEMA PUBLIC;
    CREATE OR REPLACE GIT REPOSITORY snowflake
    API_INTEGRATION = git_integration
    -- GIT_CREDENTIALS = my_secret if needed
    ORIGIN = 'https://github.com/pandata-group/snowflake.git';

-- List files in main branch
    ls @snowflake/branches/main;

-- Fetch files from repo - Must run if repo was updated
    alter git repository snowflake fetch;

-- Execute SQL
    EXECUTE IMMEDIATE FROM @snowflake/branches/main/sql/base.sql;