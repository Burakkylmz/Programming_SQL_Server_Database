USE Contacts;

DROP PROCEDURE IF EXISTS dbo.InsertContactNotes;

GO

CREATE PROCEDURE dbo.InsertContactNotes
(
 @ContactId		INT,
 @Notes			VARCHAR(MAX)
)
AS
BEGIN;

DECLARE @NoteTable	TABLE (Note	VARCHAR(MAX));
DECLARE @NoteValue	VARCHAR(MAX);

INSERT INTO @NoteTable (Note)
SELECT value
	FROM STRING_SPLIT(@Notes, ',');

DECLARE NoteCursor CURSOR FOR 
	SELECT Note FROM @NoteTable;

OPEN NoteCursor
FETCH NEXT FROM NoteCursor INTO @NoteValue;

WHILE @@FETCH_STATUS = 0
 BEGIN;
	INSERT INTO dbo.ContactNotes (ContactId, Notes)
		VALUES (@ContactId, @NoteValue);

	FETCH NEXT FROM NoteCursor INTO @NoteValue;

 END;

CLOSE NoteCursor;
DEALLOCATE NoteCursor;

SELECT * FROM dbo.ContactNotes
	WHERE ContactId = @ContactId
ORDER BY NoteId DESC;

END;

--test script
DECLARE @TempNotes	ContactNote;

INSERT INTO @TempNotes (Note)
VALUES
('Hi, Peter called.'),
('Quick note to let you know Jo wants you to ring her. She rang at 14:30.'),
('Terri asked about the quote, I have asked her to ring back tomorrow.');

EXEC dbo.InsertContactNotes
	@ContactId = 23,
	@Notes = @TempNotes;
