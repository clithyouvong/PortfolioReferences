/*
Use this to cleanup data sync entities on a db that you've removed the data sync metadata policies on
*/

-- Find all SQL Data Sync triggers
select name from sys.triggers where name like '%_dss_%_trigger';
-- Find all SQL Data Sync tables
select table_schema + '.' + table_name from information_schema.tables where table_schema='DataSync'
-- Find all SQL Data Sync procedures
select 'DataSync.' + name from sys.procedures where schema_id = SCHEMA_ID('DataSync')
-- Find all SQL Data Sync types
select name from sys.types where schema_id = SCHEMA_ID('DataSync')


-- Hit CTRL-T for "Results to Text"
GO
set nocount on
-- Generate drop scripts for all SQL Data Sync triggers
select 'drop trigger [' + name + ']' from sys.triggers where name like '%_dss_%_trigger';
-- Generate drop scripts for all SQL Data Sync tables
select 'drop table ' + table_schema + '.[' + table_name + ']' from information_schema.tables where table_schema='DataSync'
-- Generate drop scripts for all SQL Data Sync procedures
select 'drop procedure DataSync.[' + name + ']' from sys.procedures where schema_id = SCHEMA_ID('DataSync')
-- Generate drop scripts for all SQL Data Sync types
select 'drop type DataSync.[' + name + ']' from sys.types where schema_id = SCHEMA_ID('DataSync')
-- COPY output and run in a separate connection
