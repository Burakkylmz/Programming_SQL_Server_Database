Use WideWorldImporters-Pluralsight;
GO

/*
  Create a DDL trigger in this current database that prevents
  altering or dropping a table
*/
CREATE OR ALTER TRIGGER TDB_PreventTableDropOrAlter
ON DATABASE
FOR DROP_TABLE,ALTER_TABLE
AS
BEGIN
 PRINT 'DROP and ALTER table events are not allowed. Disable trigger TDB_PreventTableDropOrAlter to complete action.'
 ROLLBACK
END

/*
  Attempt to drop our Audit Log table
*/
DROP TABLE Application.AuditLog;

/*
  Attempt to add a column to the Application.Person table
*/
ALTER TABLE Application.People ADD TwitterHandle nvarchar(100);

/*
  Disable the trigger so that we can complete our modification;
*/
DISABLE TRIGGER TDB_PreventTableDropOrAlter ON DATABASE;

/*
  Attempt to add a column to the Application.Person table again
*/
ALTER TABLE Application.People ADD TwitterHandle nvarchar(100);

/*
  Enable the trigger again
*/
ENABLE TRIGGER TDB_PreventTableDropOrAlter ON DATABASE;
GO


/*************************************
*
* Log DDL Events to a table
*
*************************************/

CREATE TABLE Application.AuditLogDDL
( 
 Id INT IDENTITY,  
 EventTime DATETIME,
 EventType NVARCHAR(100),
 LoginName NVARCHAR(100),
 Command NVARCHAR(MAX) 
)
GO

/*
  This will log ALL DDL events at the database level.

  In reality, this should be refined to only capture events
  on specific types OR this audit table should be aggressively
  managed to only keep relevant events and table size small.
*/
CREATE TRIGGER AuditLogDDLEvents
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @EventData XML = EVENTDATA()
 INSERT INTO Application.AuditLogDDL(EventTime,EventType,LoginName,Command) 
 SELECT @EventData.value('(/EVENT_INSTANCE/PostTime)[1]', 'DATETIME'),
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'VARCHAR(100)'),
	    @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'VARCHAR(100)'),
		@EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')
END


/*
  Now, let's perform some DDL Events and see what we get
*/

/*
  Attempt to add a column to the Application.Person table
*/
ALTER TABLE Application.People ADD InstagramHandle nvarchar(100);

/*
  Check the Log
*/
SELECT * FROM Application.AuditLogDDL;

/*
  Disable the trigger so that we can complete our modification;
*/
DISABLE TRIGGER TDB_PreventTableDropOrAlter ON DATABASE;

/*
  Attempt to add a column to the Application.Person table again
*/
ALTER TABLE Application.People ADD InstagramHandle nvarchar(100);

/*
  Check the Log
*/
SELECT * FROM Application.AuditLogDDL;


/*
  Enable the trigger again
*/
ENABLE TRIGGER TDB_PreventTableDropOrAlter ON DATABASE;
GO