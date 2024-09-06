/*Version la plus à jour*/


USE master
GO
--CREATE DATABASE CasernePompier
--GO
USE CasernePompier
GO

DROP TABLE IF EXISTS RépondreIncendie;
DROP TABLE IF EXISTS AvoirHoraire;
DROP TABLE IF EXISTS Horaire;
DROP TABLE IF EXISTS Pompier;
DROP TABLE IF EXISTS Equipement;
DROP TABLE IF EXISTS Vehicule;
DROP TABLE IF EXISTS Incendie;
DROP TABLE IF EXISTS Equipe;
DROP TABLE IF EXISTS Secteur;
DROP TABLE IF EXISTS Caserne;
GO

CREATE TABLE Caserne (
	id_caserne VARCHAR(10) NOT NULL PRIMARY KEY,
	Adresse VARCHAR(50) NOT NULL,
	Num_Tel VARCHAR(10)
);


CREATE TABLE Secteur (
	id_secteur VARCHAR(10) NOT NULL,
	Nom_secteur VARCHAR(30) NOT NULL,
	Surface FLOAT,
	id_caserne VARCHAR(10),
	CONSTRAINT pk_Secteur PRIMARY KEY(id_secteur),
	CONSTRAINT fk_Caserne FOREIGN KEY(id_caserne) REFERENCES Caserne(id_caserne)
);


CREATE TABLE Equipe (
	id_Equipe VARCHAR(10) PRIMARY KEY,
	id_caserne VARCHAR(10),
	CONSTRAINT fk_Caserne_Equipe FOREIGN KEY(id_caserne) REFERENCES Caserne(id_caserne)
);

CREATE TABLE Pompier (
	NAS VARCHAR(10) NOT NULL PRIMARY KEY,
	Nom VARCHAR(10),
	Prenom VARCHAR(10),
	Grade VARCHAR(20),
	id_Equipe VARCHAR(10),
	CONSTRAINT fk_Equipe FOREIGN KEY(id_Equipe) REFERENCES Equipe(id_Equipe)
);

CREATE TABLE Incendie (
	id_incendie VARCHAR(3) NOT NULL PRIMARY KEY ,
	classification  VARCHAR(50) NOT NULL,
	type VARCHAR(50) NOT NULL,
	niveau_risque  VARCHAR(20) NOT NULL, 
	adresse VARCHAR(100) NOT NULL,
	id_secteur VARCHAR(10),
	CONSTRAINT fk_Incendie_Secteur FOREIGN KEY(id_secteur) REFERENCES Secteur(id_secteur)
);

CREATE TABLE Equipement (
	id_Equipement VARCHAR(10) NOT NULL PRIMARY KEY, 
	Description_Equipement VARCHAR(500),
	Disponibilité INT NOT NULL, /*0 ou 1*/
	Derniere_inspection DATE NOT NULL,
	Resultat_inspection VARCHAR(10),
	quantité INT, 
	id_caserne VARCHAR(10),
	CONSTRAINT fk_Caserne_Equipement FOREIGN KEY(id_caserne) REFERENCES Caserne(id_caserne)
);

CREATE TABLE Vehicule (
	matricule VARCHAR(10) NOT NULL PRIMARY KEY,
	Disponibilité INT NOT NULL,
	Derniere_inspection DATE NOT NULL,
	Resultat_inspection VARCHAR(10),
	Capacité_nb_pompiers INT NOT NULL,
	Capacité_reservoir INT,
	Type VARCHAR(300),
	DescriptionFonction VARCHAR(400),
	quantité INT,
	id_caserne VARCHAR(10),
	CONSTRAINT fk_Caserne_Vehicule FOREIGN KEY(id_caserne) REFERENCES Caserne(id_caserne)
);

CREATE TABLE Horaire (
	id_horaire VARCHAR(10) NOT NULL,
	quart_travail VARCHAR(10) NOT NULL,
	journée DATE NOT NULL,
	CONSTRAINT pk_Horaire PRIMARY KEY (id_horaire)
);

CREATE TABLE AvoirHoraire(
	id_Equipe VARCHAR(10) NOT NULL,
	id_horaire VARCHAR(10) NOT NULL,
	CONSTRAINT pk_avoir_horaire PRIMARY KEY (id_Equipe, id_horaire),
	CONSTRAINT fk_ah_Equipe FOREIGN KEY (id_Equipe) REFERENCES Equipe(id_Equipe),
	CONSTRAINT fk_ah_quart FOREIGN KEY (id_horaire) REFERENCES Horaire(id_horaire)
)

CREATE TABLE RépondreIncendie(
	id_incendie VARCHAR(3), 
	id_Equipe VARCHAR(10),
	Date_incendie SMALLDATETIME,
	CONSTRAINT pk_repond_incendie PRIMARY KEY (id_incendie, id_Equipe,Date_incendie),
	CONSTRAINT fk_ri_incendie FOREIGN KEY (id_incendie) REFERENCES Incendie(id_incendie),
	CONSTRAINT fk_ri_Equipe FOREIGN KEY (id_Equipe) REFERENCES Equipe(id_Equipe)
)


--Insertion des données dans Caserne
INSERT INTO Caserne (id_caserne,Adresse, Num_Tel) VALUES ('C1','1920 Rue Brébeuf', '4504537311'),
											  ('C2', '1510 Rue Bellevue','4504637046'),
											  ('C3', '3300 Boul. Lapinière', '4504637038');


--Insertion des données dans Secteur
INSERT INTO Secteur (id_secteur, Nom_secteur,surface, id_caserne) VALUES('S1','Longueuil', 56530, 'C1'),
																		('S2','Greenfield Park',45983,'C2'),
																		('S3','Brossard', 58745,'C3'),
																		('S4','Saint Hubert', 53524,'C3'),
																		('S5','Chambly',32564,'C2'),
																		('S6','LeMoyne', 24563,'C1');
--Insertion des données dans Equipe
INSERT INTO Equipe (id_Equipe, id_caserne) VALUES ('E1','C1'),('E2','C1'),('E3','C1'),('E4','C1'),
												  ('E5','C2'),('E6','C2'),('E7','C2'),('E8','C2'),
												  ('E9','C3'),('E10','C3'),('E11','C3'),('E12','C3');


--ALTER TABLE Vehicule ALTER COLUMN Fonction VARCHAR(2000);

--ALTER TABLE Vehicule ALTER COLUMN Capacité_reservoir int; 
/*
INSERT INTO Vehicule (matricule, Disponibilité, Derniere_inspection, Resultat_inspection, Capacité_nb_pompiers,Fonction, Type, id_caserne) VALUES
('JMS-5842', 1, '2022-05-18', 'Approuvé', 1, 'Vehicule principalement utilise pour les deplacements. Il contient une radio pour les communications, des outils de gestion et de supervision des interventions, un appareil respiratoire et du materiel specialise', 'Camion de chef aux operations', 'C2'),
('GHN-4578', 0, '2024-03-25', 'Reprouve', 2, 'Vehicule dappui aux operations. En mode intervention, son apport est critique a divers types de sauvetage, car il transporte du materiel de desincarceration specialise', 'Vehicule de secours', 'C3'),
('BTR-5823', 1, '2024-04-12', 'Reprouve', 2, 'Vehicule dappui aux operations. En mode intervention, son apport est critique a divers types de sauvetage, car il transporte du materiel de desincarceration specialise', 'Vehicule de secours', 'C1');

INSERT INTO Vehicule VALUES
('MFN-6935', 1, '2023-11-28', 'Approuvé', 4, 2000, 'Vehicule procedant principalement a lextinction de feux avec de leau. Ses compartiments renferment plusieurs outils destines a permettre aux pompiers daccomplir leurs taches lors dune intervention', 'Camion autopompe', 'C2'),
('KGL-8457', 1, '2022-01-12', 'Reprouve', 3, 1200, 'Vehicule delevation permettant d''atteindre des hauteurs variant de 23 a 30 metres a laide dun systeme hydraulique. Ses compartiments renferment plusieurs outils destines a permettre aux pompiers daccomplir leurs taches lors dune intervention', 'Camion echelle', 'C1');
*/
INSERT INTO Vehicule VALUES

--avec capacité_résevoir
('MFN-6935', 1, '2023-11-28', 'Approuvé', 4, 2000, 'Camion autopompe', 'Véhicule procédant principalement à l’’extinction de feux avec de l’’eau. Ses compartiments renferment plusieurs outils destinés à permettre aux pompiers d’’accomplir leurs tâches lors d’’une intervention', 4, 'C1'),
('KGL-8457', 1, '2022-12-01', 'Approuvé', 3, 1200, 'Camion échelle', 'Véhicule d’’élévation permettant d’’atteindre des hauteurs variant de 23 à 30 mètres à l’’’aide d’’un système hydraulique. Ses compartiments renferment plusieurs outils destinés à permettre aux pompiers d’’accomplir leurs tâches lors d’’une intervention', 1, 'C1'),
('TFR-4563', 1, '2022-11-22', 'Approuvé', 4, 2500, 'Camion citerne', 'Véhicule destiné à l’’’extinction des incendies avec des réserves d’’eau importantes. Il est équipé de plusieurs outils pour aider les pompiers à accomplir leurs tâches', 2, 'C2'),
('HNL-6725', 1, '2023-05-03', 'Approuvé', 3, 1300, 'Camion échelle', 'Véhicule équipé d’’une échelle permettant d’’atteindre des hauteurs significatives avec un système hydraulique. Il contient divers outils pour les interventions', 1, 'C2'),
('ZXC-8467', 1, '2024-03-07', 'Approuvé', 4, 2100, 'Camion autopompe', 'Véhicule d’’extinction des incendies urbains, équipé de divers outils et d’’un réservoir d’’eau de grande capacité', 2, 'C3'),
('BNM-5674', 1, '2023-11-30', 'Approuvé', 3, 1250, 'Camion échelle', 'Véhicule d’’élévation avec échelle hydraulique, permettant d’’atteindre des hauteurs de 25 mètres. Il contient des outils variés pour les interventions', 1, 'C3'),
('HJK-4567', 1, '2023-04-14', 'Approuvé', 4, 2200, 'Camion citerne', 'Véhicule destiné à l’’extinction des incendies avec des réserves d’’eau importantes. Ses compartiments renferment divers outils pour les pompiers', 4, 'C3'),
('UYT-6789', 1, '2022-10-22', 'Approuvé', 3, 1350, 'Camion échelle', 'Véhicule équipé d’’une échelle pour atteindre des hauteurs de 28 mètres avec un système hydraulique. Il contient divers outils pour les interventions', 1, 'C3'),
('UIO-7890', 1, '2023-11-22', 'Approuvé', 4, 2200, 'Camion autopompe', 'Véhicule d’’extinction des incendies urbains, équipé de divers outils et d’’un réservoir d’’eau de grande capacité', 2, 'C3'),
('NML-4567', 1, '2022-08-25', 'Approuvé', 3, 1320, 'Camion échelle', 'Véhicule d’’élévation avec échelle hydraulique, permettant d’’atteindre des hauteurs de 28 mètres. Il contient des outils variés pour les interventions', 1, 'C3'),
('YUI-7890', 1, '2023-02-15', 'Approuvé', 4, 2300, 'Camion citerne', 'Véhicule destiné à l’’extinction des incendies avec des réserves d’’eau importantes. Ses compartiments renferment divers outils pour les pompiers', 2, 'C2'),
('OPQ-3456', 1, '2022-11-05', 'Approuvé', 3, 1400, 'Camion échelle', 'Véhicule équipé d’’une échelle pour atteindre des hauteurs de 30 mètres avec un système hydraulique. Il contient divers outils pour les interventions', 1, 'C2');

INSERT INTO Vehicule (matricule, Disponibilité, Derniere_inspection, Resultat_inspection, Capacité_nb_pompiers, Type, DescriptionFonction, quantité, id_caserne) VALUES
('JMS-5842', 1, '2022-05-18', 'Approuvé', 1, 'Camion de chef aux operations', 'Véhicule principalement utilisé pour les déplacements. Il contient une radio pour les communications, des outils de gestion et de supervision des interventions, un appareil respiratoire et du matériel spécialisé', 2, 'C1'),
('GHN-4578', 0, '2024-03-15', 'Reprouvé', 1, 'Véhicule de secours',  'Véhicule d’’appui aux opérations. En mode intervention, son apport est critique à divers types de sauvetage, car il transporte du matériel de désincarcération spécialisé', 1, 'C1'),
('BTR-5823', 1, '2024-04-12', 'Approuvé', 1, 'Véhicule de secours',  'Véhicule d’’appui aux opérations. En mode intervention, son apport est critique à divers types de sauvetage, car il transporte du matériel de désincarcération spécialisé', 2, 'C2'),
('RMS-8394', 1, '2023-06-15', 'Approuvé', 2, 'Camion de commandement',  'Véhicule utilisé principalement pour la gestion et la coordination des interventions. Il contient des outils de communication avancés et du matériel de supervision', 1, 'C2'),
('JDK-9807', 0, '2023-08-18', 'Reprouvé', 1, 'Véhicule de soutien',  'Véhicule de soutien logistique pour les opérations de sauvetage. Il transporte du matériel spécialisé pour la désincarcération et les premiers secours', 1, 'C2'),
('LPM-2914', 1, '2023-07-12', 'Approuvé', 1, 'Véhicule de secours',  'Véhicule de première intervention équipé pour divers types de secours. Il contient des outils de gestion et de supervision des opérations', 2, 'C3'),
('QWE-4893', 1, '2022-12-25', 'Approuvé', 2, 'Camion forestier',  'Véhicule conçu pour la gestion des feux de forêt. Il est équipé d’’un système de pompage et de réservoirs d’’eau adaptés', 2, 'C3'),
('VBN-1234', 0, '2024-01-10', 'Reprouvé', 1, 'Véhicule de secours', 'Véhicule d’’appui pour les opérations de secours. Il transporte du matériel spécialisé pour la désincarcération et les interventions d’’urgence', 1, 'C3'),
('DFG-9123', 1, '2022-06-05', 'Approuvé', 1, 'Camion de chef aux operations', 'Véhicule de gestion des interventions. Il contient des outils de communication et de supervision, ainsi qu''un appareil respiratoire', 2, 'C3'),
('JKL-5678', 0, '2023-07-28', 'Reprouvé', 1, 'Véhicule de soutien', 'Véhicule de soutien logistique pour les opérations de sauvetage. Il transporte du matériel spécialisé pour la désincarcération et les premiers secours', 1, 'C3'),
('MNB-1234', 1, '2024-03-10', 'Approuvé', 1, 'Véhicule de secours', 'Véhicule de première intervention équipé pour divers types de secours. Il contient des outils de gestion et de supervision des opérations', 2, 'C1'),
('QAZ-6789', 1, '2022-09-16', 'Approuvé', 2, 'Camion forestier', 'Véhicule conçu pour la gestion des feux de forêt. Il est équipé d’’un système de pompage et de réservoirs d’’eau adaptés', 2, 'C1'),
('ASD-1234', 0, '2024-04-18', 'Reprouvé', 1, 'Véhicule d’’appui pour les opérations de secours. Il transporte du matériel spécialisé pour la désincarcération et les interventions d’’urgence', 'Véhicule de secours', 1, 'C1'),
('FGH-5678', 1, '2022-08-09', 'Approuvé', 1, 'Camion de chef aux operations', 'Véhicule de gestion des interventions. Il contient des outils de communication et de supervision, ainsi qu''un appareil respiratoire', 2, 'C2'),
('WRT-1234', 0, '2023-07-14', 'Reprouvé', 1, 'Véhicule de soutien logistique pour les opérations de sauvetage. Il transporte du matériel spécialisé pour la désincarcération et les premiers secours', 'Véhicule de soutien', 1, 'C2'),
('ERT-4567', 1, '2023-05-18', 'Approuvé', 1, 'Camion de chef aux operations', 'Véhicule principalement utilisé pour les déplacements. Il contient une radio pour les communications, des outils de gestion et de supervision des interventions, un appareil respiratoire et du matériel spécialisé', 2, 'C3')

INSERT INTO Equipement VALUES
('Eq10', 'Embarcation pour le sauvetage nautique et sur glace', 1, '2023-02-15', 'Approuvé', 2, 'C1'),
('Eq11', 'Habit de combat', 1, '2022-08-20', 'Approuvé', 10, 'C1'), 
('Eq12', 'APRIA(appareil de protection respiratoire individuel autonome)', 1, '2023-11-05', 'Approuvé', 10, 'C1'),
('Eq13', 'APRIA (appareil de protection respiratoire individuel autonome)', 1, '2024-03-10', 'Approuvé', 10, 'C2'),
('Eq14', 'APRIA (appareil de protection respiratoire individuel autonome)', 1, '2022-12-15', 'Approuvé', 10, 'C3'),
('Eq15', 'Caméra thermique', 1, '2023-01-25', 'Approuvé', 2, 'C1'),
('Eq16', 'Habit de combat', 1, '2022-08-20', 'Approuvé', 10, 'C2'),
('Eq17', 'Habit de combat', 1, '2022-08-20', 'Reprouvé', 10, 'C3'),
('Eq18', 'Caméra thermique', 1, '2023-01-25', 'Approuvé', 2, 'C2'),
('Eq19', 'Caméra thermique', 1, '2023-01-25', 'Approuvé', 2, 'C3'),
('Eq20', 'Embarcation pour le sauvetage nautique et sur glace', 1, '2023-02-15', 'Approuvé', 2, 'C2'),
('Eq21', 'Embarcation pour le sauvetage nautique et sur glace', 1, '2023-02-15', 'Approuvé', 2, 'C3'),
('Eq22', 'Tuyau d''incendie', 1, '2023-03-05', 'Approuvé', 4, 'C1'),
('Eq23', 'Tuyau d''incendie', 1, '2023-03-05', 'Approuvé', 4, 'C2'),
('Eq24', 'Tuyau d''incendie', 1, '2023-03-05', 'Approuvé', 4, 'C3'),
('Eq25', 'Échelle', 1, '2023-04-10', 'Approuvé', 2, 'C1'),
('Eq26', 'Échelle', 1, '2023-04-10', 'Approuvé', 2, 'C2'),
('Eq27', 'Échelle', 1, '2023-04-10', 'Approuvé', 2, 'C3'),
('Eq28', 'Extincteur', 1, '2023-05-15', 'Approuvé', 4, 'C1'),
('Eq29', 'Extincteur', 1, '2023-05-15', 'Approuvé', 4, 'C2'),
('Eq30', 'Extincteur', 1, '2023-05-15', 'Approuvé', 4, 'C3'),
('Eq31', 'Couverture ignifuge', 1, '2023-06-20', 'Approuvé', 10, 'C1'),
('Eq32', 'Couverture ignifuge', 1, '2023-06-20', 'Approuvé', 10, 'C2'),
('Eq33', 'Couverture ignifuge', 1, '2023-06-20', 'Approuvé', 10, 'C3'),
('Eq34', 'Système de communication radio', 1, '2023-07-25', 'Approuvé', 4, 'C1'),
('Eq35', 'Système de communication radio', 1, '2023-07-25', 'Approuvé', 4, 'C2'),
('Eq36', 'Système de communication radio', 1, '2023-07-25', 'Approuvé', 4, 'C3'),
('Eq37', 'Génératrice portative', 1, '2023-08-30', 'Approuvé', 2, 'C1'),
('Eq38', 'Génératrice portative', 1, '2023-08-30', 'Approuvé', 2, 'C2'),
('Eq39', 'Génératrice portative', 1, '2023-08-30', 'Approuvé', 2, 'C3'),
('Eq40', 'Détecteur de gaz', 1, '2023-09-15', 'Approuvé', 4, 'C1'),
('Eq41', 'Détecteur de gaz', 1, '2023-09-15', 'Approuvé', 4, 'C2'),
('Eq42', 'Détecteur de gaz', 1, '2023-09-15', 'Approuvé', 4, 'C3'),
('Eq43', 'Ventilateur portatif', 1, '2023-10-20', 'Approuvé', 2, 'C1'),
('Eq44', 'Ventilateur portatif', 1, '2023-10-20', 'Approuvé', 2, 'C2'),
('Eq45', 'Ventilateur portatif', 1, '2023-10-20', 'Approuvé', 2, 'C3'),
('Eq46', 'Barre de forcage', 1, '2023-11-25', 'Approuvé', 10, 'C1'),
('Eq47', 'Barre de forcage', 1, '2023-11-25', 'Approuvé', 10, 'C2'),
('Eq48', 'Barre de forcage', 1, '2023-11-25', 'Approuvé', 10, 'C3'),
('Eq49', 'Trancheuse', 1, '2023-12-30', 'Approuvé', 2, 'C1'),
('Eq50', 'Trancheuse', 1, '2023-12-30', 'Approuvé', 2, 'C2'),
('Eq51', 'Trancheuse', 1, '2023-12-30', 'Approuvé', 2, 'C3');


INSERT INTO Pompier (NAS, Nom, Prenom, Grade, id_Equipe)
VALUES
  ('123456789', 'Jazi', 'Ayman', 'commandant', 'E1'),
  ('234567892', 'Laplante', 'Luc', 'commandant', 'E5'),
  ('890123458', 'Morin', 'Pierre', 'commandant', 'E9'),
  ('765432100', 'Leroy', 'Paul', 'capitaine', 'E1'),
  ('234567891', 'Lavoie', 'Patrick', 'capitaine', 'E2'),
  ('345678912', 'Girard', 'Catherine', 'capitaine', 'E3'),
  ('543210987', 'Moreau', 'Lucas', 'capitaine', 'E4'),
  ('321098765', 'Durand', 'Pierre', 'capitaine', 'E5'),
  ('456789123', 'Gauthier', 'Mathieu', 'capitaine', 'E6'),
  ('567891234', 'Caron', 'Isabelle', 'capitaine', 'E7'),
  ('678912345', 'Lefebvre', 'Alexandre', 'capitaine', 'E8'),
  ('789123456', 'Bertrand', 'Marie', 'capitaine', 'E9'),
  ('890123567', 'L�vesque', 'Sophie', 'capitaine', 'E10'),
  ('901234678', 'Fortin', 'David', 'capitaine', 'E11'),
  ('123466789', 'Tanguay', 'Julie', 'capitaine', 'E12'),
  ('234567890', 'Gagnon', 'Pierre', 'Caporal', 'E1'),
  ('987654333', 'Tremblay', 'Marie', 'Caporal', 'E2'),
  ('543210988', 'Moreau', 'Lucas', 'Caporal', 'E3'),
  ('678901234', 'Simon', 'Laura', 'Caporal', 'E4'),
  ('654321090', 'Manai', 'Ahmad', 'Caporal', 'E5'),
  ('234577890', 'Ouellet', 'Michel', 'Caporal', 'E6'),
  ('345678901', 'Poirier', 'Nathalie', 'Caporal', 'E7'),
  ('456789012', 'Simard', 'St�phanie', 'Caporal', 'E8'),
  ('567890123', 'Bouchard', 'Martin', 'Caporal', 'E9'),
  ('678901254', 'Dub�', '�milie', 'Caporal', 'E10'),
  ('789012345', 'Gagn�', '�ric', 'Caporal', 'E11'),
  ('890123456', 'Gauthier', 'Marie', 'Caporal', 'E12'),
  ('567899123', 'Petit', 'Emilie', 'Auxiliaire', 'E1'),
  ('987654322', 'Leclerc', 'Philippe', 'Auxiliaire', 'E2'),
  ('678901224', 'Perrault', 'Sophie', 'Auxiliaire', 'E3'),
  ('987654324', 'Fabre', 'Marc', 'Auxiliaire', 'E4'),
  ('890123454', 'Lambert', 'Christine', 'Auxiliaire', 'E5'),
  ('901234567', 'Pelletier', 'Jean', 'Auxiliaire', 'E6'),
  ('543217987', 'Roy', 'Pierre', 'Auxiliaire', 'E7'),
  ('987654310', 'Roy', 'Philippe', 'Auxiliaire', 'E8'),
  ('432109877', 'Lapierre', 'Isabelle', 'Auxiliaire', 'E9'),
  ('789012346', 'Lavigne', 'Patrick', 'Auxiliaire', 'E10'),
  ('456789013', 'Thibault', '�ric', 'Auxiliaire', 'E11'),
  ('567890124', 'C�t�', 'Marie', 'Auxiliaire', 'E12'),
  ('876543210', 'Dupont', 'Jean', 'sapeurs-pompier', 'E1'),
  ('345678921', 'Martin', 'Sophie', 'sapeurs-pompier', 'E1'),
  ('654321091', 'Roux', 'Marie', 'sapeurs-pompier', 'E2'),
  ('456779012', 'Bernard', 'Marie', 'sapeurs-pompier', 'E2'),
  ('789112345', 'Fournier', 'Alice', 'sapeurs-pompier', 'E3'),
  ('890123451', 'Rousseau', 'Claire', 'sapeurs-pompier', 'E3'),
  ('210987655', 'Blanc', 'Fran�ois', 'sapeurs-pompier', 'E4'),
  ('901237567', 'Garnier', 'Elise', 'sapeurs-pompier', 'E4'),
  ('109876543', 'Morin', 'Nicolas', 'sapeurs-pompier', 'E5'),
  ('890123446', 'Bourgeois', 'Isabelle', 'sapeurs-pompier', 'E5'),
  ('210987654', 'B�langer', 'Sophie', 'sapeurs-pompier', 'E6'),
  ('321098865', 'L�gar�', 'Patrick', 'sapeurs-pompier', 'E6'),
  ('432109876', 'Lemieux', 'Isabelle', 'sapeurs-pompier', 'E7'),
  ('654311098', 'Morin', 'Sylvie', 'sapeurs-pompier', 'E7'),
  ('765432109', 'Laforest', 'Fran�ois', 'sapeurs-pompier', 'E8'),
  ('876543209', 'Lapointe', 'Val�rie', 'sapeurs-pompier', 'E8'),
  ('987654321', 'Martin', 'Genevi�ve', 'sapeurs-pompier', 'E9'),
  ('876543211', 'Fortier', 'Julie', 'sapeurs-pompier', 'E9'),
  ('765432110', 'Desch�nes', 'Luc', 'sapeurs-pompier', 'E10'),
  ('654321099', 'Lemay', 'Sophie', 'sapeurs-pompier', 'E10'),
  ('543210989', 'Poulin', 'Jean', 'sapeurs-pompier', 'E11'),
  ('321098766', 'Roy', 'Fran�ois', 'sapeurs-pompier', 'E11'),
  ('210987657', 'Gosselin', 'Marie', 'sapeurs-pompier', 'E12'),
  ('109876544', 'Beaulieu', 'Pierre', 'sapeurs-pompier', 'E12'),
  ('890123455', 'Lemieux', 'Isabelle', 'sapeurs-pompier', 'E12'),
  ('678901235', 'Caron', 'Sophie', 'sapeurs-pompier', 'E12'),
  ('432119876', 'Michel', 'Julien', 'sapeurs-pompier', 'E11'),
  ('654321098', 'Roux', 'Louis', 'sapeurs-pompier', 'E11');



INSERT INTO Horaire (id_horaire, journée, quart_travail)
VALUES 
      ('H11', '2023-07-01', '24h'),-- samedi
      ('H12', '2023-07-02', '24h'),--  dimanche
      ('H13', '2023-07-03', 'jour'),
      ('H14','2023-07-03', 'Nuit'),  
      ('H15', '2023-07-04', 'jour'),
      ('H16','2023-07-04', 'Nuit'),
      ('H17', '2023-07-05', 'jour'),
      ('H18','2023-07-05', 'Nuit'),
      ('H19', '2023-07-06', 'jour'),
      ('H20','2023-07-06', 'Nuit'),
      ('H21', '2023-07-07', 'jour'),
      ('H22','2023-07-07', 'Nuit'),
      ('H23', '2023-07-08', '24h'),--samedi
      ('H24','2023-07-09', '24h');-- dimanche




INSERT INTO Incendie 
VALUES
	('I1','Incendie Forestier  ', 'feux de cimes', 'Risque élevé','Forêt Mini Dépot,2200 Boul.Lapiniere,Brossard,QC', 'S3'),
	('I2','Incendie Forestier ', 'feux de surface ', 'Risque faible', 'Forêt Macleod, Mont-Saint-Hilaire, QC', 'S5'),
	('I3','Incendie Forestier ', 'feux de terre', 'Risque moyen','Forêt Mini Dépot,2200 Boul.Lapiniere,Brossard,QC', 'S3'),
	('I4','Incendie résidentiel', 'Le bâtiment résidentiel de plus de sept étages ','Risque très élevé','99 Place Charles-Le Moyne, Longueuil, QC' , 'S1'),
	('I5','Incendie de Bâtiment Commercial ', 'centre commercial de plus de 45 commerces ','Risque très élevé' ,'Mail Champlain,2151 Boul. Lapinière, Brossard, QC' , 'S3'),
	('I6','Incendie résidentiel', 'appartement ','Risque faible' ,' 1805 Grande Allée, Saint-Hubert, QC ' ,'S4'),
	('I7','Incendie de Bâtiment Commercial ', 'centre commercial de moins de 45 commerces ','Risque élevé' ,'Place Longueuil, 825 Rue Saint-Laurent O, Longueuil, QC' ,'S1'),
	('I8','Incendie industriel',' bâtiment industriel du Groupe F, division 3','Risque moyen' ,'9000 Bd Industriel, Chambly, QC ' ,'S5'),
	('I9','Incendie industriel', ' bâtiment industriel du Groupe F, division 2','Risque élevé' ,'105 Avenue de Catania, Brossard, QC ' ,'S3'),
	('I10','Incendie de Véhicule', ' véhicule isolé','Risque faible' ,'Bd Édouard, Saint-Hubert, QC ' ,'S4');
INSERT INTO RépondreIncendie VALUES
('I1', 'E3', '2023-07-07 22:24:46'),
( 'I1', 'E5', '2023-07-07 22:24:46'),
( 'I1', 'E7', '2023-07-07 22:24:46'),
( 'I1', 'E2', '2023-07-07 22:24:46'),
( 'I2', 'E9', '2023-07-09 12:55:22'),
( 'I3', 'E4', '2023-07-23 05:13:09'),
( 'I3', 'E5', '2023-07-23 05:13:09'),
( 'I3', 'E2', '2023-07-23 05:13:09'),
( 'I3', 'E12', '2023-07-23 05:13:09'),
( 'I4', 'E11', '2023-07-30 05:06:49'),
( 'I5', 'E9', '2023-07-09 10:40:56'),
( 'I5', 'E1', '2023-07-09 10:40:56'),
( 'I5', 'E12', '2023-07-09 10:40:56'),
( 'I5', 'E6', '2023-07-09 10:40:56'),
( 'I6', 'E2', '2023-07-20 20:56:30'),
( 'I6', 'E10', '2023-07-20 20:56:30'),
( 'I6', 'E12', '2023-07-20 20:56:30'),
( 'I6', 'E11', '2023-07-20 20:56:30'),
( 'I7', 'E12', '2023-07-22 01:42:45'),
( 'I7', 'E2', '2023-07-22 01:42:45'),
( 'I7', 'E6', '2023-07-22 01:42:45'),
( 'I7', 'E9', '2023-07-22 01:42:45'),
( 'I8', 'E11', '2023-07-29 00:40:09'),
( 'I8', 'E3', '2023-07-29 00:40:09'),
( 'I8', 'E6', '2023-07-29 00:40:09'),
( 'I8', 'E2', '2023-07-29 00:40:09'),
( 'I9', 'E9', '2023-07-21 22:50:59'),
( 'I10', 'E7', '2023-07-09 00:54:53'),
( 'I10', 'E3', '2023-07-09 00:54:53');
/* à enlever pas autant d'incendie
( 'I11', 'E7', '2023-07-16 02:01:28'),
( 'I12', 'E2', '2023-07-24 23:34:29'),
( 'I13', 'E5', '2023-07-13 07:42:51'),
( 'I14', 'E6', '2023-07-30 14:10:29'),
( 'I14', 'E2', '2023-07-30 14:10:29'),
( 'I14', 'E11', '2023-07-30 14:10:29'),
( 'I14', 'E4', '2023-07-30 14:10:29'),
( 'I15', 'E2', '2023-07-08 11:45:36'),
( 'I15', 'E5', '2023-07-08 11:45:36'),
( 'I16', 'E1', '2023-07-25 14:45:28'),
( 'I17', 'E10', '2023-07-14 06:47:17'),
( 'I17', 'E3', '2023-07-14 06:47:17'),
( 'I17', 'E7', '2023-07-14 06:47:17'),
( 'I17', 'E5', '2023-07-14 06:47:17'),
( 'I18', 'E4', '2023-07-23 16:16:12'),
( 'I19', 'E1', '2023-07-26 08:30:58'),
( 'I19', 'E5', '2023-07-26 08:30:58'),
( 'I19', 'E4', '2023-07-26 08:30:58'),
( 'I20', 'E7', '2023-07-01 06:11:52'),
( 'I20', 'E8', '2023-07-01 06:11:52'),
( 'I20', 'E4', '2023-07-01 06:11:52'),
( 'I20', 'E3', '2023-07-01 06:11:52');*/
 



 INSERT INTO AvoirHoraire (id_Equipe,id_horaire) VALUES
-- 2023-07-01 Samedi
('E1', 'H11'), 
('E2', 'H11'),
('E5', 'H11'),
('E6', 'H11'),
('E9', 'H11'),
('E10', 'H11'),

-- 2023-07-02 dimanche
('E3', 'H12'),
('E4', 'H12'),
('E7', 'H12'),
('E8', 'H12'),
('E11', 'H12'),
('E12', 'H12'),

-- 2023-07-02 dimanche-nuit PAS DE QUART DE NUIT POUR DIMANCHE C'EST LUNDI NUIT

('E3', 'H14'),
('E4', 'H14'),
('E7', 'H14'),
('E8', 'H14'),
('E11', 'H14'),
('E12', 'H14'),

-- 2023-07-03 Lundi
('E1', 'H13'),
('E2', 'H13'),
('E5', 'H13'),
('E6', 'H13'),
('E9', 'H13'),
('E10', 'H13'),

-- 2023-07-04 mardi
('E1', 'H15'),
('E2', 'H15'),
('E5', 'H15'),
('E6', 'H15'),
('E9', 'H15'),
('E10', 'H15'),

-- 2023-07-04 Mardi-nuit
('E3', 'H16'),
('E4', 'H16'),
('E7', 'H16'),
('E8', 'H16'),
('E11', 'H16'),
('E12', 'H16'),

-- 2023-07-05 Mercredi
('E1', 'H17'),
('E2', 'H17'),
('E5', 'H17'),
('E6', 'H17'),
('E9', 'H17'),
('E10', 'H17'),

-- 2023-07-05 Mercredi-nuit
('E3', 'H18'),
('E4', 'H18'),
('E7', 'H18'),
('E8', 'H18'),
('E11', 'H18'),
('E12', 'H18'),

-- 2023-07-06 jeudi
('E1', 'H19'),
('E2', 'H19'),
('E5', 'H19'),
('E6', 'H19'),
('E9', 'H19'),
('E10', 'H19'),

-- 2023-07-06 Jeudi-nuit
('E3', 'H20'),
('E4', 'H20'),
('E7', 'H20'),
('E8', 'H20'),
('E11', 'H20'),
('E12', 'H20'),

-- 2023-07-07 vendredi
('E1', 'H21'),
('E2', 'H21'),
('E5', 'H21'),
('E6', 'H21'),
('E9', 'H21'),
('E10', 'H21'),

-- 2023-07-07 Vendredi-nuit
('E3', 'H22'),
('E4', 'H22'),
('E7', 'H22'),
('E8', 'H22'),
('E11', 'H22'),
('E12', 'H22'),

-- 2023-07-08 (Samedi)
('E1', 'H23'),
('E2', 'H23'),
('E5', 'H23'),
('E6', 'H23'),
('E9', 'H23'),
('E10', 'H23'),

-- 2023-07-09 (Dimanche)
('E3', 'H24'),
('E4', 'H24'),
('E7', 'H24'),
('E8', 'H24'),
('E11', 'H24'),
('E12', 'H24');

/*

SELECT * FROM Caserne;
SELECT * FROM Secteur;
SELECT * FROM Equipe;
SELECT * FROM Pompier;
SELECT * FROM RépondreIncendie;
SELECT * FROM Horaire;
SELECT * FROM AvoirHoraire;
SELECT * FROM Incendie;*/

/*SELECT * FROM Equipement;
SELECT * FROM Vehicule;*/


/*
/*le nom et prenom des pompiers et le id de leur 'Eq'uipe et caserne qui travaillent le quart de jour pour la journée 2023/07/03*/
SELECT Pompier.Nom, Pompier.Prenom, Pompier.id_Equipe, Equipe.id_caserne 
FROM Pompier
INNER JOIN Equipe ON Equipe.id_Equipe = Pompier.id_Equipe
INNER JOIN AvoirHoraire ON Equipe.id_Equipe = AvoirHoraire.id_Equipe
where AvoirHoraire.id_horaire IN (SELECT id_horaire From Horaire WHERE journée = '2023-07-03' AND quart_travail = 'Jour') ;

/*le nom et prenom des pompiers qui interviennent dans les incendies dont niveau de risque est faible */
SELECT Pompier.Nom, Pompier.Prenom, RépondreIncendie.id_incendie FROM Pompier
INNER JOIN Equipe ON Equipe.id_Equipe = Pompier.id_Equipe
INNER JOIN RépondreIncendie ON Equipe.id_Equipe = RépondreIncendie.id_Equipe
WHERE RépondreIncendie.id_incendie IN (select id_incendie FROM Incendie WHERE niveau_risque = 'Risque faible'); 

/*le nombre d'Auxiliaire qui travaillent pour le secteur de Longueuil*/
Select COUNT(case when Grade = 'Auxiliaire' then 1 else null end) AS nombre_auxiliaire FROM Pompier
INNER JOIN Equipe ON Equipe.id_Equipe = Pompier.id_Equipe
INNER JOIN Caserne ON Caserne.id_caserne = Equipe.id_caserne
WHERE Caserne.id_caserne IN (SELECT Secteur.id_caserne FROM Secteur WHERE Secteur.Nom_secteur = 'Longueuil');

/*le nombre de véhicules dont le résultat de l'inspection des casernes qui couvrent des secteurs qui ont subi des incendies dont le niveau de risque est élevé.
Afficher le nom des secteurs, le id et l'addresse de la caserne et le nombre de véhicules reprouvés*/

select count(case when Vehicule.resultat_inspection = 'Reprouvé' then Vehicule.quantité else null end ) AS nombre_vehicule_reprouvé, Vehicule.id_caserne,
Secteur.Nom_secteur, Caserne.Adresse
FROM Vehicule
INNER JOIN Caserne ON Caserne.id_caserne = Vehicule.id_caserne 
INNER JOIN Secteur ON Secteur.id_caserne = Vehicule.id_caserne
where Secteur.id_secteur IN (SELECT Incendie.id_Secteur FROM Incendie WHERE Incendie.niveau_risque = 'Risque élevé')
GROUP BY Vehicule.id_caserne, Caserne.Adresse, Secteur.Nom_secteur
ORDER BY nombre_vehicule_reprouvé DESC;
*/

select id_equipe, Horaire.journée, Horaire.quart_travail from AvoirHoraire
inner join Horaire ON Horaire.id_horaire = AvoirHoraire.id_horaire
where AvoirHoraire.id_horaire IN (select Horaire.id_horaire from Horaire where Horaire.journée = '2023-07-07' AND quart_travail = 'jour');