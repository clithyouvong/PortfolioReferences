-- Step 1 Using a password generator,
-- Generate a password that is at least 16 characters excluding any ambiguous Charcters 
-- https://passwordsgenerator.net/

-- Step 2 Use the convention:
-- {appname_1word_lowercase}_{env}_{purpose}_{CRUD}
-- Create a username

-- step 3 exec on master
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-login-transact-sql?view=sql-server-ver15#after-creating-a-login
--Create Login [some_username_with_company_convention] with password = 'some_random_password_from_generator';
--Create User [some.user@domain.com] From External Provider

-- Step 4 exec on master and db
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-user-transact-sql?view=sql-server-ver15
--Create User [some_username_with_company_convention] from login [some_username_with_company_convention];

-- step 5 exec on db
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver15
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/grant-object-permissions-transact-sql?view=sql-server-ver15
--Grant Select, Execute, insert, update, alter ON Database::[my_database] To [some_username_with_company_convention];
--Grant Select, Execute, insert, update, alter ON Database::[my_database] To [some.user@domain.com];

-- step 6 record password in centralized administrative location
