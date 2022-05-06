CREATE TABLE Kustom..IBAN2  ( 
	Iban_ID     	int IDENTITY(1,1) NOT NULL,
	IBAN        	nvarchar(32) NOT NULL,
	EK          	int NOT NULL,
	Currencies_Id	int NOT NULL,
    Currencies_ShortName VARCHAR(3) NOT NULL,
	Cpty_Id      	int NOT NULL,
    Cpty_ShortName VARCHAR(10) NOT NULL
	)
GO
ALTER TABLE Kustom..IBAN2
	ADD CONSTRAINT kontrol_IBAN
	UNIQUE (IBAN)
GO
ALTER TABLE Kustom..IBAN2
	ADD CONSTRAINT kontrol_EK
	CHECK (EK>(0))
GO
ALTER TABLE Kustom..IBAN2
    ADD CONSTRAINT ek_curr_cpty_unique UNIQUE( EK, Currencies_Id, Cpty_Id)
 

---------------------

GO
IF EXISTS 
(
    SELECT NAME
    FROM sysobjects 
    WHERE NAME = 'cwp_CWULAS1CodeList' AND TYPE = 'P'
)
    DROP PROC cwp_CWULAS1CodeList
GO

CREATE PROCEDURE cwp_CWULAS1CodeList (

@CPTY_ShortName NVARCHAR(30) 

)
AS
BEGIN

    DECLARE @Iban_ID int

    SELECT _LIST_='currencyibann_list', _LIST_CLEAR_=''

    SELECT _LIST_ = 'currencyibann_list', _LIST_COLOR_COLUMN_ = 3, 'CURR','EK', 'IBAN'

    SELECT _LIST_ = 'currencyibann_list', _LIST_COLOR_INSERT_ = Iban_ID,'','Black', 3,Currencies_ShortName, EK, IBAN

    FROM Kustom..IBAN2 WHERE ( @CPTY_ShortName IS NULL OR Cpty_ShortName =@CPTY_ShortName ) 
  
END
GO
GRANT EXEC ON cwp_CWULAS1CodeList TO PUBLIC


-------------

IF EXISTS 
(
    SELECT NAME
    FROM sysobjects 
    WHERE NAME = 'cwp_CWULAS1insert' AND TYPE = 'P'
)
    DROP PROC cwp_CWULAS1insert

GO

CREATE PROC cwp_CWULAS1insert (
    @counterparty_sh varchar(10),
    @currency_sh varchar(3),
    @ek int,
    @iban nvarchar(35)
)
AS
BEGIN
    
    DECLARE
    
    @currency_id INT,
    @cpty_id INT

        SELECT @cpty_id = Cpty_Id FROM kplus..Cpty
        WHERE Cpty_ShortName=@counterparty_sh

        SELECT @currency_id = Currencies_Id FROM kplus..Currencies
        WHERE Currencies_ShortName=@currency_sh

        INSERT INTO Kustom..IBAN2 (Cpty_ShortName, Cpty_Id ,Currencies_ShortName, Currencies_Id ,EK, IBAN ) VALUES (@counterparty_sh, @cpty_id, @currency_sh, @currency_id, @ek, @iban)


EXEC cwp_CWULAS1CodeList @counterparty_sh

END
GO
GRANT EXEC ON cwp_CWULAS1insert TO PUBLIC

GO

-------------


IF EXISTS 
(
    SELECT NAME
    FROM sysobjects 
    WHERE NAME = 'cwp_CWULAS1delete' AND TYPE = 'P'
)
    DROP PROC cwp_CWULAS1delete

GO

CREATE PROC cwp_CWULAS1delete (

@iban nvarchar(32),
@counterparty_sh nvarchar(30)

)
AS
BEGIN
DELETE FROM Kustom..IBAN2 WHERE IBAN=@iban
EXEC cwp_CWULAS1CodeList @counterparty_sh
END
GO
GRANT EXEC ON cwp_CWULAS1delete TO PUBLIC



---------------

IF EXISTS 
(
    SELECT NAME
    FROM sysobjects 
    WHERE NAME = 'cwp_CWULAS1update' AND TYPE = 'P'
)
    DROP PROC cwp_CWULAS1update

GO

CREATE PROC cwp_CWULAS1update (

    @ek int,
    @currency_sh varchar(3),
    @iban nvarchar(32),
    @counterparty_sh nvarchar(30)
)
AS
BEGIN

    UPDATE Kustom..IBAN2 SET IBAN=@iban WHERE Currencies_ShortName=@currency_sh AND EK=@ek AND Cpty_ShortName=@counterparty_sh

EXEC cwp_CWULAS1CodeList @counterparty_sh

END
GO
GRANT EXEC ON cwp_CWULAS1update TO PUBLIC


--------------

GO
IF EXISTS 
(
    SELECT NAME
    FROM sysobjects 
    WHERE NAME = 'cwp_CWULAS1CodeLoad_EK' AND TYPE = 'P'
)
    DROP PROC cwp_CWULAS1CodeLoad_EK
GO

CREATE PROCEDURE cwp_CWULAS1CodeLoad_EK
    (
        @Result VARCHAR(50)
    )
    AS
    BEGIN
    DECLARE @Iban_ID INT
  
SELECT @Iban_ID = CONVERT(INT, RTRIM(LTRIM( LEFT(@Result, CHARINDEX(' ',@Result) - 1))))   

   SELECT _VALUE_ = 'ek_1',''
   SELECT _VALUE_ = 'ek_1',0

insert into TempA(Result) values(@Result)
SELECT _VALUE_ = 'ek_1',EK, Currencies_ShortName, IBAN, Cpty_ShortName,
_LIST_CLEAR_=''
FROM Kustom..IBAN2 WHERE Iban_ID = @Iban_ID

    
SELECT 
IBAN=IBAN,
Currencies_ShortName=Currencies_ShortName,
Cpty_ShortName=Cpty_ShortName
FROM Kustom..IBAN2 WHERE Iban_ID = @Iban_ID

     
    END
GO

GRANT EXEC ON cwp_CWULAS1CodeLoad_EK TO PUBLIC


---------------

GO
IF EXISTS 
(
    SELECT NAME
    FROM sysobjects 
    WHERE NAME = 'cwp_CWULAS1CodeLoad_IBAN' AND TYPE = 'P'
)
    DROP PROC cwp_CWULAS1CodeLoad_IBAN
GO

CREATE PROCEDURE cwp_CWULAS1CodeLoad_IBAN
    (
        @Result VARCHAR(50)
    )
    AS
    BEGIN
    DECLARE @Iban_ID INT
  
SELECT @Iban_ID = CONVERT(INT, RTRIM(LTRIM( LEFT(@Result, CHARINDEX(' ',@Result) - 1))))   

   SELECT _VALUE_ = 'iban_1',''
   SELECT _VALUE_ = 'iban_1',0

insert into TempA(Result) values(@Result)
SELECT _VALUE_ = 'iban_1',IBAN,Currencies_ShortName, EK, Cpty_ShortName,
_LIST_CLEAR_=''
FROM Kustom..IBAN2 WHERE Iban_ID = @Iban_ID

    
SELECT 
EK=EK,
Currencies_ShortName=Currencies_ShortName,
Cpty_ShortName=Cpty_ShortName
FROM Kustom..IBAN2 WHERE Iban_ID = @Iban_ID

     
    END
GO

GRANT EXEC ON cwp_CWULAS1CodeLoad_IBAN TO PUBLIC


-----------

GO
IF EXISTS 
(
    SELECT NAME
    FROM sysobjects 
    WHERE NAME = 'cwp_CWULAS1CodeLoad_Currency' AND TYPE = 'P'
)
    DROP PROC cwp_CWULAS1CodeLoad_Currency
GO

CREATE PROCEDURE cwp_CWULAS1CodeLoad_Currency
    (
        @Result VARCHAR(50)
    )
    AS
    BEGIN
    DECLARE @Iban_ID INT
  
SELECT @Iban_ID = CONVERT(INT, RTRIM(LTRIM( LEFT(@Result, CHARINDEX(' ',@Result) - 1))))   

   SELECT _VALUE_ = 'Curr_help',''
   SELECT _VALUE_ = 'Curr_help',0

insert into TempA(Result) values(@Result)
SELECT _VALUE_ = 'Curr_help',Currencies_ShortName, IBAN, EK, Cpty_ShortName,
_LIST_CLEAR_=''
FROM Kustom..IBAN2 WHERE Iban_ID = @Iban_ID

    
SELECT 
EK=EK,
IBAN=IBAN,
Cpty_ShortName=Cpty_ShortName
FROM Kustom..IBAN2 WHERE Iban_ID = @Iban_ID

     
    END
GO

GRANT EXEC ON cwp_CWULAS1CodeLoad_Currency TO PUBLIC


----------------

IF EXISTS 
(
    SELECT NAME
    FROM sysobjects 
    WHERE NAME = 'cwp_CWULAS1CodeLoad' AND TYPE = 'P'
)
    DROP PROC cwp_CWULAS1CodeLoad

GO

CREATE PROC cwp_CWULAS1CodeLoad (

    @Result VARCHAR(50)
)
AS
BEGIN

    EXEC cwp_CWULAS1CodeLoad_EK @Result
    EXEC cwp_CWULAS1CodeLoad_IBAN @Result
    EXEC cwp_CWULAS1CodeLoad_Currency @Result

END
GO
GRANT EXEC ON cwp_CWULAS1CodeLoad TO PUBLIC

GO
