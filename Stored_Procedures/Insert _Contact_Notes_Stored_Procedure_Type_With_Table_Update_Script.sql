USE Contacts;

DROP PROCEDURE IF EXISTS dbo.InsertContactNotes;

GO

CREATE PROCEDURE dbo.InsertContactNotes
(
 @ContactId		INT,
 @Notes			ContactNote READONLY
)
AS
BEGIN;

DECLARE @TempNotes ContactNote;

INSERT INTO @TempNotes (Note)
SELECT Note FROM @Notes;

UPDATE @TempNotes SET Note = 'Pre: ' + Note;

INSERT INTO dbo.ContactNotes (ContactId, Notes)
	SELECT @ContactId, Note
		FROM @Notes;

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
