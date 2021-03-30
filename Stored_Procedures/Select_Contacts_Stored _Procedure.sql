USE Contacts;

GO

IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'SelectContacts')
 BEGIN;
	DROP PROCEDURE dbo.SelectContacts;
 END;

GO

CREATE PROCEDURE dbo.SelectContacts
AS
BEGIN;

SELECT * FROM dbo.Contacts WHERE FirstName = 'Grace';

END;

--Test Script
EXEC dbo.SelectContacts;