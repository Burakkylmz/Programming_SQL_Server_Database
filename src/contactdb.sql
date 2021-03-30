USE master

:setvar path "C:\temp\contactsdb\"

:setvar currentFile "01 Create AddressBook Database.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "10 Create Contacts Table.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "15 Create ContactNotes Table.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

PRINT 'Executing $(path)$(currentFile)'
:setvar currentFile "20 Create Roles Table.sql"
:r $(path)$(currentFile)

:setvar currentFile "25 Create ContactRoles Table.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "30 Create ContactAddresses Table.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "35 Create PhoneNumberTypes Table.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "40 Create ContactPhoneNumbers Table.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "45 Create ContactVerificationDetails Table.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "50 Insert PhoneNumberTypes.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "55 Contact Table Trigger.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "60 Insert Roles.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "65 Bulk Insert Contacts.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "70 Bulk Insert Contact Addresses.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "75 Bulk Insert ContactNotes.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "80 Bulk Insert ContactPhoneNumbers.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "85 Bulk Insert ContactRoles.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

:setvar currentFile "90 Bulk Insert ContactVerificationDetails.sql"
PRINT 'Executing $(path)$(currentFile)'
:r $(path)$(currentFile)

PRINT 'All apply scripts successfully executed.'

USE master