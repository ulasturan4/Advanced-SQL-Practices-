IF EXISTS
(
    SELECT name
    FROM sysobjects
    WHERE name = 'ulasreportSPOT' AND TYPE ='P'
)
    DROP PROC ulasreportSPOT

GO

CREATE PROCEDURE ulasreportSPOT
(

    @Folder_Id INT,
    @ToDate DATETIME,
    @Cpty_Id INT
)
AS 
BEGIN

    SELECT  __CLEAR__=1
    SELECT __TITLE__='Spot Deals'
    SELECT __ELEM_TITLE__ = 'CCY-NetAmount'    
    SELECT __LENGTH__=3,NULL
    SELECT __HEADER__='CCY','Net Amount'
    SELECT __FORMAT__ = NULL,'-999 999 999 999 999 999.99'


;WITH UNIONTABLE AS
  ( 
    SELECT cu.Currencies_ShortName AS Curr ,SUM(sd.Amount1) AS NetAmount FROM kplus..SpotDeals sd
    INNER JOIN kplus..Folders f ON f.Folders_Id=sd.Folders_Id
    INNER JOIN kplus..Pairs pa ON sd.Pairs_Id=pa.Pairs_Id
    LEFT JOIN kplus..Cpty c ON sd.Cpty_Id=c.Cpty_Id
    INNER JOIN kplus..Currencies cu ON cu.Currencies_Id=pa.Currencies_Id_1
    WHERE (@Folder_Id IS NULL OR f.Folders_Id=@Folder_Id) AND  (@ToDate IS NULL OR DATEDIFF(DAY,@ToDate, TradeDate) <= 0 )
    AND (@Cpty_Id IS NULL OR c.Cpty_Id=@Cpty_Id)
    GROUP BY cu.Currencies_ShortName

    UNION

    SELECT cu.Currencies_ShortName AS Curr, SUM(sd.Amount2) AS NetAmount FROM kplus..SpotDeals sd
    INNER JOIN kplus..Folders f ON f.Folders_Id=sd.Folders_Id
    INNER JOIN kplus..Pairs pa ON sd.Pairs_Id=pa.Pairs_Id
    LEFT JOIN kplus..Cpty c ON sd.Cpty_Id=c.Cpty_Id
    INNER JOIN kplus..Currencies cu ON cu.Currencies_Id=pa.Currencies_Id_2
    WHERE (@Folder_Id IS NULL OR f.Folders_Id=@Folder_Id) AND  (@ToDate IS NULL OR DATEDIFF(DAY,@ToDate, TradeDate) <= 0 )
    AND (@Cpty_Id IS NULL OR c.Cpty_Id=@Cpty_Id)
    GROUP BY cu.Currencies_ShortName
) SELECT Curr, SUM(NetAmount) as NetAmount FROM UNIONTABLE GROUP BY Curr

-------------------

    SELECT __ELEM_TITLE__ = 'IBAN-CCY-NetAmount'    
    SELECT __LENGTH__=NULL,3,NULL
    SELECT __HEADER__='IBAN','CCY','NetAmount'
    SELECT __FORMAT__ = NULL,NULL,'999 999 999 999 999 999.99'

;WITH UNIONTABLE AS
  ( 
    SELECT ib.IBAN AS IBAN ,cu.Currencies_ShortName AS Curr ,SUM(sd.Amount1) AS NetAmount FROM kplus..SpotDeals sd
    INNER JOIN kplus..Folders f ON f.Folders_Id=sd.Folders_Id
    INNER JOIN kplus..Pairs pa ON sd.Pairs_Id=pa.Pairs_Id
    INNER JOIN Kustom..IBAN_SD_foreign i ON sd.SpotDeals_Id=i.DealId
    INNER JOIN Kustom..IBAN2 ib ON ib.Iban_ID=i.Iban1_ID
    LEFT JOIN kplus..Cpty c ON sd.Cpty_Id=c.Cpty_Id
    INNER JOIN kplus..Currencies cu ON cu.Currencies_Id=pa.Currencies_Id_1
    WHERE (@Folder_Id IS NULL OR f.Folders_Id=@Folder_Id) AND  (@ToDate IS NULL OR DATEDIFF(DAY,@ToDate, TradeDate) <= 0 )
    AND (@Cpty_Id IS NULL OR c.Cpty_Id=@Cpty_Id)
    GROUP BY ib.IBAN, cu.Currencies_ShortName

    UNION

    SELECT ib.IBAN AS IBAN, cu.Currencies_ShortName AS Curr, SUM(sd.Amount2) AS NetAmount FROM kplus..SpotDeals sd
    INNER JOIN kplus..Folders f ON f.Folders_Id=sd.Folders_Id
    INNER JOIN kplus..Pairs pa ON sd.Pairs_Id=pa.Pairs_Id
    INNER JOIN Kustom..IBAN_SD_foreign i ON sd.SpotDeals_Id=i.DealId
    INNER JOIN Kustom..IBAN2 ib ON ib.Iban_ID=i.Iban2_ID
    LEFT JOIN kplus..Cpty c ON sd.Cpty_Id=c.Cpty_Id
    INNER JOIN kplus..Currencies cu ON cu.Currencies_Id=pa.Currencies_Id_2
    WHERE (@Folder_Id IS NULL OR f.Folders_Id=@Folder_Id) AND  (@ToDate IS NULL OR DATEDIFF(DAY,@ToDate, TradeDate) <= 0 )
    AND (@Cpty_Id IS NULL OR c.Cpty_Id=@Cpty_Id)
    GROUP BY ib.IBAN, cu.Currencies_ShortName
) SELECT IBAN, Curr, SUM(NetAmount) AS NetAmount FROM UNIONTABLE GROUP BY IBAN, Curr

--------------

    SELECT __ELEM_TITLE__ = 'SPOT'    
    SELECT __LENGTH__=NULL,NULL,20,NULL,NULL,NULL,3,NULL,NULL,3,NULL
    SELECT __HEADER__='Deal Type','Deal Id','Folder_ShortName','TradeDate','Cpty','Amount1','CCY1','IBAN','Amount2','CCY2','IBAN'
    SELECT __FORMAT__ = NULL,'999999999999999',NULL,NULL,NULL,'999 999 999 999 999.99',NULL,NULL,'999 999 999 999 999.99',NULL,NULL

        
     SELECT i.DealType,i.DealId,f.Folders_ShortName, sd.TradeDate,c.Cpty_ShortName,sd.Amount1, cu.Currencies_ShortName, ib.IBAN, sd.Amount2 , cu1.Currencies_ShortName ,ib1.IBAN
     FROM kplus..SpotDeals sd 
     INNER JOIN kplus..Folders f ON f.Folders_Id=sd.Folders_Id
     INNER JOIN kplus..Pairs pa ON sd.Pairs_Id=pa.Pairs_Id
     LEFT JOIN kplus..Cpty c ON sd.Cpty_Id=c.Cpty_Id
     INNER JOIN kplus..Currencies cu ON cu.Currencies_Id=pa.Currencies_Id_1 
     INNER JOIN kplus..Currencies cu1 ON cu1.Currencies_Id=pa.Currencies_Id_2
     INNER JOIN Kustom..IBAN_SD_foreign i ON sd.SpotDeals_Id=i.DealId
     INNER JOIN Kustom..IBAN2 ib ON ib.Iban_ID=i.Iban1_ID
     INNER JOIN Kustom..IBAN2 ib1 ON ib1.Iban_ID=i.Iban2_ID
     WHERE (@Folder_Id IS NULL OR f.Folders_Id=@Folder_Id) AND (@ToDate IS NULL OR DATEDIFF(DAY,@ToDate, sd.TradeDate) <= 0 )
     AND (@Cpty_Id IS NULL OR c.Cpty_Id=@Cpty_Id)
    

END
GO

GRANT EXEC ON ulasreportSPOT TO PUBLIC
-----------