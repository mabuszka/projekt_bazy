-- klasy_ofert
ALTER TABLE klasy_ofert ADD CHECK (mnoznik > 0);

-- uczestnicy uczestnik_id 		SERIAL,
				-- imie 				VARCHAR(100),
				-- nazwisko 			VARCHAR(100),
				-- kraj_zamieszkania 	VARCHAR(100),
				-- miasto 				VARCHAR(100),
				-- kod_pocztowy 		VARCHAR(6),
				-- ulica 				VARCHAR(100)
				-- numer_domu 			VARCHAR(100),
				-- data_urodzenia		DATE
				-- PESEL 				VARCHAR(11),
				-- nr_telefonu			VARCHAR(20))
ALTER TABLE uczestnicy ADD CHECK (PESEL SIMILAR TO '[0-9]{11}');

ALTER TABLE uczestnicy ADD CHECK (kraj_zamieszkania IN ('Polska', 'Francja', 'Niemcy' ));

ALTER TABLE uczestnicy ADD CHECK (data_urodzenia <= CURRENT_DATE);

ALTER TABLE uczestnicy COLUMN imie SET NOT NULL;

ALTER TABLE uczestnicy COLUMN nazwisko SET NOT NULL;

ALTER TABLE uczestnicy COLUMN kraj_zamieszkania SET NOT NULL;

ALTER TABLE uczestnicy COLUMN miasto SET NOT NULL;

ALTER TABLE uczestnicy COLUMN numer_domu SET NOT NULL;

ALTER TABLE uczestnicy COLUMN nr_telefonu SET NOT NULL;

-- zamowienia (zamowienie_id 		SERIAL,
				-- klient_id 			INTEGER,
				-- wycieczka_id 		INTEGER,
				-- liczba_osob 		INTEGER,
				-- wartosc_zamowienia 	DECIMAL(10,2),
				-- klasa_oferty 		INTEGER,
				-- sposob_platnosci 	VARCHAR(100))

ALTER TABLE zamowienia COLUMN liczba_osob SET NOT NULL;

ALTER TABLE zamowienia COLUMN wartosc_zamowienia SET NOT NULL;

ALTER TABLE zamowienia COLUMN klasa_oferty SET NOT NULL;

ALTER TABLE zamowienia COLUMN sposob_platnosci SET NOT NULL;

ALTER TABLE zamowienia COLUMN wycieczka_id SET NOT NULL;

ALTER TABLE zamowienia COLUMN klient_id SET NOT NULL;

ALTER TABLE zamowienia ADD CHECK (liczba_osob >= 0);


-- przewodnicy (przewodnik_id 		SERIAL
				-- imie 				VARCHAR(100),
				-- nazwisko 			VARCHAR(100),
				-- adres_email 		VARCHAR(200),
				-- nr_telefonu 		VARCHAR(20))

ALTER TABLE przewodnicy COLUMN imie SET NOT NULL;

ALTER TABLE przewodnicy COLUMN nazwisko SET NOT NULL;

ALTER TABLE przewodnicy COLUMN adres_email SET NOT NULL;

ALTER TABLE przewodnicy COLUMN nr_telefonu SET NOT NULL;

-- wycieczki (wycieczka_id 		SERIAL,
				-- liczba_uczestnikow 	INTEGER,
				-- data_rozpoczecia 	DATE,
				-- data_zakonczenia 	DATE,
				-- oferta_id 			INTEGER)

ALTER TABLE wycieczki COLUMN liczba_uczestnikow SET NOT NULL;

ALTER TABLE wycieczki COLUMN data_rozpoczecia SET NOT NULL;

ALTER TABLE wycieczki COLUMN data_zakonczenia SET NOT NULL;

ALTER TABLE wycieczki COLUMN oferta_id SET NOT NULL;

ALTER TABLE wycieczki ADD CHECK (data_zakonczenia >= data_rozpoczecia);

ALTER TABLE wycieczki ADD CHECK (liczba_uczestnikow >= 0);


-- oferty      	  (oferta_id 			SERIAL,
				-- miejsce_wyjazdu 		VARCHAR(100),
				-- limit_uczestnikow 	INTEGER,
				-- dlugosc_trwania 		INTEGER,
				-- cena_podstawowa 		DECIMAL(10,2),
				-- opis_oferty 			TEXT,
				-- zdjecie				TEXT)

ALTER TABLE oferty COLUMN miejsce_wyjazdu SET NOT NULL;

ALTER TABLE oferty COLUMN limit_uczestnikow SET NOT NULL;

ALTER TABLE oferty COLUMN dlugosc_trwania SET NOT NULL;

ALTER TABLE oferty COLUMN cena_podstawowa SET NOT NULL;

ALTER TABLE oferty COLUMN opis_oferty SET NOT NULL;

ALTER TABLE oferty ADD CHECK (dlugosc_trwania >= 0);

ALTER TABLE oferty ADD CHECK (limit_uczestnikow > 0);

ALTER TABLE oferty ADD CHECK (cena_podstawowa > 0);



