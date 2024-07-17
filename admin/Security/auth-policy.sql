-- Policy to only accept SSO login - MFA Requirement disabled as we require MFA from Azure for SSO
CREATE OR REPLACE AUTHENTICATION POLICY user_auth_policy
  AUTHENTICATION_METHODS = ('SAML') -- 'PASSWORD'
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL', 'DRIVERS')
  MFA_AUTHENTICATION_METHODS = ('SAML'); -- 'PASSWORD'
  --MFA_ENROLLMENT = REQUIRED; -- Disable if using SSO/SCIM with MFA

-- Policy to prevent lockout to admin allowing password access if SSO Fails
CREATE OR REPLACE AUTHENTICATION POLICY admin_auth_policy
  AUTHENTICATION_METHODS = ('SAML', 'PASSWORD') -- 'PASSWORD'
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL', 'DRIVERS')
  MFA_AUTHENTICATION_METHODS = ('PASSWORD', 'SAML')
  MFA_ENROLLMENT = REQUIRED;

-- Policy for Service accounts to not require MFA
CREATE OR REPLACE AUTHENTICATION POLICY service_auth_policy
  AUTHENTICATION_METHODS = ('PASSWORD')
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL', 'DRIVERS')
  MFA_AUTHENTICATION_METHODS = ('PASSWORD');

-- Show authentication policies
SHOW AUTHENTICATION POLICIES;

-- Drop authentication policies
DROP AUTHENTICATION POLICY <policy_name>;

-- Enforce Policy
ALTER ACCOUNT SET AUTHENTICATION POLICY <policy_name>;
ALTER USER <username> SET AUTHENTICATION POLICY <policy_name>;

-- Remove Authentication Policy
ALTER ACCOUNT UNSET AUTHENTICATION POLICY;
ALTER USER <username> UNSET AUTHENTICATION POLICY;

--Unset users passwords once SSO enabled
ALTER USER <username> UNSET PASSWORD;

-- Check which authorization polcies are applied to who
SELECT *
FROM TABLE(
    SECURITY.INFORMATION_SCHEMA.POLICY_REFERENCES(
      POLICY_NAME => 'SECURITY.POLICIES.SERVICE_AUTH_POLICY'
  )
);