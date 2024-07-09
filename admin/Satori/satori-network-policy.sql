-- Network rule to limit traffic to Snowflake to Satori
CREATE NETWORK RULE allow_access_via_Satori
  MODE = INGRESS
  TYPE = IPV4
  VALUE_LIST = ('44.226.66.93/32', '44.231.170.119/32', '52.88.75.183/32');

  -- Network policy to enforce rule created
CREATE NETWORK POLICY only_access_via_satori
  ALLOWED_NETWORK_RULE_LIST = ('allow_access_via_Satori');

-- Verify rule works by testing on a set user
ALTER USER <UserName> SET NETWORK_POLICY = only_access_via_satori;

-- Apply policy to entire Snowflake account
ALTER ACCOUNT SET NETWORK_POLICY = only_access_via_satori;