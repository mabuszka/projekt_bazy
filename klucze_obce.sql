ALTER TABLE tagi_ofert ADD CONSTRAINT tagi_ofert_oferta FOREIGN KEY (oferta_id)
	REFERENCES oferty(oferta_id) ON DELETE CASCADE ON UPDATE UPDATE;
	
ALTER TABLE tagi_ofert ADD CONSTRAINT tagi_ofert_tag FOREIGN KEY (tag_id)
	REFERENCES tagi(tag_id) ON DELETE CASCADE ON UPDATE UPDATE;
	
