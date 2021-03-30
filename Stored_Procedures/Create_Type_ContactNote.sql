USE Contacts;

DROP TYPE IF EXISTS dbo.ContactNote;

GO

CREATE TYPE dbo.ContactNote
AS TABLE
(
 Note	VARCHAR(MAX) NOT NULL
);