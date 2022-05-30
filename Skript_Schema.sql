

DROP TABLE IF EXISTS komentar
DROP TABLE IF EXISTS prihlaseni
DROP TABLE IF EXISTS sichta_udalost

DROP TABLE IF EXISTS udalost
DROP TABLE IF EXISTS sichta
DROP TABLE IF EXISTS smena
DROP TABLE IF EXISTS pracovnik






CREATE TABLE komentar 
    ( koment_id INTEGER NOT NULL IDENTITY NOT FOR REPLICATION , 
     Text VARCHAR (500) NOT NULL , 
     Smena_ID INTEGER NOT null ) 

ALTER TABLE Komentar ADD constraint komentar_pk PRIMARY KEY CLUSTERED (Koment_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 

CREATE TABLE pracovnik 
    ( pracovnik_id INTEGER NOT NULL IDENTITY NOT FOR REPLICATION , 
     Jmeno VARCHAR (20) NOT NULL , 
     Prijmeni VARCHAR (20) NOT NULL , 
     PosledniNavsteva DATETIME , 
     Vek INTEGER NOT NULL , 
     Pozice VARCHAR (10) NOT NULL , 
     Role VARCHAR (10) NOT NULL 
    )
 


ALTER TABLE Pracovnik 
    ADD CONSTRAINT brigadnik_pozice_omezeni 
    CHECK ( Pozice IN ('Grill', 'Kuchynì', 'Obsluha', 'Dohled') ) 



ALTER TABLE pracovnik add check(role IN(
    'Admin', 'Brigádník', 'Supervizor'
)) 

ALTER TABLE Pracovnik ADD constraint pracovnik_pk PRIMARY KEY CLUSTERED (Pracovnik_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 

CREATE TABLE prihlaseni (
    pracovnik_id   INTEGER NOT NULL,
    sichta_id      INTEGER NOT NULL
)



ALTER TABLE Prihlaseni ADD constraint prihlaseni_pk PRIMARY KEY CLUSTERED (Pracovnik_ID, Sichta_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 

CREATE TABLE sichta 
    ( sichta_id INTEGER NOT NULL IDENTITY NOT FOR REPLICATION , 
     Datum DATETIME NOT NULL , 
     Zacatek DATETIME NOT NULL , 
     Konec DATETIME NOT NULL , 
     CelkemMist INTEGER NOT NULL , 
     Smena_ID INTEGER NOT NULL 
    )
 


ALTER TABLE sichta add constraint sichta_celkemmist_omezeni check(celkemmist BETWEEN 1 AND 10)


ALTER TABLE Sichta ADD constraint sichta_pk PRIMARY KEY CLUSTERED (Sichta_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 

CREATE TABLE sichta_udalost (
    sichta_id    INTEGER NOT NULL,
    udalost_id   INTEGER NOT NULL
)



ALTER TABLE Sichta_Udalost ADD constraint sichta_udalost_pk PRIMARY KEY CLUSTERED (Sichta_ID, Udalost_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 

CREATE TABLE smena 
    ( smena_id INTEGER NOT NULL IDENTITY NOT FOR REPLICATION , 
     Zacatek DATETIME NOT NULL , 
     Konec DATETIME NOT NULL , 
     Pracovnik_ID INTEGER NOT null ) 

ALTER TABLE Smena ADD constraint smena_pk PRIMARY KEY CLUSTERED (Smena_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 

CREATE TABLE udalost 
    ( udalost_id INTEGER NOT NULL IDENTITY NOT FOR REPLICATION , 
     Nazev VARCHAR(20) NOT null, posledni_uprava datetime DEFAULT CURRENT_TIMESTAMP 
    ) 

ALTER TABLE Udalost ADD constraint udalost_pk PRIMARY KEY CLUSTERED (Udalost_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON ) 

ALTER TABLE Komentar
    ADD CONSTRAINT komentar_smena_fk FOREIGN KEY ( smena_id )
        REFERENCES smena ( smena_id )
ON DELETE NO ACTION 
    ON UPDATE no action 

ALTER TABLE Prihlaseni
    ADD CONSTRAINT prihlaseni_pracovnik_fk FOREIGN KEY ( pracovnik_id )
        REFERENCES pracovnik ( pracovnik_id )
ON DELETE NO ACTION 
    ON UPDATE no action 

ALTER TABLE Prihlaseni
    ADD CONSTRAINT prihlaseni_sichta_fk FOREIGN KEY ( sichta_id )
        REFERENCES sichta ( sichta_id )
ON DELETE NO ACTION 
    ON UPDATE no action 

ALTER TABLE Sichta
    ADD CONSTRAINT sichta_smena_fk FOREIGN KEY ( smena_id )
        REFERENCES smena ( smena_id )
ON DELETE NO ACTION 
    ON UPDATE no action 

ALTER TABLE Sichta_Udalost
    ADD CONSTRAINT sichta_udalost_sichta_fk FOREIGN KEY ( sichta_id )
        REFERENCES sichta ( sichta_id )
ON DELETE NO ACTION 
    ON UPDATE no action 

ALTER TABLE Sichta_Udalost
    ADD CONSTRAINT sichta_udalost_udalost_fk FOREIGN KEY ( udalost_id )
        REFERENCES udalost ( udalost_id )
ON DELETE NO ACTION 
    ON UPDATE no action 

ALTER TABLE Smena
    ADD CONSTRAINT smena_pracovnik_fk FOREIGN KEY ( pracovnik_id )
        REFERENCES pracovnik ( pracovnik_id )
ON DELETE NO ACTION 
    ON UPDATE no action 


