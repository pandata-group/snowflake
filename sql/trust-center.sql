USE ROLE ACCOUNTADMIN;

CREATE ROLE trust_center_admin_role;
GRANT APPLICATION ROLE SNOWFLAKE.TRUST_CENTER_ADMIN TO ROLE trust_center_admin_role;

CREATE ROLE trust_center_viewer_role;
GRANT APPLICATION ROLE SNOWFLAKE.TRUST_CENTER_VIEWER TO ROLE trust_center_viewer_role;

-- Grant Roles
GRANT ROLE trust_center_admin_role TO USER <admin_user>;
GRANT ROLE trust_center_viewer_role TO USER <viewer_user>;