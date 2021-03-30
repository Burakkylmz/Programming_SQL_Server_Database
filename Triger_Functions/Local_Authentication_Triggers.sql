USE master;  
GO

/*
  Create a new local login to test LOGON Triggers.

  ONLY do something like this in a local, non-shared environment!
*/
CREATE LOGIN login_test WITH PASSWORD = 'abc123!'; 
GO  

/*
  Grant them access to see DMVs. There are many better ways to
  accomplish this in production, but this will work for the demo.
*/
GRANT VIEW SERVER STATE TO login_test;  
GO  

/*
  Create a LOGON trigger that will limit the number of connections
  for this specific user. They cannot open more than 2 connections.
*/
CREATE OR ALTER TRIGGER LimitConnectionsForUser  
ON ALL SERVER  
FOR LOGON  
AS  
BEGIN  
IF ORIGINAL_LOGIN()= 'login_test' AND  
    (SELECT COUNT(*) FROM sys.dm_exec_sessions  
            WHERE is_user_process = 1 AND  
                original_login_name = 'login_test') > 2
    ROLLBACK;  
END;  





/***********************************************
 *
 * Create a server-level audit logging database
 *
 **********************************************/ 

/*
  Create an Audit Log Database for server-level events. This
  will be owned by my local user for now.
*/
CREATE DATABASE AuditLogDB;
GO

USE AuditLogDB;
GO

/*
  Create a table within the new database to store login event data
*/
CREATE TABLE LogonEventData
(
    LogonTime datetime,
    SPID int,
    HostName nvarchar(50),
	AppName nvarchar(100),
    LoginName nvarchar(50),
    ClientHost nvarchar(50)
);
GO

/*
  Create a second LOGON Trigger to log information.

  This will be executed each time as the owner of the logging
  database. Without this, the Trigger would be executed as the
  CALLER ('test_login' in this case) and it would return an error
  because they do not have permission to write into that
  database.

  Much care and thought should be given to how permissions are 
  used within your environments to protect data and users
  appropriately.
*/
CREATE OR ALTER TRIGGER SuccessfulLogonAudit
ON ALL SERVER WITH EXECUTE AS 'RYANB-DEV\Ryan' 
FOR LOGON
AS
BEGIN
    DECLARE @LogonTriggerData xml,
        @EventTime datetime,
        @SPID int,
		@LoginName nvarchar(50),
        @ClientHost nvarchar(50),
        @LoginType nvarchar(50),
        @HostName nvarchar(50),
        @AppName nvarchar(100);
     
    SET @LogonTriggerData = EventData();
     
    SET @EventTime = @LogonTriggerData.value('(/EVENT_INSTANCE/PostTime)[1]', 'datetime');
	SET @SPID = @LogonTriggerData.value('(/EVENT_INSTANCE/SPID)[1]', 'int');
    SET @LoginName = @LogonTriggerData.value('(/EVENT_INSTANCE/LoginName)[1]', 'nvarchar(50)');
    SET @ClientHost = @LogonTriggerData.value('(/EVENT_INSTANCE/ClientHost)[1]', 'nvarchar(50)');
    SET @HostName = HOST_NAME();
    SET @AppName = APP_NAME();
     
    INSERT INTO AuditLogDB.dbo.LogonEventData
    ( 
		LogonTime, SPID, HostName, AppName, LoginName, ClientHost
    )
    VALUES
    (
		@EventTime,	@SPID, @HostName, @AppName, @LoginName, @ClientHost
    )
END
GO

/*
 Create a new query window and check the log
*/
SELECT * FROM AuditLogDB.dbo.LogonEventData
ORDER BY LogonTime DESC;


/*
  We can reset the order of these Triggers. Because everything is run in 
  the same transaction, more work would be needed to log attempts that
  are successful but cross the number of connections limit.
*/
sp_settriggerorder @triggername = 'SuccessfulLogonAudit', @order = 'first', 
	@stmttype = 'LOGON', @namespace = 'SERVER';
GO

sp_settriggerorder @triggername = 'LimitConnectionsForUser', @order = 'last', 
	@stmttype = 'LOGON', @namespace = 'SERVER';
GO








/*
  Cleanup
*/

DROP TRIGGER LimitConnectionsForUser ON ALL SERVER;
DROP TRIGGER SuccessfulLogonAudit ON ALL SERVER;

DROP DATABASE AuditLogDB;

DROP LOGIN login_test;