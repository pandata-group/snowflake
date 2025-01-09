-- Snowflake Key-pair Documentation: https://docs.snowflake.com/en/user-guide/key-pair-auth

-- Step 1: Generate Key-Pair in Terminal/CMD
-- Unencrypted (no passphrase)
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt -- Can rename rsa_key.p8 to name of your choosing

-- Encrypted (with passphrase)
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out rsa_key.p8 -- Can rename rsa_key.p8 to name of your choosing


-- Step 2: Generate Public Key in Terminal/CMD
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub -- If you changed the name of rsa_key, update here

-- IMPORTANT: Store .p8 and .pub keys safely


-- Assign public key to a snowflake user
ALTER USER example_user SET RSA_PUBLIC_KEY='MIIBIjANBgkqh...';
-- Only owners of a user, or users with the SECURITYADMIN role or higher can alter a user


-- Step 3: Verify user's public key fingerprint - run as one block
DESC USER example_user;
SELECT SUBSTR((SELECT "value" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  WHERE "property" = 'RSA_PUBLIC_KEY_FP'), LEN('SHA256:') + 1);

-- output: Azk1Pq...
-- record output

-- Run in terminal/CMD
openssl rsa -pubin -in rsa_key.pub -outform DER | openssl dgst -sha256 -binary | openssl enc -base64 -- if you changed the name of rsa_key, update here

-- Compare outputs, if they match, you successfully configured the public key