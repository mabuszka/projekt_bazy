--wiecej raise exceptiom?
--spr czy dobrze działa
CREATE FUNCTION zloz_zamowienie(klient INTEGER, wycieczka INTEGER, osoby INTEGER, klasa_zam INTEGER, platnosc VARCHAR(100)) RETURNS TEXT AS $$
DECLARE
	cena DECIMAL(10,2);
	oferta INTEGER;
BEGIN
	SELECT oferta_id INTO oferta FROM wycieczki WHERE wycieczka_id=wycieczka;
	SELECT cena_podstawowa INTO cena FROM oferty WHERE oferta_id=oferta;
	SELECT mnoznik*cena*osoby INTO cena FROM klasy_ofert WHERE klasa=klasa_zam;
	INSERT INTO zamowienia(klient_id,wycieczka_id,liczba_osob,wartosc_zamowienia,klasa_ofety,sposob_platnosci) 
		VALUES (klient,wycieczka,osoby,cena,klasa_zam,platnosc);
	RETURN 'Pomyslnie zlozono zamowienie.';
END;
$$ LANGUAGE 'plpgsql';


--spr czy dobrze działa
CREATE FUNCTION edytuj_zamowienie(id_zam INTEGER,osoby_nowe INTEGER,klasa_nowa INTEGER,platnosc_nowa VARCHAR(100)) RETURNS TEXT AS $$
DECLARE
	znajdz_zam INTEGER;
	cena DECIMAL(10,7);
	oferta INTEGER;
BEGIN
	SELECT count(zamowienie_id) INTO znajdz_zam FROM zamowienia WHERE zamowienie_id=id_zam;
	IF (znajdz_zam=0) THEN
		RAISE EXCEPTION 'Nie istnieje zamowienie o numerze '||id_zam;
	END IF;
	SELECT cena_podstawowa INTO cena FROM oferty WHERE oferta_id=oferta;
	SELECT mnoznik*cena*osoby INTO cena FROM klasy_ofert WHERE klasa=klasa_nowa;
	UPDATE zamowienia SET liczba_osob=osoby_nowe, klasa_ofety=klasa_nowa,sposob_platnosci=platnosc_nowa,wartosc_zamowienia=cena WHERE zamowienie_id=id_zam;
END;
$$ LANGUAGE 'plpgsql';


--spr czy dobrze działa
CREATE FUNCTION anuluj_zamowienie(id_zam INTEGER) RETURNS TEXT AS $$
DECLARE
	znajdz_zam INTEGER;
BEGIN
	SELECT count(zamowienie_id) INTO znajdz_zam FROM zamowienia WHERE zamowienie_id=id_zam;
	IF (znajdz_zam=0) THEN
		RAISE EXCEPTION 'Nie istnieje zamowienie o numerze '||id_zam;
	END IF;
	DELETE FROM zamowienia WHERE zamowienie_id=id_zam;
END;
$$ LANGUAGE 'plpgsql';


--usun przewodnika z wycieczki
CREATE FUNCTION usun_przewodnika(id_przewodnika INTEGER, id_wycieczki INTEGER) RETURNS TEXT AS $$
DECLARE
	znajdz_przew INTEGER;
BEGIN
	SELECT count(przewodnik_id) INTO znajdz_przew FROM przewodnictwa WHERE wycieczka_id=id_wycieczki AND przewodnik_id=id_przewodnika;
	IF (znajdz_przew=0) THEN
		RAISE EXCEPTION 'Przewodnik nie jest przypisany do tej wycieczki.';
	END IF;
	DELETE FROM przwodnictwa WHERE przewodnik_id=id_przewodnika;
	RETURN 'Pomyslnie usunieto przewodnika z wycieczki.';
END;
$$ LANGUAGE 'plpgsql';


--dodaj przewodnika do wycieczki
CREATE FUNCTION dodaj_przewodnika(id_przewodnika INTEGER, id_wycieczki INTEGER) RETURNS TEXT AS $$
BEGIN
	INSERT INTO przewodnictwa VALUES(id_przewodnika,id_wycieczki);
	RETURN 'Pomyslnie dodano przewodnika do wycieczki';
END;
$$ LANGUAGE 'plpgsql';


--dodaj klienta
CREATE FUNCTION dodaj_klienta(imie_nowe VARCHAR(100), nazwisko_nowe VARCHAR(100), kraj VARCHAR(100), miasto_nowe VARCHAR(100), ulica_nowa VARCHAR(100), dom VARCHAR(100), kod VARCHAR(6), pesel_nowy VARCHAR(100), telefon VARCHAR(20), urodzony DATE) RETURNS TEXT AS $$
DECLARE 
	klient INTEGER;
BEGIN
	SELECT wyszukaj_klienta(imie_nowe, nazwisko_nowe, kraj, miasto_nowe, ulica_nowa, dom , kod , pesel_nowy , telefon , urodzony) INTO klient;
	IF (klient IS NOT NULL) THEN
		RAISE EXCEPTION 'Klient istnieje juz w bazie';
	END IF;
	INSERT INTO uczestnicy(imie,nazwisko,kraj_zamieszkania,miasto,kod_pocztowy,ulica,numer_domu,data_urodzenia,pesel,nr_telefonu) 
		VALUES(imie_nowe,nazwisko_nowe,kraj,miasto_nowe,kod,ulica_nowa,dom,urodzony,pesel,telefon);
END;
$$ LANGUAGE 'plpgsql';


--znajdz klienta po danych 
CREATE FUNCTION wyszukaj_klienta(imie_nowe VARCHAR(100), nazwisko_nowe VARCHAR(100), kraj VARCHAR(100), miasto_nowe VARCHAR(100), ulica_nowa VARCHAR(100), dom VARCHAR(100), kod VARCHAR(6), pesel_nowy VARCHAR(100), telefon VARCHAR(20), urodzony DATE) RETURNS INTEGER AS $$
DECLARE
	klient INTEGER;
BEGIN
	SELECT uczestnik_id INTO klient FROM uczestnicy 
	WHERE (imie=imie_nowe AND nazwisko=nazwisko_nowe AND kraj_zamieszkania=kraj 
	AND miasto=miasto_nowe AND ulica=ulica_nowa AND numer_domu=dom AND kod_pocztowy=kod 
	AND pesel=pesel_nowy AND nr_telefonu=telefon AND data_urodzenia=urodzony);
	RETURN klient; --jak nic nie znajdzie to da nulla, co nie?
END;
$$ LANGUAGE 'plpgsql';




--template
CREATE FUNCTION f() RETURNS TEXT AS $$
BEGIN
END;
$$ LANGUAGE 'plpgsql';