CREATE TABLE Uczestnicy(
				Uczestnik_id 		SERIAL,
				Imie 				VARCHAR(100),
				Nazwisko 			VARCHAR(100),
				Kraj_zamieszkania 	VARCHAR(100),
				Miasto 				VARCHAR(100),
				Kod_pocztowy 		VARCHAR(6),
				Ulica 				VARCHAR(100),
				Numer_domu 			VARCHAR(100),
				Data_urodzenia 		DATE,
				PESEL 				VARCHAR(11),
<<<<<<< Updated upstream
				Nr_telefonu 		VARCHAR(20)
);
=======
				nr_telefonu			VARCHAR(20))
>>>>>>> Stashed changes

CREATE TABLE Przewodnicy(
				Przewodnik_id 	 	SERIAL,
				Imie 	 			VARCHAR(100),
				Nazwisko 	  		VARCHAR(100),
				Adres_email 	 	VARCHAR(200),
				Nr_telefonu  		VARCHAR(20)
);

CREATE TABLE Wycieczki(
				Wycieczka_id 		SERIAL,
				Liczba_uczestnikow 	INTEGER,
				Data_rozpoczecia 	DATE,
				Data_zakonczenia 	DATE,
				Oferta_id 			INTEGER
);

CREATE TABLE Oferty(
				Oferta_id 		  	SERIAL,
				Miejsce_wyjazdu  	VARCHAR(100),
				Limit_uczestnikow  	INTEGER,
				Dlugosc_trwania  	INTEGER,
				Cena_podstawowa  	DECIMAL(10,2),
				Opis_oferty 	 	TEXT,
				Zdjecie	 		 	TEXT
);

CREATE TABLE Tagi(
				Tag_id 	 			SERIAL,
				Nazwa_tagu 	 		VARCHAR(100),
				Opis 		 		TEXT
);

CREATE TABLE Tagi_ofert(
				Tag_id 		 		INTEGER,
				Oferta_id 	 		INTEGER
);

CREATE TABLE Atrakcje(
				Atrakcja_id  		SERIAL,
				Nazwa_artakcji 		VARCHAR(250),
				Czy_dla_dzieci 		BOOLEAN,
				Opis_atrakcji   	TEXT
);

CREATE TABLE Atrakcje_w_ofercie(
				Oferta_id 			INTEGER,
				Atrakcja_id 		INTEGER
);

CREATE TABLE Przewodnictwa(
				Przewodnik_id 		INTEGER,
				Wycieczka_id 		INTEGER
);

CREATE TABLE Zamowienia(
				Zamowienie_id 		SERIAL,
				Klient_id 			INTEGER,
				Wycieczka_id 		INTEGER,
				Liczba_osob 		INTEGER,
				Wartosc_zamowienia 	DECIMAL(10,2),
				Klasa_oferty 		INTEGER,
				Sposob_platnosci 	VARCHAR(100)
);

CREATE TABLE Klasy_ofert(
				Klasa 				INTEGER,
				Mnoznik 			DECIMAL(10,2),
				Opis_slowny 		TEXT
);

CREATE TABLE Uczestnicy_w_zamowieniu(
				Uczestnik_id 		INTEGER,
				Zamowienie_id 		INTEGER
);