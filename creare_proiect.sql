--Crearea unei secvente ce va fi utilizata în inserarea înregistrarilor în tabele (punctul 11).
CREATE SEQUENCE FARURI_SEQ START WITH 1;
CREATE SEQUENCE UTILIZATORI_SEQ START WITH 1;
CREATE SEQUENCE MOTOCICLETE_SEQ START WITH 1;
CREATE SEQUENCE MOTOARE_SEQ START WITH 1;
CREATE SEQUENCE PLATI_SEQ START WITH 1;
CREATE SEQUENCE INTRETINERI_SEQ START WITH 1;
CREATE SEQUENCE ACHIZITII_SEQ START WITH 1;
CREATE SEQUENCE FRANE_SEQ START WITH 1;
CREATE SEQUENCE ACCESORII_SEQ START WITH 1;
CREATE SEQUENCE CATEGORII_SEQ START WITH 1;

--Creare tabele

CREATE TABLE FARURI(
  id_far INT DEFAULT FARURI_SEQ.NEXTVAL PRIMARY KEY,
  tip_far VARCHAR(30),
  model VARCHAR(30),
  diametru INT
);
CREATE TABLE UTILIZATORI (
  id_utilizator INT DEFAULT UTILIZATORI_SEQ.NEXTVAL PRIMARY KEY,
  nume VARCHAR(255),
  prenume VARCHAR(255),
  email VARCHAR(255),
  varsta INT,
  data_nasterii DATE
);

CREATE TABLE FRANE (
    id_frana INT DEFAULT FRANE_SEQ.NEXTVAL PRIMARY KEY,
    tip_frana VARCHAR(255),
    pozitie VARCHAR(255)
);

CREATE TABLE ACCESORII (
    id_accesoriu INT DEFAULT ACCESORII_SEQ.NEXTVAL PRIMARY KEY,
    nume VARCHAR(255)
);

CREATE TABLE CATEGORII (
    id_categorie INT DEFAULT CATEGORII_SEQ.NEXTVAL PRIMARY KEY,
    nume VARCHAR(255),
    descriere VARCHAR(255)
);

CREATE TABLE MOTOARE (
  id_motor INT DEFAULT MOTOARE_SEQ.NEXTVAL PRIMARY KEY,
  putere INT,
  consum_combustibil DECIMAL(10, 2),
  nr_timpi INT,
  carburant VARCHAR(255),
  CONSTRAINT nr_timpi_check CHECK (nr_timpi IN (2,4))
);

CREATE TABLE PLATI (
  id_plata INT DEFAULT PLATI_SEQ.NEXTVAL PRIMARY KEY,
  id_utilizator INT,
  cost DECIMAL(10, 2),
  data DATE,
  modalitate_plata VARCHAR(100),
  CONSTRAINT modalitate_plata_check CHECK (modalitate_plata IN ('cash', 'card')),
  FOREIGN KEY (id_utilizator) REFERENCES UTILIZATORI(id_utilizator)
);

CREATE TABLE MOTOCICLETE (
  id_motocicleta INT DEFAULT MOTOCICLETE_SEQ.NEXTVAL PRIMARY KEY,
  id_utilizator INT,
  id_categorie INT,
  id_motor INT,
  id_far INT,
  capacitate_rezervor INT,
  kilometraj INT,
  nr_inmatriculare VARCHAR(255),
  marca VARCHAR(255),
  model VARCHAR(255),
  stare VARCHAR(255),
  an INT,
  FOREIGN KEY (id_utilizator) REFERENCES UTILIZATORI(id_utilizator),
  FOREIGN KEY (id_categorie) REFERENCES CATEGORII(id_categorie),
  FOREIGN KEY (id_motor) REFERENCES MOTOARE(id_motor),
  FOREIGN KEY (id_far) REFERENCES FARURI(id_far)
);

CREATE TABLE INTRETINERI (
  id_intretinere INT DEFAULT INTRETINERI_SEQ.NEXTVAL PRIMARY KEY,
  id_motocicleta INT,
  id_utilizator INT,
  id_plata INT,
  nume VARCHAR(255),
  descriere VARCHAR(255),
  data DATE,
  FOREIGN KEY (id_motocicleta) REFERENCES MOTOCICLETE(id_motocicleta),
  FOREIGN KEY (id_utilizator) REFERENCES UTILIZATORI(id_utilizator),
  FOREIGN KEY (id_plata) REFERENCES PLATI(id_plata)
);

CREATE TABLE ACHIZITII (
  id_achizitie INT DEFAULT ACHIZITII_SEQ.NEXTVAL PRIMARY KEY,
  id_plata INT,
  id_utilizator INT,
  id_motocicleta INT,
  nume VARCHAR(255),
  descriere VARCHAR(255),
  data DATE,
  FOREIGN KEY (id_plata) REFERENCES PLATI(id_plata),
  FOREIGN KEY (id_utilizator) REFERENCES UTILIZATORI(id_utilizator),
  FOREIGN KEY (id_motocicleta) REFERENCES MOTOCICLETE(id_motocicleta)
);

CREATE TABLE ACCESORII_MOTOCICLETE (
  id_motocicleta INT,
  id_accesoriu INT,
  PRIMARY KEY (id_motocicleta, id_accesoriu),
  FOREIGN KEY (id_motocicleta) REFERENCES MOTOCICLETE(id_motocicleta),
  FOREIGN KEY (id_accesoriu) REFERENCES ACCESORII(id_accesoriu)
);

CREATE TABLE FRANE_MOTOCICLETE (
    id_motocicleta INT,
    id_frana INT,
    PRIMARY KEY (id_motocicleta, id_frana),
    FOREIGN KEY (id_motocicleta) REFERENCES MOTOCICLETE(id_motocicleta),
    FOREIGN KEY (id_frana) REFERENCES FRANE(id_frana)
);

--Inserare inregistrari

--1.Pentru tabelul FARURI

INSERT INTO FARURI (tip_far, model, diametru) 
VALUES ('Halogen', 'H4', 35);

INSERT INTO FARURI (tip_far, model, diametru) 
VALUES('Halogen', 'H7', 40);

INSERT INTO FARURI (tip_far, model, diametru) 
VALUES('LED', 'SMD', 25);

INSERT INTO FARURI (tip_far, model, diametru) 
VALUES ('Xenon', 'D2S', 35);

INSERT INTO FARURI (tip_far, model, diametru) 
VALUES ('Halogen', 'H1', 30);

INSERT INTO FARURI (tip_far, model, diametru) 
VALUES ('LED', 'COB', 35);
       
INSERT INTO FARURI (tip_far, model, diametru) 
VALUES ('Xenon', 'D1S', 25);

INSERT INTO FARURI (tip_far, model, diametru) 
VALUES ('Halogen', 'H3', 30);

INSERT INTO FARURI (tip_far, model, diametru) 
VALUES ('LED', 'RGB', 40);
       
INSERT INTO FARURI (tip_far, model, diametru) 
VALUES('Xenon', 'D3S', 25);

SELECT * 
FROM FARURI
ORDER BY ID_FAR;


--2.Pentru tabelul UTILIZATORI

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES ('Popescu', 'Ion', 'popescu.ion@gmail.com', 35, '12-FEB-1990');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Ionescu', 'Maria', 'ionescu.maria@yahoo.com', 27, '20-MAY-1996');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Georgescu', 'Alexandru', 'georgescu.alex@yahoo.com', 41, '01-NOV-1980');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Radulescu', 'Andreea', 'radulescu.andreea@gmail.com', 23, '08-SEP-1998');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Popa', 'Mihai', 'popa.mihai@gmail.com', 31, '17-APR-1990');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Cristea', 'Ana', 'cristea.ana@yahoo.com', 29, '25-JUL-1992');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Dumitrescu', 'Alexandra', 'dumitrescu.alexandra@gmail.com', 38, '30-DEC-1983');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Constantinescu', 'Cristian', 'constantinescu.cristian@yahoo.com', 45, '06-MAR-1976');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Popovici', 'Diana', 'popovici.diana@gmail.com', 26, '14-AUG-1995');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Muresan', 'Radu', 'muresan.radu@gmail.com', 33, '10-JAN-1988');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Muresan', 'Radu', 'muresan.radu@gmail.com', 33, '10-JAN-1988');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Muresan', 'Radu', 'muresan.radu@gmail.com', 33, '10-JAN-1988');

INSERT INTO UTILIZATORI (nume, prenume, email, varsta, data_nasterii) VALUES('Muresan', 'Radu', 'muresan.radu@gmail.com', 33, '10-JAN-1988');

SELECT * 
FROM UTILIZATORI
ORDER BY ID_UTILIZATOR;

--3.Pentru tabelul FRANE

INSERT INTO FRANE (tip_frana, pozitie) VALUES ('Ferodo Disc', 'Fata-Dreapta');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('Ferodo Disc', 'Spate-Stanga');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('Ferodo Disc','Spate-Dreapta');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('Brembo Disc', 'Fata-Stanga');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('Brembo Disc', 'Fata-Dreapta');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('Brembo Disc', 'Spate-Stanga');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('Brembo Disc','Spate-Dreapta');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('TRW Placute', 'Fata-Stanga');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('TRW Placute','Spate-Stanga');

INSERT INTO FRANE (tip_frana, pozitie) VALUES('TRW Placute','Fata-Dreapta');

SELECT * 
FROM FRANE
ORDER BY ID_FRANA;


--4.Pentru tabelul ACCESORII

INSERT INTO ACCESORII (nume) VALUES ('Casca');

INSERT INTO ACCESORII (nume) VALUES('Manusi'); 

INSERT INTO ACCESORII (nume) VALUES('Jacheta moto');

INSERT INTO ACCESORII (nume) VALUES('Pantaloni moto'); 

INSERT INTO ACCESORII (nume) VALUES('Bocanci moto');

INSERT INTO ACCESORII (nume) VALUES('Ochelari moto'); 

INSERT INTO ACCESORII (nume) VALUES('Costum de ploaie'); 

INSERT INTO ACCESORII (nume) VALUES('Antifurt');

INSERT INTO ACCESORII (nume) VALUES('Pilot automat'); 

INSERT INTO ACCESORII (nume) VALUES('Topcase');

SELECT * 
FROM ACCESORII
ORDER BY ID_ACCESORIU;


--5.Pentru tabelul CATEGORII

INSERT INTO CATEGORII (nume, descriere) VALUES ('Cruiser', 'Motocicleta cu un stil clasic si confortabila pentru plimbari lungi');

INSERT INTO CATEGORII (nume, descriere) VALUES('Sport', 'Motocicleta cu un stil sportiv, agresiv si performanta mare');

INSERT INTO CATEGORII (nume, descriere) VALUES('Adventure', 'Motocicleta pentru aventura, cu suspensii lungi si putere mare');

INSERT INTO CATEGORII (nume, descriere) VALUES('Touring', 'Motocicleta pentru turism, cu un stil confortabil si spatios');

INSERT INTO CATEGORII (nume, descriere) VALUES('Naked', 'Motocicleta fara carenaj, cu un stil minimal si agresiv');

INSERT INTO CATEGORII (nume, descriere) VALUES('Scooter', 'Motocicleta cu o platforma de picioare si un spatiu de depozitare mare');

INSERT INTO CATEGORII (nume, descriere) VALUES('Cafe Racer', 'Motocicleta cu un stil vintage si modificari pentru performanta');

INSERT INTO CATEGORII (nume, descriere) VALUES('Chopper', 'Motocicleta cu un stil personalizat si lunga deosebit de lunga');

INSERT INTO CATEGORII (nume, descriere) VALUES('Bobber', 'Motocicleta cu un stil minimalist si construita cu piese vechi');

INSERT INTO CATEGORII (nume, descriere) VALUES('Street', 'Motocicleta cu un stil urban si agresiv');

--NOU

INSERT INTO CATEGORII (nume, descriere) VALUES('Sport Cruiser', 'Combin? farmecul relaxat al cruiser-urilor cu performan?a dinamic? a motocicletelor sportive');

SELECT * 
FROM CATEGORII
ORDER BY ID_CATEGORIE;

       
--6.Pentru tabelul MOTOARE

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES (150, 8.5, 4,'benzina'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(120, 7.2, 4,'motorina'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(90, 6.8, 2,'etanol'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(110, 7.9, 4,'benzina'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(100, 7.1, 4,'motorina'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(80, 5.9, 2,'benzina'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(120, 7.6, 4,'motorina'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(140, 8.9, 4,'benzina'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(110, 7.3, 2,'etanol'); 

INSERT INTO MOTOARE (putere, consum_combustibil, nr_timpi, carburant) VALUES(95, 6.5, 2, 'benzina');

SELECT * 
FROM MOTOARE
ORDER BY ID_MOTOR;

  
--7.Pentru tabelul PLATI

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(10, 56.25, '03-JAN-2022', 'cash');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(2, 98.50, '05-JAN-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(13, 75.00, '07-FEB-2022', 'cash');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(10, 32.80, '09-MAR-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(12, 62.10, '11-APR-2022', 'cash');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(5, 128.45, '13-APR-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(2, 93.20, '15-JUN-2022', 'cash');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(10, 44.70, '17-JUL-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(13, 81.90, '19-JUL-2022', 'cash');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 56.00, '21-NOV-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 150.00, '20-JAN-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 6.00, '13-NOV-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 231.00, '14-NOV-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 80.00, '15-FEB-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 59.00, '12-JUL-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 56.00, '21-JAN-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(7, 50.00, '28-FEB-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(9, 52.00, '21-JAN-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(9, 56.00, '23-APR-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 6.00, '22-MAY-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 46.00, '20-MAR-2022', 'card');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 5.00, '21-APR-2022', 'card');

INSERT INTO PLATI (id_plata,id_utilizator, cost, data, modalitate_plata) VALUES(23,8, 56.00, '01-NOV-2022', 'card');

INSERT INTO PLATI (id_plata,id_utilizator, cost, data, modalitate_plata) VALUES(24,8, 56.00, '01-NOV-2022', 'cash');

INSERT INTO PLATI (id_plata,id_utilizator, cost, data, modalitate_plata) VALUES(26,8, 56.00, '01-NOV-2022', 'cash');

INSERT INTO PLATI (id_plata,id_utilizator, cost, data, modalitate_plata) VALUES(27,8, 56.00, '01-NOV-2022', 'cash');

INSERT INTO PLATI (id_utilizator, cost, data, modalitate_plata) VALUES(8, 56.00, '01-NOV-2022', 'cash');

SELECT * 
FROM PLATI
ORDER BY ID_PLATA;


--8.Pentru tabelul MOTOCICLETE

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an, capacitate_rezervor) 
VALUES (11, 1, 1, 1, 5000, 'B-01-ABC', 'Honda', 'CBR600RR', 'foarte buna', 2018,10);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (11, 1, 2, 2, 7000, 'B-02-DEF', 'Yamaha', 'R6', 'buna', 2016,15);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (2, 2, 3, 3, 10000, 'B-03-GHI', 'Kawasaki', 'Ninja ZX-6R', 'foarte buna', 2020,21);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (2, 2, 4, 4, 8000, 'B-04-JKL', 'Suzuki', 'GSX-R750', 'buna', 2014,17);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (13, 3, â5, 5, 12000, 'B-05-MNO', 'Ducati', 'Panigale V4', 'excelenta', 2019,19);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (13, 3, 6, 6, 9000, 'B-06-PQR', 'Triumph', 'Street Triple RS', 'buna', 2015,18);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (9, 4, 7, 7, 6000, 'B-07-STU', 'BMW', 'S1000RR', 'foarte buna', 2017,19);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie,id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (9, 4, 8, 8, 15000, 'B-08-VWX', 'KTM', 'RC 390', 'buna', 2016,14);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (5, 5, 9, 9, 11000, 'B-09-YZ1', 'Harley-Davidson', 'Sportster 1200', 'buna', 2013,13);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (5, 5, 10, 10, 20000, 'B-10-234', 'Indian', 'Chieftain Dark Horse', 'foarte buna', 2018,12);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (5, 5, 10, 10, 20000, 'B-10-234', 'Indian', 'Chieftain Dark Horse', 'foarte buna', 2018,11);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (5, 5, 10, 10, 20000, 'B-10-234', 'Indian', 'Chieftain Dark Horse', 'foarte buna', 2018,18);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (5, 5, 10, 10, 20000, 'B-10-234', 'Indian', 'Chieftain Dark Horse', 'foarte buna', 2018,19);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (5, 5, 10, 10, 20000, 'B-10-234', 'Indian', 'Chieftain Dark Horse', 'foarte buna', 2018,21);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (5, 5, 10, 10, 20000, 'B-10-234', 'Indian', 'Chieftain Dark Horse', 'foarte buna', 2018,21);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (5, 5, 10, 10, 20000, 'B-10-234', 'Indian', 'Chieftain Dark Horse', 'foarte buna', 2018,20);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (2, 5, 3, 3, 10000, 'B-03-GHI', 'Kawasaki', 'Ninja ZX-6R', 'foarte buna', 2020,21);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (2, 5, 4, 4, 8000, 'B-04-JKL', 'Suzuki', 'GSX-R750', 'buna', 2014,17);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (13, 5, 5, 5, 12000, 'B-05-MNO', 'Ducati', 'Panigale V4', 'excelenta', 2019,19);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (13, 5, 6, 6, 9000, 'B-06-PQR', 'Triumph', 'Street Triple RS', 'buna', 2015,18);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (9, 5, 7, 7, 6000, 'B-07-STU', 'BMW', 'S1000RR', 'foarte buna', 2017,19);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie,id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an,capacitate_rezervor) 
VALUES (9, 5, 8, 8, 15000, 'B-08-VWX', 'KTM', 'RC 390', 'buna', 2016,14);

--NOI
INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an, capacitate_rezervor)
VALUES (9, 1, 3, 5, 12000, 'B-123-XYZ', 'Honda', 'CBR600RR', 'Excelenta', 2019, 18);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an, capacitate_rezervor)
VALUES (9, 2, 6, 8, 8000, 'C-456-UVW', 'Yamaha', 'YZF-R1', 'Buna', 2020, 17);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an, capacitate_rezervor)
VALUES (9, 3, 9, 2, 6000, 'D-789-ABC', 'Kawasaki', 'Ninja 650', 'Foarte Buna', 2021, 15);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an, capacitate_rezervor)
VALUES (9, 4, 1, 7, 10000, 'E-012-XYZ', 'Suzuki', 'GSX-R1000', 'Buna', 2018, 19);

INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an, capacitate_rezervor)
VALUES (3, 4, 2, 7, 10000, 'E-012-XYZ', 'Suzuki', 'GSX-R1000', 'Buna', 2018, 19);

SELECT * 
FROM MOTOCICLETE
ORDER BY ID_MOTOCICLETA;


--9.Pentru tabelul INTRETINERI

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES (11, 2, 3, 'Schimb ulei', 'Schimb de ulei la motor', '15-MAR-2022');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(12, 13, 4, 'Inlocuire baterie', 'Inlocuirea bateriei vechi cu una noua', '27-DEC-2021');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(13, 13, 5, 'Schimb cauciucuri', 'Schimb de anvelope', '02-APR-2022');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(4, 5, 6, 'Curatare carburator', 'Curatare carburator si sistem de injectie', '18-OCT-2021');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(15, 6, 7, 'Inlocuire placute frana', 'Inlocuire placute de frana', '01-FEB-2022');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(6, 7, 8, 'Inlocuire lant', 'Inlocuirea lantului de transmisie', '20-NOV-2021');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(9, 8, 9, 'Reglare suspensie', 'Reglarea suspensiei fata/spate', '05-APR-2022');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(3, 9, 10, 'Inlocuire bujie', 'Inlocuirea bujiei cu una noua', '13-MAY-2022');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(9, 10, 1, 'Curatare filtru aer', 'Curatare filtru de aer', '21-SEP-2021');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(10, 11, 2, 'Verificare sistem electric', 'Verificare si testare sistem electric', '10-DEC-2021');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(11, 13, 4, 'Inlocuire senzor temperatura', 'Inlocuirea senzorului de temperatura', '22-JUN-2022');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(12, 5, 5, 'Schimb lichid frana', 'Schimb de lichid de frana', '28-JUN-2022');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(12, 5, 5, 'Schimb lichid frana', 'Schimb de lichid de frana', '28-JUN-2022');

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES(12, 5, 5, 'Schimb lichid frana', 'Schimb de lichid de frana', '28-JUN-2022');


SELECT * 
FROM INTRETINERI
ORDER BY ID_INTRETINERE;


--10.Pentru tabelul ACHIZITIE

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(2, 4, 5, 'Motocicleta Yamaha R6', 'Motocicleta sportiva cu 600cc, culoare rosie', '15-MAR-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(1, 3, 4, 'Motocicleta Harley Davidson Fat Boy', 'Chopper clasic, culoare neagra mata', '02-APR-2021');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(10, 2, 2, 'Casca HJC RPHA 11', 'Casca integrala pentru motociclete, culoare alb?', '08-MAY-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(9, 4, 4, 'Anvelopa Michelin Road 5', 'Anvelopa sportiva pentru motociclete, dimensiune 180/55 R17', '20-JAN-2023');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(8, 5, 5, 'Geanta laterala Givi Xstream', 'Geanta de depozitare pentru motociclete, capacitate 25L', '14-FEB-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(7, 6, 3, 'Ulei motocicleta Motul 7100', 'Ulei de motor sintetic, pentru motociclete cu performante ridicate', '02-MAR-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(6, 10, 7, 'Manusi moto Alpinestars GP Plus', 'Manusi de piele pentru motociclete, cu protectii la degete si încheieturi', '28-APR-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(5, 8, 8, 'Placute frâna Brembo', 'Placute de frâna de înalta performanta pentru motociclete', '04-MAY-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(4, 9, 9, 'Lant moto DID VX', 'Lant de transmisie pentru motociclete, cu tehnologie X-ring si tratament special antirugina', '31-JAN-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(3, 7, 5, 'Sa motocicleta La Rosa', 'Sa de pasager pentru motociclete, din piele maro si cusaturi decorative', '19-FEB-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(2, 1, 1, 'Proteza motor Yamaha R1', 'Proteza de motor pentru motocicleta Yamaha R1', '17-MAR-2021');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(1, 2, 2, 'Perna de gel pentru sa', 'Perna de gel pentru sa de motocicleta, pentru un confort sporit în timpul calatoriilor lungi', '09-MAY-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(1, 2, 2, 'Perna de gel pentru sa', 'Perna de gel pentru sa de motocicleta, pentru un confort sporit în timpul calatoriilor lungi', '09-MAY-2022');

INSERT INTO ACHIZITII (id_plata, id_utilizator, id_motocicleta, nume, descriere, data) VALUES
(1, 2, 2, 'Perna de gel pentru sa', 'Perna de gel pentru sa de motocicleta, pentru un confort sporit în timpul calatoriilor lungi', '09-MAY-2022');

SELECT * 
FROM ACHIZITII
ORDER BY ID_ACHIZITIE;


--11.Pentru tabelul ACCESORII_MOTOCICLETE

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES (1, 2);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(1, 4);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(1, 6);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(2, 1);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(2, 3);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(2, 5);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(3, 1);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(3, 4);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(3, 7);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(4, 3);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(4, 5);

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(4, 8);

--NOU

INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(8, 1);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(8, 2);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(9, 3);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(10, 4);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(10, 5);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(11, 6);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(12, 7);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(12, 8);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(12, 9);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(12, 10);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(14, 1);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(15, 2);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(15, 3);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(41, 4);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(43, 5);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(43, 6);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(43, 7);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(44, 8);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(44, 9);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(6, 1);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(6, 2);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(6, 3);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(6, 4);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(7, 5);
INSERT INTO ACCESORII_MOTOCICLETE (id_motocicleta, id_accesoriu) VALUES(21, 5);

SELECT * 
FROM ACCESORII_MOTOCICLETE
ORDER BY ID_MOTOCICLETA;

--12.Pentru tabelul FRANE_MOTOCICLETE

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES (1, 1);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(1, 3);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(1, 5);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(2, 2);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(2, 4);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(2, 6);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(3, 3);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(3, 5);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(3, 7);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(4, 4);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(4, 6);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(4, 8);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(5, 5);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(5, 7);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(5, 9);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(6, 6);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(6, 8);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(6, 10);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(7, 7);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(7, 9);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(7, 1);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(8, 8);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(8, 10);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(8, 2);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(9, 9);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(9, 1);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(10,1);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(10,2);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES (11, 1);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(11, 3);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(11, 5);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(12, 2);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(12, 4);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(12, 6);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(13, 3);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(13, 5);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(13, 7);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(14, 4);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(14, 6);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(14, 8);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(15, 5);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(15, 7);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(15, 9);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(10, 6);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(11, 8);

INSERT INTO FRANE_MOTOCICLETE (id_motocicleta, id_frana) VALUES(12, 10);

SELECT * 
FROM FRANE_MOTOCICLETE
ORDER BY ID_MOTOCICLETA;

SELECT COUNT(*)
FROM MOTOCICLETE;