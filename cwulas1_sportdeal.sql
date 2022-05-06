IF EXISTS
(
    SELECT name
    FROM sysobjects
    WHERE name = 'cwp_CWULAS1Cpty_Crcies_Iban_SlctAuto_SD' AND TYPE ='P'
)
    DROP PROC cwp_CWULAS1Cpty_Crcies_Iban_SlctAuto_SD

GO

CREATE PROC cwp_CWULAS1Cpty_Crcies_Iban_SlctAuto_SD (

@Counterparty_ID INT,
@Pairs_ID INT

)
AS
BEGIN

    DECLARE

    @currency1 INT,
    @currency2 INT

    SELECT @currency1 = Currencies_Id_1 FROM kplus..Pairs
    WHERE Pairs_Id=@Pairs_ID

    SELECT @currency2 = Currencies_Id_2 FROM kplus..Pairs
    WHERE Pairs_Id=@Pairs_ID

    SELECT _VALUE_ = 'IBAN1',IBAN
    FROM Kustom..IBAN2
    WHERE Cpty_Id=@Counterparty_ID AND EK=(SELECT MIN(EK) FROM Kustom..IBAN2 ) AND Currencies_Id=@currency1

    SELECT _VALUE_ = 'IBAN2',IBAN
    FROM Kustom..IBAN2
    WHERE Cpty_Id=@Counterparty_ID AND EK=(SELECT MIN(EK) FROM Kustom..IBAN2 ) AND Currencies_Id=@currency2

END
GO 

GRANT EXEC ON cwp_CWULAS1Cpty_Crcies_Iban_SlctAuto_SD TO PUBLIC

--------

IF EXISTS
(
    SELECT name
    FROM sysobjects
    WHERE name = 'cwp_CWULAS1Cpty_Crcy1_Iban_SlctHelp_SD' AND TYPE ='P'
)
    DROP PROC cwp_CWULAS1Cpty_Crcy1_Iban_SlctHelp_SD

GO

CREATE PROC cwp_CWULAS1Cpty_Crcy1_Iban_SlctHelp_SD (

@Counterparty_ID INT,
@Pairs_ID INT
)
AS
BEGIN

    DECLARE

    @currency1 INT

    SELECT @currency1 = Currencies_Id_1 FROM kplus..Pairs
    WHERE Pairs_Id=@Pairs_ID


    SELECT IBAN FROM Kustom..IBAN2
    WHERE Cpty_Id=@Counterparty_ID AND Currencies_Id=@currency1

END
GO 

GRANT EXEC ON cwp_CWULAS1Cpty_Crcy1_Iban_SlctHelp_SD TO PUBLIC

----------

IF EXISTS
(
    SELECT name
    FROM sysobjects
    WHERE name = 'cwp_CWULAS1Cpty_Crcy2_Iban_SlctHelp_SD' AND TYPE ='P'
)
    DROP PROC cwp_CWULAS1Cpty_Crcy2_Iban_SlctHelp_SD

GO

CREATE PROC cwp_CWULAS1Cpty_Crcy2_Iban_SlctHelp_SD (

@Counterparty_ID INT,
@Pairs_ID INT

)
AS
BEGIN

    DECLARE

    @currency2 INT

    SELECT @currency2 = Currencies_Id_2 FROM kplus..Pairs
    WHERE Pairs_Id=@Pairs_ID

    SELECT IBAN  FROM Kustom..IBAN2
    WHERE Cpty_Id=@Counterparty_ID AND Currencies_Id=@currency2

END
GO 

GRANT EXEC ON cwp_CWULAS1Cpty_Crcy2_Iban_SlctHelp_SD TO PUBLIC

-------------

kplus..SpotDeals

-----------


