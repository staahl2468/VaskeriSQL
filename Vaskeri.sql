USE Master
GO
IF DB_ID('BBB') IS NOT NULL
	BEGIN
		ALTER DATABASE BBB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE BBB
	END
GO
CREATE DATABASE BBB
GO
USE BBB
GO

CREATE TABLE Vaskerier(
Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Navn NVARCHAR(30) NOT NULL,
Åbner TIME NOT NULL,
Lukker TIME NOT NULL
)

CREATE TABLE Brugere(
Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Navn NVARCHAR(30) NOT NULL,
Email NVARCHAR(50) NOT NULL,
Pass NVARCHAR(30) NOT NULL,
Konto DECIMAL NOT NULL,
VaskeriId int NOT NULL,
Oprettet DATETIME NOT NULL,
CONSTRAINT BrugerMailUnique UNIQUE (Navn, Email),
CONSTRAINT PassMinLength CHECK (LEN(Pass) > 4),
CONSTRAINT FK_VaskeriIdB FOREIGN KEY (VaskeriId) REFERENCES Vaskerier(Id)
)

CREATE TABLE Maskiner(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Navn NVARCHAR(30) NOT NULL,
Pris DECIMAL NOT NULL,
Vasketid INT NOT NULL,
VaskeriId INT NOT NULL,
CONSTRAINT FK_VaskeriIdM FOREIGN KEY (VaskeriId) REFERENCES Vaskerier(Id)
)

CREATE TABLE Bookinger(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Tidspunkt DATETIME NOT NULL,
BrugerId INT NOT NULL,
MaskineId INT NOT NULL,
CONSTRAINT FK_BrugerId FOREIGN KEY (BrugerId) REFERENCES Brugere(Id),
CONSTRAINT FK_MaskineId FOREIGN KEY (MaskineId) REFERENCES Maskiner(Id),
)


INSERT INTO Vaskerier (Navn, Åbner, Lukker)
VALUES ('Whitewash Inc', '08:00', '20:00')
INSERT INTO Vaskerier (Navn, Åbner, Lukker)
VALUES ('Double Bubble', '02:00', '22:00')
INSERT INTO Vaskerier (Navn, Åbner, Lukker)
VALUES ('Wash & Coffee', '12:00', '20:00')

INSERT INTO Brugere (Navn, Email, Pass, Konto, VaskeriId, Oprettet) 
VALUES ('John', 'john_doe66@gmail.com', 'password', 100.00, 2, 2021-02-15)
INSERT INTO Brugere (Navn, Email, Pass, Konto, VaskeriId, Oprettet) 
VALUES ('Neil Armstrong', 'firstman@nasa.gov', 'eagleLander69', 1000.00, 1, 2021-02-10)
INSERT INTO Brugere (Navn, Email, Pass, Konto, VaskeriId, Oprettet) 
VALUES ('Batman', 'noreply@thecave.com', 'Rob1b', 500.00, 3, 2020-03-10)
INSERT INTO Brugere (Navn, Email, Pass, Konto, VaskeriId, Oprettet) 
VALUES ('Goldman Sachs', 'moneylaundering@gs.com', 'NotRecognized', 100000.00, 1, 2021-01-01)
INSERT INTO Brugere (Navn, Email, Pass, Konto, VaskeriId, Oprettet) 
VALUES ('50 Cent', '50cent@gmail.com', 'ItsMyBirthday', 0.50, 3, 2020-07-06)

INSERT INTO Maskiner (Navn, Pris, Vasketid, VaskeriId)
VALUES ('Mielle 911 Turbo', 5.00, 60, 2)
INSERT INTO Maskiner (Navn, Pris, Vasketid, VaskeriId)
VALUES ('Siemons IClean', 10000.00, 30, 1)
INSERT INTO Maskiner (Navn, Pris, Vasketid, VaskeriId)
VALUES ('Electrolax FX-2', 15.00, 45, 2)
INSERT INTO Maskiner (Navn, Pris, Vasketid, VaskeriId)
VALUES ('NASA Spacewasher 8000', 500.00, 5, 1)
INSERT INTO Maskiner (Navn, Pris, Vasketid, VaskeriId)
VALUES ('The Lost Sock', 3.50, 90, 3)
INSERT INTO Maskiner (Navn, Pris, Vasketid, VaskeriId)
VALUES ('Yo Mama', 0.50, 120, 3)

INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2021-02-26 12:00:00', 1, 1)
INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2021-02-26 16:00:00', 1, 3)
INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2021-02-26 08:00:00', 2, 4)
INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2021-02-26 15:00:00', 3, 5)
INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2021-02-26 20:00:00', 4, 2)
INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2021-02-26 19:00:00', 4, 2)
INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2021-02-26 10:00:00', 4, 2)
INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2021-02-26 16:00:00', 5, 6)


BEGIN TRANSACTION SachsTran
INSERT INTO Bookinger (Tidspunkt, BrugerId, MaskineId)
VALUES ('2022-09-15 12:00:00', 4, 2)
GO

CREATE VIEW BookingView AS
	SELECT Tidspunkt as Tidspunkt, Brugere.Navn as BrugerNavn, Maskiner.Navn as MaskineNavn, Maskiner.Pris as Pris 
	FROM Bookinger
	JOIN Brugere on Bookinger.BrugerId = Brugere.Id
	JOIN Maskiner on Bookinger.MaskineId = Maskiner.Id
GO
SELECT * FROM BookingView
GO


SELECT * FROM Brugere WHERE Email LIKE '%@gmail.com%'
GO


CREATE VIEW MaskineView AS
	SELECT Maskiner.Navn AS MaskineNavn, Vaskerier.Navn AS VaskeriNavn, Vaskerier.Åbner AS Åbningstid, Vaskerier.Lukker AS Lukketid
	FROM Maskiner
	JOIN Vaskerier on Maskiner.VaskeriId = Vaskerier.Id
GO
SELECT * FROM MaskineView
GO


SELECT Navn, COUNT(Bookinger.MaskineId) AS Antal FROM Maskiner, Bookinger WHERE Bookinger.MaskineId = Maskiner.Id GROUP BY Navn
GO

DELETE FROM Bookinger WHERE CAST(Tidspunkt AS TIME) BETWEEN '12:00' AND '13:00'
GO

SELECT * FROM Bookinger
GO

UPDATE Brugere
SET Pass = 'SelinaKyle'
WHERE Navn = 'Batman'
GO

SELECT * FROM Brugere
GO