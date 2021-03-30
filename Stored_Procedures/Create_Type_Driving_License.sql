USE Contacts;

GO

CREATE TYPE dbo.DrivingLicense
FROM CHAR(16) NOT NULL;

DROP TYPE dbo.DrivingLicense;
