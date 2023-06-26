-- libridb.autori definition

CREATE TABLE `autori` (
  `CodiceA` int NOT NULL AUTO_INCREMENT,
  `NomeA` varchar(50) DEFAULT NULL,
  `CognomeA` varchar(50) DEFAULT NULL,
  `AnnoN` int DEFAULT NULL,
  `AnnoM` int DEFAULT NULL,
  `Sesso` char(1) DEFAULT NULL,
  `Nazione` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CodiceA`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- libridb.editore definition

CREATE TABLE `editore` (
  `CodiceE` int NOT NULL,
  `nome` varchar(55) DEFAULT NULL,
  `sede` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`CodiceE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- libridb.genere definition

CREATE TABLE `genere` (
  `codiceG` int NOT NULL,
  `descrizione` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`codiceG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- libridb.libri definition

CREATE TABLE `libri` (
  `CodiceR` int NOT NULL AUTO_INCREMENT,
  `Titolo` varchar(100) DEFAULT NULL,
  `CodiceA` int DEFAULT NULL,
  `numPag` int DEFAULT NULL,
  `Anno` int DEFAULT NULL,
  `CodiceG` int DEFAULT NULL,
  `CodiceE` int DEFAULT NULL,
  PRIMARY KEY (`CodiceR`),
  KEY `CodiceA` (`CodiceA`),
  KEY `fk_genere` (`CodiceG`),
  KEY `fk_editore` (`CodiceE`),
  CONSTRAINT `fk_editore` FOREIGN KEY (`CodiceE`) REFERENCES `editore` (`CodiceE`),
  CONSTRAINT `fk_genere` FOREIGN KEY (`CodiceG`) REFERENCES `genere` (`codiceG`),
  CONSTRAINT `libri_ibfk_1` FOREIGN KEY (`CodiceA`) REFERENCES `autori` (`CodiceA`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO libridb.autori (NomeA,CognomeA,AnnoN,AnnoM,Sesso,Nazione) VALUES
	 ('Alessandro','Manzoni',1785,1873,'M','Italia'),
	 ('Lev','Tolstoj',1828,1910,'M','Russia'),
	 ('Bruno','Vespa',1944,NULL,'M','Italia'),
	 ('Stephen','King',1947,NULL,'M','USA'),
	 ('Ernest','Hemingway',1899,1961,'M','USA'),
	 ('Umberto','Eco',1932,2016,'M','Italia'),
	 ('Susanna','Tamaro',1957,NULL,'F','Italia'),
	 ('Virginia','Woolf',1882,1941,'F','UK'),
	 ('Agatha','Cristie',1890,1976,'F','UK');
INSERT INTO libridb.editore (CodiceE,nome,sede) VALUES
	 (1,'Rizzoli','Roma'),
	 (2,'Mondadori','Milano');
INSERT INTO libridb.genere (codiceG,descrizione) VALUES
	 (1,'Gialli'),
	 (2,'Horror'),
	 (3,'Storici'),
	 (4,'Romanzi');
INSERT INTO libridb.libri (Titolo,CodiceA,numPag,Anno,CodiceG,CodiceE) VALUES
	 ('I promessi sposi',1,571,1825,4,1),
	 ('Storia della colonna infame',1,144,1840,3,1),
	 ('Guerra e pace',2,1415,1867,3,1),
	 ('Anna Karenina',2,1120,1875,4,1),
	 ('Donne al potere',3,272,2022,4,1),
	 ('La grande tempesta',3,408,2022,4,1),
	 ('Misery',4,392,1987,2,2),
	 ('IT',4,1315,1986,2,2),
	 ('Shining',4,592,1980,2,2),
	 ('Il vecchio e il mare',5,204,1951,4,1);
INSERT INTO libridb.libri (Titolo,CodiceA,numPag,Anno,CodiceG,CodiceE) VALUES
	 ('Per chi suona la campana',5,518,1943,4,1),
	 ('Fiesta',5,243,1926,4,1),
	 ('Il nome della rosa',6,624,1980,1,1),
	 ('Il pendolo di Foucault',6,704,1851,4,1),
	 ('Va dove ti porta il cuore',7,192,1994,4,1),
	 ('Gita al faro',8,280,1927,4,1),
	 ('Orlando',8,272,1928,4,1),
	 ('Assassinio sull''Orient Express',9,64,1934,1,1),
	 ('Sipario',9,199,1946,1,1);


CREATE DEFINER=`root`@`localhost` FUNCTION `libridb`.`get_age_by_name`(nome VARCHAR(55), cognome VARCHAR(55)) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE eta INT;
    SELECT YEAR(CURRENT_DATE()) - AnnoN INTO eta
    FROM autori
    WHERE nomeA = nome AND cognomeA = cognome;
    RETURN eta;
END;

CREATE PROCEDURE libridb.get_autori_by_nazione(in nazioneA varchar(55))
begin
drop table if exists autori_eta_temp;
create temporary table autori_eta_temp (nome varchar(55), cognome varchar(55), eta int );
insert into autori_eta_temp(nome,cognome,eta) select nomeA, cognomeA, get_age_by_name(nomeA,cognomeA) as eta 
from autori 
where nazioneA=nazione and AnnoM is null ;
select * from autori_eta_temp;
END;
