-- ile razy pojechali na wyjazd
CREATE VIEW  ile_razy_pojechal AS
SELECT u.uczestnik_id, COUNT(u.uczestnik_id) AS ile_razy
FROM uczestnicy u
		JOIN uczestnicy_w_zamowieniu z
			ON (u.uczestnik_id = z.uczestnik_id)
GROUP BY u.uczestnik_id;

-- dane do spr widoku z jeżdżeniem (Działa! :D)
-- INSERT INTO uczestnicy(imie, nazwisko, kraj_zamieszkania) VALUES ('Adam','Nowak','Polska');
-- INSERT INTO uczestnicy(imie, nazwisko, kraj_zamieszkania) VALUES ('Borys','Nowak','Polska');
-- INSERT INTO uczestnicy(imie, nazwisko, kraj_zamieszkania) VALUES ('Hans','Nowak','Niemcy');
-- INSERT INTO uczestnicy(imie, nazwisko, kraj_zamieszkania) VALUES ('Stef','Nowak','Niemcy');
-- INSERT INTO uczestnicy(imie, nazwisko, kraj_zamieszkania) VALUES ('Pierr','Nowak','Francja');
-- INSERT INTO uczestnicy(imie, nazwisko, kraj_zamieszkania) VALUES ('Jaux','Nowak','Francja');

-- INSERT INTO uczestnicy_w_zamowieniu(uczestnik_id, zamowienie_id) VALUES(1,1);
-- INSERT INTO uczestnicy_w_zamowieniu(uczestnik_id, zamowienie_id) VALUES(1,2);
-- INSERT INTO uczestnicy_w_zamowieniu(uczestnik_id, zamowienie_id) VALUES(2,1);
-- INSERT INTO uczestnicy_w_zamowieniu(uczestnik_id, zamowienie_id) VALUES(3,1);
-- INSERT INTO uczestnicy_w_zamowieniu(uczestnik_id, zamowienie_id) VALUES(3,2);
-- INSERT INTO uczestnicy_w_zamowieniu(uczestnik_id, zamowienie_id) VALUES(4,1);
-- INSERT INTO uczestnicy_w_zamowieniu(uczestnik_id, zamowienie_id) VALUES(5,1);
-- INSERT INTO uczestnicy_w_zamowieniu(uczestnik_id, zamowienie_id) VALUES(5,2);


-- uczestnicy jezdzączy cześciej niż średnia w ich kraju
CREATE VIEW czesciej_niz_standard AS
SELECT u.uczestnik_id, u.imie, u.nazwisko, u.kraj_zamieszkania, i.ile_razy
FROM uczestnicy u 
	JOIN ile_razy_pojechal i ON (i.uczestnik_id = u.uczestnik_id)
WHERE (CASE 
			WHEN u.kraj_zamieszkania LIKE 'Polska'
				THEN
					(i.ile_razy >= (SELECT AVG(i.ile_razy)
									FROM ile_razy_pojechal i
										JOIN  uczestnicy u 
											ON (i.uczestnik_id = u.uczestnik_id)
									WHERE u.kraj_zamieszkania LIKE 'Polska'
									)						
					)	
		WHEN u.kraj_zamieszkania LIKE 'Niemcy' 
			THEN
				(i.ile_razy >= (SELECT AVG(i.ile_razy)
								FROM ile_razy_pojechal i
									JOIN  uczestnicy u 
										ON (i.uczestnik_id = u.uczestnik_id)
								WHERE u.kraj_zamieszkania LIKE 'Niemcy'
								)
																	
				)
		WHEN u.kraj_zamieszkania LIKE 'Francja' 
			THEN
				(i.ile_razy >= (SELECT AVG(i.ile_razy)
								FROM ile_razy_pojechal i
								JOIN  uczestnicy u 
									ON (i.uczestnik_id = u.uczestnik_id)
								WHERE u.kraj_zamieszkania LIKE 'Francja'
								)
				)
		END 
		);
									
			

CREATE VIEW stali_klienci AS
SELECT z.klient_id, MAX(u.imie) AS imie, MAX(u.nazwisko) AS nazwisko 
FROM uczestnicy u 
	JOIN zamowienia z 
			ON (z.klient_id = u.uczestnik_id)
GROUP BY z.klient_id
HAVING COUNT(*) > 5;

-- dane do testu widoku stali klienci
-- INSERT INTO zamowienia(zamowienie_id, klient_id) VALUES (1,1);
-- INSERT INTO zamowienia(zamowienie_id, klient_id) VALUES (2,1);
-- INSERT INTO zamowienia(zamowienie_id, klient_id) VALUES (3,1);
-- INSERT INTO zamowienia(zamowienie_id, klient_id) VALUES (4,1);
-- INSERT INTO zamowienia(zamowienie_id, klient_id) VALUES (5,2);
-- INSERT INTO zamowienia(zamowienie_id, klient_id) VALUES (6,2);

-- 10 najczęstszych miejsc docelowych wycieczek

CREATE VIEW najczestesze_cele AS
SELECT o.miejsce_wyjazdu, COUNT(o.miejsce_wyjazdu) AS ile_wycieczek
FROM oferty o
	JOIN wycieczki w 
		ON (o.oferta_id = w.oferta_id)
GROUP BY o.miejsce_wyjazdu
ORDER BY COUNT(*) DESC
LIMIT 10;

-- dane do testu
-- INSERT INTO oferty(miejsce_wyjazdu) VALUES ('a');
-- INSERT INTO oferty(miejsce_wyjazdu) VALUES ('b');
-- INSERT INTO oferty(miejsce_wyjazdu) VALUES ('c');
INSERT INTO wycieczki(oferta_id, liczba_uczestnikow) VALUES (1,2);
INSERT INTO wycieczki(oferta_id,liczba_uczestnikow) VALUES (1,2);
INSERT INTO wycieczki(oferta_id,liczba_uczestnikow) VALUES (1,2);
INSERT INTO wycieczki(oferta_id,liczba_uczestnikow) VALUES (1,2);
INSERT INTO wycieczki(oferta_id,liczba_uczestnikow) VALUES (1,2);
-- INSERT INTO wycieczki(oferta_id) VALUES (1);
-- INSERT INTO wycieczki(oferta_id) VALUES (1);
-- INSERT INTO wycieczki(oferta_id) VALUES (2);
-- INSERT INTO wycieczki(oferta_id) VALUES (2);
-- INSERT INTO wycieczki(oferta_id) VALUES (2);
-- INSERT INTO wycieczki(oferta_id) VALUES (3);
-- INSERT INTO wycieczki(oferta_id) VALUES (3);

-- 5 najbardziej popularnych ofert 

CREATE VIEW najwiecej_odwiedzane_cele AS
SELECT o.miejsce_wyjazdu, SUM(w.liczba_uczestnikow) AS ile_osob_odwiedzilo
FROM oferty o
	JOIN wycieczki w 
		ON (o.oferta_id = w.oferta_id)
GROUP BY o.miejsce_wyjazdu
ORDER BY SUM(w.liczba_uczestnikow) DESC
LIMIT 5;










-- 10 przewodnikow z największą liczbą poprowadzonych wycieczek

CREATE VIEW najbardziej_doswiadczeni_przewodnicy AS
SELECT p.przewodnik_id, p.imie, p.nazwisko, COUNT(p.przewodnik_id) AS ile_wycieczek
FROM przewodnicy p
	JOIN wycieczki w
		ON (p.przewodnik_id = w.przewodnik_id)
GROUP BY (p.przewodnik_id, p.imie, p.nazwisko)
ORDER BY COUNT(przewodnik_id) DESC
LIMIT 10;

-- dane do sprawdzenia 
-- INSERT INTO przewodnicy(imie) VALUES ('Adam')
