-- Policy to only accept SSO login - MFA Requirement disabled if IdP has MFA enabled
CREATE OR REPLACE AUTHENTICATION POLICY sso_auth_policy
  AUTHENTICATION_METHODS = ('SAML', 'KEYPAIR') -- 'PASSWORD' 
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL', 'DRIVERS')
  MFA_AUTHENTICATION_METHODS = ('SAML'); -- 'PASSWORD'
  --MFA_ENROLLMENT = REQUIRED; -- Disable if using SSO with MFA

-- Policy to prevent lockout to admin allowing password access if SSO Fails
CREATE OR REPLACE AUTHENTICATION POLICY admin_auth_policy
  AUTHENTICATION_METHODS = ('SAML', 'PASSWORD', 'KEYPAIR')
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL', 'DRIVERS')
  MFA_AUTHENTICATION_METHODS = ('PASSWORD', 'SAML')
  MFA_ENROLLMENT = REQUIRED;

-- Policy for External users outside your organization
CREATE OR REPLACE AUTHENTICATION POLICY external_auth_policy
  AUTHENTICATION_METHODS = ('PASSWORD','KEYPAIR')
  CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL', 'DRIVERS')
  MFA_AUTHENTICATION_METHODS = ('PASSWORD')
  MFA_ENROLLMENT = REQUIRED;


-- Service accounts should have their TYPE updated to 'SERVICE'
ALTER <user> SET TYPE = 'SERVICE'; -- This will remove any stored passwords and break any integrations using such and force KeyPair


-- Show authentication policies
SHOW AUTHENTICATION POLICIES;

-- Drop authentication policies
DROP AUTHENTICATION POLICY <policy_name>;

-- Enforce Policy
ALTER ACCOUNT SET AUTHENTICATION POLICY <policy_name>;
ALTER USER <user> SET AUTHENTICATION POLICY <policy_name>;

-- Remove Authentication Policy
ALTER ACCOUNT UNSET AUTHENTICATION POLICY;
ALTER USER <user> UNSET AUTHENTICATION POLICY;

--Unset users passwords once SSO enabled
ALTER USER <user> UNSET PASSWORD;

-- Check which authorization policies are applied to who
SELECT *
FROM TABLE(
    SECURITY.INFORMATION_SCHEMA.POLICY_REFERENCES(
      POLICY_NAME => 'SECURITY.POLICIES.SERVICE_AUTH_POLICY'
  )
);

-- Show users who will be affected by Snowflakes April 2025 MFA Requirements
SELECT name, type, disabled, has_mfa, has_password
FROM snowflake.account_usage.users
WHERE deleted_on IS NULL
  AND has_mfa = false
  AND has_password
  AND (type IS NULL OR type IN ('PERSON', 'LEGACY_SERVICE'))
  AND disabled = 'false' -- optional: adjust for use case
ORDER BY NAME ASC;
