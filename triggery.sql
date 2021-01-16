--trigger który rzuca wyjątkiem jeśli chcemy złożyć/zmodyfikować zamówienie na wycieczkę 
--tak że przekroczylibyśmy maksa liczby osób

CREATE FUNCTION limit_osob() RETURNS TRIGGER AS $$
DECLARE
	ilosc_osob INTEGER;
	limit_osob INTEGER;
	oferta INTEGER;
BEGIN
	SELECT oferta_id INTO oferta FROM wycieczki WHERE wycieczka_id=NEW.wycieczka_d;
	SELECT limit_uczestnikow INTO limit_osob FROM oferty WHERE oferta_id=NEW.oferta_id;
	SELECT liczba_uczestnikow+NEW.osoby INTO ilosc_osob FROM wycieczki WHERE wycieczka_id=NEW.wycieczka_id;
	IF  (ilosc_osob<=limit_osob) THEN
		RAISE EXCEPTION 'Brak miejsc na wycieczce.';
	ELSE
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER sprawdz_limit_osob_insert BEFORE INSERT ON zamowienia 
	FOR EACH ROW EXECUTE PROCEDURE limit_osob();
CREATE TRIGGER sprawdz_limit_osob_update BEFORE UPDATE ON zamowienia 
	FOR EACH ROW EXECUTE PROCEDURE limit_osob();


--trigger który update'uje liczbe uczestnikow na wycieczce po dodaniu/usunięciu/edycji zamówienia

CREATE FUNCTION aktualizacja_liczby_uczestnikow() RETURNS TRIGGER AS $$
DECLARE
	stara_liczba INTEGER;
	nowa_liczba INTEGER;
	wycieczka INTEGER;
BEGIN
	SELECT OLD.liczba_osob INTO stara_liczba;
	SELECT NEW.liczba_osob INTO nowa_liczba;
	IF (stara_liczba=NULL) THEN
	stara_liczba := 0;
	wycieczka := NEW.wycieczka_id;
	ELSIF (nowa_liczba=NULL) THEN
	nowa_liczba := 0;
	wycieczka := OLD.wycieczka_id;
	END IF;
	UPDATE wycieczki SET liczba_uczestnikow=liczba_uczestnikow+nowa_liczba-stara_liczba WHERE wycieczka_id=wycieczka;
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER aktualizacja_liczby_uczestnikow_insert AFTER INSERT ON zamowienia
	FOR EACH ROW EXECUTE PROCEDURE aktualizacja_liczby_uczestnikow();
CREATE TRIGGER aktualizacja_liczby_uczestnikow_insert AFTER DELETE ON zamowienia
	FOR EACH ROW EXECUTE PROCEDURE aktualizacja_liczby_uczestnikow();
CREATE TRIGGER aktualizacja_liczby_uczestnikow_insert AFTER UPDATE ON zamowienia
	FOR EACH ROW EXECUTE PROCEDURE aktualizacja_liczby_uczestnikow();


--spr maila pracowniczego
CREATE FUNCTION sprawdz_maila() RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.adres_email LIKE '%_@biuro_bazy.com') THEN
		RETURN NEW;
	ELSE
		RAISE EXCEPTION 'E-mail w zlej domenie!';
	END IF;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER sprawdz_maila_insert BEFORE INSERT ON przewodnicy
	FOR EACH ROW EXECUTE PROCEDURE sprawdz_maila();
CREATE TRIGGER sprawdz_maila_insert BEFORE UPDATE ON przewodnicy
	FOR EACH ROW EXECUTE PROCEDURE sprawdz_maila();







--template
CREATE FUNCTION f() RETURNS TEXT AS $$
BEGIN
END;
$$ LANGUAGE 'plpgsql';
CREATE TRIGGER f_tr() _ ON _
	FOR EACH ROW EXECUTE PROCEDURE f();