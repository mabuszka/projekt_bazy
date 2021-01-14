ALTER TABLE klasy_ofert ADD CHECK (mnoznik > 0);

ALTER TABLE uczestnicy ADD CHECK (PESEL SIMILAR TO '[0-9]{11}');

ALTER TABLE uczestnicy ADD CHECK (kraj_zamieszkania IN ('Polska', 'Francja', 'Niemcy' ));

ALTER TABLE uczestnicy ADD CHECK (wiek >= 0 & wiek < 150);





