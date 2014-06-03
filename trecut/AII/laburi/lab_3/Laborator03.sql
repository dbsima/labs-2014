CREATE DATABASE librarie;

USE librarie;

CREATE TABLE edituri (
	id_editura	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	denumire	VARCHAR(30) NOT NULL,
	CIF			INT(10) NOT NULL,			
	descriere	VARCHAR(1000),
	localitate	VARCHAR(50) NOT NULL,
	regiune		VARCHAR(50) NOT NULL,
	tara		VARCHAR(50) NOT NULL
);

CREATE TABLE colectii (
	id_colectie	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	denumire	VARCHAR(30) NOT NULL,
	descriere	VARCHAR(1000)
);

CREATE TABLE domenii (
	id_domeniu	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	denumire	VARCHAR(30) NOT NULL,
	descriere	VARCHAR(1000)
);

CREATE TABLE carti (
	id_carte	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	titlu		VARCHAR(50) NOT NULL,
	descriere	VARCHAR(1000),
	id_editura	INT(10) UNSIGNED NOT NULL,
	an_aparitie	INT(4) NOT NULL,
	editie		INT(2) NOT NULL,
	id_colectie	INT(10) UNSIGNED NOT NULL,
	id_domeniu	INT(10) UNSIGNED NOT NULL,
	stoc		INT(4) UNSIGNED NOT NULL,
	pret		DECIMAL(8,2) UNSIGNED NOT NULL,
	FOREIGN KEY (id_editura) REFERENCES edituri(id_editura) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_colectie) REFERENCES colectii(id_colectie) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_domeniu) REFERENCES domenii(id_domeniu) ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE carti ADD CONSTRAINT editie_chk CHECK (editie>0);
ALTER TABLE carti ADD CONSTRAINT stoc_chk CHECK (stoc>=0);
ALTER TABLE carti ADD CONSTRAINT pret_chk CHECK (pret>0);

CREATE TABLE scriitori (
	id_scriitor	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	nume		VARCHAR(30) NOT NULL,
	prenume		VARCHAR(30) NOT NULL,
	biografie	VARCHAR(1000) NOT NULL
);

CREATE TABLE autori (
	id_autor	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	id_carte	INT(10) UNSIGNED NOT NULL,
	id_scriitor	INT(10) UNSIGNED NOT NULL,
	FOREIGN KEY (id_carte) REFERENCES carti (id_carte) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_scriitor) REFERENCES scriitori (id_scriitor) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE comenzi_aprovizionare (
	id_comanda_aprovizionare	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	serie_numar					VARCHAR(10) NOT NULL,
	data						DATETIME NOT NULL,
	stare						VARCHAR(30) NOT NULL DEFAULT 'plasata',
	id_editura					INT(10) UNSIGNED NOT NULL,
	FOREIGN KEY (id_editura) REFERENCES edituri (id_editura) ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE comenzi_aprovizionare ADD CONSTRAINT stare_ca_chk CHECK (stare in ('plasata', 'onorata'));

CREATE TABLE detalii_comanda_aprovizionare (
	id_detaliu_comanda_aprovizionare	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	id_comanda_aprovizionare			INT(10) UNSIGNED NOT NULL,
	id_carte							INT(10) UNSIGNED NOT NULL,
	cantitate                           INT(4) UNSIGNED NOT NULL,
	FOREIGN KEY (id_comanda_aprovizionare) REFERENCES comenzi_aprovizionare (id_comanda_aprovizionare)  ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_carte) REFERENCES carti (id_carte)  ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE detalii_comanda_aprovizionare ADD CONSTRAINT cantitate_dca_chk CHECK(cantitate>0);

CREATE TABLE utilizatori (
	CNP				BIGINT(13) UNSIGNED PRIMARY KEY NOT NULL,
	nume			VARCHAR(30) NOT NULL,
	prenume			VARCHAR(30) NOT NULL,
	adresa			VARCHAR(100) NOT NULL,
	telefon			INT(10),
	email			VARCHAR(60) NOT NULL,
	tip				VARCHAR(30) NOT NULL DEFAULT 'client',
	rol				VARCHAR(30) NOT NULL DEFAULT 'client inregistrat',
	nume_utilizator VARCHAR(30) NOT NULL,
	parola			VARCHAR(30) NOT NULL
);
ALTER TABLE utilizatori ADD CONSTRAINT email_chk CHECK (email LIKE '%@%.%');
ALTER TABLE utilizatori ADD CONSTRAINT tip_chk CHECK (tip IN ('administrator', 'client'));
ALTER TABLE utilizatori ADD CONSTRAINT rol_chk CHECK (rol IN ('super-administrator', 'administrator obisnuit', 'client inregistrat', 'client verificat'));

CREATE TABLE facturi (
	id_factura	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	serie_numar	VARCHAR(10) NOT NULL,
	data		DATETIME NOT NULL,
	stare		VARCHAR(30) NOT NULL DEFAULT 'emisa', 
	CNP			BIGINT(13) UNSIGNED NOT NULL,
	FOREIGN KEY (CNP) REFERENCES utilizatori(cnp)  ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE facturi ADD CONSTRAINT stare_f_chk CHECK (stare in ('emisa', 'achitata'));

CREATE TABLE detalii_factura (
	id_detaliu_factura	INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	id_factura			INT(10) UNSIGNED NOT NULL,
	id_carte			INT(10) UNSIGNED NOT NULL,
	cantitate			INT(4) UNSIGNED NOT NULL,
	FOREIGN KEY (id_factura) REFERENCES facturi (id_factura)  ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_carte) REFERENCES carti (id_carte)  ON UPDATE CASCADE ON DELETE CASCADE
);
ALTER TABLE detalii_factura ADD CONSTRAINT cantitate_df_chk CHECK (cantitate>=0);

INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '143875322', '-', 'Bucuresti', 'Maramures', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '600748490', '-', 'Satu-Mare', 'Maramures', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Corint', '494655416', '-', 'Constanta', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Corint', '107517959', '-', 'Iasi', 'Maramures', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Agapis', '911654956', '-', 'Cluj-Napoca', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '628986089', '-', 'Braila', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '824179198', '-', 'Satu-Mare', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Niculescu', '612359884', '-', 'Piatra Neamt', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Dacia', '455696544', '-', 'Galati', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '576884947', '-', 'Oradea', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Diversitas', '308836805', '-', 'Iasi', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Polirom', '982698986', '-', 'Satu-Mare', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '723302499', '-', 'Bucuresti', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Dacia', '697336950', '-', 'Constanta', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '923917317', '-', 'Bucuresti', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Carea Romaneasca', '559703672', '-', 'Craiova', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Humanitas', '321583246', '-', 'Arad', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Polirom', '151380040', '-', 'Cluj-Napoca', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Rao Books', '378310249', '-', 'Arad', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Trei', '955658169', '-', 'Piatra Neamt', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '845937195', '-', 'Constanta', 'Bucovina', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '346281003', '-', 'Bucuresti', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Carea Romaneasca', '198888527', '-', 'Timisoara', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '791105677', '-', 'Galati', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '634255286', '-', 'Cluj-Napoca', 'Bucovina', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '527891303', '-', 'Timisoara', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('ALL', '109043031', '-', 'Braila', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Niculescu', '525420833', '-', 'Buzau', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Dacia', '786732806', '-', 'Bucuresti', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Trei', '472567255', '-', 'Craiova', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Carea Romaneasca', '546394595', '-', 'Satu-Mare', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Litera', '246497024', '-', 'Satu-Mare', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '242095640', '-', 'Brasov', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Carea Romaneasca', '861542990', '-', 'Brasov', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Diversitas', '360875535', '-', 'Braila', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '362091696', '-', 'Iasi', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '101934792', '-', 'Craiova', 'Bucovina', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Litera', '673530580', '-', 'Arad', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Litera', '866999498', '-', 'Iasi', 'Bucovina', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Trei', '388743268', '-', 'Brasov', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '780057515', '-', 'Galati', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '550337781', '-', 'Galati', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Dacia', '821602258', '-', 'Braila', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Agapis', '453104654', '-', 'Satu-Mare', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('ALL', '270022870', '-', 'Piatra Neamt', 'Maramures', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '162088085', '-', 'Timisoara', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Corint', '916421355', '-', 'Arad', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Humanitas', '443632779', '-', 'Buzau', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '738541690', '-', 'Iasi', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Polirom', '677335823', '-', 'Arad', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Trei', '657845348', '-', 'Craiova', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Dacia', '744066540', '-', 'Timisoara', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Niculescu', '500726717', '-', 'Satu-Mare', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Dacia', '347229860', '-', 'Galati', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Agapis', '924783570', '-', 'Timisoara', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Polirom', '452953632', '-', 'Piatra Neamt', 'Bucovina', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Corint', '239968609', '-', 'Bucuresti', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Rao Books', '121965835', '-', 'Cluj-Napoca', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '991043071', '-', 'Timisoara', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Litera', '144376438', '-', 'Piatra Neamt', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Dacia', '421172625', '-', 'Oradea', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Carea Romaneasca', '780923040', '-', 'Craiova', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Polirom', '366891080', '-', 'Brasov', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Diversitas', '197633488', '-', 'Oradea', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Litera', '558097630', '-', 'Iasi', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Humanitas', '870238953', '-', 'Iasi', 'Bucovina', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '897506997', '-', 'Satu-Mare', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Diversitas', '774557325', '-', 'Galati', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Trei', '716513016', '-', 'Iasi', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '619012714', '-', 'Iasi', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Humanitas', '845418533', '-', 'Timisoara', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Trei', '531123812', '-', 'Galati', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '247764320', '-', 'Iasi', 'Bucovina', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Rao Books', '496801997', '-', 'Timisoara', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Niculescu', '935772828', '-', 'Piatra Neamt', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Niculescu', '560812867', '-', 'Buzau', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '209436028', '-', 'Arad', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '530059044', '-', 'Galati', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Niculescu', '492908503', '-', 'Buzau', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Rao Books', '306062625', '-', 'Arad', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Polirom', '172019640', '-', 'Piatra Neamt', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Humanitas', '226198052', '-', 'Piatra Neamt', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Agapis', '659691006', '-', 'Oradea', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Rao Books', '864328270', '-', 'Iasi', 'Bucovina', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Humanitas', '570784430', '-', 'Satu-Mare', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('ALL', '920946082', '-', 'Piatra Neamt', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '118741427', '-', 'Satu-Mare', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Humanitas', '634131689', '-', 'Craiova', 'Maramures', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '367463167', '-', 'Galati', 'Muntenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Trei', '216800492', '-', 'Bucuresti', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Corint', '639514550', '-', 'Arad', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Nemira', '132350044', '-', 'Arad', 'Maramures', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Aramis', '296437166', '-', 'Timisoara', 'Banat', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Carea Romaneasca', '688799165', '-', 'Brasov', 'Transilvania', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Niculescu', '439834144', '-', 'Cluj-Napoca', 'Maramures', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Litera', '157378375', '-', 'Brasov', 'Oltenia', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Agapis', '120686929', '-', 'Arad', 'Maramures', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '997171451', '-', 'Iasi', 'Dobrogea', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Curtea Veche', '918898988', '-', 'Iasi', 'Moldova', 'Romania');
INSERT INTO edituri (denumire, CIF, descriere, localitate, regiune, tara)
 VALUES('Trei', '244189781', '-', 'Oradea', 'Oltenia', 'Romania');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('thriller', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('suplimentul de cultura', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bios', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('suplimentul de cultura', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('practic', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bios', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('opus', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bios', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('antologii', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('antologii', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('collegium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bac', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('antologii', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('document', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('antologii', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('thriller', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('antologii', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('linux', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('chic', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('chic', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('linux', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bios', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('suplimentul de cultura', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('fiction ltd', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('practic', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('stiintele educatiei', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('linux', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('opus', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('duplex', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('practic', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('document', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('biblioteca medievala', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bios', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('opus', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('suplimentul de cultura', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('antologii', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('antologii', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('hexagon', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('duplex', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('thriller', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('historia', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bac', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('antologii', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bios', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('historia', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('thriller', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('stiintele educatiei', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bac', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('biblioteca medievala', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('historia', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('linux', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('practic', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('suplimentul de cultura', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('practic', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bios', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('practic', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('fiction canon', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('linux', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('hexagon', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('historia', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('thriller', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('document', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('stiintele educatiei', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('suplimentul de cultura', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('collegium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('linux', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('traditia crestina', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('stiintele educatiei', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('thriller', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('thriller', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bac', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('document', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('hexagon', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('bios', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('stiintele educatiei', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('stiintele educatiei', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('hexagon', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('duplex', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('document', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('gymnasium', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('duplex', '-');
INSERT INTO colectii (denumire, descriere)
 VALUES ('suplimentul de cultura', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Muzeologie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria universala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cinematografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Sculptura', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Analiza matematica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Matematici superioare', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Sculptura', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Albume', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Fotografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Teatru', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria romanilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arheologie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istorie antica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cercetari operationale', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Jurisprudenta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arheologie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Muzica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria grecilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Muzica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Muzeologie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Fotografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arta populara', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria universala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria romanilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria grecilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria romanilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Fotografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cercetari operationale', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arte plastice', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria Europei', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Fotografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Criminalistica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Critica de arta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Fotografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria Europei', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Teatru', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria universala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Muzica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria universala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Sculptura', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Geometrie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Teatru', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Teatru', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Muzeologie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Critica de arta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arheologie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cercetari operationale', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arta monumentala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria universala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria universala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istorie antica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arta monumentala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arta monumentala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Albume', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Criminalistica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria grecilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Jurisprudenta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria Europei', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arta monumentala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Albume', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cinematografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria grecilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Matematici superioare', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Albume', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Jurisprudenta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cinematografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Teatru', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Jurisprudenta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Teatru', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Algebra', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Fotografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Avangardism', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cercetari operationale', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cinematografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria universala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria grecilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria Europei', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Jurisprudenta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Analiza matematica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istorie antica', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria universala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Fotografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Matematici superioare', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria Europei', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria grecilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Avangardism', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Istoria romanilor', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Jurisprudenta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Geometrie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arta monumentala', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Teatru', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Sculptura', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Teatru', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Cercetari operationale', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Arte plastice', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Geometrie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Jurisprudenta', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Fotografie', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Avangardism', '-');
INSERT INTO domenii (denumire, descriere)
 VALUES('Criminalistica', '-');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce vedem filme', '-', '23', '1882', '6', '79', '80', '490', '8082');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Trickster', '-', '86', '1904', '7', '69', '27', '449', '5465');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Lolita', '-', '18', '1945', '10', '40', '57', '522', '9837');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Demonii Vantului', '-', '22', '1885', '2', '13', '46', '189', '1633');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Trickster', '-', '40', '1922', '1', '73', '85', '247', '1627');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Cinema', '-', '36', '1877', '5', '59', '17', '676', '2044');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Iubirile croitoresei', '-', '23', '1855', '7', '37', '6', '323', '8335');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce vedem filme', '-', '21', '1898', '6', '64', '93', '679', '3050');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce vedem filme', '-', '39', '1830', '10', '86', '51', '714', '253');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Forta politica a femeilor', '-', '64', '1810', '8', '21', '50', '578', '7409');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Gandirea Salbatica', '-', '40', '1915', '1', '43', '83', '246', '5215');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('8 metode eficiente pentru educarea copiilor', '-', '12', '1853', '1', '61', '52', '87', '4278');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Iubirile croitoresei', '-', '90', '1887', '9', '94', '75', '169', '9084');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('8 metode eficiente pentru educarea copiilor', '-', '47', '1821', '6', '99', '49', '73', '7893');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Istoria limbii romane', '-', '59', '2002', '9', '34', '28', '966', '8603');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce vedem filme', '-', '34', '1897', '1', '60', '88', '201', '8517');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Patru Barbati plus Aurelius', '-', '87', '1900', '5', '48', '77', '303', '1127');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Si Hams si Regretel', '-', '23', '1874', '2', '40', '34', '547', '7796');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Gandirea Salbatica', '-', '73', '1894', '2', '21', '7', '902', '2879');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Varia', '-', '89', '1951', '6', '20', '84', '433', '9239');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Gandirea Salbatica', '-', '44', '2002', '3', '25', '44', '391', '8306');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Minunata lume noua', '-', '41', '1903', '2', '36', '34', '990', '920');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Lolita', '-', '47', '2002', '6', '12', '83', '924', '5205');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Varia', '-', '4', '1825', '5', '50', '93', '291', '8301');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '3', '1996', '6', '53', '88', '687', '475');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Cinema', '-', '98', '1875', '4', '69', '85', '268', '8128');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Integrala prozei scurte', '-', '67', '1971', '6', '29', '58', '482', '8814');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce vedem filme', '-', '35', '1847', '5', '26', '59', '171', '1597');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Ziua M. Cand a inceput al doilea razboi mondial', '-', '50', '1802', '6', '55', '87', '169', '4763');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Iubirile croitoresei', '-', '24', '1807', '8', '65', '86', '994', '3327');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Demonii Vantului', '-', '67', '1831', '4', '66', '36', '782', '5411');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Varia', '-', '94', '1871', '5', '76', '25', '501', '5560');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Ziua M. Cand a inceput al doilea razboi mondial', '-', '79', '1905', '1', '24', '90', '354', '2837');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Integrala prozei scurte', '-', '49', '1801', '4', '45', '66', '540', '9700');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De veghe in lanul de secara', '-', '69', '1834', '8', '96', '86', '450', '3315');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Patru Barbati plus Aurelius', '-', '13', '1880', '10', '15', '71', '796', '1203');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '36', '1936', '6', '72', '84', '871', '6917');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Integrala prozei scurte', '-', '59', '2001', '8', '48', '36', '102', '2774');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Terapia centrata pe copil', '-', '47', '1879', '5', '58', '24', '467', '495');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Trickster', '-', '52', '1943', '8', '91', '26', '366', '1678');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Patru Barbati plus Aurelius', '-', '99', '1832', '2', '46', '86', '610', '5343');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Gandirea Salbatica', '-', '96', '2002', '1', '87', '89', '748', '7931');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Si Hams si Regretel', '-', '8', '1986', '2', '29', '33', '837', '5985');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Demonii Vantului', '-', '87', '1894', '7', '98', '70', '685', '3120');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Si Hams si Regretel', '-', '26', '1812', '9', '75', '19', '16', '6845');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Forta politica a femeilor', '-', '50', '1812', '5', '90', '32', '274', '3736');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Cinema', '-', '43', '1976', '1', '89', '5', '812', '9875');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Cinema', '-', '70', '1965', '1', '94', '46', '958', '90');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Lolita', '-', '59', '1932', '9', '46', '29', '117', '4361');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Cinema', '-', '71', '1927', '5', '64', '30', '988', '1791');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '66', '1816', '7', '57', '45', '732', '8515');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Varia', '-', '1', '1803', '7', '19', '90', '517', '3234');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Iubirile croitoresei', '-', '89', '1945', '6', '41', '88', '748', '9701');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('8 metode eficiente pentru educarea copiilor', '-', '53', '1917', '2', '42', '15', '6', '2408');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Lolita', '-', '36', '1887', '1', '46', '9', '433', '946');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Lolita', '-', '64', '1996', '10', '95', '83', '943', '7862');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '72', '2003', '8', '57', '29', '947', '5117');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '18', '1947', '4', '68', '57', '235', '2073');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '93', '1888', '5', '64', '12', '550', '9979');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Lolita', '-', '47', '1800', '5', '72', '5', '726', '9490');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Varia', '-', '67', '1888', '7', '9', '19', '165', '9371');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Varia', '-', '80', '1911', '2', '45', '27', '945', '6205');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Cinema', '-', '76', '1987', '2', '86', '15', '929', '5080');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Patru Barbati plus Aurelius', '-', '74', '2005', '2', '70', '91', '710', '2397');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Gandirea Salbatica', '-', '8', '1910', '6', '79', '19', '781', '5471');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Si Hams si Regretel', '-', '13', '1828', '9', '90', '95', '946', '5297');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Lolita', '-', '47', '1941', '6', '97', '17', '812', '8813');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Integrala prozei scurte', '-', '33', '1972', '5', '19', '42', '909', '6715');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '18', '1937', '9', '28', '85', '848', '9231');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Istoria limbii romane', '-', '84', '1903', '9', '47', '69', '659', '5784');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Cruciada copiilor', '-', '53', '1989', '1', '69', '3', '829', '1926');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('8 metode eficiente pentru educarea copiilor', '-', '65', '1907', '6', '68', '97', '614', '8551');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Terapia centrata pe copil', '-', '37', '1820', '1', '51', '40', '483', '7906');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De veghe in lanul de secara', '-', '5', '1835', '8', '87', '38', '864', '9604');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Terapia centrata pe copil', '-', '34', '1851', '1', '37', '36', '70', '991');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Minunata lume noua', '-', '84', '1853', '3', '80', '97', '589', '1798');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Varia', '-', '9', '1827', '3', '22', '52', '80', '8593');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Ziua M. Cand a inceput al doilea razboi mondial', '-', '43', '1892', '1', '91', '94', '725', '9002');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Forta politica a femeilor', '-', '78', '1996', '2', '6', '37', '724', '4618');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Terapia centrata pe copil', '-', '35', '1811', '4', '25', '29', '925', '2968');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Macel in Georgia', '-', '78', '1938', '1', '2', '30', '236', '6185');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Istoria limbii romane', '-', '52', '1863', '3', '18', '4', '926', '522');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Ziua M. Cand a inceput al doilea razboi mondial', '-', '25', '1928', '2', '32', '29', '915', '9126');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '15', '1960', '10', '96', '82', '908', '9819');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Integrala prozei scurte', '-', '84', '1811', '4', '94', '74', '547', '5844');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '63', '1916', '8', '46', '73', '727', '5317');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '63', '1901', '10', '70', '73', '335', '4866');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Iubirile croitoresei', '-', '14', '1977', '3', '1', '64', '188', '7240');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('8 metode eficiente pentru educarea copiilor', '-', '78', '1847', '7', '92', '43', '297', '7624');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Demonii Vantului', '-', '36', '1801', '10', '40', '100', '948', '4996');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Forta politica a femeilor', '-', '16', '1978', '3', '29', '56', '788', '4605');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Gandirea Salbatica', '-', '17', '1980', '6', '71', '66', '210', '1101');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Si Hams si Regretel', '-', '87', '1932', '10', '81', '66', '82', '6180');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Si Hams si Regretel', '-', '91', '1812', '4', '67', '25', '113', '8448');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Si Hams si Regretel', '-', '88', '1948', '8', '81', '19', '118', '5793');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Integrala prozei scurte', '-', '89', '1932', '4', '75', '80', '2', '2526');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Varia', '-', '88', '1957', '5', '40', '50', '786', '6299');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Forta politica a femeilor', '-', '80', '1889', '1', '25', '66', '521', '1113');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('Terapia centrata pe copil', '-', '35', '1917', '3', '93', '42', '456', '6401');
INSERT INTO carti (titlu, descriere, id_editura, an_aparitie, editie, id_colectie, id_domeniu, stoc, pret)
 VALUES('De ce m-am reintors in Romania', '-', '16', '2010', '7', '68', '87', '864', '3876');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Vladimir', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('MITCHIEVICI', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('MITCHIEVICI', 'Helene', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ILIS', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SALINGER', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('CRUDU', 'Dumitru', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('MITCHIEVICI', 'Sandra', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Dumitru', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Ovidiu', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Helene', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SALINGER', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('POP', 'Sandra', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('WILSON', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Dumitru', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('WILSON', 'Doina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Angelo', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('MITCHIEVICI', 'Helene', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ZECA-BUZURA', 'Florina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'J.D.', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Doina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ZECA-BUZURA', 'Helene', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('HUXLEY', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('DUENAS', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('WILSON', 'Jim', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('HUXLEY', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('PRALONG', 'Florina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SUVOROV', 'Jim', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Doina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('CRUDU', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SUVOROV', 'Vladimir', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Florina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Aldous', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ZECA-BUZURA', 'Matei', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ZECA-BUZURA', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Jim', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('CRUDU', 'Aldous', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Ovidiu', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ZECA-BUZURA', 'J.D.', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('MITCHIEVICI', 'Victor', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Matei', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Florina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('WILSON', 'Ovidiu', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('DUENAS', 'J.D.', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('WILSON', 'Dumitru', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RUSTI', 'Doina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ILIS', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Ovidiu', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SALINGER', 'Matei', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Angelo', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('MITCHIEVICI', 'Helene', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SALINGER', 'Sandra', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('HUXLEY', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('MITCHIEVICI', 'Aldous', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('MITCHIEVICI', 'Aldous', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('HUXLEY', 'Victor', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('CRUDU', 'Angelo', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SUVOROV', 'Vladimir', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('PRALONG', 'Matei', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ZECA-BUZURA', 'Aldous', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('WILSON', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SALINGER', 'Jim', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('DUENAS', 'Sandra', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SUVOROV', 'Dumitru', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('PRALONG', 'Matei', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SUVOROV', 'Dumitru', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('HUXLEY', 'Ovidiu', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Sandra', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SALINGER', 'Victor', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Florina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SUVOROV', 'Vladimir', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SUVOROV', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ZECA-BUZURA', 'Dumitru', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Vladimir', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('POP', 'Angelo', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RUSTI', 'Doina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SALINGER', 'Victor', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('SUVOROV', 'Florina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Victor', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('POP', 'Vladimir', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Aldous', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('PRALONG', 'Dumitru', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Florina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('POP', 'Maria', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RUSTI', 'Victor', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('ILIS', 'Vladimir', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('FLORIAN', 'Sandra', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('PRALONG', 'Daniela', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('DUENAS', 'Jim', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Helene', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('PRALONG', 'Victor', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Helene', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RENAUD', 'Ovidiu', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('CRUDU', 'Aldous', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('DUENAS', 'Vladimir', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('RUSTI', 'Doina', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('POP', 'Ovidiu', '-');
INSERT INTO scriitori (nume, prenume, biografie)
 VALUES('NABOKOV', 'Angelo', '-');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('20', '23');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('39', '66');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('79', '80');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('91', '6');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('65', '86');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('97', '17');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('69', '27');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('50', '17');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('60', '18');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('10', '70');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('40', '57');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('23', '97');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('93', '22');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('90', '2');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('13', '46');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('90', '99');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('34', '40');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('71', '61');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('73', '85');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('48', '91');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('78', '36');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('86', '45');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('59', '17');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('77', '12');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('48', '23');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('44', '87');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('37', '6');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('24', '43');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('50', '21');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('87', '56');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('64', '93');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('80', '31');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('100', '39');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('11', '100');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('86', '51');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('15', '33');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('52', '64');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('23', '18');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('21', '50');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('79', '69');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('73', '40');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('80', '21');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('43', '83');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('47', '50');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('78', '12');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('86', '41');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('61', '52');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('88', '78');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('50', '90');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('8', '99');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('94', '75');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('70', '76');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('55', '47');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('94', '96');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('99', '49');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('74', '19');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('4', '59');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('27', '59');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('34', '28');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('67', '85');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('1', '34');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('78', '1');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('60', '88');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('2', '77');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('24', '87');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('97', '75');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('48', '77');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('4', '27');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('39', '23');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('95', '32');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('40', '34');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('48', '51');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('34', '73');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('19', '82');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('21', '7');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('3', '63');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('68', '89');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('56', '16');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('20', '84');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('34', '96');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('58', '44');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('83', '23');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('25', '44');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('92', '92');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('65', '41');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('28', '92');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('36', '34');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('91', '78');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('10', '47');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('27', '36');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('12', '83');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('25', '55');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('97', '4');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('70', '95');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('50', '93');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('92', '14');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('72', '3');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('81', '76');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('53', '88');
INSERT INTO autori (id_carte, id_scriitor)
 VALUES('88', '69');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('TWN250365', '2008-12-4', 'plasata', '65');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('KVQ462568', '1996-2-9', 'plasata', '18');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('JTO854956', '1992-9-13', 'onorata', '90');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('BMU171189', '2008-10-7', 'plasata', '61');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('WJW997990', '2007-12-21', 'onorata', '59');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('QBL884947', '1992-12-25', 'plasata', '6');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('XRY299620', '1996-12-2', 'plasata', '80');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('FYN892110', '2009-6-21', 'plasata', '33');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('BNW517317', '1990-10-24', 'plasata', '73');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('OEU245242', '1992-7-17', 'plasata', '12');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('KPK487351', '1997-6-10', 'onorata', '8');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('XSY758169', '2005-7-26', 'onorata', '96');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('XXX540018', '1993-11-17', 'plasata', '34');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('CQJ683400', '2003-10-19', 'onorata', '88');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('BBX655286', '2006-11-8', 'onorata', '4');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('BNW968894', '2001-4-14', 'plasata', '51');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('IWS619681', '1990-11-23', 'plasata', '68');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('NFP638119', '1993-2-4', 'onorata', '44');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('HWY985143', '2001-8-15', 'plasata', '28');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('QKI242990', '2007-2-7', 'plasata', '36');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('LHY374754', '2006-8-2', 'plasata', '50');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('RQN809371', '1992-1-1', 'plasata', '88');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('MSX329997', '2005-6-19', 'onorata', '69');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('HQQ623439', '2005-9-28', 'plasata', '54');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('GJP678244', '1995-7-1', 'onorata', '67');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('YEP977854', '1996-2-7', 'plasata', '24');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('UCO988085', '2004-3-5', 'onorata', '56');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('IPK611782', '1993-6-24', 'plasata', '55');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('AYB541690', '1999-3-28', 'onorata', '24');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('OEV189943', '1998-10-16', 'onorata', '66');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('PFF693068', '2000-2-20', 'plasata', '51');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('KKM581500', '2009-7-22', 'onorata', '80');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('NKH795285', '2001-12-28', 'onorata', '10');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('ILR121047', '2005-7-1', 'plasata', '47');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('VJH170623', '1997-12-3', 'onorata', '100');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('MPA468366', '1991-8-20', 'onorata', '12');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('UKK577104', '1990-8-6', 'onorata', '87');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('NXR108657', '1997-7-13', 'plasata', '33');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('MDT379386', '2000-7-6', 'plasata', '86');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('NVA810996', '1998-7-23', 'onorata', '42');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('AYL712714', '1999-4-25', 'plasata', '34');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('RMU402388', '1994-5-15', 'onorata', '70');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('QUS974145', '2008-9-8', 'plasata', '81');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('XUD735117', '1997-11-11', 'plasata', '25');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('NEN792270', '1998-2-25', 'plasata', '57');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('THM341607', '1990-4-7', 'plasata', '90');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('RAX667388', '1999-10-9', 'onorata', '49');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('GCC456933', '2001-6-25', 'onorata', '39');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('IKR328270', '1995-5-30', 'onorata', '31');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('NIY799394', '1992-8-21', 'onorata', '72');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('CMG890828', '1997-2-14', 'onorata', '100');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('SRG139235', '1998-10-28', 'onorata', '45');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('NLA544237', '1990-7-6', 'plasata', '72');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('EBV488580', '1996-9-7', 'plasata', '19');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('PCT322779', '2005-2-21', 'onorata', '46');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('TRA140083', '1991-2-7', 'plasata', '22');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('VXX871451', '1999-3-31', 'onorata', '89');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('HOF836278', '2008-2-23', 'onorata', '13');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('INO783794', '1996-11-17', 'onorata', '38');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('AVQ592812', '2006-10-5', 'onorata', '35');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('SQJ186139', '1991-10-28', 'onorata', '28');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('JXH959355', '1993-12-24', 'onorata', '69');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('JWF188452', '2007-1-21', 'onorata', '30');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('PFO238367', '1995-4-17', 'onorata', '48');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('LLJ902720', '2000-4-24', 'onorata', '81');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('EGC703186', '2007-1-29', 'onorata', '34');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('CFL361735', '2000-7-4', 'onorata', '30');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('WEV326589', '1992-6-19', 'plasata', '53');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('VBF868309', '2008-7-25', 'onorata', '91');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('SAK397193', '2007-5-26', 'plasata', '37');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('YYQ572034', '1997-8-17', 'plasata', '26');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('JKC388482', '1990-10-19', 'onorata', '42');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('LBP889852', '2007-8-5', 'plasata', '91');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('YUG751231', '1998-12-31', 'onorata', '15');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('JEU665281', '1998-6-22', 'onorata', '32');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('XSX640547', '1992-1-30', 'onorata', '58');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('UWC356461', '2002-11-4', 'onorata', '70');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('WKW791830', '2003-10-20', 'onorata', '64');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('NAC155077', '1997-7-26', 'plasata', '98');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('DOK307217', '2009-8-16', 'onorata', '63');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('HPQ229792', '1998-8-18', 'onorata', '82');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('QUP496370', '1995-7-17', 'onorata', '87');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('XJF750265', '1992-3-11', 'plasata', '21');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('DQY683113', '2002-12-9', 'onorata', '68');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('FSS417318', '2005-9-27', 'onorata', '75');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('ECW408978', '1997-6-25', 'plasata', '50');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('LLB730879', '2003-1-9', 'plasata', '22');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('RQJ908025', '2002-9-2', 'plasata', '60');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('RPO508496', '1997-11-15', 'plasata', '64');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('URY572585', '2001-1-6', 'plasata', '43');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('BOM667751', '2008-3-31', 'onorata', '34');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('TXA708208', '2008-3-16', 'onorata', '74');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('WAS854578', '1995-1-20', 'plasata', '35');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('RDB241785', '2005-11-7', 'onorata', '58');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('KTJ168257', '2004-5-17', 'onorata', '46');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('UCQ973858', '2006-1-28', 'plasata', '9');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('WFW969026', '1999-12-26', 'onorata', '9');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('TED579469', '1990-12-30', 'plasata', '78');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('SST437257', '1996-8-5', 'onorata', '100');
INSERT INTO comenzi_aprovizionare (serie_numar, data, stare, id_editura)
 VALUES('CSC746070', '2008-10-21', 'plasata', '73');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('20', '23', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('66', '79', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('91', '6', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('86', '97', '7');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('69', '27', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('17', '60', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('10', '70', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('57', '23', '7');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('93', '22', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('2', '13', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('90', '99', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('40', '71', '1');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('73', '85', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('91', '78', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('86', '45', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('17', '77', '2');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('48', '23', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('87', '37', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('24', '43', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('21', '87', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('64', '93', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('31', '100', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('11', '100', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('51', '15', '3');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('52', '64', '3');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('18', '21', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('79', '69', '3');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('40', '80', '1');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('43', '83', '7');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('50', '78', '2');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('86', '41', '1');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('52', '88', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('50', '90', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('99', '94', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('70', '76', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('47', '94', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('99', '49', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('19', '4', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('27', '59', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('28', '67', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('1', '34', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('1', '60', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('2', '77', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('87', '97', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('48', '77', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('27', '39', '3');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('95', '32', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('34', '48', '1');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('34', '73', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('82', '21', '7');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('3', '63', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('89', '56', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('20', '84', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('96', '58', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('83', '23', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('44', '92', '2');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('65', '41', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('92', '36', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('91', '78', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('47', '27', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('12', '83', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('55', '97', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('70', '95', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('93', '92', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('72', '3', '1');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('76', '53', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('88', '69', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('98', '56', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('69', '85', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('58', '92', '7');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('40', '16', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('58', '83', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('82', '35', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('45', '26', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('72', '56', '7');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('50', '55', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('55', '87', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('51', '71', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('96', '78', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('86', '95', '7');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('12', '67', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('34', '66', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('83', '24', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('94', '80', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('76', '25', '2');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('91', '50', '9');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('66', '81', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('90', '55', '7');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('44', '49', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('74', '45', '6');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('41', '31', '1');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('69', '91', '8');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('96', '86', '1');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('36', '61', '3');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('1', '20', '5');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('71', '97', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('89', '36', '3');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('86', '72', '4');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('72', '57', '10');
INSERT INTO detalii_comanda_aprovizionare (id_comanda_aprovizionare, id_carte, cantitate)
 VALUES('9', '62', '8');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1220713379378', 'ZOTA', 'Daniel', '-', '0', 'zota.daniel@google.com', 'client inregistrat', 'client', 'zota.daniel', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1160121873449', 'NEGREANU', 'Mircea', '-', '0', 'negreanu.mircea@hotmail.com', 'client inregistrat', 'client', 'negreanu.mircea', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1560330668692', 'ROGOBETE', 'Mircea', '-', '0', 'rogobete.mircea@live.com', 'super-administrator', 'administrator', 'rogobete.mircea', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2981007225570', 'GIUMALE', 'Petre', '-', '0', 'giumale.petre@yahoo.com', 'administrator obisnuit', 'administrator', 'giumale.petre', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1350615180258', 'DRAGUSIN', 'Camelia', '-', '0', 'dragusin.camelia@live.com', 'administrator obisnuit', 'administrator', 'dragusin.camelia', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1860926240323', 'IONESCU', 'Tudor', '-', '0', 'ionescu.tudor@google.com', 'administrator obisnuit', 'administrator', 'ionescu.tudor', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1921202602499', 'GEORGESCU', 'Monica', '-', '0', 'georgescu.monica@yahoo.com', 'client inregistrat', 'client', 'georgescu.monica', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1320810148322', 'POPA', 'Monica', '-', '0', 'popa.monica@yahoo.com', 'super-administrator', 'administrator', 'popa.monica', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2390831245242', 'CHIVU', 'Camelia', '-', '0', 'chivu.camelia@yahoo.com', 'super-administrator', 'administrator', 'chivu.camelia', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1400515716087', 'POPA', 'Cristina', '-', '0', 'popa.cristina@yahoo.com', 'super-administrator', 'administrator', 'popa.cristina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2740606757054', 'VASILESCU', 'Radu', '-', '0', 'vasilescu.radu@google.com', 'administrator obisnuit', 'administrator', 'vasilescu.radu', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1181216988226', 'POPESCU', 'Ioana', '-', '0', 'popescu.ioana@hotmail.com', 'client inregistrat', 'client', 'popescu.ioana', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1331019521959', 'VOITAN', 'Otilia', '-', '0', 'voitan.otilia@live.com', 'client inregistrat', 'client', 'voitan.otilia', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2740822491303', 'NEGREANU', 'Corina', '-', '0', 'negreanu.corina@hotmail.com', 'client inregistrat', 'client', 'negreanu.corina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1330818720833', 'RUSU', 'Teodora', '-', '0', 'rusu.teodora@live.com', 'administrator obisnuit', 'administrator', 'rusu.teodora', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1621205967255', 'NECULA', 'Cristina', '-', '0', 'necula.cristina@oracle.com', 'client inregistrat', 'client', 'necula.cristina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2430329797024', 'SERBAN', 'David', '-', '0', 'serban.david@live.com', 'client inregistrat', 'client', 'serban.david', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2910414242990', 'DUMITRESCU', 'Mircea', '-', '0', 'dumitrescu.mircea@live.com', 'administrator obisnuit', 'administrator', 'dumitrescu.mircea', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2820915291696', 'IONASCU', 'Tudor', '-', '0', 'ionascu.tudor@yahoo.com', 'client inregistrat', 'client', 'ionascu.tudor', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1130423330580', 'NECULA', 'Ana Maria', '-', '0', 'necula.ana maria@hotmail.com', 'client verificat', 'client', 'necula.ana maria', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1970809923368', 'SPIRIDON', 'Mihai', '-', '0', 'spiridon.mihai@hotmail.com', 'client verificat', 'client', 'spiridon.mihai', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1150928544482', 'SERBAN', 'David', '-', '0', 'serban.david@yahoo.com', 'client verificat', 'client', 'serban.david', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2580801528666', 'GHICA', 'Beatrice', '-', '0', 'ghica.beatrice@google.com', 'administrator obisnuit', 'administrator', 'ghica.beatrice', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2500719929795', 'POPA', 'Iuliana', '-', '0', 'popa.iuliana@google.com', 'super-administrator', 'administrator', 'popa.iuliana', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2661201667465', 'TURCU', 'Elena', '-', '0', 'turcu.elena@oracle.com', 'client verificat', 'client', 'turcu.elena', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1540425940501', 'ANASTASOAIE', 'Tudor', '-', '0', 'anastasoaie.tudor@oracle.com', 'client verificat', 'client', 'anastasoaie.tudor', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2890709189943', 'ZARNESCU', 'Cristina', '-', '0', 'zarnescu.cristina@oracle.com', 'client inregistrat', 'client', 'zarnescu.cristina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1300711575690', 'DUMITRESCU', 'Bogdan', '-', '0', 'dumitrescu.bogdan@google.com', 'client inregistrat', 'client', 'dumitrescu.bogdan', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1120105869914', 'RADULESCU', 'Sofia', '-', '0', 'radulescu.sofia@yahoo.com', 'client verificat', 'client', 'radulescu.sofia', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2850817517871', 'NEGREANU', 'Cristina', '-', '0', 'negreanu.cristina@oracle.com', 'administrator obisnuit', 'administrator', 'negreanu.cristina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1350701636938', 'DRAGUSIN', 'Otilia', '-', '0', 'dragusin.otilia@yahoo.com', 'super-administrator', 'administrator', 'dragusin.otilia', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2270726710599', 'DUMITRESCU', 'Monica', '-', '0', 'dumitrescu.monica@google.com', 'client inregistrat', 'client', 'dumitrescu.monica', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1980922458745', 'TURCU', 'Adrian', '-', '0', 'turcu.adrian@yahoo.com', 'client verificat', 'client', 'turcu.adrian', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1300312901748', 'RUSU', 'Maria', '-', '0', 'rusu.maria@hotmail.com', 'administrator obisnuit', 'administrator', 'rusu.maria', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1321027480319', 'VASILESCU', 'Adrian', '-', '0', 'vasilescu.adrian@live.com', 'super-administrator', 'administrator', 'vasilescu.adrian', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2630325810996', 'ZARNESCU', 'Sebastian', '-', '0', 'zarnescu.sebastian@oracle.com', 'client inregistrat', 'client', 'zarnescu.sebastian', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1490122685489', 'ROGOBETE', 'Sebastian', '-', '0', 'rogobete.sebastian@hotmail.com', 'administrator obisnuit', 'administrator', 'rogobete.sebastian', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2200109123812', 'ZARNESCU', 'Teodora', '-', '0', 'zarnescu.teodora@yahoo.com', 'super-administrator', 'administrator', 'zarnescu.teodora', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1450302901997', 'GEORGESCU', 'Monica', '-', '0', 'georgescu.monica@oracle.com', 'administrator obisnuit', 'administrator', 'georgescu.monica', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2071111112867', 'SPIRIDON', 'Andrei', '-', '0', 'spiridon.andrei@yahoo.com', 'administrator obisnuit', 'administrator', 'spiridon.andrei', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1650927806356', 'MARINESCU', 'Petre', '-', '0', 'marinescu.petre@hotmail.com', 'client inregistrat', 'client', 'marinescu.petre', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2060703434517', 'CRISTEA', 'Andrei', '-', '0', 'cristea.andrei@oracle.com', 'super-administrator', 'administrator', 'cristea.andrei', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1870530873877', 'RUSU', 'Radu', '-', '0', 'rusu.radu@live.com', 'client inregistrat', 'client', 'rusu.radu', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2381126456867', 'ANASTASOAIE', 'Bogdan', '-', '0', 'anastasoaie.bogdan@oracle.com', 'client verificat', 'client', 'anastasoaie.bogdan', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2630920799394', 'IONESCU', 'Ioana', '-', '0', 'ionescu.ioana@google.com', 'client verificat', 'client', 'ionescu.ioana', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1870929869947', 'RADIAN', 'Cristina', '-', '0', 'radian.cristina@hotmail.com', 'administrator obisnuit', 'administrator', 'radian.cristina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1560824600673', 'RUSU', 'Petre', '-', '0', 'rusu.petre@yahoo.com', 'administrator obisnuit', 'administrator', 'rusu.petre', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2370516807384', 'SPIRIDON', 'David', '-', '0', 'spiridon.david@yahoo.com', 'client inregistrat', 'client', 'spiridon.david', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2660907515008', 'ZARNESCU', 'Simona', '-', '0', 'zarnescu.simona@hotmail.com', 'super-administrator', 'administrator', 'zarnescu.simona', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1410117346945', 'SPIRIDON', 'Petre', '-', '0', 'spiridon.petre@google.com', 'client verificat', 'client', 'spiridon.petre', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2141013594821', 'IONASCU', 'Radu', '-', '0', 'ionascu.radu@live.com', 'client verificat', 'client', 'ionascu.radu', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1030518483814', 'NECULA', 'Mihai', '-', '0', 'necula.mihai@oracle.com', 'super-administrator', 'administrator', 'necula.mihai', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2120107552289', 'COJOC', 'Madalina', '-', '0', 'cojoc.madalina@oracle.com', 'client verificat', 'client', 'cojoc.madalina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2750917592812', 'NEGREANU', 'Stefan', '-', '0', 'negreanu.stefan@hotmail.com', 'client verificat', 'client', 'negreanu.stefan', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1410610827041', 'VOITAN', 'David', '-', '0', 'voitan.david@oracle.com', 'client verificat', 'client', 'voitan.david', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1321227859623', 'GEORGESCU', 'Madalina', '-', '0', 'georgescu.madalina@oracle.com', 'super-administrator', 'administrator', 'georgescu.madalina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1521012819968', 'RUSU', 'Tudor', '-', '0', 'rusu.tudor@google.com', 'client inregistrat', 'client', 'rusu.tudor', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2050417887614', 'VOITAN', 'Alexandra', '-', '0', 'voitan.alexandra@live.com', 'administrator obisnuit', 'administrator', 'voitan.alexandra', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1391229490780', 'COJOC', 'David', '-', '0', 'cojoc.david@hotmail.com', 'administrator obisnuit', 'administrator', 'cojoc.david', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2510822963727', 'RADULESCU', 'Sofia', '-', '0', 'radulescu.sofia@google.com', 'super-administrator', 'administrator', 'radulescu.sofia', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2830211466179', 'DRAGUSIN', 'Tudor', '-', '0', 'dragusin.tudor@hotmail.com', 'administrator obisnuit', 'administrator', 'dragusin.tudor', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1520602820080', 'GHICA', 'Corina', '-', '0', 'ghica.corina@hotmail.com', 'administrator obisnuit', 'administrator', 'ghica.corina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1931004397193', 'DUMITRESCU', 'Madalina', '-', '0', 'dumitrescu.madalina@live.com', 'super-administrator', 'administrator', 'dumitrescu.madalina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1490219623887', 'IONASCU', 'Beatrice', '-', '0', 'ionascu.beatrice@oracle.com', 'super-administrator', 'administrator', 'ionascu.beatrice', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1770318259801', 'RADIAN', 'Camelia', '-', '0', 'radian.camelia@live.com', 'client verificat', 'client', 'radian.camelia', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2520614847926', 'CRISTEA', 'Monica', '-', '0', 'cristea.monica@yahoo.com', 'client verificat', 'client', 'cristea.monica', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2281231742918', 'SPIRIDON', 'Sebastian', '-', '0', 'spiridon.sebastian@yahoo.com', 'super-administrator', 'administrator', 'spiridon.sebastian', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1610414451631', 'SERBAN', 'Andrei', '-', '0', 'serban.andrei@oracle.com', 'client inregistrat', 'client', 'serban.andrei', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2620527902045', 'RUSU', 'Stefan', '-', '0', 'rusu.stefan@live.com', 'client inregistrat', 'client', 'rusu.stefan', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1790213606335', 'CHIVU', 'Adrian', '-', '0', 'chivu.adrian@oracle.com', 'super-administrator', 'administrator', 'chivu.adrian', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2630901730552', 'VOITAN', 'Catalin', '-', '0', 'voitan.catalin@live.com', 'client inregistrat', 'client', 'voitan.catalin', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1281014307217', 'RADIAN', 'Mircea', '-', '0', 'radian.mircea@yahoo.com', 'client inregistrat', 'client', 'radian.mircea', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2150728946928', 'TURCU', 'Mihai', '-', '0', 'turcu.mihai@live.com', 'administrator obisnuit', 'administrator', 'turcu.mihai', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2651116616210', 'ZOTA', 'David', '-', '0', 'zota.david@live.com', 'super-administrator', 'administrator', 'zota.david', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2651121797808', 'GIUMALE', 'Monica', '-', '0', 'giumale.monica@oracle.com', 'client inregistrat', 'client', 'giumale.monica', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2921209341492', 'DUMITRESCU', 'Daniel', '-', '0', 'dumitrescu.daniel@oracle.com', 'administrator obisnuit', 'administrator', 'dumitrescu.daniel', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1880904904674', 'ZOTA', 'Elena', '-', '0', 'zota.elena@hotmail.com', 'client inregistrat', 'client', 'zota.elena', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1240430792786', 'NEGREANU', 'Alexandra', '-', '0', 'negreanu.alexandra@yahoo.com', 'administrator obisnuit', 'administrator', 'negreanu.alexandra', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2650221674216', 'COJOC', 'Bogdan', '-', '0', 'cojoc.bogdan@hotmail.com', 'client verificat', 'client', 'cojoc.bogdan', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1591029305614', 'NEGREANU', 'Catalin', '-', '0', 'negreanu.catalin@live.com', 'super-administrator', 'administrator', 'negreanu.catalin', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1450425572585', 'BALACEANU', 'Elena', '-', '0', 'balaceanu.elena@google.com', 'administrator obisnuit', 'administrator', 'balaceanu.elena', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2391102174778', 'VASILESCU', 'Simona', '-', '0', 'vasilescu.simona@yahoo.com', 'client verificat', 'client', 'vasilescu.simona', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1750130868614', 'CIULU', 'Simona', '-', '0', 'ciulu.simona@oracle.com', 'client verificat', 'client', 'ciulu.simona', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1780209877809', 'RADULESCU', 'Iuliana', '-', '0', 'radulescu.iuliana@hotmail.com', 'administrator obisnuit', 'administrator', 'radulescu.iuliana', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1751107394472', 'DUMITRESCU', 'Monica', '-', '0', 'dumitrescu.monica@yahoo.com', 'client inregistrat', 'client', 'dumitrescu.monica', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2200817266945', 'NECULA', 'Catalin', '-', '0', 'necula.catalin@live.com', 'super-administrator', 'administrator', 'necula.catalin', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1380703444247', 'ANASTASOAIE', 'Petre', '-', '0', 'anastasoaie.petre@live.com', 'super-administrator', 'administrator', 'anastasoaie.petre', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2600105164679', 'CIULU', 'Cristina', '-', '0', 'ciulu.cristina@google.com', 'administrator obisnuit', 'administrator', 'ciulu.cristina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1770419894569', 'VOITAN', 'Madalina', '-', '0', 'voitan.madalina@yahoo.com', 'administrator obisnuit', 'administrator', 'voitan.madalina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1270727746070', 'ZARNESCU', 'Otilia', '-', '0', 'zarnescu.otilia@yahoo.com', 'super-administrator', 'administrator', 'zarnescu.otilia', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1091129638516', 'ILNOIU', 'Cristina', '-', '0', 'ilnoiu.cristina@google.com', 'client inregistrat', 'client', 'ilnoiu.cristina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1580607546677', 'MARINESCU', 'Madalina', '-', '0', 'marinescu.madalina@google.com', 'super-administrator', 'administrator', 'marinescu.madalina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1370423106114', 'GHICA', 'Beatrice', '-', '0', 'ghica.beatrice@yahoo.com', 'client inregistrat', 'client', 'ghica.beatrice', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1030111576132', 'IONASCU', 'Radu', '-', '0', 'ionascu.radu@google.com', 'client verificat', 'client', 'ionascu.radu', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2160817673952', 'NEGREANU', 'Madalina', '-', '0', 'negreanu.madalina@yahoo.com', 'client inregistrat', 'client', 'negreanu.madalina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('2860918487035', 'SERBAN', 'Mihai', '-', '0', 'serban.mihai@live.com', 'client inregistrat', 'client', 'serban.mihai', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1421121471699', 'MARINESCU', 'Bogdan', '-', '0', 'marinescu.bogdan@oracle.com', 'client verificat', 'client', 'marinescu.bogdan', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1860318200783', 'RUSU', 'Corina', '-', '0', 'rusu.corina@hotmail.com', 'super-administrator', 'administrator', 'rusu.corina', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1940503835624', 'DRAGUSIN', 'Teodora', '-', '0', 'dragusin.teodora@oracle.com', 'administrator obisnuit', 'administrator', 'dragusin.teodora', '-');
INSERT INTO utilizatori (CNP, nume, prenume, adresa, telefon, email, tip, rol, nume_utilizator, parola)
 VALUES('1580802702610', 'VASILESCU', 'David', '-', '0', 'vasilescu.david@oracle.com', 'administrator obisnuit', 'administrator', 'vasilescu.david', '-');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('TWN250365', '2008-12-4', 'emisa', '1770318259801');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('KVQ462568', '1996-2-9', 'emisa', '2910414242990');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('JTO854956', '1992-9-13', 'achitata', '1270727746070');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('BMU171189', '2008-10-7', 'emisa', '2830211466179');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('WJW997990', '2007-12-21', 'achitata', '1391229490780');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('QBL884947', '1992-12-25', 'emisa', '1860926240323');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('XRY299620', '1996-12-2', 'emisa', '1591029305614');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('FYN892110', '2009-6-21', 'emisa', '1980922458745');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('BNW517317', '1990-10-24', 'emisa', '2150728946928');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('OEU245242', '1992-7-17', 'emisa', '1181216988226');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('KPK487351', '1997-6-10', 'achitata', '1320810148322');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('XSY758169', '2005-7-26', 'achitata', '2860918487035');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('XXX540018', '1993-11-17', 'emisa', '1300312901748');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('CQJ683400', '2003-10-19', 'achitata', '2600105164679');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('BBX655286', '2006-11-8', 'achitata', '2981007225570');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('BNW968894', '2001-4-14', 'emisa', '2141013594821');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('IWS619681', '1990-11-23', 'emisa', '1610414451631');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('NFP638119', '1993-2-4', 'achitata', '2381126456867');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('HWY985143', '2001-8-15', 'emisa', '1300711575690');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('QKI242990', '2007-2-7', 'emisa', '2630325810996');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('LHY374754', '2006-8-2', 'emisa', '1410117346945');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('RQN809371', '1992-1-1', 'emisa', '2600105164679');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('MSX329997', '2005-6-19', 'achitata', '2620527902045');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('HQQ623439', '2005-9-28', 'emisa', '2750917592812');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('GJP678244', '1995-7-1', 'achitata', '2281231742918');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('YEP977854', '1996-2-7', 'emisa', '2500719929795');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('UCO988085', '2004-3-5', 'achitata', '1321227859623');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('IPK611782', '1993-6-24', 'emisa', '1410610827041');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('AYB541690', '1999-3-28', 'achitata', '2500719929795');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('OEV189943', '1998-10-16', 'achitata', '2520614847926');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('PFF693068', '2000-2-20', 'emisa', '2141013594821');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('KKM581500', '2009-7-22', 'achitata', '1591029305614');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('NKH795285', '2001-12-28', 'achitata', '1400515716087');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('ILR121047', '2005-7-1', 'emisa', '1560824600673');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('VJH170623', '1997-12-3', 'achitata', '1580802702610');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('MPA468366', '1991-8-20', 'achitata', '1181216988226');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('UKK577104', '1990-8-6', 'achitata', '1380703444247');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('NXR108657', '1997-7-13', 'emisa', '1980922458745');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('MDT379386', '2000-7-6', 'emisa', '2200817266945');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('NVA810996', '1998-7-23', 'achitata', '2060703434517');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('AYL712714', '1999-4-25', 'emisa', '1300312901748');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('RMU402388', '1994-5-15', 'achitata', '1790213606335');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('QUS974145', '2008-9-8', 'emisa', '1450425572585');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('XUD735117', '1997-11-11', 'emisa', '2661201667465');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('NEN792270', '1998-2-25', 'emisa', '1521012819968');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('THM341607', '1990-4-7', 'emisa', '1270727746070');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('RAX667388', '1999-10-9', 'achitata', '2660907515008');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('GCC456933', '2001-6-25', 'achitata', '1450302901997');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('IKR328270', '1995-5-30', 'achitata', '1350701636938');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('NIY799394', '1992-8-21', 'achitata', '1281014307217');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('CMG890828', '1997-2-14', 'achitata', '1580802702610');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('SRG139235', '1998-10-28', 'achitata', '2630920799394');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('NLA544237', '1990-7-6', 'emisa', '1281014307217');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('EBV488580', '1996-9-7', 'emisa', '2820915291696');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('PCT322779', '2005-2-21', 'achitata', '1870929869947');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('TRA140083', '1991-2-7', 'emisa', '1150928544482');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('VXX871451', '1999-3-31', 'achitata', '1770419894569');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('HOF836278', '2008-2-23', 'achitata', '1331019521959');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('INO783794', '1996-11-17', 'achitata', '2200109123812');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('AVQ592812', '2006-10-5', 'achitata', '1321027480319');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('SQJ186139', '1991-10-28', 'achitata', '1300711575690');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('JXH959355', '1993-12-24', 'achitata', '2620527902045');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('JWF188452', '2007-1-21', 'achitata', '2850817517871');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('PFO238367', '1995-4-17', 'achitata', '2370516807384');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('LLJ902720', '2000-4-24', 'achitata', '1450425572585');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('EGC703186', '2007-1-29', 'achitata', '1300312901748');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('CFL361735', '2000-7-4', 'achitata', '2850817517871');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('WEV326589', '1992-6-19', 'emisa', '2120107552289');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('VBF868309', '2008-7-25', 'achitata', '1091129638516');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('SAK397193', '2007-5-26', 'emisa', '1490122685489');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('YYQ572034', '1997-8-17', 'emisa', '1540425940501');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('JKC388482', '1990-10-19', 'achitata', '2060703434517');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('LBP889852', '2007-8-5', 'emisa', '1091129638516');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('YUG751231', '1998-12-31', 'achitata', '1330818720833');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('JEU665281', '1998-6-22', 'achitata', '2270726710599');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('XSX640547', '1992-1-30', 'achitata', '2050417887614');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('UWC356461', '2002-11-4', 'achitata', '1790213606335');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('WKW791830', '2003-10-20', 'achitata', '1490219623887');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('NAC155077', '1997-7-26', 'emisa', '1860318200783');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('DOK307217', '2009-8-16', 'achitata', '1931004397193');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('HPQ229792', '1998-8-18', 'achitata', '2391102174778');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('QUP496370', '1995-7-17', 'achitata', '1380703444247');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('XJF750265', '1992-3-11', 'emisa', '1970809923368');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('DQY683113', '2002-12-9', 'achitata', '1610414451631');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('FSS417318', '2005-9-27', 'achitata', '2651121797808');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('ECW408978', '1997-6-25', 'emisa', '1410117346945');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('LLB730879', '2003-1-9', 'emisa', '1150928544482');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('RQJ908025', '2002-9-2', 'emisa', '2510822963727');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('RPO508496', '1997-11-15', 'emisa', '1490219623887');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('URY572585', '2001-1-6', 'emisa', '1870530873877');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('BOM667751', '2008-3-31', 'achitata', '1300312901748');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('TXA708208', '2008-3-16', 'achitata', '2651116616210');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('WAS854578', '1995-1-20', 'emisa', '1321027480319');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('RDB241785', '2005-11-7', 'achitata', '2050417887614');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('KTJ168257', '2004-5-17', 'achitata', '1870929869947');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('UCQ973858', '2006-1-28', 'emisa', '2390831245242');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('WFW969026', '1999-12-26', 'achitata', '2390831245242');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('TED579469', '1990-12-30', 'emisa', '1240430792786');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('SST437257', '1996-8-5', 'achitata', '1580802702610');
INSERT INTO facturi (serie_numar, data, stare, CNP)
 VALUES('CSC746070', '2008-10-21', 'emisa', '2150728946928');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('20', '23', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('66', '79', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('91', '6', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('86', '97', '7');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('69', '27', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('17', '60', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('10', '70', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('57', '23', '7');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('93', '22', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('2', '13', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('90', '99', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('40', '71', '1');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('73', '85', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('91', '78', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('86', '45', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('17', '77', '2');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('48', '23', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('87', '37', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('24', '43', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('21', '87', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('64', '93', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('31', '100', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('11', '100', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('51', '15', '3');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('52', '64', '3');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('18', '21', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('79', '69', '3');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('40', '80', '1');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('43', '83', '7');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('50', '78', '2');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('86', '41', '1');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('52', '88', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('50', '90', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('99', '94', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('70', '76', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('47', '94', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('99', '49', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('19', '4', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('27', '59', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('28', '67', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('1', '34', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('1', '60', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('2', '77', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('87', '97', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('48', '77', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('27', '39', '3');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('95', '32', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('34', '48', '1');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('34', '73', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('82', '21', '7');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('3', '63', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('89', '56', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('20', '84', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('96', '58', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('83', '23', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('44', '92', '2');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('65', '41', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('92', '36', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('91', '78', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('47', '27', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('12', '83', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('55', '97', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('70', '95', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('93', '92', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('72', '3', '1');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('76', '53', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('88', '69', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('98', '56', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('69', '85', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('58', '92', '7');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('40', '16', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('58', '83', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('82', '35', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('45', '26', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('72', '56', '7');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('50', '55', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('55', '87', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('51', '71', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('96', '78', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('86', '95', '7');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('12', '67', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('34', '66', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('83', '24', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('94', '80', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('76', '25', '2');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('91', '50', '9');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('66', '81', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('90', '55', '7');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('44', '49', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('74', '45', '6');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('41', '31', '1');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('69', '91', '8');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('96', '86', '1');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('36', '61', '3');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('1', '20', '5');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('71', '97', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('89', '36', '3');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('86', '72', '4');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('72', '57', '10');
INSERT INTO detalii_factura (id_factura, id_carte, cantitate)
 VALUES('59', '62', '8');

DELIMITER //
CREATE FUNCTION calculate_supply_order_value (
	serie_numar VARCHAR(10)
)
RETURNS DECIMAL(12,2)
BEGIN
	DECLARE result DECIMAL(12,2);
	SELECT SUM(dca.cantitate*c.pret) INTO result FROM comenzi_aprovizionare ca, detalii_comanda_aprovizionare dca, carti c
	WHERE ca.serie_numar=serie_numar AND dca.id_comanda_aprovizionare=ca.id_comanda_aprovizionare AND c.id_carte=dca.id_carte;
	RETURN result;
END; //

DELIMITER //
CREATE FUNCTION calculate_bill_value (
	serie_numar VARCHAR(10)
)
RETURNS DECIMAL(12,2)
BEGIN
	DECLARE result DECIMAL(12,2);
	SELECT SUM(df.cantitate*c.pret) INTO result FROM facturi f, detalii_factura df, carti c
	WHERE f.serie_numar=serie_numar AND df.id_factura=f.id_factura AND c.id_carte=df.id_carte;
	RETURN result;
END; //

DELIMITER //
CREATE PROCEDURE calculate_user_total_bill_value (
	IN CNP BIGINT(13),
	OUT total_bill_value DECIMAL(12,2)
)
BEGIN
	SELECT SUM(calculate_bill_value(serie_numar)) INTO total_bill_value FROM facturi f WHERE f.CNP=CNP;
	SELECT serie_numar, calculate_bill_value(serie_numar), data FROM facturi f WHERE f.CNP=CNP ORDER BY data ASC;
	SELECT CONCAT('Valoare Totala : ',total_bill_value,' RON'); 
END; //
