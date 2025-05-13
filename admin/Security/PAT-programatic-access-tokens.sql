-- OPTION 1: Using ENFORCED_NOT_REQUIRED or NOT_ENFORCED PAT Policy in Authentication Policy

-- Create and attach PAT
ALTER USER IF EXISTS <user>
ADD PROGRAMMATIC ACCESS TOKEN PAT_<USER>
  DAYS_TO_EXPIRY = 233 -- Set to the same day per year to make token rotation easier
  ROLE_RESTRICTION = SYSADMIN;

-- Verify access token on user
SHOW USER PROGRAMMATIC ACCESS TOKENS FOR USER <USER>;



-- OPTION 2: Using ENFORCED_REQUIRED or Default PAT policy and no Authentication Policy
-- Wide open Global Access
USE ACCOUNTADMIN;
CREATE NETWORK POLICY my_network_policy ALLOWED_IP_LIST = ('0.0.0.0/0');

-- Verify Network Policy has been created
SHOW NETWORK POLICIES;

-- Attach Network Policy to user/service account which you want to generate a PAT for
ALTER USER <user> SET NETWORK_POLICY = MY_NETWORK_POLICY;

-- Create and attach PAT
ALTER USER IF EXISTS <user>
ADD PROGRAMMATIC ACCESS TOKEN PAT_<user>
  DAYS_TO_EXPIRY = 233 -- Set to the same day per year to make token rotation easier
  ROLE_RESTRICTION = SYSADMIN;

-- Verify access token on user
SHOW USER PROGRAMMATIC ACCESS TOKENS FOR USER SVC_<user>;