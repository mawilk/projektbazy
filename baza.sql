

CREATE DATABASE Konferencje
GO
USE Konferencje
GO

CREATE TABLE Prog ( 
	ID_Progu INT PRIMARY KEY NOT NULL,
	ProcentCeny SMALLINT NOT NULL CHECK(ProcentCeny > 0),
	ProgCzasowy SMALLINT NOT NULL
)

CREATE TABLE ProgiCenowe (
	ID_Progu INT UNIQUE FOREIGN KEY REFERENCES Prog(ID_Progu) NOT NULL,
	ID_Konferencji INT UNIQUE FOREIGN KEY REFERENCES Konferencja(ID_Konferencji) NOT NULL,
	PRIMARY KEY(ID_Progu, ID_Konferencji)
)

CREATE TABLE ZnizkaStudencka (
	ProcentZnizki SMALLINT
)

INSERT INTO Prog (ID_Progu, ProcentCeny, ProgCzasowy) VALUES (1, 90, 3)
GO
INSERT INTO Prog (ID_Progu, ProcentCeny, ProgCzasowy) VALUES (2, 100, 2)
GO
INSERT INTO Prog (ID_Progu, ProcentCeny, ProgCzasowy) VALUES (3, 110, 1)
GO

CREATE TABLE StatusKonferencji (
	ID_StatusuKonferencji SMALLINT PRIMARY KEY NOT NULL,
	StatusKonferencji NVARCHAR(15) NOT NULL
)

INSERT INTO StatusKonferencji (ID_StatusuKonferencji,StatusKonferencji) VALUES (1, 'W trakcie')
GO
INSERT INTO StatusKonferencji (ID_StatusuKonferencji,StatusKonferencji) VALUES (2, 'Zamkniety')
GO
INSERT INTO StatusKonferencji (ID_StatusuKonferencji,StatusKonferencji) VALUES (3, 'Zakonczony')
GO
INSERT INTO StatusKonferencji (ID_StatusuKonferencji,StatusKonferencji) VALUES (4, 'Skompletowany')
GO

CREATE TABLE StatusRejestracji (
	ID_StatusuRejestracji SMALLINT PRIMARY KEY NOT NULL,
	StatusRejestracji NVARCHAR(15) NOT NULL
)

INSERT INTO StatusRejestracji (ID_StatusuRejestracji,StatusRejestracji) VALUES (1, 'W trakcie')
GO
INSERT INTO StatusRejestracji (ID_StatusuRejestracji,StatusRejestracji) VALUES (2, 'Zakonczona')
GO
INSERT INTO StatusRejestracji (ID_StatusuRejestracji,StatusRejestracji) VALUES (3, 'Anulowana')
GO

CREATE TABLE StatusPlatnosci (
	ID_StatusuPlatnosci SMALLINT PRIMARY KEY NOT NULL,
	StatusPlatnosci NVARCHAR(15) NOT NULL
)

INSERT INTO StatusPlatnosci (ID_StatusuPlatnosci,StatusPlatnosci) VALUES (1, 'Niezaplacone')
GO
INSERT INTO StatusPlatnosci (ID_StatusuPlatnosci,StatusPlatnosci) VALUES (2, 'Zaplacone')
GO
INSERT INTO StatusPlatnosci (ID_StatusuPlatnosci,StatusPlatnosci) VALUES (3, 'Zwrot')
GO
INSERT INTO StatusPlatnosci (ID_StatusuPlatnosci,StatusPlatnosci) VALUES (4, 'Anulowane')
GO

----------------------------------------------------------------------------------------

CREATE TABLE DaneAdresowe (
	ID_DanychAdresowych INT IDENTITY(1,1) PRIMARY KEY  NOT NULL ,
	Adres NVARCHAR(60) NOT NULL ,
	Miasto NVARCHAR(15) NOT NULL ,
	KodPocztowy NVARCHAR(10) NOT NULL ,
	Kraj NVARCHAR(15) NOT NULL ,
)

	
CREATE TABLE Klient (
	ID_Klienta INT IDENTITY(1,1) PRIMARY KEY  NOT NULL ,
	CzyFirma BIT NOT NULL DEFAULT 0,
)
	
CREATE TABLE Osoba (
	ID_Osoby INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	ID_Klienta INT FOREIGN KEY REFERENCES Klient(ID_Klienta) NULL,
	ID_DanychAdresowych INT FOREIGN KEY REFERENCES DaneAdresowe(ID_DanychAdresowych) NULL ,
	Imie NVARCHAR(20) NOT NULL ,
	Nazwisko NVARCHAR(20) NOT NULL ,
	NrAlbumu NVARCHAR(6) NULL,
	Telefon NVARCHAR(15) NULL,
	Email NVARCHAR(32) NULL

)
		
CREATE TABLE Firma (
	NIP INT PRIMARY KEY NOT NULL,
	ID_Klienta INT UNIQUE FOREIGN KEY REFERENCES Klient(ID_Klienta) NOT NULL,
	ID_DanychAdresowych INT UNIQUE FOREIGN KEY REFERENCES DaneAdresowe(ID_DanychAdresowych) NOT NULL,
	NazwaFirmy NVARCHAR(40) NOT NULL,
	Telefon NVARCHAR(15) NULL,
	Fax NVARCHAR(24) NULL,
	Email NVARCHAR(32) NULL
	
)

CREATE TABLE Pracownik (
	NIP INT UNIQUE FOREIGN KEY REFERENCES Firma(NIP) NOT NULL,
	ID_Osoby INT UNIQUE FOREIGN KEY REFERENCES Osoba(ID_Osoby) NOT NULL,
	PRIMARY KEY(ID_Osoby, NIP)
)

CREATE TABLE TematKonferencji (
	ID_TematuKonferencji INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	Opis TEXT NOT NULL
)

CREATE TABLE Konferencja (
	ID_Konferencji INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	ID_TematuKonferencji INT FOREIGN KEY REFERENCES TematKonferencji(ID_TematuKonferencji) NOT NULL,
	DataRozpoczecia DATE NOT NULL,
	DataZakonczenia DATE NOT NULL,
	Cena MONEY NOT NULL CHECK(Cena > 0),
	StatusKonferencji SMALLINT FOREIGN KEY REFERENCES StatusKonferencji(ID_StatusuKonferencji) NOT NULL,
)

CREATE TABLE DzienKonferencji (
	ID_DniaKonferencji INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	ID_Konferencji INT FOREIGN KEY REFERENCES Konferencja(ID_Konferencji) NOT NULL,
	DzienKonferencji DATE NOT NULL,
	LimitMiejscKonferencja SMALLINT NOT NULL CHECK(LimitMiejscKonferencja > 0)
)

CREATE TABLE TematWarsztatu (
	ID_TematuWarsztatu INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	Opis TEXT NOT NULL
)

CREATE TABLE Warsztat (
	ID_Warsztatu INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	ID_TematuWarsztatu INT FOREIGN KEY REFERENCES TematWarsztatu(ID_TematuWarsztatu) NOT NULL,
	ID_DniaKonferencji INT FOREIGN KEY REFERENCES DzienKonferencji(ID_DniaKonferencji) NOT NULL,
	Cena MONEY NOT NULL CHECK(Cena > 0),
	LimitMiejscWarsztat SMALLINT NOT NULL CHECK(LimitMiejscWarsztat > 0),
	GodzinaRozpoczecia TIME NOT NULL,
	GodzinaZakonczenia TIME NOT NULL
	
)

CREATE TABLE Zamowienie (
	ID_Zamowienia INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	ID_Klienta INT FOREIGN KEY REFERENCES Klient(ID_Klienta) NOT NULL,
	ID_Konferencji INT FOREIGN KEY REFERENCES Konferencja(ID_Konferencji) NOT NULL,
	DataZlozeniaZamowienia DATE NOT NULL,
	StatusRejestracji SMALLINT FOREIGN KEY REFERENCES StatusRejestracji(ID_StatusuRejestracji) NOT NULL,
	StatusRezerwacji BIT NOT NULL,
	DoZapltay MONEY NOT NULL DEFAULT 0,
	Zaplacono MONEY NOT NULL DEFAULT 0,
	TerminPlatnosci DATE NOT NULL,
	StatusPlatnosci SMALLINT FOREIGN KEY REFERENCES StatusPlatnosci(ID_StatusuPlatnosci) NOT NULL,
)

CREATE TABLE ZamowienieSzczegolowe (
	ID_ZamSzczegolowego INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	ID_Zamowienia INT FOREIGN KEY REFERENCES Zamowienie(ID_Zamowienia) NOT NULL,
	ID_DniaKonferencji INT FOREIGN KEY REFERENCES DzienKonferencji(ID_DniaKonferencji) NOT NULL,
	LiczbaMiejsc SMALLINT NOT NULL CHECK(LiczbaMiejsc > 0)
)

CREATE TABLE ZamowienieWarsztatu (
	ID_ZamowieniaWarsztatu INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	ID_ZamSzczegolowego INT FOREIGN KEY REFERENCES ZamowienieSzczegolowe(ID_ZamSzczegolowego) NOT NULL,
	ID_Warsztatu INT FOREIGN KEY REFERENCES Warsztat(ID_Warsztatu) NOT NULL,
	LiczbaMiejsc SMALLINT NOT NULL CHECK(LiczbaMiejsc > 0),
	StatusRezerwacji BIT NOT NULL
)

CREATE TABLE UczestnikKonferencji (
	ID_UczestnikaKonferencji INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
	ID_Osoby INT FOREIGN KEY REFERENCES Osoba(ID_Osoby) NOT NULL,
	ID_ZamSzczegolowego INT FOREIGN KEY REFERENCES ZamowienieSzczegolowe(ID_ZamSzczegolowego) NOT NULL,
)

CREATE TABLE UczestnikWarsztatu (
	ID_ZamowieniaWarsztatu INT FOREIGN KEY REFERENCES ZamowienieWarsztatu(ID_ZamowieniaWarsztatu) NOT NULL,
	ID_UczestnikaKonferencji INT FOREIGN KEY REFERENCES UczestnikKonferencji(ID_UczestnikaKonferencji) NOT NULL,
	PRIMARY KEY (ID_UczestnikaKonferencji, ID_ZamowieniaWarsztatu)

)
GO
----------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE nowy_adres
	@Adres NVARCHAR(45),
	@KodPocztowy NVARCHAR(10),
	@Miasto NVARCHAR(25) ,
	@Kraj NVARCHAR(25)
	
AS
BEGIN

	SET NOCOUNT ON;
		INSERT INTO DaneAdresowe 
		VALUES(@Adres,@Miasto,@KodPocztowy,@Kraj)
END
GO

CREATE PROCEDURE dodaj_klienta_osoba

	@Imie NVARCHAR(20),
	@Nazwisko NVARCHAR(20),
	@NrAlbumu NVARCHAR(6) = null,
	@Telefon NVARCHAR(25) = null,
	@Email NVARCHAR(45) = null,
	@Adres NVARCHAR(60),
	@Miasto NVARCHAR(15),
	@KodPocztowy NVARCHAR(10),
	@Kraj NVARCHAR(15)

AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ID_Osoby AS INT;
	DECLARE @ID_Klienta AS INT;
	DECLARE @ID_DanychAdresowych  AS INT;
	
	BEGIN TRY
		BEGIN TRAN 

		EXECUTE nowy_adres @Adres, @Miasto, @KodPocztowy, @Kraj;
		SET @ID_DanychAdresowych = @@IDENTITY;
		
		INSERT INTO Klient VALUES(0);
		SET @ID_Klienta = @@IDENTITY;
		
		INSERT INTO Osoba
		VALUES(@ID_Klienta,@ID_DanychAdresowych, @Imie, @Nazwisko, @NrAlbumu, @Telefon, @Email);
		COMMIT TRAN
	END TRY
	
	BEGIN CATCH
	
		DECLARE @error as varchar(127)
		SET @error = (Select ERROR_MESSAGE())
		RAISERROR('Nie mozna dodac klienta, blad danych. %s', 16, 1, @error);
		ROLLBACK TRAN
		
	END CATCH
END
GO


GO
CREATE PROCEDURE dodaj_osobe_jako_klienta
	@ID_Osoby INT
		
AS
BEGIN

	SET NOCOUNT ON;
		IF (SELECT Osoba.ID_Klienta FROM Osoba WHERE Osoba.ID_Osoby = @ID_Osoby) is null
		BEGIN
			INSERT INTO Klient(CzyFirma) VALUES (0)
			UPDATE Osoba
			SET ID_Klienta = @@IDENTITY
			WHERE Osoba.ID_Osoby = @ID_Osoby 
		END
		ELSE
		BEGIN
			RAISERROR('Ta osoba jest juz klientem. ', 16, 1);
		END
		
END
GO
GO
CREATE PROCEDURE dodaj_klienta_firma(
	-- parametry
	@NIP varchar(20),
	@NazwaFirmy nvarchar(45),
	@Telefon NVARCHAR(25) = NULL,
	@Fax NVARCHAR(24) = NULL,
	@Email NVARCHAR(45) = NULL,
	@Adres NVARCHAR(60),
	@Miasto NVARCHAR(15),
	@KodPocztowy NVARCHAR(10),
	@Kraj NVARCHAR(15)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ID_DanychAdresowych  AS INT;
	DECLARE @ID_Klienta AS INT;
	
	BEGIN TRY

		EXECUTE nowy_adres @Adres,@Miasto,@KodPocztowy,@Kraj;
		SET @ID_DanychAdresowych = @@IDENTITY;
		 
		INSERT INTO Klient(CzyFirma) VALUES(1);
		SET @ID_Klienta = @@IDENTITY;
		
		
		INSERT INTO Firma
		VALUES(@NIP,@ID_Klienta,@ID_DanychAdresowych, @NazwaFirmy,@Telefon,@Fax,@Email);
	
	END TRY
	
	BEGIN CATCH
	
		DECLARE @error AS VARCHAR(127)
		SET @error = (SELECT ERROR_MESSAGE() AS error_message)
		RAISERROR('Nie mozna dodac firmy, blad danych. %s', 16, 1,@error);
		
	END CATCH
	
END
GO

CREATE PROCEDURE dodaj_osobe (
	@Imie NVARCHAR(20),
	@Nazwisko NVARCHAR(20),
	@NrAlbumu NVARCHAR(6) = null,
	@Telefon NVARCHAR(25) = null,
	@Email NVARCHAR(45) = null,
	@Adres NVARCHAR(60),
	@Miasto NVARCHAR(15),
	@KodPocztowy NVARCHAR(10),
	@Kraj NVARCHAR(15))
AS
	SET NOCOUNT ON;
	DECLARE @ID_DanychAdresowych AS INT;
	BEGIN TRY
	
		SET NOCOUNT ON;
		BEGIN TRAN

		EXECUTE nowy_adres @Adres,@Miasto,@KodPocztowy,@Kraj;
		SET @ID_DanychAdresowych = @@IDENTITY;
		
		INSERT INTO Osoba
		VALUES(NULL,@ID_DanychAdresowych, @Imie, @Nazwisko, @NrAlbumu, @Telefon, @Email);
		COMMIT TRAN
		
	END TRY
	
	BEGIN CATCH
	
		DECLARE @error AS VARCHAR(127)
		SET @error = (Select ERROR_MESSAGE())
		RAISERROR('Nie mozna dodac osoby, blad danych. %s', 16, 1, @error);
		ROLLBACK TRAN
		
	END CATCH
END
GO
CREATE PROCEDURE dodaj_pracownika

	@NIP INT,
	@ID_Osoby INT
	
AS
BEGIN

	SET NOCOUNT ON;
		INSERT INTO Pracownik(NIP,ID_Osoby)
		VALUES(@ID_Osoby, @ID_ZamowieniaSzczegolowego);

END
GO


GO
CREATE PROCEDURE dodaj_konferencje
	-- parametry
	@ID_TematuKonferencji INT,
	@DataRozpoczecia DATE,
	@DataZakonczenia DATE,
	@CenaKonferencji MONEY,
	@StatusKonferencji VARCHAR(10)
	
AS
BEGIN

	SET NOCOUNT ON;
	begin try
		INSERT INTO Konferencja
		VALUES(@ID_TematuKonferencji, @DataRozpoczecia, @DataZakonczenia,@CenaKonferencji,@StatusKonferencji);
	end try
	begin catch
		declare @error as varchar(127)
		set @error = (Select ERROR_MESSAGE())
		RAISERROR('Nie mo�na dodac konferencji. %s', 16, 1, @error);
	end catch
END
GO
GO 
CREATE PROCEDURE dodaj_temat_konferencji

	@Opis TEXT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ID_TematuKonferencji AS INT
	BEGIN TRY
		INSERT INTO TematKonferencji(Opis) VALUES(@Opis)
		SET @ID_TematuKonferencji = @@IDENTITY
	END TRY
	BEGIN CATCH
	
		DECLARE @error AS VARCHAR(127)
		SET @error = (Select ERROR_MESSAGE())
		RAISERROR('Nie mozna dodac tematu, blad danych. %s', 16, 1, @error);
		
	END CATCH
END
GO
GO
CREATE PROCEDURE dodaj_warsztat
	-- parametry
	@ID_TematuWarsztatu INT,
	@ID_DniaKonferencji DATE,
	@CenaWarsztatu MONEY,
	@GodzRozpoczecia TIME,
	@GodzinaZakonczenia TIME
	
AS
BEGIN

	SET NOCOUNT ON;
	begin try
		INSERT INTO Warsztat
		VALUES(@ID_TematuWarsztatu, @ID_DniaKonferencji, @CenaWarsztatu, @GodzRozpoczecia, @GodzinaZakonczenia);
	end try
	begin catch
		declare @error as varchar(127)
		set @error = (Select ERROR_MESSAGE())
		RAISERROR('Nie mozna dodac warsztatu. %s', 16, 1, @error);
	end catch
END
GO
GO 
CREATE PROCEDURE dodaj_temat_warsztatu

	@Opis TEXT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		INSERT INTO TematWarsztatu(Opis) VALUES(@Opis)
	END TRY
	BEGIN CATCH
	
		DECLARE @error AS VARCHAR(127)
		SET @error = (Select ERROR_MESSAGE())
		RAISERROR('Nie mozna dodac tematu. %s', 16, 1, @error);
		
	END CATCH
END
GO
GO
CREATE PROCEDURE dodaj_dzien_konferencji
	-- parametry
	@ID_Konferencji INT,
	@DzienKonferencji DATE,
	@LimitMiejscKonferencja SMALLINT
	
AS
BEGIN

	SET NOCOUNT ON;
	begin try
		INSERT INTO DzienKonferencji
		VALUES(@ID_Konferencji, @DzienKonferencji, @LimitMiejscKonferencji);
	end try
	begin catch
		declare @error as varchar(127)
		set @error = (Select ERROR_MESSAGE())
		RAISERROR('Nie mo�na dodac dnia konferencji. %s', 16, 1, @error);
	end catch
END
GO
GO
CREATE PROCEDURE dodaj_zamowienie(
	-- parametry
	@ID_Klienta INT,
	@ID_Konferencji INT,
	@DataZlozeniaZamowienia DATE,
	@StatusRejestracji NVARCHAR(10),
	@StatusRezerwacji BIT,
	@DoZapltay MONEY,
	@Zaplacono MONEY,
	@TerminPlatnosci DATE,
	@StatusPlatnosci NVARCHAR(10)
AS
BEGIN

	SET NOCOUNT ON;
	
	BEGIN TRY

		INSERT INTO Zamowienie
		VALUES(@ID_Klienta, @ID_Konferencji, @DataZlozeniaZamowienia, @StatusRejestracji, @StatusRezerwacji, @DoZapltay, @Zaplacono, @TerminPlatnosci, @StatusPlatnosci)
	
	END TRY
	
	BEGIN CATCH
	
		DECLARE @error AS VARCHAR(127)
		SET @error = (SELECT ERROR_MESSAGE() AS error_message)
		RAISERROR('Nie mozna dodac firmy, blad danych. %s', 16, 1,@error);
		
	END CATCH
	
END
GO
CREATE PROCEDURE dodaj_zamowienie_szcz
	@ID_Zamowienia INT,
	@ID_DniaKonferencji INT,
	@LiczbaMiejscKonferencja SMALLINT
		
AS
BEGIN

	SET NOCOUNT ON;
		IF (SELECT Zamowienie.ID_Zamowienia FROM Zamowienie WHERE Zamowienie.ID_Zamowienia = @ID_Zamowienia) IS NOT NULL)
		BEGIN
			INSERT INTO ZamowienieSzczegolowe
			VALUES (@ID_Zamowienia, @ID_DniaKonferencji, @LiczbaMiejscKonferencja)

		END
		ELSE
		BEGIN
			RAISERROR('Nie ma takiego zamowienia. ', 16, 1);
		END
		
END
GO
GO
CREATE PROCEDURE dodaj_zamowienie_warsztatu
	@ID_ZamSzczegolowego INT,
	@ID_Warsztatu INT, 
	@LiczbaMiejscWarsztat SMALLINT, 
	@StatusRezerwacji BIT
		
AS
BEGIN

	SET NOCOUNT ON;
		IF (SELECT ZamowienieSzczegolowe.ID_ZamSzczegolowe FROM ZamowienieSzczegolowe WHERE Zamowienie.ID_ZamSzczegolowego = @ID_ZamSzczegolowego) IS NOT NULL)
		BEGIN
			INSERT INTO ZamowienieWarsztatu
			VALUES (@ID_ZamSzczegolowego, @ID_Warsztatu, @LiczbaMiejscWarsztat, @StatusRezerwacji)

		END
		ELSE
		BEGIN
			RAISERROR('Nie ma takiego zamowienia. ', 16, 1);
		END
		
END
GO
GO
CREATE PROCEDURE dodaj_uczestnika_konferencji

	@ID_Osoby INT,
	@ID_ZamowieniaSzczegolowego INT
	
AS
BEGIN

	SET NOCOUNT ON;
		INSERT INTO UczestnikKonferencji(ID_Osoby,ID_ZamSzczegolowego)
		VALUES(@ID_Osoby, @ID_ZamowieniaSzczegolowego);

END
GO
GO
CREATE PROCEDURE dodaj_uczestnika_warsztatu

	@ID_UczestnikaKonferencji INT,
	@ID_ZamowieniaWarsztatu INT
	
AS
BEGIN

	SET NOCOUNT ON;
		INSERT INTO UczestnikWarsztatu
		VALUES(@ID_UczestnikaKonferencji,@ID_ZamowieniaWarsztatu);
END
GO