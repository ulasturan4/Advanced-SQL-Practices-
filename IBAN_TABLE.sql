CREATE TABLE IBAN
(
Iban_ID int IDENTITY(1,1) NOT NULL,
IBAN nvarchar(26) NOT NULL,
EK int NOT NULL, 
Currencies_ShortNameK int NOT NULL,
Cpty_IdK int NOT NULL
PRIMARY KEY (Iban_ID)
)