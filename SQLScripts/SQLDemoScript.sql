/* 
	Erster Wurf Tabellenstruktur 
	View s und Stored Proc s
	Fehlend Barzahler werden nicht abgerechnet
	Fehlend Fremdspieler werden Einzeln am Tag abgerechnet
	Fehlend Nur Vereinsmitglieder und Einzugsmitglieder werden abgerechnet
	Fehlend Mitgliedsbeitrag wird für den laufenden Monat mitabgerechnet 30 oder 60 Euro
	Fehlend Schrankmiete ggfs 1/2 wird mit für den laufenden Monat abgerechnet
	Fehlend Rückstellung vom Vormonat wird mitabgerechnet
	Fehlend Mitglied ausgesetzt wird abgerechnet
	Fehlend Kassenwart muss vor der Abrechnung die Liste durchsehen

	Bei Ausführung als Script werden Buchungen und eine Abrechnung simuliert
*/

DROP TABLE IF EXISTS Verzehr;
DROP TABLE IF EXISTS Verzehr_History;
DROP TABLE IF EXISTS Konto; 
DROP TABLE IF EXISTS Produkte; 
DROP TABLE IF EXISTS Persohnen;
DROP PROC IF EXISTS usp_abrechnung

CREATE TABLE dbo.Persohnen
(	Id int IDENTITY (1,1) 
	PRIMARY KEY,
	Vname varchar(31),
	Nname VARCHAR(31)	);

CREATE TABLE Produkte 
(	Id INT IDENTITY (1,1) 
	PRIMARY KEY,
	Produkt VARCHAR(31), 
	Preis SMALLMONEY	);

CREATE TABLE Verzehr
(	Id INT IDENTITY (1, 1)
	PRIMARY KEY, 
	FK_Persohnen INT FOREIGN KEY
	REFERENCES Persohnen(Id),
	FK_Produkt INT FOREIGN KEY
	REFERENCES Produkte(Id), 
	Preis SMALLMONEY,
	DatumUhrzeit SMALLDATETIME 
	DEFAULT GETDATE()	);

CREATE TABLE Verzehr_History
(	Id INT, 
	FK_Persohnen INT FOREIGN KEY
	REFERENCES Persohnen(Id),
	FullName VARCHAR(64),
	FK_Produkt INT FOREIGN KEY
	REFERENCES Produkte(Id), 
	Produkt varchar(64),
	Preis SMALLMONEY,
	DatumUhrzeit SMALLDATETIME, 
	AbrechnungDatumUhrzeit SMALLDATETIME DEFAULT GETDATE());

CREATE TABLE Konto 
(	Id INT IDENTITY (1,1) 
		PRIMARY KEY,
	FK_Persohnen INT 
		FOREIGN KEY REFERENCES dbo.Persohnen(Id), 
	FullName VARCHAR(64),
	Buchung VARCHAR(31),
	BuchungsAnzahl INT,
	SummePreis SMALLMONEY, 
	AbrechnungDatumUhrzeit SMALLDATETIME DEFAULT GETDATE());
GO

--------------------------------------------------------------

INSERT INTO dbo.Persohnen
(
    Vname,
    Nname
)
VALUES
(   'Jens', -- Vname - varchar(31)
    'Herrmann'  -- Nname - varchar(31)
    ),
(	'Michael', 'Meiyer'	),
(	'Gabriele', 'Müller'	),
(	'Rainer', 'Leggewie'	),
(	'Stefan', 'Frank'	);

INSERT INTO dbo.Produkte
(
    Produkt,
    Preis
)
VALUES
(   'Duplo', -- Produkt - varchar(31)
    0.85  -- Preis - decimal
    ),
(	'Mars', 1.20	),
(	'Snickers', 1.20	),
(	'Erdnüsse', 1.15	),
(	'Chips', 1.5	);

INSERT INTO dbo.Verzehr
(
    FK_Persohnen,
    FK_Produkt,
    Preis,
    DatumUhrzeit
)
VALUES
(   2,   -- FK_Persohnen - int
    1,   -- FK_Produkt - int
    (SELECT preis FROM dbo.Produkte WHERE Id = 1),   -- Preis - decimal
    DEFAULT -- DatumUhrzeit - smalldatetime
    ), 
(	1, 3, (SELECT preis FROM dbo.Produkte WHERE Id = 3), DEFAULT	),
(	4, 2, (SELECT preis FROM dbo.Produkte WHERE Id = 2), DEFAULT	),
(	2, 5, (SELECT preis FROM dbo.Produkte WHERE Id = 5), DEFAULT	),
(	2, 3, (SELECT preis FROM dbo.Produkte WHERE Id = 3), DEFAULT	),
(	4, 1, (SELECT preis FROM dbo.Produkte WHERE Id = 1), DEFAULT	),
(	3, 2, (SELECT preis FROM dbo.Produkte WHERE Id = 2), DEFAULT	),
(	2, 3, (SELECT preis FROM dbo.Produkte WHERE Id = 3), DEFAULT	),
(	4, 4, (SELECT preis FROM dbo.Produkte WHERE Id = 4), DEFAULT	),
(	5, 1, (SELECT preis FROM dbo.Produkte WHERE Id = 1), DEFAULT	),
(	5, 3, (SELECT preis FROM dbo.Produkte WHERE Id = 3), DEFAULT	),
(	5, 2, (SELECT preis FROM dbo.Produkte WHERE Id = 2), DEFAULT	),
(	5, 5, (SELECT preis FROM dbo.Produkte WHERE Id = 5), DEFAULT	),
(	1, 5, (SELECT preis FROM dbo.Produkte WHERE Id = 5), DEFAULT	);
GO

---------------------------

CREATE OR ALTER PROC usp_abrechnung AS 
INSERT INTO dbo.Konto
(	FK_Persohnen,
    FullName,
    Buchung,
    BuchungsAnzahl,
    SummePreis	)
SELECT v.FK_Persohnen,
	   min(p.Vname) + ' ' +
	   min(p.Nname) AS FullName,
	   'Eingang' AS Buchung,
       -- FK_Produkt,
	   COUNT(v.Id) AS BuchungsAnzahl,
       SUM(v.Preis) AS SummePreis
       -- v.DatumUhrzeit,
FROM dbo.Verzehr AS v INNER JOIN dbo.Persohnen AS p
ON v.FK_Persohnen = p.Id
GROUP BY v.FK_Persohnen

INSERT INTO dbo.Verzehr_History
(	Id,
    FK_Persohnen,
    FullName,
    FK_Produkt,
	Produkt,
    Preis,
    DatumUhrzeit
)
SELECT v.id,
       v.FK_Persohnen,
	   p.Vname + ' ' + p.Nname AS FullName,
       v.FK_Produkt,
	   prd.Produkt,
       v.Preis,
       v.DatumUhrzeit
FROM dbo.Verzehr AS v LEFT OUTER JOIN dbo.Persohnen AS p
ON v.FK_Persohnen = p.id LEFT OUTER JOIN dbo.Produkte AS prd
on v.FK_Produkt = prd.Id;

TRUNCATE TABLE dbo.Verzehr;
GO

-----------------------------------

select * FROM dbo.Persohnen;
SELECT * FROM dbo.Produkte;
SELECT * FROM dbo.Verzehr;
SELECT * FROM dbo.Konto;
SELECT * FROM dbo.Verzehr_History;

-----------------------------------

EXEC dbo.usp_abrechnung;

-----------------------------------

SELECT '------------------- Nach Abrechnung -------------------'

SELECT * FROM dbo.Verzehr;
SELECT * FROM dbo.Konto;
SELECT * FROM dbo.Verzehr_History;
GO

