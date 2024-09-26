-- Create user
CREATE USER <username>
  PASSWORD = '<password>'
  DEfAULT_WAREHOUSE = '<warehouse_name'> -- Optional
  MUST_CHANGE_PASSWORD = TRUE | FALSE -- Optional: Default = FALSE
;

-- Show user properties
DESC USER <username>;

-- Alter user 
ALTER USER <username> SET TYPE = PERSON | SERVICE | LEGACY_SERVICE | NULL;
  -- Default is PERSON for human users
  -- SERVICE: Removes current password and disallows password authentication. Meant for OAuth/Key-pair services.
  -- LEGACY_SERVICE: Retains password and password authentication - less secure

-- Grant role
GRANT ROLE SYSADMIN TO USER SVC_PANDATA;

-- Set or unset specific authentication policy
ALTER USER <username> SET AUTHENTICATION POLICY <auth_policy>;
ALTER USER <username> UNSET AUTHENTICATION POLICY;



-- EXAMPLE: Create Pandata service account user with proper auth policy and roles
CREATE USER SVC_PANDATA
  PASSWORD = '<password>'
  --DEfAULT_WAREHOUSE = '<warehouse_name'> -- Optional
  --MUST_CHANGE_PASSWORD = TRUE | FALSE -- Optional: Default = FALSE
;

ALTER USER SVC_PANDATA SET TYPE = LEGACY_SERVICE; -- Best to use OAuth/Key-pair but lots of integrations don't have the capabilities

GRANT ROLE SYSADMIN TO USER SVC_PANDATA; -- Service accounts should operate primarily at SYSADMIN and no higher

ALTER USER SVC_PANDATA SET AUTHENTICATION POLICY service_auth_policy; -- Our service_auth_policy allows service accounts password access but not SSO
