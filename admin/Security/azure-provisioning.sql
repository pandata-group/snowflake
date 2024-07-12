-- Automatic user provisioning setup for Azure and Snowlfake

-- Creating a role AAD_PROVISIONER
use role accountadmin;
create role if not exists aad_provisioner;
grant create user on account to role aad_provisioner;
grant create role on account to role aad_provisioner;
grant role aad_provisioner to role accountadmin;

create or replace security integration aad_provisioning
    type = scim
    scim_client = 'azure'
    run_as_role = 'AAD_PROVISIONER';

-- Generates SCIM access token for Azure (expires every 6 months)
 select system$generate_scim_access_token('AAD_PROVISIONING');

-- Applying/Updating token in Azure
-- 1. Login to Azure as an admin user
-- 2. Go to Microsoft Entra ID
-- 3. Go to Enterprise Applications
-- 4. Go to Application managing SSO/Provisioning
-- 5. Under 'Manage' go to 'Provisioning' then open the 'Admin Credentials' section
-- 6. Update the 'Secret Token' with the SCIM access token generated
-- 7. Test connection and save.