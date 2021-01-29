--złóż zamówienie
DROP FUNCTION zloz_zamowienie;
CREATE FUNCTION zloz_zamowienie(klient INTEGER, wycieczka INTEGER, klasa_zam INTEGER, platnosc VARCHAR(100)) RETURNS TEXT AS $$
DECLARE
	oferta INTEGER;
	znajdz_wycieczka INTEGER;
	znajdz_klient INTEGER;
	znajdz_klasa INTEGER;
BEGIN
	SELECT wycieczka_id INTO znajdz_wycieczka FROM wycieczki WHERE wycieczka_id=wycieczka;
	SELECT uczestnik_id INTO znajdz_klient FROM uczestnicy WHERE uczestnik_id=klient;
	SELECT klasa INTO znajdz_klasa FROM klasy_ofert WHERE klasa=klasa_zam;
	IF (znajdz_wycieczka IS NULL) THEN
		RAISE EXCEPTION 'Nie istnieje wycieczka o takim numerze.';
	ELSIF (znajdz_klient IS NULL) THEN
		RAISE EXCEPTION 'Nie istnieje klient o takim numerze.';
	ELSIF (znajdz_klasa IS NULL) THEN
		RAISE EXCEPTION 'Niepoprawny numer klasy.';
	END IF;
	INSERT INTO zamowienia(klient_id,wycieczka_id,wartosc_zamowienia,klasa_oferty,sposob_platnosci) 
		VALUES (klient,wycieczka,0,klasa_zam,platnosc);
	RETURN 'Pomyslnie zlozono zamowienie.';
END;
$$ LANGUAGE 'plpgsql';


--POPRAWIONE DO SPR
--edycja zamowienia
DROP FUNCTION edytuj_zamowienie;
CREATE FUNCTION edytuj_zamowienie(id_zam INTEGER, klasa_nowa INTEGER, platnosc_nowa VARCHAR(100)) RETURNS TEXT AS $$
DECLARE
	znajdz_zam INTEGER;
	cena DECIMAL(10,2);
	oferta INTEGER;
	znajdz_klasa INTEGER;
	id_wyc INTEGER;
	osoby_nowe INTEGER;
BEGIN
	SELECT klasa INTO znajdz_klasa FROM klasy_ofert WHERE klasa=klasa_nowa;
	SELECT count(zamowienie_id) INTO znajdz_zam FROM zamowienia WHERE zamowienie_id=id_zam;
	IF (znajdz_klasa IS NULL) THEN
		RAISE EXCEPTION 'Niepoprawny numer klasy.';
	ELSIF (znajdz_zam=0) THEN
		RAISE EXCEPTION 'Nie istnieje zamowienie o tym numerze.';
	END IF;
	SELECT count(u.uczestnik_id) INTO osoby_nowe FROM uczestnicy_w_zamowieniu u WHERE u.zamowienie_id=id_zam;
	SELECT wycieczka_id INTO id_wyc FROM zamowienia WHERE zamowienie_id=id_zam;
	SELECT oferta_id INTO oferta FROM wycieczki WHERE wycieczka_id=id_wyc;
	SELECT cena_podstawowa INTO cena FROM oferty WHERE oferta_id=oferta;
	SELECT mnoznik*cena*osoby_nowe INTO cena FROM klasy_ofert WHERE klasa=klasa_nowa;
	UPDATE zamowienia SET klasa_oferty=klasa_nowa,sposob_platnosci=platnosc_nowa,wartosc_zamowienia=cena WHERE zamowienie_id=id_zam;
	RETURN 'Pomyslnie zmodyfikowano zamowienie';
END;
$$ LANGUAGE 'plpgsql';
SELECT edytuj_zamowienie(1,3,1,'przelew');


--POPRAWIONE DO SPR
--usun zamowienie
DROP FUNCTION anuluj_zamowienie;
CREATE FUNCTION anuluj_zamowienie(id_zam INTEGER) RETURNS TEXT AS $$
DECLARE
	znajdz_zam INTEGER;
BEGIN
	SELECT count(zamowienie_id) INTO znajdz_zam FROM zamowienia WHERE zamowienie_id=id_zam;
	IF (znajdz_zam=0) THEN
		RAISE EXCEPTION 'Nie istnieje zamowienie o takim numerze ';
	END IF;
	DELETE FROM zamowienia WHERE zamowienie_id=id_zam;
	DELETE FROM uczestnicy_w_zamowieniu WHERE zamowienie_id=id_zam;
	RETURN 'Pomyslnie anulowano zamowienie';
END;
$$ LANGUAGE 'plpgsql';


--usun przewodnika z wycieczki
CREATE FUNCTION usun_przewodnika(id_przewodnika INTEGER, id_wycieczki INTEGER) RETURNS TEXT AS $$
DECLARE
	znajdz_przew INTEGER;
	wycieczka INTEGER;
	przewodnik INTEGER;
BEGIN
	SELECT wycieczka_id INTO wycieczka FROM wycieczki WHERE wycieczka_id=id_wycieczki;
	SELECT przewodnik_id INTO przewodnik FROM przewodnicy WHERE przewodnik_id=id_przewodnika;
	IF (wycieczka IS NULL) THEN
		RAISE EXCEPTION 'Nie istnieje wycieczka o takim numerze.';
	ELSIF (przewodnik IS NULL) THEN
		RAISE EXCEPTION 'Nie istnieje przewodnik o takim numerze.';
	END IF;
	SELECT count(przewodnik_id) INTO znajdz_przew FROM przewodnictwa WHERE wycieczka_id=id_wycieczki AND przewodnik_id=id_przewodnika;
	IF (znajdz_przew=0) THEN
		RAISE EXCEPTION 'Przewodnik ten nie jest przypisany do tej wycieczki.';
	END IF;
	DELETE FROM przewodnictwa WHERE przewodnik_id=id_przewodnika;
	RETURN 'Pomyslnie usunieto przewodnika z wycieczki.';
END;
$$ LANGUAGE 'plpgsql';


--dodaj przewodnika do wycieczki
CREATE FUNCTION dodaj_przewodnika(id_przewodnika INTEGER, id_wycieczki INTEGER) RETURNS TEXT AS $$
DECLARE
	wycieczka INTEGER;
	aktywnosc BOOLEAN;
	przewodnik INTEGER;
BEGIN
	SELECT wycieczka_id INTO wycieczka FROM wycieczki WHERE wycieczka_id=id_wycieczki;
	SELECT przewodnik_id INTO przewodnik FROM przewodnicy WHERE przewodnik_id=id_przewodnika;
	SELECT aktywny INTO aktywnosc FROM przewodnicy WHERE przewodnik_id=id_przewodnika;
	IF (wycieczka IS NULL) THEN
		RAISE EXCEPTION 'Nie istnieje wycieczka o takim numerze.';
	ELSIF (przewodnik IS NULL) THEN
		RAISE EXCEPTION 'Nie istnieje przewodnik o takim numerze.';
	ELSIF (NOT aktywnosc) THEN
		RAISE EXCEPTION 'Przewodnik o tym numerze juz u nas nie pracuje.';
	END IF;
	INSERT INTO przewodnictwa VALUES(id_przewodnika,id_wycieczki);
	RETURN 'Pomyslnie dodano przewodnika do wycieczki';
END;
$$ LANGUAGE 'plpgsql';


--dodaj klienta do bazy
CREATE OR REPLACE FUNCTION dodaj_klienta(imie_nowe VARCHAR(100), nazwisko_nowe VARCHAR(100), kraj VARCHAR(100), miasto_nowe VARCHAR(100), ulica_nowa VARCHAR(100), dom VARCHAR(100), kod VARCHAR(6), telefon VARCHAR(20), urodzony DATE, pesel_nowy VARCHAR(11) DEFAULT NULL) RETURNS TEXT AS $$
DECLARE 
	klient INTEGER;
BEGIN
	SELECT wyszukaj_klienta(imie_nowe, nazwisko_nowe, kraj, miasto_nowe, ulica_nowa, dom , kod, telefon , urodzony, pesel_nowy) INTO klient;
	IF (klient IS NOT NULL) THEN
		RAISE EXCEPTION 'Klient istnieje juz w bazie';
	END IF;
	INSERT INTO uczestnicy(imie,nazwisko,kraj_zamieszkania,miasto,kod_pocztowy,ulica,numer_domu,data_urodzenia,pesel,nr_telefonu) 
		VALUES(imie_nowe,nazwisko_nowe,kraj,miasto_nowe,kod,ulica_nowa,dom,urodzony,pesel_nowy,telefon);
	RETURN 'Pomyslnie dodano klienta.';
END;
$$ LANGUAGE 'plpgsql';

SELECT edytuj_klienta(4,'Anna','Panna','Polska','Miasto','Ulica','dom','kod','telefon',current_date-1000);


--znajdz klienta po danych 
CREATE OR REPLACE FUNCTION wyszukaj_klienta(imie_nowe VARCHAR(100), nazwisko_nowe VARCHAR(100), kraj VARCHAR(100), miasto_nowe VARCHAR(100), ulica_nowa VARCHAR(100), dom VARCHAR(100), kod VARCHAR(6), telefon VARCHAR(20), urodzony DATE, pesel_nowy VARCHAR(11) DEFAULT NULL) RETURNS INTEGER AS $$
DECLARE
	klient INTEGER;
BEGIN
	IF (pesel_nowy IS NOT NULL) THEN
		SELECT uczestnik_id INTO klient FROM uczestnicy 
			WHERE (imie=imie_nowe AND nazwisko=nazwisko_nowe AND kraj_zamieszkania=kraj 
				AND miasto=miasto_nowe AND ulica=ulica_nowa AND numer_domu=dom AND kod_pocztowy=kod 
				AND pesel=pesel_nowy AND nr_telefonu=telefon AND data_urodzenia=urodzony);
	ELSE
		SELECT uczestnik_id INTO klient FROM uczestnicy 
			WHERE (imie=imie_nowe AND nazwisko=nazwisko_nowe AND kraj_zamieszkania=kraj 
				AND miasto=miasto_nowe AND ulica=ulica_nowa AND numer_domu=dom AND kod_pocztowy=kod 
				AND pesel IS NULL AND nr_telefonu=telefon AND data_urodzenia=urodzony);
	END IF;
	RETURN klient;
END;
$$ LANGUAGE 'plpgsql';


--modyfikuj uczestnika 
CREATE FUNCTION edytuj_klienta(id INTEGER, imie_nowe VARCHAR(100), nazwisko_nowe VARCHAR(100), kraj VARCHAR(100), miasto_nowe VARCHAR(100), ulica_nowa VARCHAR(100), dom VARCHAR(100), kod VARCHAR(6), telefon VARCHAR(20), urodzony DATE, pesel_nowy VARCHAR(100) DEFAULT NULL) RETURNS TEXT AS $$
BEGIN
	IF ((SELECT uczestnik_id FROM uczestnicy WHERE uczestnik_id=id) IS NULL) THEN
		RAISE EXCEPTION 'Nie istnieje taki klient.';
	END IF;
	UPDATE uczestnicy SET imie=imie_nowe,nazwisko=nazwisko_nowe,kraj_zamieszkania=kraj,miasto=miasto_nowe,kod_pocztowy=kod,ulica=ulica_nowa,numer_domu=dom,data_urodzenia=urodzony,pesel=pesel_nowy,nr_telefonu=telefon WHERE uczestnik_id=id;
	RETURN 'Pomyslnie zmodyfikowano dane o kliencie.';
END;
$$ LANGUAGE 'plpgsql';


--modyfikuj wycieczkę
CREATE FUNCTION modyfikuj_wycieczke(id INTEGER, poczatek DATE) RETURNS TEXT AS $$
DECLARE
	oferta INTEGER;
	trwanie INTEGER;
BEGIN
	IF (poczatek<current_date) THEN
		RAISE EXCEPTION 'Nie mozna ustawic przeszlej daty wyjazdu.';
	END IF;
	SELECT oferta_id INTO oferta FROM wycieczki WHERE wycieczka_id=id;
	SELECT dlugosc_wyjazdu INTO trwanie FROM oferty WHERE oferta_id=oferta;
	UPDATE wycieczki SET data_rozpoczecia=poczatek, data_zakonczenia=poczatek+trwanie WHERE wycieczka_id=id;
	RETURN 'Pomyslnie zmieniono date wycieczki';
END;
$$ LANGUAGE 'plpgsql';


--przedstaw cene
CREATE FUNCTION przedstaw_cene(wycieczka INTEGER, klasa_zam INTEGER, osoby INTEGER) RETURNS DECIMAL(10,2) AS $$
DECLARE
	oferta INTEGER;
	cena DECIMAL(10,2);
BEGIN
	SELECT oferta_id INTO oferta FROM wycieczki WHERE wycieczka_id=wycieczka;
	SELECT cena_podstawowa INTO cena FROM oferty WHERE oferta_id=oferta;
	SELECT mnoznik*cena INTO cena FROM klasy_ofert WHERE klasa=klasa_zam;
	RETURN cena*osoby;
END;
$$ LANGUAGE 'plpgsql';


--zatrudnij przewodnika
CREATE FUNCTION zatrudnij(imie_nowe VARCHAR(100), nazwisko_nowe VARCHAR(100), telefon VARCHAR(20), znam BOOLEAN DEFAULT FALSE) RETURNS TEXT AS $$
DECLARE
	znajdz INTEGER;
	aktywny_czy BOOLEAN;
BEGIN
	SELECT przewodnik_id INTO znajdz FROM przewodnicy WHERE imie=imie_nowe AND nazwisko=nazwisko_nowe AND nr_telefonu=telefon;
	SELECT aktywny INTO aktywny_czy FROM przewodnicy WHERE imie=imie_nowe AND nazwisko=nazwisko_nowe AND nr_telefonu=telefon;
	IF (znajdz IS NOT NULL AND NOT znam AND NOT aktywny_czy) THEN
		RAISE EXCEPTION 'Uwaga! Ten przewodnik kiedys u nas pracowal.';
	ELSIF (znajdz IS NOT NULL AND NOT znam) THEN
		RAISE EXCEPTION 'Ten przewodnik juz u nas pracuje.';
	ELSIF (znajdz IS NOT NULL AND znam) THEN
		UPDATE przewodnicy SET aktywny=TRUE WHERE przewodnik_id=znajdz;
	ELSE
		INSERT INTO przewodnicy(imie,nazwisko,adres_email,nr_telefonu,aktywny) 
			VALUES(imie_nowe,nazwisko_nowe,imie_nowe||nazwisko_nowe||'@biuro_bazy.com',telefon,TRUE);
	END IF;
	RETURN 'Pomyslnie zatrudniono przewodnika.';
END;
$$ LANGUAGE 'plpgsql';


--zwolnij przewodnika
CREATE FUNCTION zwolnij(id INTEGER) RETURNS TEXT AS $$
DECLARE
	znajdz INTEGER;
BEGIN
	SELECT przewodnik_id INTO znajdz FROM przewodnictwa JOIN wycieczki ON wycieczki.wycieczka_id=przewodnictwa.wycieczka_id WHERE data_zakonczenia>=current_date AND przewodnik_id=id;
	IF (znajdz IS NOT NULL) THEN	
		RAISE EXCEPTION 'Nie mozna zwolnic przewodnika jesli jest przypisany do przyszlej/trwajacej wycieczki.';
	ELSIF ((SELECT przewodnik_id FROM przewodnicy WHERE przewodnik_id=id) IS NULL) THEN
		RAISE EXCEPTION 'Pracownik o tym numerze nie istnieje.';
	END IF;
	UPDATE przewodnicy SET aktywny=FALSE WHERE przewodnik_id=id;
	RETURN 'Pomyslnie zwolniono przewodnika.';
END;
$$ LANGUAGE 'plpgsql';


--dodaj wycieczke
CREATE FUNCTION dodaj_wycieczke(oferta INTEGER, poczatek DATE) RETURNS TEXT AS $$
DECLARE
	trwanie INTEGER;
BEGIN
	SELECT dlugosc_wyjazdu INTO trwanie FROM oferty WHERE oferta_id=oferta;
	INSERT INTO wycieczki(oferta_id,data_rozpoczecia,data_zakonczenia,liczba_uczestnikow) VALUES(oferta,poczatek,poczatek+trwanie,0);
	RETURN 'Pomyslnie utworzono nowa wycieczke.';
END;
$$ LANGUAGE 'plpgsql';


-- sprawdz zblizajace sie wycieczki
CREATE FUNCTION zblizajace_sie_wycieczki(dni INTEGER) 
RETURNS TABLE ( wycieczka_id 		INTEGER,
				miejsce_wyjazdu  	VARCHAR(100),
				liczba_uczestnikow 	INTEGER,
				limit_uczestnikow  	INTEGER,
				data_rozpoczecia 	DATE,
				data_zakonczenia 	DATE,
				dlugosc_wyjazdu  	INTEGER,
				cena_podstawowa  	DECIMAL(10,2)
) AS $$
BEGIN
	RETURN QUERY
	SELECT w.wycieczka_id,
			o.miejsce_wyjazdu,
			w.liczba_uczestnikow,
			o.limit_uczestnikow,
			w.data_rozpoczecia ,
			w.data_zakonczenia,
			o.dlugosc_wyjazdu,
			o.cena_podstawowa
	FROM oferty o
		JOIN wycieczki w
			ON (w.oferta_id = o.oferta_id)
	WHERE w.data_rozpoczecia < CURRENT_DATE + dni;
END;
$$ LANGUAGE 'plpgsql';


--szukanie ofert z atrakcjami (wersja 'lub')
CREATE OR REPLACE FUNCTION oferty_z_atrakcjami(VARIADIC szukane_atrakcje TEXT[]) 
RETURNS TABLE(
oferta_id 			INTEGER,
				miejsce_wyjazdu  	VARCHAR,
				limit_uczestnikow  	INTEGER,
				dlugosc_wyjazdu  	INTEGER,
				cena_podstawowa  	DECIMAL,
				atrakcje			 TEXT[]
) AS $$
BEGIN
	RETURN QUERY
SELECT 	o.oferta_id,
			o.miejsce_wyjazdu,
			o.limit_uczestnikow,
			o.dlugosc_wyjazdu,
			o.cena_podstawowa,
			array_agg(a.atrakcja)::TEXT[]	
	FROM oferty o 
		JOIN atrakcje_w_ofercie ao
			ON (ao.oferta_id = o.oferta_id)
		JOIN atrakcje a
			ON (a.atrakcja = ao.atrakcja)
	WHERE o.oferta_id IN (SELECT 	o.oferta_id
						FROM oferty o 
							JOIN atrakcje_w_ofercie ao
								ON (ao.oferta_id = o.oferta_id)
							JOIN atrakcje a
								ON (a.atrakcja = ao.atrakcja)
						WHERE a.atrakcja LIKE ANY(szukane_atrakcje))
	GROUP BY (o.oferta_id, o.miejsce_wyjazdu, o.limit_uczestnikow, o.dlugosc_wyjazdu, o.cena_podstawowa);
END;
$$ LANGUAGE 'plpgsql';

-- szukanie ofert z atrakcjami (wersja 'wszystkie') 
CREATE OR REPLACE FUNCTION oferty_ze_wszystkimi_atrakcjami(VARIADIC szukane_atrakcje TEXT[]) 
RETURNS TABLE(
oferta_id 			INTEGER,
				miejsce_wyjazdu  	VARCHAR,
				limit_uczestnikow  	INTEGER,
				dlugosc_wyjazdu  	INTEGER,
				cena_podstawowa  	DECIMAL,
				atrakcje			 TEXT[]
) AS $$
BEGIN
	RETURN QUERY
	
	
SELECT 	o.oferta_id,
			o.miejsce_wyjazdu,
			o.limit_uczestnikow,
			o.dlugosc_wyjazdu,
			o.cena_podstawowa,
			array_agg(a.atrakcja)::TEXT[]	
	FROM oferty o 
		JOIN atrakcje_w_ofercie ao
			ON (ao.oferta_id = o.oferta_id)
		JOIN atrakcje a
			ON (a.atrakcja = ao.atrakcja)
	GROUP BY (o.oferta_id, o.miejsce_wyjazdu, o.limit_uczestnikow, o.dlugosc_wyjazdu, o.cena_podstawowa)
	HAVING array_agg(a.atrakcja)::TEXT[] @> szukane_atrakcje;
END;
$$ LANGUAGE 'plpgsql';


--szukanie ofert z tagami (wersja 'lub')
CREATE OR REPLACE FUNCTION oferty_z_tagami(VARIADIC szukane_tagi TEXT[]) 
RETURNS TABLE(
oferta_id 			INTEGER,
				miejsce_wyjazdu  	VARCHAR,
				limit_uczestnikow  	INTEGER,
				dlugosc_wyjazdu  	INTEGER,
				cena_podstawowa  	DECIMAL,
				atrakcje			 TEXT[]
) AS $$
BEGIN
	RETURN QUERY
SELECT 	o.oferta_id,
			o.miejsce_wyjazdu,
			o.dlugosc_wyjazdu,
			o.limit_uczestnikow,
			o.cena_podstawowa,
	FROM oferty o 
			array_agg(t.tag)::TEXT[]	
			ON (t_o.oferta_id = o.oferta_id)
		JOIN tagi_ofert t_o
		JOIN tagi t
			ON (t.tag = t_o.tag)
	WHERE o.oferta_id IN (SELECT 	o.oferta_id
						FROM oferty o 
							JOIN tagi_ofert t_o
								ON (t_o.oferta_id = o.oferta_id)
							JOIN tagi t
								ON (t.tag = t_o.tag)
						WHERE t.tag LIKE ANY(szukane_tagi))
	GROUP BY (o.oferta_id, o.miejsce_wyjazdu, o.limit_uczestnikow, o.dlugosc_wyjazdu, o.cena_podstawowa);



END;
-- szukanie ofert z tagami (wersja 'wszystkie')

CREATE OR REPLACE FUNCTION oferty_ze_wszystkimi_tagami(VARIADIC szukane_tagi TEXT[]) 
RETURNS TABLE(
oferta_id 			INTEGER,
				miejsce_wyjazdu  	VARCHAR,
				limit_uczestnikow  	INTEGER,
				dlugosc_wyjazdu  	INTEGER,
				cena_podstawowa  	DECIMAL,
				tagi			 TEXT[]
) AS $$
BEGIN
	RETURN QUERY
	
	
SELECT 	o.oferta_id,
			o.miejsce_wyjazdu,
			o.limit_uczestnikow,
			o.dlugosc_wyjazdu,
			o.cena_podstawowa,
			array_agg(t.tag)::TEXT[]	
	FROM oferty o 
		JOIN tagi_ofert t_o
			ON (t_o.oferta_id = o.oferta_id)
		JOIN tagi t
			ON (t.tag = t_o.tag)
	GROUP BY (o.oferta_id, o.miejsce_wyjazdu, o.limit_uczestnikow, o.dlugosc_wyjazdu, o.cena_podstawowa)
	HAVING array_agg(t.tag)::TEXT[] @> szukane_tagi;
END;
$$ LANGUAGE 'plpgsql';