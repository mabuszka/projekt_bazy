ALTER TABLE tagi_ofert ADD CONSTRAINT tagi_ofert_oferta FOREIGN KEY (oferta_id)
	REFERENCES oferty(oferta_id) ON DELETE RESTRICT ON UPDATE UPDATE;
	
ALTER TABLE tagi_ofert ADD CONSTRAINT tagi_ofert_tag FOREIGN KEY (tag_id)
	REFERENCES tagi(tag_id) ON DELETE RESTRICT ON UPDATE UPDATE;
	
ALTER TABLE przewodnictwa ADD CONSTRAINT przewodnictwa_przewodnik FOREIGN KEY (przewodnik_id)
	REFERENCES przewodnicy(przewodnik_id) ON DELETE RESTRICT ON UPDATE UPDATE;
	
ALTER TABLE przewodnictwa ADD CONSTRAINT przewodnictwa_wycieczka FOREIGN KEY (wycieczka_id)
	REFERENCES wycieczki(wycieczka_id) ON DELETE RESTRICT ON UPDATE UPDATE;
	
ALTER TABLE atrakcje_w_ofercie ADD CONSTRAINT atrakcje_w_ofercie_oferta FOREIGN KEY (oferta_id)
	REFERENCES oferty(oferta_id) ON DELETE RESTRICT ON UPDATE UPDATE;
	
ALTER TABLE atrakcje_w_ofercie ADD CONSTRAINT atrakcje_w_ofercie_atrakcja FOREIGN KEY (atrakcja_id)
	REFERENCES atrakcje(atrakcja_id) ON DELETE RESTRICT ON UPDATE UPDATE;
	

	
ALTER TABLE zamowienia ADD FOREIGN KEY (klient_id) 
	REFERENCES uczestnicy(uczestnik_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE zamowienia ADD FOREIGN KEY (wycieczka_id) 
	REFERENCES wycieczki(wycieczka_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE zamowienia ADD FOREIGN KEY (klasa_oferty) 
	REFERENCES klasy_ofert(klasa) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE wycieczki ADD FOREIGN KEY (oferta_id) REFERENCES oferty(oferta_id);

