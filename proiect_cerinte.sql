--cerinta 6

--6. Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent care 
--s? utilizeze toate cele 3 tipuri de colec?ii studiate. Apela?i subprogramul.

--cerinta in limbaj natural
--Pentru toate motocicletele care au kilometrajul mai mare decât o valoare dat? (colec?ie care s? re?in? id-urile 
--acestor motociclete) ?i sunt de?inute de utilizatorii care au un num?r maxim de motociclete (colec?ie care s? 
--re?in? id-ul acestor utilizatori), s? se calculeze num?rul de accesorii necesare (ata?ate) în medie la o astfel 
--de motociclet? (colec?ie care s? re?in? pentru fiecare motociclet? num?rul de accesorii ale ei). Pentru o 
--veridicitate suplimentar? a informa?iilor ob?inute, pe parcursul problemei se va afi?a num?rul maxim de 
--motociclete de?inute de un utilizator, lista utilizatorilor care de?in aceste motociclete ?i lista motocicletelor 
--acestora. La final, s? se afi?eze lista motocicletelor cu restric?ia precizat? (care s? aib? kilometrajul mai 
--mare decât o valoare dat?) al?turi de num?rul de accesorii ata?ate ?i o valoare care s? reprezinte num?rul 
--mediu de accesorii pe care le de?ine o astfel de motociclet?. 

CREATE OR REPLACE PROCEDURE cerinta6 
    (v_kilometraj motociclete.kilometraj%TYPE DEFAULT 7000)
IS
    TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    t_indexat tablou_indexat;
    
    TYPE tablou_imbricat IS TABLE OF NUMBER;
    t_imbricat tablou_imbricat := tablou_imbricat();
    
    TYPE vector IS VARRAY(100) OF NUMBER;
    v vector:= vector();
    
    nr_max INT;
    v_nume UTILIZATORI.NUME%TYPE;
    nr_accesorii INT;
    nr_mediu_accesorii INT;
    nr_total_accesorii INT;
BEGIN

    --aflam numarul maxim de motociclete detinute de catre un utilizator
    SELECT MAX(COUNT(M.ID_MOTOCICLETA))
    INTO nr_max
    FROM MOTOCICLETE M
    GROUP BY M.ID_UTILIZATOR;
    
    DBMS_OUTPUT.PUT_LINE('Numarul maxim de motociclete detinute de un utilizator: '||nr_max);
    DBMS_OUTPUT.PUT_LINE('.................................');
    
    DBMS_OUTPUT.PUT_LINE('Utilizatorii care detin numarul maxim de motociclete:');
    DBMS_OUTPUT.PUT_LINE('.................................');
    
    --parcurgem toti utilizatori care detin nr_max motociclete
    --si stocam in t_indexat id-ul utilizatorilor cu numar maxim de motocilete detinute
    FOR rec_id_utilizator IN (  SELECT M.ID_UTILIZATOR
                                FROM MOTOCICLETE M
                                GROUP BY M.ID_UTILIZATOR
                                HAVING COUNT(M.ID_MOTOCICLETA) = nr_max) LOOP
        t_indexat(rec_id_utilizator.ID_UTILIZATOR) := 1;
        SELECT 
            (U.NUME||' '||U.PRENUME) INTO v_nume
        FROM UTILIZATORI U
        WHERE U.ID_UTILIZATOR=rec_id_utilizator.ID_UTILIZATOR;
        DBMS_OUTPUT.PUT_LINE(v_nume);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Motocicletelor acestor utilizatori:');
    DBMS_OUTPUT.PUT_LINE('.................................');
    DBMS_OUTPUT.PUT_LINE('.................................');
    
    --parcurgem utilizatorii detin un numar maxim de motociclete
    FOR i IN t_indexat.FIRST .. t_indexat.LAST
    LOOP
        IF t_indexat.EXISTS(i) THEN --conditie de existenta
            DBMS_OUTPUT.PUT_LINE('Id-urile motocicletelor utilizatorului cu id-ul '||i);
            DBMS_OUTPUT.PUT_LINE('.................................');
            --parcurgem motocicletele detinute de utilizatorul cu id=i
            FOR motocicleta_rec IN (  SELECT M.ID_MOTOCICLETA, M.KILOMETRAJ
                                FROM MOTOCICLETE M
                                WHERE M.ID_UTILIZATOR = i) LOOP
                --daca motocicleta are kilometrajul mai mare decat valoarea data ca parametru
                --o adaugam in t_imbricat
                IF motocicleta_rec.KILOMETRAJ>v_kilometraj THEN
                    t_imbricat.EXTEND;
                    t_imbricat(t_imbricat.count) := motocicleta_rec.ID_MOTOCICLETA;
                END IF;
                DBMS_OUTPUT.PUT_LINE(motocicleta_rec.ID_MOTOCICLETA);
            END LOOP;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Numarul de accesorii pentru fiecare motocicleta care are kilometrajul mai mare decat valoarea data');
    DBMS_OUTPUT.PUT_LINE('.................................');
    
    --parcurgem motocicletele detinute de utilizatorii care au un numar maxim de motociclete
    FOR i IN 1..(t_imbricat.COUNT-1) LOOP
        --retinem in nr_accesorii numarul de accesorii atasate la o astfel de motocicleta
        SELECT COUNT(AM.ID_ACCESORIU) INTO nr_accesorii
        FROM ACCESORII_MOTOCICLETE AM
        JOIN MOTOCICLETE M ON M.ID_MOTOCICLETA = AM.ID_MOTOCICLETA
        WHERE AM.ID_MOTOCICLETA = t_imbricat(i);
        IF t_imbricat.EXISTS(i) THEN --conditie de existenta
            v.EXTEND;
            v(i):=nr_accesorii;
            DBMS_OUTPUT.PUT_LINE('Motocicleta cu id '||t_imbricat(i)||' are '||v(i)||' accesorii');
        END IF;
    END LOOP;
    
    --parcurgem vectorul si aflam numarul total de accesorii atasate la motocicletele
    --care sunt detinute de catre utilizatorii care au un numar maxim de motociclete
    nr_total_accesorii := 0;
    FOR i IN 1..v.COUNT LOOP
        nr_total_accesorii := nr_total_accesorii + v(i);
    END LOOP;

    --facem media accesoriilor detinute de o motocicleta cu conditiile specificate
    nr_accesorii:=v.COUNT;
    IF nr_accesorii> 0 THEN --tratam cazul de impartire la 0
        nr_mediu_accesorii := nr_total_accesorii/nr_accesorii;
    ELSE
        nr_mediu_accesorii := 0; 
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Numarul mediu de accesorii este '||nr_mediu_accesorii);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista motociclete cu specificatiile cerute');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END cerinta6;
/

BEGIN
    cerinta6(12000);
END;
/

--cerinta 7

--7. Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent care 
--s? utilizeze 2 tipuri diferite de cursoare studiate, unul dintre acestea fiind cursor parametrizat, dependent de 
--cel?lalt cursor. Apela?i subprogramul.

--Cerinta in limbaj natural
--Pentru fiecare categorie care cuprinde un num?r de motociclete mai mare decât o valoare specificat?, s? afi?eze 
--numele acesteia, num?rul de motociclete care fac parte din ea ?i lista motocicletelor care fac parte din aceast? 
--categorie.

CREATE OR REPLACE PROCEDURE cerinta7
    (v_nrmin_moto INT DEFAULT 0)
IS
    --cursor parametrizat care afiseaza informatii despre motocicletele care fac parte dintr-o categorie data
    --(numar de inmatriculare, numele proprietarului, marca si modelul)
    
    CURSOR c_moto (v_id_categorie NUMBER) IS
        SELECT M.NR_INMATRICULARE numar_inmatriculare, (U.NUME||' '||U.PRENUME) nume_proprietar, (M.MARCA||' '||M.MODEL) informatii
        FROM MOTOCICLETE M
        JOIN UTILIZATORI U ON U.ID_UTILIZATOR=M.ID_UTILIZATOR
        WHERE M.ID_CATEGORIE = v_id_categorie;
    --tratarea cazului in care nu exista categorii care sa contina mai mult de v_nrmin_moto motociclete
    verifica INT:=0;
BEGIN
    --parcurgem categoriile care contin un numar de motociclete mai mare decat valoarea v_nrmin_moto data
    FOR rec_categ IN (
        SELECT 
            C.ID_CATEGORIE ID, C.NUME NUME, COUNT(M.ID_MOTOCICLETA) NR_MOTOCICLETE
        FROM MOTOCICLETE M
        RIGHT JOIN CATEGORII C ON M.ID_CATEGORIE=C.ID_CATEGORIE
        GROUP BY C.ID_CATEGORIE, C.NUME
        HAVING COUNT(M.ID_MOTOCICLETA)>v_nrmin_moto) LOOP
        
        DBMS_OUTPUT.PUT_LINE('........................');
        --afisare adaptata la numarul de motociclete 
        IF rec_categ.nr_motociclete=0 THEN
            DBMS_OUTPUT.PUT_LINE('Categoria '||rec_categ.nume||' nu contine nicio motocicleta');
        ELSIF rec_categ.nr_motociclete=1 THEN
            DBMS_OUTPUT.PUT_LINE('Categoria '||rec_categ.nume||' contine o singura motocicleta');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Categoria '||rec_categ.nume||' contine '||rec_categ.nr_motociclete||' motociclete');
        END IF;
        DBMS_OUTPUT.PUT_LINE('........................');
        
        FOR rec_moto IN c_moto(rec_categ.id) LOOP
            DBMS_OUTPUT.PUT_LINE('Numar de inmatriculare: '||rec_moto.numar_inmatriculare||' Proprietar: '||rec_moto.nume_proprietar||' Informatii: '||rec_moto.informatii);
        END LOOP;
        verifica:=1;
    END LOOP;

    IF verifica=0 THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista categorii care sa contina mai mult de '||v_nrmin_moto||' motociclete');
    END IF;
END cerinta7;
/

BEGIN
    cerinta7(2);
END;
/


--cerinta 8
--8. Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent de 
--tip func?ie care s? utilizeze într-o singur? comand? SQL 3 dintre tabelele definite. Defini?i minim 2 excep?ii 
--proprii. Apela?i subprogramul astfel încât s? eviden?ia?i toate cazurile definite ?i tratate.

--Cerinta in limbaj natural
--Pentru utilizatorul a c?rui nume de familie este dat, s? se afi?eze num?rul de motociclete pe care le de?ine 
--care merg pe benzin?. 

CREATE OR REPLACE FUNCTION cerinta8
    (v_nume utilizatori.nume%TYPE DEFAULT 'Georgescu') RETURN NUMBER
IS
    nr_motociclete NUMBER;
    --exceptii proprii
    NO_DATA_FOUND_UTILIZATOR EXCEPTION;
    NO_DATA_FOUND_MOTOCICLETA EXCEPTION;
    contor NUMBER;
BEGIN
    SELECT COUNT(*) INTO contor
    FROM UTILIZATORI 
    WHERE UPPER(NUME)=UPPER(v_nume);
    
    --exceptie pentru niciun utilizator existent cu numele dat
    IF contor=0 THEN
        RAISE NO_DATA_FOUND_UTILIZATOR;
    --exceptie pentru mai multi utilizatori care indeplinesc conditia ceruta
    ELSIF contor>1 THEN
        RAISE TOO_MANY_ROWS;
    END IF;

    SELECT COUNT(*) INTO contor
    FROM MOTOCICLETE M
    JOIN UTILIZATORI U ON U.ID_UTILIZATOR=M.ID_UTILIZATOR
    WHERE UPPER(U.NUME)=UPPER(v_nume);
    
    --exceptie pentru utilizatorii care detin nicio motocicleta in baza de date
    IF contor=0 THEN
        RAISE NO_DATA_FOUND_MOTOCICLETA;
    END IF;
    
    SELECT
        COUNT(M.ID_MOTOCICLETA) INTO nr_motociclete
    --luam si utilizatorii care nu au motociclete care sa consume benzina
    FROM UTILIZATORI U
    LEFT JOIN MOTOCICLETE M ON U.ID_UTILIZATOR = M.ID_UTILIZATOR
    --selectam motocicletele care merg pe benzina
    WHERE M.ID_MOTOCICLETA IS NULL OR M.ID_MOTOCICLETA IN (
        SELECT M1.ID_MOTOCICLETA
        FROM MOTOCICLETE M1
        JOIN MOTOARE MT1 ON MT1.ID_MOTOR=M1.ID_MOTOR
        WHERE UPPER(MT1.CARBURANT) = 'BENZINA')
    GROUP BY U.ID_UTILIZATOR, U.NUME
    HAVING UPPER(U.NUME)=UPPER(v_nume);
    
    RETURN nr_motociclete;
EXCEPTION
    WHEN NO_DATA_FOUND_UTILIZATOR THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun utilizator in baza de date cu numele dat');
        RETURN -1;
    WHEN NO_DATA_FOUND_MOTOCICLETA THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul specificat nu are motociclete salvate in baza de date');
        RETURN -1;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul specificat nu detine motociclete care sa indeplineasca conditia');
        RETURN -1;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multi utilizatori cu numele dat');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cod: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Mesaj: ' || SQLERRM);
        RETURN -1;
END cerinta8;
/

BEGIN
    --cazul in care utilizatorul dat detine motociclete care consuma benzina
    DBMS_OUTPUT.PUT_LINE('Pentru Popa: '||cerinta8('Popa'));
    DBMS_OUTPUT.PUT_LINE('.........................');
    
    --cazul in care nu exista un utilizator cu numele dat in baza de date
    DBMS_OUTPUT.PUT_LINE('Pentru Vornicu: '||cerinta8('Vornicu'));
    DBMS_OUTPUT.PUT_LINE('.........................');
    
    --cazul in care utilizatorul dat nu detine motociclete (in general)
    DBMS_OUTPUT.PUT_LINE('Pentru Popescu: '||cerinta8('Popescu'));
    DBMS_OUTPUT.PUT_LINE('.........................');
    
    --cazul in care utilizatorul dat nu detine motociclete care sa consume benzina
    DBMS_OUTPUT.PUT_LINE('Pentru Georgescu: '||cerinta8('Georgescu'));
    DBMS_OUTPUT.PUT_LINE('.........................');
    
    --cazul in care exista mai multi utilizatori cu numele dat
    DBMS_OUTPUT.PUT_LINE('Pentru Muresan: '||cerinta8('Muresan'));
END;
/

--cerinta 9
--Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat  independent de tip 
--procedur? care s? utilizeze într-o singur? comand? SQL 5 dintre tabelele definite. Trata?i toate excep?iile care 
--pot ap?rea, incluzând excep?iile NO_DATA_FOUND ?i  TOO_MANY_ROWS. Apela?i subprogramul astfel încât s? eviden?ia?i 
--toate cazurile tratate.

--Cerinta in limbaj natural
--În cadrul unui studiu se cere s? se afle care este, în medie, suma pe care o aloc? ?oferii tineri adul?i 
--(utilizatorii cu vârsta cuprins? între 25 ?i 34 de ani) în scopul între?inerii motocicletelor personale care fac 
--parte dintr-o categorie care con?ine un string specificat. Astfel, se va afi?a numele categoriei pentru care se 
--face studiul ?i o scurt? descriere a acesteia, iar apoi suma medie cerut? ?i num?rul de persoane (utilizatori) 
--care au participat la studiu.

CREATE OR REPLACE PROCEDURE cerinta9
    (v_categorie categorii.nume%TYPE DEFAULT 'Naked')
IS
    NO_DATA_FOUND_INTRETINERE EXCEPTION;
    NO_DATA_FOUND_MOTOCICLETA EXCEPTION;
    contor NUMBER;
    nr_utilizatori NUMBER;
    nr_intretineri NUMBER;
    cost_total NUMBER;
    suma_medie NUMBER;
    categ_info categorii.descriere%TYPE;
BEGIN

    DBMS_OUTPUT.PUT_LINE('Numele categoriei: '||v_categorie);
    
    SELECT 
        COUNT(*) INTO contor
    FROM CATEGORII 
    WHERE INSTR(UPPER(NUME), UPPER(v_categorie))>0;
    
    --exceptie pentru cazul in care nu exista categoria data
    IF contor=0 THEN
        RAISE NO_DATA_FOUND;
    ELSIF contor>1 THEN
        RAISE TOO_MANY_ROWS;
    END IF; 
    
    SELECT 
        DESCRIERE INTO categ_info
    FROM CATEGORII 
    WHERE INSTR(UPPER(NUME), UPPER(v_categorie))>0;
    DBMS_OUTPUT.PUT_LINE('Descriere: '||categ_info);
    
    SELECT 
        COUNT(*) INTO contor
    FROM MOTOCICLETE M
    JOIN CATEGORII C ON C.ID_CATEGORIE=M.ID_CATEGORIE
    WHERE UPPER(NUME)=UPPER(v_categorie);
    
    --exceptie pentru cazul in care inca nu exista motociclete inregistrate in baza de date care sa faca parte din acea categorie
    IF contor=0 THEN
        RAISE NO_DATA_FOUND_MOTOCICLETA;
    END IF; 
    
    --selectam toate intretinerile detinute de utilizatorii cu varsta cuprinsa in intervalul dat alocate 
    --motocicletelor din categoria specificata ca parametru si retinem in cost_total - suma totala a acestora, in
    --nr_intretineri - numarul acestora, in nr_utilizatori - numarul de utilizatori cu specificatiile date
    --care detin motociclete din categoria care contin stringul dat ca parametru
    SELECT 
        SUM(P.COST), COUNT(DISTINCT I.ID_INTRETINERE), COUNT(DISTINCT I.ID_UTILIZATOR)
        INTO cost_total, nr_intretineri, nr_utilizatori
    FROM INTRETINERI I
    JOIN UTILIZATORI U ON U.ID_UTILIZATOR=I.ID_UTILIZATOR
    JOIN PLATI P ON P.ID_PLATA=I.ID_PLATA
    JOIN MOTOCICLETE M ON M.ID_MOTOCICLETA=I.ID_MOTOCICLETA
    JOIN CATEGORII C ON C.ID_CATEGORIE=M.ID_CATEGORIE
    WHERE U.VARSTA<=34 AND U.VARSTA>=25 AND INSTR(UPPER(C.NUME), UPPER(v_categorie)) > 0;
    
    --exceptie pentru cazul in care nu exista intretineri efectuate motocicletelor care sa respecte conditiile cerute
    IF nr_intretineri=0 THEN
        RAISE NO_DATA_FOUND_INTRETINERE;
    END IF; 
    
    --calculam media
    suma_medie:=cost_total/nr_intretineri;
    DBMS_OUTPUT.PUT_LINE('Suma medie alocata intretinerilor pentru aceasta categorie este '||suma_medie);
    DBMS_OUTPUT.PUT_LINE('Numarul de participanti la studiu: '||nr_utilizatori);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista nicio categorie in baza de date cu numele specificat');
    WHEN NO_DATA_FOUND_MOTOCICLETA THEN
        DBMS_OUTPUT.PUT_LINE('Inca nu exista motociclete in baza de date din aceasta categorie');
    WHEN NO_DATA_FOUND_INTRETINERE THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista intretineri efectuate pentru motocicletele din categoria specificata');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multe categorii care sa contina acest nume');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cod: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Mesaj: ' || SQLERRM);
END cerinta9;
/

BEGIN
    --Cazul ideal, in care exista intretineri alocate motocicletelor din categoria data
    cerinta9('Naked');
    DBMS_OUTPUT.PUT_LINE('..............................');
    
    --Cazul in care nu exista categoria cu numele specificat
    cerinta9('Supersportive');
    DBMS_OUTPUT.PUT_LINE('..............................');
    
    --Cazul in care nu exista motociclete in baza de date care sa faca parte din categoria specificata
    cerinta9('Bobber');
    DBMS_OUTPUT.PUT_LINE('..............................');
    
    --Cazul in care nu exista intretineri efectuate pentru motocicletele din categoria specificata
    cerinta9('Adventure');
    
    --Cazul in care exista mai multe categorii in baza de date care sa contina stringul specificat
    DBMS_OUTPUT.PUT_LINE('..............................');
    cerinta9('Cruiser');
END;
/

select * from motociclete;

--cerinta 10
--10. Defini?i un trigger de tip LMD la nivel de comand?. Declan?a?i trigger-ul.

CREATE OR REPLACE TRIGGER cerinta10
BEFORE INSERT OR UPDATE OR DELETE ON INTRETINERI
DECLARE
    ora NUMBER;
    zi_saptamana VARCHAR(20);
    zi_luna NUMBER;
BEGIN
    --selectam ora (numarul din doua cifre), ziua saptamanii, ziua lunii
    SELECT 
        TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')), TO_CHAR(SYSDATE, 'DY'), TO_NUMBER(TO_CHAR(SYSDATE, 'DD'))
        INTO ora, zi_saptamana, zi_luna
    FROM DUAL;

    IF (ora < 8 OR ora > 20) OR zi_saptamana IN ('SUN', 'SAT') OR zi_luna IN (1, EXTRACT(DAY FROM LAST_DAY(SYSDATE)))THEN
        IF INSERTING THEN
            RAISE_APPLICATION_ERROR(-20001,'Inserarea in tabelul INTRETINERI se poate realiza de luni pana vineri, intre orele 8:00-20:00 si nu in prima sau ultima zi a lunii!');
        ELSIF DELETING THEN
            RAISE_APPLICATION_ERROR(-20002,'Stergerea in tabelul INTRETINERI se poate realiza de luni pana vineri, intre orele 8:00-20:00 si nu in prima sau ultima zi a lunii!');
        END IF;
    ELSIF (ora < 8 OR ora > 20) OR zi_saptamana IN ('SUN', 'SAT') THEN
        IF UPDATING THEN
            RAISE_APPLICATION_ERROR(-20003,'Actualizarile in tabelul INTRETINERI se poate realiza de luni pana vineri, intre orele 8:00-20:00!');
        END IF;
    END IF;
END;
/

--varianta care declanseaza triggerul 
SELECT 
    TO_CHAR(SYSDATE, 'HH24') ora, TO_CHAR(SYSDATE, 'DY') zi_saptamana, TO_NUMBER(TO_CHAR(SYSDATE, 'DD')) zi_luna
FROM dual;

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES (18, 13, 10, 'Schimb ulei', 'Schimb de ulei la motor', '22-DEC-2023');

--varianta care nu il declanseaza
SELECT 
    TO_CHAR(SYSDATE, 'HH24') ora, TO_CHAR(SYSDATE, 'DY') zi_saptamana, TO_NUMBER(TO_CHAR(SYSDATE, 'DD')) zi_luna
FROM dual;

INSERT INTO INTRETINERI (id_motocicleta, id_utilizator, id_plata, nume, descriere, data) 
VALUES (18, 13, 10, 'Schimb ulei', 'Schimb de ulei la motor', '22-DEC-2023');

                            
--cerinta 11
--11. Defini?i un trigger de tip LMD la nivel de linie. Declan?a?i trigger-ul.

CREATE OR REPLACE TRIGGER cerinta11
BEFORE INSERT OR UPDATE ON MOTOCICLETE
FOR EACH ROW
DECLARE
    varsta_motocicleta INT;
BEGIN
    varsta_motocicleta := EXTRACT(YEAR FROM SYSDATE)-:NEW.AN;
    IF varsta_motocicleta>5 AND :NEW.KILOMETRAJ>10000 AND UPPER(:NEW.STARE) = 'EXCELENTA' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Starea "Excelenta" nu este permisa pentru acest grad de uzura varsta-kilometraj.');
    ELSIF varsta_motocicleta>8 AND :NEW.KILOMETRAJ>100000 AND UPPER(:NEW.STARE) = 'FOARTE BUNA' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Starea "Foarte buna" nu este permisa pentru acest grad de uzura varsta-kilometraj.');
    ELSIF varsta_motocicleta>11 AND :NEW.KILOMETRAJ>300000 AND UPPER(:NEW.STARE) = 'BUNA' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Starea "Buna" nu este permisa pentru acest grad de uzura varsta-kilometraj.');
    END IF;
END;
/

--varianta care declanseaza triggerul
INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an, capacitate_rezervor)
VALUES (2, 4, 2, 6, 12000, 'E-012-XYZ', 'Suzuki', 'GSX-R1000', 'Excelenta', 2013, 19);

--varianta care nu declanseaza triggerul, deoarece respecta restrictiile cerute
INSERT INTO MOTOCICLETE (id_utilizator, id_categorie, id_motor, id_far, kilometraj, nr_inmatriculare, marca, model, stare, an, capacitate_rezervor)
VALUES (2, 4, 2, 6, 9000, 'E-012-XYZ', 'Suzuki', 'GSX-R1000', 'Excelenta', 2013, 19);


--cerinta 12
--12. Defini?i un trigger de tip LDD. Declan?a?i trigger-ul.

CREATE TABLE monitor_SMM(
  nume_baza_de_date VARCHAR2(50),
  user_logat VARCHAR2(30),
  eveniment VARCHAR2(30),
  tip_obiect VARCHAR2(30),
  nume_obiect VARCHAR2(30),
  data DATE
);

CREATE OR REPLACE TRIGGER cerinta12
AFTER CREATE OR DROP OR ALTER ON SCHEMA
DECLARE
    v_nume_baza_de_date VARCHAR2(50);
    v_user_logat VARCHAR2(30);
    v_eveniment VARCHAR2(30);
    v_tip_obiect VARCHAR2(30);
    v_nume_obiect VARCHAR2(30);
    v_data DATE;
BEGIN
    v_nume_baza_de_date := SYS.DATABASE_NAME;
    v_user_logat := SYS.LOGIN_USER;
    v_eveniment := SYS.SYSEVENT;
    v_tip_obiect := SYS.DICTIONARY_OBJ_TYPE;
    v_nume_obiect := SYS.DICTIONARY_OBJ_NAME;
    v_data := SYSDATE;

    INSERT INTO monitor_SMM
    VALUES (v_nume_baza_de_date, v_user_logat, v_eveniment, v_tip_obiect, v_nume_obiect, v_data);
END;
/

CREATE TABLE GPS (
    ID_GPS NUMBER PRIMARY KEY,
    Model VARCHAR2(50),
    Latitudine NUMBER,
    Longitudine NUMBER
);

SELECT * FROM GPS;

ALTER TABLE GPS ADD (Status VARCHAR2(20));

ALTER TABLE GPS ADD (Precizie NUMBER);

ALTER TABLE GPS DROP COLUMN Status;

DROP TABLE GPS;

SELECT * 
FROM monitor_SMM;

--cerinta 13

CREATE OR REPLACE PACKAGE cerinta13 IS
    PROCEDURE cerinta6 (v_kilometraj motociclete.kilometraj%TYPE DEFAULT 7000);
    PROCEDURE cerinta7 (v_nrmin_moto INT DEFAULT 0);
    FUNCTION cerinta8 (v_nume utilizatori.nume%TYPE DEFAULT 'Georgescu') RETURN NUMBER;
    PROCEDURE cerinta9 (v_categorie categorii.nume%TYPE DEFAULT 'Georgescu');
END cerinta13;
/

CREATE OR REPLACE PACKAGE BODY cerinta13 IS

    --cerinta 6
    PROCEDURE cerinta6 (v_kilometraj motociclete.kilometraj%TYPE DEFAULT 7000)
    AS
        TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        t_indexat tablou_indexat;
    
        TYPE tablou_imbricat IS TABLE OF NUMBER;
        t_imbricat tablou_imbricat := tablou_imbricat();
    
        TYPE vector IS VARRAY(100) OF NUMBER;
        v vector:= vector();
    
        nr_max INT;
        v_nume UTILIZATORI.NUME%TYPE;
        nr_accesorii INT;
        nr_mediu_accesorii INT;
        nr_total_accesorii INT;
    BEGIN
        SELECT MAX(COUNT(M.ID_MOTOCICLETA))
        INTO nr_max
        FROM MOTOCICLETE M
        GROUP BY M.ID_UTILIZATOR;
    
        DBMS_OUTPUT.PUT_LINE('Numarul maxim de motociclete detinute de un utilizator: '||nr_max);
        DBMS_OUTPUT.PUT_LINE('.................................');
    
        DBMS_OUTPUT.PUT_LINE('Utilizatorii care detin numarul maxim de motociclete:');
        DBMS_OUTPUT.PUT_LINE('.................................');
    
        FOR rec_id_utilizator IN (  SELECT M.ID_UTILIZATOR
                                    FROM MOTOCICLETE M
                                    GROUP BY M.ID_UTILIZATOR
                                    HAVING COUNT(M.ID_MOTOCICLETA) = nr_max) LOOP
            t_indexat(rec_id_utilizator.ID_UTILIZATOR) := 1;
            SELECT 
                (U.NUME||' '||U.PRENUME) INTO v_nume
            FROM UTILIZATORI U
            WHERE U.ID_UTILIZATOR=rec_id_utilizator.ID_UTILIZATOR;
            DBMS_OUTPUT.PUT_LINE(v_nume);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Motocicletelor acestor utilizatori:');
        DBMS_OUTPUT.PUT_LINE('.................................');
        DBMS_OUTPUT.PUT_LINE('.................................');
        FOR i IN t_indexat.FIRST .. t_indexat.LAST
        LOOP
            IF t_indexat.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE('Id-urile motocicletelor utilizatorului cu id-ul '||i);
                DBMS_OUTPUT.PUT_LINE('.................................');
                FOR inner_rec IN (  SELECT M.ID_MOTOCICLETA, M.KILOMETRAJ
                                    FROM MOTOCICLETE M
                                    WHERE M.ID_UTILIZATOR = i) LOOP
                    IF inner_rec.KILOMETRAJ>v_kilometraj THEN
                        t_imbricat.EXTEND;
                        t_imbricat(t_imbricat.count) := inner_rec.ID_MOTOCICLETA;
                    END IF;
                    DBMS_OUTPUT.PUT_LINE(inner_rec.ID_MOTOCICLETA);
                END LOOP;
            END IF;
        END LOOP;
    
        DBMS_OUTPUT.PUT_LINE('Numarul de accesorii pentru fiecare motocicleta care are kilometrajul mai mare decat valoarea data');
        DBMS_OUTPUT.PUT_LINE('.................................');
        FOR i IN 1..(t_imbricat.COUNT-1) LOOP
            SELECT COUNT(AM.ID_ACCESORIU) INTO nr_accesorii
            FROM ACCESORII_MOTOCICLETE AM
            JOIN MOTOCICLETE M ON M.ID_MOTOCICLETA = AM.ID_MOTOCICLETA
            WHERE AM.ID_MOTOCICLETA = t_imbricat(i);
            IF t_imbricat.EXISTS(i) THEN
                v.EXTEND;
                v(i):=nr_accesorii;
                DBMS_OUTPUT.PUT_LINE('Motocicleta cu id '||t_imbricat(i)||' are '||v(i)||' accesorii');
            END IF;
        END LOOP;
    
        nr_total_accesorii := 0;
        FOR i IN 1..v.COUNT LOOP
            nr_total_accesorii := nr_total_accesorii + v(i);
        END LOOP;

        nr_accesorii:=v.COUNT;
        IF nr_accesorii> 0 THEN
            nr_mediu_accesorii := nr_total_accesorii/nr_accesorii;
        ELSE
            nr_mediu_accesorii := 0; 
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('Numarul mediu de accesorii este '||nr_mediu_accesorii);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Nu exista motociclete cu specificatiile cerute');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
    END cerinta6;


    --cerinta7
    PROCEDURE cerinta7 (v_nrmin_moto INT DEFAULT 0)
    IS
        CURSOR c_moto (v_id_categorie NUMBER) IS
            SELECT M.NR_INMATRICULARE numar_inmatriculare, (U.NUME||' '||U.PRENUME) nume_proprietar, (M.MARCA||' '||M.MODEL) informatii
            FROM MOTOCICLETE M
            JOIN UTILIZATORI U ON U.ID_UTILIZATOR=M.ID_UTILIZATOR
            WHERE M.ID_CATEGORIE = v_id_categorie;
        verifica INT:=0;
    BEGIN
        FOR rec_categ IN (
            SELECT 
                C.ID_CATEGORIE ID, C.NUME NUME, COUNT(M.ID_MOTOCICLETA) NR_MOTOCICLETE
            FROM MOTOCICLETE M
            RIGHT JOIN CATEGORII C ON M.ID_CATEGORIE=C.ID_CATEGORIE
            GROUP BY C.ID_CATEGORIE, C.NUME
            HAVING COUNT(M.ID_MOTOCICLETA)>v_nrmin_moto) LOOP
        
            DBMS_OUTPUT.PUT_LINE('........................');
            IF rec_categ.nr_motociclete=0 THEN
                DBMS_OUTPUT.PUT_LINE('Categoria '||rec_categ.nume||' nu contine nicio motocicleta');
            ELSIF rec_categ.nr_motociclete=1 THEN
                DBMS_OUTPUT.PUT_LINE('Categoria '||rec_categ.nume||' contine o singura motocicleta');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Categoria '||rec_categ.nume||' contine '||rec_categ.nr_motociclete||' motociclete');
            END IF;
            DBMS_OUTPUT.PUT_LINE('........................');
        
            FOR rec_moto IN c_moto(rec_categ.id) LOOP
                DBMS_OUTPUT.PUT_LINE('Numar de inmatriculare: '||rec_moto.numar_inmatriculare||' Proprietar: '||rec_moto.nume_proprietar||' Informatii: '||rec_moto.informatii);
            END LOOP;
            verifica:=1;
        END LOOP;

        IF verifica=0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista categorii care sa contina mai mult de '||v_nrmin_moto||' motociclete');
        END IF;
    END cerinta7;


    --cerinta8
    FUNCTION cerinta8 (v_nume utilizatori.nume%TYPE DEFAULT 'Georgescu') RETURN NUMBER
    IS
        nr_motociclete NUMBER;
        NO_DATA_FOUND_UTILIZATOR EXCEPTION;
        NO_DATA_FOUND_MOTOCICLETA EXCEPTION;
        contor NUMBER;
    BEGIN
        SELECT COUNT(*) INTO contor
        FROM UTILIZATORI 
        WHERE UPPER(NUME)=UPPER(v_nume);
    
        --exceptie pentru niciun utilizator existent cu numele dat
        IF contor=0 THEN
            RAISE NO_DATA_FOUND_UTILIZATOR;
        --exceptie pentru mai multi utilizatori care indeplinesc conditia ceruta
        ELSIF contor>1 THEN
            RAISE TOO_MANY_ROWS;
        END IF;

        SELECT COUNT(*) INTO contor
        FROM MOTOCICLETE M
        JOIN UTILIZATORI U ON U.ID_UTILIZATOR=M.ID_UTILIZATOR
        WHERE UPPER(U.NUME)=UPPER(v_nume);
    
        --exceptie pentru utilizatorii care detin nicio motocicleta in baza de date
        IF contor=0 THEN
            RAISE NO_DATA_FOUND_MOTOCICLETA;
        END IF;
    
        SELECT
            COUNT(M.ID_MOTOCICLETA) INTO nr_motociclete
        FROM UTILIZATORI U
        LEFT JOIN MOTOCICLETE M ON U.ID_UTILIZATOR = M.ID_UTILIZATOR
        WHERE M.ID_MOTOCICLETA IS NULL OR M.ID_MOTOCICLETA IN (
            SELECT M1.ID_MOTOCICLETA
            FROM MOTOCICLETE M1
            JOIN MOTOARE MT1 ON MT1.ID_MOTOR=M1.ID_MOTOR
            WHERE UPPER(MT1.CARBURANT) = 'BENZINA')
        GROUP BY U.ID_UTILIZATOR, U.NUME
        HAVING UPPER(U.NUME)=UPPER(v_nume);
    
        RETURN nr_motociclete;
    EXCEPTION
        WHEN NO_DATA_FOUND_UTILIZATOR THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun utilizator in baza de date cu numele dat');
            RETURN -1;
        WHEN NO_DATA_FOUND_MOTOCICLETA THEN
            DBMS_OUTPUT.PUT_LINE('Utilizatorul specificat nu are motociclete salvate in baza de date');
            RETURN -1;
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Utilizatorul specificat nu detine motociclete care sa indeplineasca conditia');
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multi utilizatori cu numele dat');
            RETURN -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Cod: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Mesaj: ' || SQLERRM);
            RETURN -1;
    END cerinta8;


    
    --cerinta9
    PROCEDURE cerinta9 (v_categorie categorii.nume%TYPE DEFAULT 'Georgescu')
    IS
        NO_DATA_FOUND_CATEGORIE EXCEPTION;
        NO_DATA_FOUND_INTRETINERE EXCEPTION;
        NO_DATA_FOUND_MOTOCICLETA EXCEPTION;
        TOO_MANY_ROWS_CATEGORIE EXCEPTION;
        contor NUMBER;
        nr_utilizatori NUMBER;
        nr_intretineri NUMBER;
        cost_total NUMBER;
        suma_medie NUMBER;
        categ_info categorii.descriere%TYPE;
    BEGIN

        DBMS_OUTPUT.PUT_LINE('Numele categoriei: '||v_categorie);
    
        SELECT 
            COUNT(*) INTO contor
        FROM CATEGORII 
        WHERE INSTR(UPPER(NUME), UPPER(v_categorie))>0;
    
        --exceptie pentru cazul in care nu exista categoria data
        IF contor=0 THEN
            RAISE NO_DATA_FOUND_CATEGORIE;
        ELSIF contor>1 THEN
            RAISE TOO_MANY_ROWS_CATEGORIE;
        END IF; 
    
        SELECT 
            DESCRIERE INTO categ_info
        FROM CATEGORII 
        WHERE INSTR(UPPER(NUME), UPPER(v_categorie))>0;
        DBMS_OUTPUT.PUT_LINE('Descriere: '||categ_info);
    
        SELECT 
            COUNT(*) INTO contor
        FROM MOTOCICLETE M
        JOIN CATEGORII C ON C.ID_CATEGORIE=M.ID_CATEGORIE
        WHERE UPPER(NUME)=UPPER(v_categorie);
    
        --exceptie pentru cazul in care inca nu exista motociclete inregistrate in baza de date care sa faca parte din acea categorie
        IF contor=0 THEN
            RAISE NO_DATA_FOUND_MOTOCICLETA;
        END IF; 
    
        SELECT 
            SUM(P.COST), COUNT(DISTINCT I.ID_INTRETINERE), COUNT(DISTINCT I.ID_UTILIZATOR)
            INTO cost_total, nr_intretineri, nr_utilizatori
        FROM INTRETINERI I
        JOIN UTILIZATORI U ON U.ID_UTILIZATOR=I.ID_UTILIZATOR
        JOIN PLATI P ON P.ID_PLATA=I.ID_PLATA
        JOIN MOTOCICLETE M ON M.ID_MOTOCICLETA=I.ID_MOTOCICLETA
        JOIN CATEGORII C ON C.ID_CATEGORIE=M.ID_CATEGORIE
        WHERE U.VARSTA<=34 AND U.VARSTA>=25 AND INSTR(UPPER(C.NUME), UPPER(v_categorie)) > 0;
    
        --exceptie pentru cazul in care nu exista intretineri efectuate motocicletelor care sa respecte conditiile cerute
        IF nr_intretineri=0 THEN
            RAISE NO_DATA_FOUND_INTRETINERE;
        END IF; 
    
        suma_medie:=cost_total/nr_intretineri;
        DBMS_OUTPUT.PUT_LINE('Suma medie alocata intretinerilor pentru aceasta categorie este '||suma_medie);
        DBMS_OUTPUT.PUT_LINE('Numarul de participanti la studiu: '||nr_utilizatori);
    EXCEPTION
        WHEN NO_DATA_FOUND_CATEGORIE THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista nicio categorie in baza de date cu numele specificat');
        WHEN NO_DATA_FOUND_MOTOCICLETA THEN
            DBMS_OUTPUT.PUT_LINE('Inca nu exista motociclete in baza de date din aceasta categorie');
        WHEN NO_DATA_FOUND_INTRETINERE THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista intretineri efectuate pentru motocicletele din categoria specificata');
        WHEN TOO_MANY_ROWS_CATEGORIE THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multe categorii care sa contina acest nume');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Cod: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Mesaj: ' || SQLERRM);
    END cerinta9;

END cerinta13;
/

EXECUTE cerinta13.cerinta6(12000);
EXECUTE cerinta13.cerinta7(2);
BEGIN
DBMS_OUTPUT.PUT_LINE(cerinta13.cerinta8('Popa'));
END;
/
EXECUTE cerinta13.cerinta9('Naked');


--cerinta 14

CREATE OR REPLACE TYPE InfoUtilizator AS OBJECT (
  id_utilizator INT,
  nume VARCHAR2(50),
  prenume VARCHAR2(50),
  email VARCHAR2(100),
  varsta INT,
  data_nasterii DATE
);
/



CREATE OR REPLACE PACKAGE cerinta14 IS
    TYPE MotocicleteUtilizatorType IS TABLE OF NUMBER;
    TYPE NumeAccesoriiType IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    
    --returneaza id-ul motocicletei al carui numar de inmatriculare este specificat 
    FUNCTION GetIdMotocicleta (v_nr_inmatriculare motociclete.nr_inmatriculare%TYPE) RETURN NUMBER;
    
    --returneaza id-ul utilizatorului care detine motocicleta data
    FUNCTION GetIdUtilizator (v_id_motocicleta motociclete.id_motocicleta%TYPE) RETURN NUMBER;
    
    --returneaza informatii despre un utilizator al carui id este specificat
    FUNCTION Get_UtilizatorInfo(v_id_utilizator utilizatori.id_utilizator%TYPE) RETURN InfoUtilizator;
    
    --afiseaza informatii despre motocicleta al carui id este specificat
    PROCEDURE afisare_InfoMotocicleta(v_id_motocicleta motociclete.id_motocicleta%TYPE);
    
    --afiseaza detalii despre platile efectuate asupra unei motociclete al carui id este specificat
    PROCEDURE plati_motocicleta(v_id_motocicleta motociclete.id_motocicleta%TYPE);
    
    --atsam un accesoriu la o motocicleta al carui id este dat
    PROCEDURE Adauga_AccesoriuMotocicleta(v_id_motocicleta IN NUMBER, nume_accesoriu IN VARCHAR2);
    
    --returneaza un tablou imbricat care contine id-urile motocicletelor detinute de utilizatorul cu id-ul dat
    FUNCTION GetMotocicleteUtilizator (v_id_utilizator utilizatori.id_utilizator%TYPE) RETURN MotocicleteUtilizatorType;
    
    --afiseaza informatii despre motocicletele unui utilizator al carui id este dat
    PROCEDURE Afiseaza_InfoMotocicleteUtilizator (v_id_utilizator utilizatori.id_utilizator%TYPE);
    
    --returneaza un tablou indexat care retine denumirile accesoriilor motocicletei al carui id este dat
    FUNCTION GetAccesoriiMotocicleta(v_id_motocicleta motociclete.id_motocicleta%TYPE) RETURN NumeAccesoriiType;
    
    --o procedura care afiseaza informatii in functie de cerintele utilizatorului 
    PROCEDURE actiuni_motocicleta (v_nr_inmatriculare motociclete.nr_inmatriculare%TYPE, tasta NUMBER DEFAULT 0);
END cerinta14;
/


CREATE OR REPLACE PACKAGE BODY cerinta14 IS

FUNCTION GetIdMotocicleta 
    (v_nr_inmatriculare motociclete.nr_inmatriculare%TYPE) RETURN NUMBER
AS
    v_id_motocicleta motociclete.id_motocicleta%TYPE;
BEGIN
    SELECT
        ID_MOTOCICLETA INTO v_id_motocicleta
    FROM MOTOCICLETE
    WHERE UPPER(NR_INMATRICULARE)=UPPER(v_nr_inmatriculare);
    RETURN v_id_motocicleta;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000,'Nu exista motociclete cu acest numar de inmatriculare');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001,'Exista mai multe motociclete cu acest numar de inmatriculare');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END GetIdMotocicleta;


FUNCTION GetIdUtilizator 
    (v_id_motocicleta motociclete.id_motocicleta%TYPE) RETURN NUMBER
IS
    v_id_utilizator utilizatori.id_utilizator%TYPE;
BEGIN
    SELECT
        ID_UTILIZATOR INTO v_id_utilizator
    FROM MOTOCICLETE
    WHERE ID_MOTOCICLETA=v_id_motocicleta;
    RETURN v_id_utilizator;
END GetIdUtilizator;

FUNCTION Get_UtilizatorInfo(v_id_utilizator UTILIZATORI.ID_UTILIZATOR%TYPE) RETURN InfoUtilizator 
AS
    v_nume VARCHAR2(50);
    v_prenume VARCHAR2(50);
    v_email VARCHAR2(100);
    v_varsta INT;
    v_data_nasterii DATE;
    v_info_utilizator InfoUtilizator;
BEGIN
    SELECT nume, prenume, email, varsta, data_nasterii
    INTO v_nume, v_prenume, v_email, v_varsta, v_data_nasterii
    FROM UTILIZATORI
    WHERE id_utilizator = v_id_utilizator;

    v_info_utilizator := InfoUtilizator(
        id_utilizator => v_id_utilizator,
        nume => v_nume,
        prenume => v_prenume,
        email => v_email,
        varsta => v_varsta,
        data_nasterii => v_data_nasterii
    );

    RETURN v_info_utilizator;
END Get_UtilizatorInfo;

PROCEDURE afisare_InfoMotocicleta(v_id_motocicleta motociclete.id_motocicleta%TYPE)
IS
    v_nr_inmatriculare VARCHAR(50);
    v_marca VARCHAR(50);
    v_model VARCHAR(50);
    v_an INT;
    v_capacitate_rezervor INT;
    v_kilometraj INT;
BEGIN
    SELECT
        nr_inmatriculare, marca, model, an, capacitate_rezervor, kilometraj
        INTO v_nr_inmatriculare, v_marca, v_model, v_an, v_capacitate_rezervor, v_kilometraj
    FROM MOTOCICLETE
    WHERE ID_MOTOCICLETA=v_id_motocicleta;
    
    DBMS_OUTPUT.PUT_LINE('Numar de inmatriculare: '||v_nr_inmatriculare);
    DBMS_OUTPUT.PUT_LINE('Marca: '||v_marca);
    DBMS_OUTPUT.PUT_LINE('Model: '|| v_model);
    DBMS_OUTPUT.PUT_LINE('An de fabricatie: '||v_an);
    DBMS_OUTPUT.PUT_LINE('Capacitatea rezervorului: '||v_capacitate_rezervor);
    DBMS_OUTPUT.PUT_LINE('Kilometraj: '||v_kilometraj);
END afisare_InfoMotocicleta;

PROCEDURE plati_motocicleta(v_id_motocicleta motociclete.id_motocicleta%TYPE)
IS
    v_total_intretineri NUMBER:=0;
    v_total_achizitii NUMBER:=0;
    v_medie_intretineri NUMBER:=0;
    v_medie_achizitii NUMBER:=0;
    cnt_intretineri NUMBER:=0;
    cnt_achizitii NUMBER:=0;
BEGIN
    FOR rec_intretinere IN (
        SELECT 
            P.COST suma
        FROM INTRETINERI I
        JOIN PLATI P ON I.ID_PLATA=P.ID_PLATA
        WHERE I.ID_MOTOCICLETA=v_id_motocicleta) LOOP
        
        cnt_intretineri:= cnt_intretineri+1;
        v_total_intretineri:= v_total_intretineri+rec_intretinere.suma;
    END LOOP;
    IF cnt_intretineri<>0
        THEN v_medie_intretineri:=v_total_intretineri/cnt_intretineri;
    END IF;
    
    FOR rec_achizitie IN (
        SELECT 
            P.COST suma
        FROM ACHIZITII I
        JOIN PLATI P ON I.ID_PLATA=P.ID_PLATA
        WHERE I.ID_MOTOCICLETA=v_id_motocicleta) LOOP
        
        cnt_achizitii:= cnt_achizitii+1;
        v_total_achizitii:= v_total_achizitii+rec_achizitie.suma;
    END LOOP;
    IF cnt_achizitii<>0
        THEN v_medie_achizitii:=v_total_achizitii/cnt_achizitii;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Pentru aceasta motocicleta, informatiile platilor efectuate sunt:');
    IF cnt_achizitii=0
        THEN DBMS_OUTPUT.PUT_LINE('Nu s-au efectuat achizitii pentru aceasta motocicleta');
    ELSE
        DBMS_OUTPUT.PUT_LINE('- S-au efectuat '||cnt_achizitii||'achiztii cu un costul total de '||v_total_achizitii||'lei');
        DBMS_OUTPUT.PUT_LINE('Valoarea medie a acestora per achiztie este de '||v_medie_achizitii);
    END IF;
    DBMS_OUTPUT.PUT_LINE('......................................');
    IF cnt_intretineri=0
        THEN DBMS_OUTPUT.PUT_LINE('Nu s-au efectuat intretineri pentru aceasta motocicleta');
    ELSE
        DBMS_OUTPUT.PUT_LINE('- S-au efectuat '||cnt_intretineri||'achiztii cu un costul total de '||v_total_intretineri||'lei');
        DBMS_OUTPUT.PUT_LINE('Valoarea medie a acestora per intretinere este de '||v_medie_intretineri);
    END IF;
END plati_motocicleta;

PROCEDURE Adauga_AccesoriuMotocicleta(
        v_id_motocicleta IN NUMBER,
        nume_accesoriu IN VARCHAR2) 
IS
    v_id_accesoriu accesorii.id_accesoriu%TYPE;
    NO_DATA_FOUND_ACCESORIU EXCEPTION;
    NO_DATA_FOUND_MOTOCICLETA EXCEPTION;
    TOO_MANY_ROWS_ACCESORIU EXCEPTION;
    ACCESORIU_DEJA_ATASAT EXCEPTION;
    contor INT;
BEGIN
    SELECT
        COUNT(*) INTO contor
    FROM MOTOCICLETE
    WHERE ID_MOTOCICLETA=v_id_motocicleta;
    
    IF contor=0 THEN
        RAISE NO_DATA_FOUND_MOTOCICLETA;
    END IF;
    
    SELECT
        COUNT(*) INTO contor
    FROM ACCESORII
    WHERE UPPER(NUME)=UPPER(nume_accesoriu);
    
    IF contor=0 THEN
        RAISE NO_DATA_FOUND_ACCESORIU;
    ELSIF contor>1 THEN
        RAISE TOO_MANY_ROWS_ACCESORIU;
    END IF;    
    
    SELECT
        ID_ACCESORIU INTO v_id_accesoriu
    FROM ACCESORII
    WHERE UPPER(NUME)=UPPER(nume_accesoriu);
    
    
    SELECT
        COUNT(*) INTO contor
    FROM ACCESORII_MOTOCICLETE
    WHERE ID_ACCESORIU=v_id_accesoriu AND ID_MOTOCICLETA=v_id_motocicleta;
    
    IF contor=1 THEN
        RAISE ACCESORIU_DEJA_ATASAT;
    END IF;

    INSERT INTO ACCESORII_MOTOCICLETE (ID_MOTOCICLETA, ID_ACCESORIU)
    VALUES (v_id_motocicleta, v_id_accesoriu);

    COMMIT; 
    
EXCEPTION 
    WHEN NO_DATA_FOUND_MOTOCICLETA THEN
        DBMS_OUTPUT.PUT_LINE('Motocicleta cu id-ul specificat nu exista in baza de date');
    WHEN NO_DATA_FOUND_ACCESORIU THEN
        DBMS_OUTPUT.PUT_LINE('Accesoriul cu numele specificat nu exista in baza de date! Mai intai adaugati-l.');
    WHEN TOO_MANY_ROWS_ACCESORIU THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multe accesorii cu numele specificat in baza de date');
    WHEN ACCESORIU_DEJA_ATASAT THEN
        DBMS_OUTPUT.PUT_LINE('Accesoriul cu numele specificat este deja atasat la aceasta motocicleta');
    WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Cod: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Mesaj: ' || SQLERRM);
END Adauga_AccesoriuMotocicleta;

FUNCTION GetMotocicleteUtilizator
    (v_id_utilizator UTILIZATORI.ID_UTILIZATOR%TYPE) RETURN MotocicleteUtilizatorType 
IS
    
    v_id_motocicleta MOTOCICLETE.ID_MOTOCICLETA%TYPE;
    v_motociclete_utilizator MotocicleteUtilizatorType;
    NO_DATA_FOUND_UTILIZATOR EXCEPTION;
    NO_DATA_FOUND_MOTOCICLETA EXCEPTION;
    contor INT;
BEGIN
    
    SELECT COUNT(*)
    INTO contor
    FROM UTILIZATORI
    WHERE ID_UTILIZATOR = v_id_utilizator;
    
    IF contor = 0 THEN
        RAISE NO_DATA_FOUND_UTILIZATOR;
    END IF;
    
    SELECT COUNT(*)
    INTO contor
    FROM MOTOCICLETE
    WHERE ID_UTILIZATOR = v_id_utilizator;
    
    IF contor = 0 THEN
        RAISE NO_DATA_FOUND_MOTOCICLETA;
    END IF;

    v_motociclete_utilizator := MotocicleteUtilizatorType();

    FOR motocicleta_rec IN (SELECT ID_MOTOCICLETA
                            FROM MOTOCICLETE
                            WHERE ID_UTILIZATOR = v_id_utilizator) LOOP
        v_id_motocicleta := motocicleta_rec.ID_MOTOCICLETA;
        v_motociclete_utilizator.EXTEND;
        v_motociclete_utilizator(v_motociclete_utilizator.LAST) := v_id_motocicleta;
    END LOOP;

    RETURN v_motociclete_utilizator;
EXCEPTION
    WHEN NO_DATA_FOUND_UTILIZATOR THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul specificat nu exist?!');
        RETURN MotocicleteUtilizatorType();
    WHEN NO_DATA_FOUND_MOTOCICLETA THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul specificat nu de?ine motociclete!');
        RETURN MotocicleteUtilizatorType();
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cod: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Mesaj: ' || SQLERRM);
        RETURN MotocicleteUtilizatorType();
END GetMotocicleteUtilizator;

PROCEDURE Afiseaza_InfoMotocicleteUtilizator
    (v_id_utilizator UTILIZATORI.ID_UTILIZATOR%TYPE)
AS
    info_utilizator InfoUtilizator;
    v_motociclete_utilizator MotocicleteUtilizatorType;
BEGIN
    v_motociclete_utilizator := GetMotocicleteUtilizator(v_id_utilizator);
    info_utilizator:=Get_UtilizatorInfo(v_id_utilizator);
    IF v_motociclete_utilizator.COUNT=0 THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul '||info_utilizator.nume||' nu detine nicio motocicleta');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Utilizatorul '||info_utilizator.nume||' '||info_utilizator.prenume||' detine '||v_motociclete_utilizator.COUNT||' motociclete:');
        DBMS_OUTPUT.PUT_LINE('......................');
        FOR i IN 1..v_motociclete_utilizator.COUNT LOOP
            afisare_InfoMotocicleta(v_motociclete_utilizator(i));
            DBMS_OUTPUT.PUT_LINE('......................');
        END LOOP;
    END IF;
END Afiseaza_InfoMotocicleteUtilizator;

FUNCTION GetAccesoriiMotocicleta
    (v_id_motocicleta MOTOCICLETE.ID_MOTOCICLETA%TYPE) RETURN NumeAccesoriiType 
IS
    v_accesorii NumeAccesoriiType:=NumeAccesoriiType();
    contor INT;
    NO_DATA_FOUND_MOTOCICLETA EXCEPTION;
BEGIN
    SELECT 
        COUNT(*) INTO contor
    FROM MOTOCICLETE
    WHERE ID_MOTOCICLETA=v_id_motocicleta;
    
    IF CONTOR=0 THEN
        RAISE NO_DATA_FOUND_MOTOCICLETA;
    END IF;
    
    FOR accesoriu_rec IN (SELECT A.NUME
                FROM ACCESORII_MOTOCICLETE AM
                JOIN ACCESORII A ON AM.ID_ACCESORIU = A.ID_ACCESORIU
                WHERE AM.ID_MOTOCICLETA = v_id_motocicleta) LOOP
        v_accesorii(v_accesorii.COUNT + 1) := accesoriu_rec.nume;
    END LOOP;

    RETURN v_accesorii;
EXCEPTION
    WHEN NO_DATA_FOUND_MOTOCICLETA THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista motocicleta in baza de date cu id-ul specificat!');
        RETURN NumeAccesoriiType();
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cod: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Mesaj: ' || SQLERRM);
        RETURN NumeAccesoriiType();
END GetAccesoriiMotocicleta;
    
PROCEDURE actiuni_motocicleta (v_nr_inmatriculare motociclete.nr_inmatriculare%TYPE, tasta NUMBER DEFAULT 0)
IS
    v_id_motocicleta motociclete.id_motocicleta%TYPE;
    info_utilizator InfoUtilizator;
    v_accesorii NumeAccesoriiType;
BEGIN
    v_id_motocicleta:=GetIdMotocicleta(v_nr_inmatriculare);
    DBMS_OUTPUT.PUT_LINE('Ati introdus tasta '||tasta);
    IF tasta=0 THEN
        DBMS_OUTPUT.PUT_LINE('Actiune anulata cu succes!');
    ELSIF tasta=1 THEN
        --afisarea detaliilor proprietarului motocicletei
        DBMS_OUTPUT.PUT_LINE('Actiune realizata cu succes!');
        DBMS_OUTPUT.PUT_LINE('Informatiile proprietarului motocicletei cu numarul de inmatriculare specificat:');
        DBMS_OUTPUT.PUT_LINE('.........................');
        info_utilizator:=Get_UtilizatorInfo(GetIdUtilizator(v_id_motocicleta));
        DBMS_OUTPUT.PUT_LINE('Nume: '||info_utilizator.nume);
        DBMS_OUTPUT.PUT_LINE('Prenume: '||info_utilizator.prenume);
        DBMS_OUTPUT.PUT_LINE('Email: '||info_utilizator.email);
        DBMS_OUTPUT.PUT_LINE('Varsta: '||info_utilizator.varsta);
        DBMS_OUTPUT.PUT_LINE('Data nasterii: '||info_utilizator.data_nasterii);
    ELSIF tasta=2 THEN
        --afisarea detaliilor platilor efectuate pentru o anumita motocicleta
        DBMS_OUTPUT.PUT_LINE('Actiune realizata cu succes!');
        DBMS_OUTPUT.PUT_LINE('Afisarea detaliilor platilor efectuate pentru motocicleta cu numarul de inmatriculare specificat');
        DBMS_OUTPUT.PUT_LINE('.........................');
        plati_motocicleta(v_id_motocicleta);
    ELSIF tasta=3 THEN
        --adaugarea unui anumit accesoriu pentru o motocicleta
        DBMS_OUTPUT.PUT_LINE('Actiune realizata cu succes!');
        DBMS_OUTPUT.PUT_LINE('Atasarea unui accesoriu la motocicleta cu numarul de inmatriculare specificat');
        DBMS_OUTPUT.PUT_LINE('.........................');
        Adauga_AccesoriuMotocicleta(v_id_motocicleta, 'Casca');
    ELSIF tasta=4 THEN
        --afisarea motocicletelor proprietarului
        DBMS_OUTPUT.PUT_LINE('Actiune realizata cu succes!');
        DBMS_OUTPUT.PUT_LINE('Afisarea motocicletelor proprietarului care detine motocicleta cu numarul de inmatriculare specificat');
        DBMS_OUTPUT.PUT_LINE('.........................');
        Afiseaza_InfoMotocicleteUtilizator(GetIdUtilizator(v_id_motocicleta));
    ELSIF tasta=5 THEN
        --afisarea denumirilor accesoriile atasate la aceasta motocicleta
        DBMS_OUTPUT.PUT_LINE('Actiune realizata cu succes!');
        DBMS_OUTPUT.PUT_LINE('Afisarea numelor accesoriilor atasate la motocicleta cu numarul de inmatriculare specificat');
        DBMS_OUTPUT.PUT_LINE('.........................');
        v_accesorii:=GetAccesoriiMotocicleta(v_id_motocicleta);
        IF v_accesorii.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista accesorii atasate la aceasta motocicleta');
        ELSE
            FOR i IN 1..v_accesorii.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE(v_accesorii(i));
            END LOOP;
        END IF;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Nu exista nicio actiune pentru tasta introdusa!');
    END IF;
END actiuni_motocicleta;

END cerinta14;
/

EXECUTE cerinta14.actiuni_motocicleta('B-123-XYZ',0);
EXECUTE cerinta14.actiuni_motocicleta('B-123-XYZ',1);
EXECUTE cerinta14.actiuni_motocicleta('B-123-XYZ',2);
EXECUTE cerinta14.actiuni_motocicleta('B-123-XYZ',3);
EXECUTE cerinta14.actiuni_motocicleta('B-123-XYZ',4);
EXECUTE cerinta14.actiuni_motocicleta('B-123-XYZ',5);
EXECUTE cerinta14.actiuni_motocicleta('B-123-XYZ',6);
EXECUTE cerinta14.actiuni_motocicleta('inexistent',1);
EXECUTE cerinta14.actiuni_motocicleta('B-10-234',1);

SELECT
    M.NR_INMATRICULARE NR_INMATRICULARE, A.NUME NUME_ACCESORIU
FROM ACCESORII_MOTOCICLETE AM
JOIN ACCESORII A ON A.ID_ACCESORIU=AM.ID_ACCESORIU
JOIN MOTOCICLETE M ON M.ID_MOTOCICLETA=AM.ID_MOTOCICLETA;

DECLARE
    info InfoUtilizator;
    motociclete_utilizator cerinta14.MotocicleteUtilizatorType;
    nume_accesorii cerinta14.NumeAccesoriiType;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('ID-ul motocicletei cu numarul de inmatriculare B-123-XYZ: '||cerinta14.GetIdMotocicleta('B-123-XYZ'));
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    DBMS_OUTPUT.PUT_LINE('ID-ul utilizatorului care detine motocicleta cu id-ul 3: '||cerinta14.GetIdUtilizator(1));
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    DBMS_OUTPUT.PUT_LINE('ID-ul utilizatorului care detine motocicleta cu id-ul 3: '||cerinta14.GetIdUtilizator(1));
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    info:=cerinta14.Get_UtilizatorInfo(1);
    DBMS_OUTPUT.PUT_LINE('Utilizatorul care are id-ul 1 se numeste '||info.nume||' '||info.prenume||' si are emailul '||info.email);
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    DBMS_OUTPUT.PUT_LINE('Informatii despre motocicleta cu id-ul 1');
    cerinta14.afisare_InfoMotocicleta(1);
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    DBMS_OUTPUT.PUT_LINE('Informatii despre platile alocate motocicletei cu id-ul 1');
    cerinta14.plati_motocicleta(1);
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    DBMS_OUTPUT.PUT_LINE('Atasam accesoriul Casca cu id-ul 5');
    cerinta14.Adauga_AccesoriuMotocicleta(5, 'Casca');
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    DBMS_OUTPUT.PUT_LINE('Stocam in motociclete_utilizator motocicletele utilizatorului cu id-ul 1');
    motociclete_utilizator:=cerinta14.GetMotocicleteUtilizator(1);
    IF motociclete_utilizator.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista motociclete detinute de utilizatorul cu id=1');
    ELSE
        FOR i IN 1..motociclete_utilizator.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(motociclete_utilizator(i));
        END LOOP;
    END IF;
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    DBMS_OUTPUT.PUT_LINE('Afisam informatii despre motocicletele detinute de utilizatorul cu id-ul 1');
    cerinta14.Afiseaza_InfoMotocicleteUtilizator(1);
    DBMS_OUTPUT.PUT_LINE('...........................................');
    
    DBMS_OUTPUT.PUT_LINE('Stocam in nume_accesorii accesoriile motocicletei cu id-ul 1');
    nume_accesorii:=cerinta14.GetAccesoriiMotocicleta(1);
    IF nume_accesorii.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista accesorii atasate de motocicleta cu id=1');
    ELSE
        FOR i IN 1..nume_accesorii.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(nume_accesorii(i));
        END LOOP;
    END IF;
END;
/
