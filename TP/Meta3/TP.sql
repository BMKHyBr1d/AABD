create or replace FUNCTION ck3_a_fase_vacinacao(codutente VARCHAR)
RETURN fase.datainicioturno%TYPE
IS
 datafunction fase.datainicioturno%TYPE;
 n number;
 vac number;
 Excecao_utente Exception;
 EXCECAO_VACINATOMADA Exception;
BEGIN

Select count(utente.id_utente) into n
    from utente
    where ID_UTENTE=codutente;

    if n=0 then 
        Raise Excecao_utente;
    end if;
    
    Select count(toma.id_toma) into vac
    from toma
    where toma.ID_UTENTE=codutente;
    
     if vac>0 then 
        Raise Excecao_vacinatomada;
    end if;
        
 SELECT DISTINCT(fase.datainicioturno) into datafunction
 FROM FASE, UTENTE, PROFISSAO
 WHERE fase.id_profissao = profissao.id_profissao AND profissao.id_profissao = utente.id_profissao AND utente.ID_UTENTE = codutente;
 
 RETURN datafunction;   

   EXCEPTION
      WHEN EXCECAO_utente THEN                                                           --LANÇA EXCECOES
        RAISE_APPLICATION_ERROR(-20501, 'Utente Inexistente');
    When EXCECAO_VACINATOMADA THEN
         RAISE_APPLICATION_ERROR(-20505, 'Vacina já tomada');
END;

commit;
SELECT ck3_a_fase_vacinacao(4)
FROM DUAL;


create or replace FUNCTION ck3_c_vacinas_dadas (nomeLocal varchar, vIdVacina number)
RETURN seringas.quantidade%TYPE
IS
 vacinasdadas seringas.quantidade%TYPE;
  loc number;
 vac number;
 Excecao_Local Exception;
 EXCECAO_VACINA Exception;
BEGIN

Select count(LOCALVACINACAO) into loc
    from local
    where LOCALVACINACAO=nomeLocal;

    if loc=0 then 
        Raise Excecao_Local;
    end if;
    
    Select count(vacina.id_vacina) into vac
    from vacina
    where vacina.ID_vacina=vIdVacina;
    
     if vac=0 then 
        Raise Excecao_vacina;
    end if;
    
SELECT SUM(SERINGAS.QUANTIDADE) into vacinasdadas
FROM TOMA,UTENTE,CONCELHO,LOCAL,SERINGAS
WHERE local.id_concelho = concelho.id_concelho and utente.id_concelho= concelho.id_concelho and toma.id_utente = utente.id_utente AND TOMA.ID_TOMA = SERINGAS.ID_TOMA AND LOCALVACINACAO = nomeLocal;


    RETURN vacinasdadas;   
  EXCEPTION
      WHEN EXCECAO_Local THEN                                                           --LANÇA EXCECOES
        RAISE_APPLICATION_ERROR(-20502, 'Local Inexistente');
    When EXCECAO_VACINA THEN
         RAISE_APPLICATION_ERROR(-20503, 'Vacina Inexistente');
END;

SELECT ck3_c_vacinas_dadas('Ginásio Municipal de Soure',1)
FROM DUAL;

create or replace FUNCTION ck3_d_vacinas_disponiveis (nomeLocal varchar, vIdVacina number)
RETURN number
IS
 vacinasdisponiveis number;
   loc number;
 vac number;
 Excecao_Local Exception;
 EXCECAO_VACINA Exception;
BEGIN

Select count(LOCALVACINACAO) into loc
    from local
    where LOCALVACINACAO=nomeLocal;

    if loc=0 then 
        Raise Excecao_Local;
    end if;
    
    Select count(vacina.id_vacina) into vac
    from vacina
    where vacina.ID_vacina=vIdVacina;
    
     if vac=0 then 
        Raise Excecao_vacina;
    end if;

    SELECT local.numvacinasdisponiveis into vacinasdisponiveis
    FROM LOCAL
    WHERE LOCALVACINACAO = nomeLocal;

    RETURN vacinasdisponiveis;   

  EXCEPTION
      WHEN EXCECAO_Local THEN                                                           --LANÇA EXCECOES
        RAISE_APPLICATION_ERROR(-20502, 'Local Inexistente');
    When EXCECAO_VACINA THEN
         RAISE_APPLICATION_ERROR(-20503, 'Vacina Inexistente');
END;

SELECT ck3_d_vacinas_disponiveis('Ginásio Municipal de Coimbra',1)
FROM DUAL;


CREATE OR REPLACE FUNCTION ck3_i_data_proxima_dose (vIdUtente number)
RETURN fase.datainicioturno%TYPE
IS
DATAX toma.data_toma%TYPE;
DATAFINAL toma.data_toma%TYPE;
tempo number;
n number;
dosestomadas number;
excecao_utente exception;
excecao_ndose exception;
BEGIN
     
Select count(utente.id_utente) into n
    from utente
    where ID_UTENTE=vIdUtente;
    
      if n=0 then
        Raise excecao_utente;
    end if;
    
    Select utente.ndosestomadas into dosestomadas
    from utente
    where ID_UTENTE=vIdUtente;
    
    
    if dosestomadas=0 then
        Raise excecao_ndose;
    end if;

SELECT DATA_TOMA INTO DATAX
FROM UTENTE,TOMA
WHERE UTENTE.ID_UTENTE = TOMA.ID_UTENTE AND TOMA.ID_UTENTE = vIdUtente ;

SELECT TEMPO_INTERVALO INTO tempo
FROM VACINA,TOMA,REACAO
WHERE VACINA.ID_VACINA = REACAO.id_vacina AND TOMA.ID_TOMA = REACAO.ID_REACAO and TOMA.ID_UTENTE = vIdUtente;

 datafinal:=datax+tempo;
 
   RETURN DATAFINAL;

 EXCEPTION
     When EXCECAO_utente THEN
            RAISE_APPLICATION_ERROR(-20501, 'Utente Inexistente');
        WHEN EXCECAO_ndose THEN                                                           
            RAISE_APPLICATION_ERROR(-20515, 'Utente ainda não tomou nenhuma dose');

      
END;

select ck3_i_data_proxima_dose(4)
from dual;

create or replace FUNCTION ck3_e_data_ultima_convocatoria(vIdUtente number)
RETURN fase.datainicioturno%TYPE
IS
DATAX convocatoria.data_convocatoria%TYPE;
  ut number;
   loc number;
 vac number;
 armaz number;
  Excecao_utente Exception;
 Excecao_Local Exception;
 EXCECAO_VACINA Exception;
 Excecao_LocalArmazenamento EXCEPTION;
BEGIN

   Select count(utente.id_utente) into ut
    from utente
    where utente.ID_UTENTE=vIdUtente;
    
    if ut=0 then 
        Raise Excecao_utente;
    end if;
    

Select count(local.LOCALVACINACAO) into loc
    from local,utente,convocatoria
    where utente.ID_UTENTE=vIdUtente
    and utente.ID_UTENTE=convocatoria.ID_UTENTE
    and convocatoria.LOCALVACINACAO=local.LOCALVACINACAO;

    if loc=0 then 
        Raise Excecao_Local;
    end if;
    
    Select count(vacina.id_vacina) into vac
    from utente,toma,seringas,frasco,lotes,vacina
    where utente.Id_Utente=vIdUtente
    and utente.ID_UTENTE=toma.ID_UTENTE
    and toma.ID_TOMA=seringas.ID_TOMA
    and seringas.ID_FRASCO=frasco.ID_FRASCO
    and frasco.ID_LOTE=lotes.ID_LOTE
    and lotes.ID_VACINA=vacina.ID_VACINA
    ;
    
     if vac=0 then 
        Raise Excecao_vacina;
    end if;
    
    Select count(armazem.id_armazem) into armaz
    from utente,toma,seringas,frasco,lotes,armazem
    where utente.Id_Utente=vIdUtente
     and utente.ID_UTENTE=toma.ID_UTENTE
    and toma.ID_TOMA=seringas.ID_TOMA
    and seringas.ID_FRASCO=frasco.ID_FRASCO
    and frasco.ID_LOTE=lotes.ID_LOTE
    and lotes.ID_ARMAZEM=armazem.ID_ARMAZEM;
    
     if armaz=0 then 
        Raise Excecao_LocalArmazenamento;
    end if;


SELECT data_convocatoria INTO DATAX
FROM UTENTE,CONVOCATORIA
WHERE UTENTE.ID_UTENTE = CONVOCATORIA.ID_UTENTE AND CONVOCATORIA.ID_UTENTE = vIdUtente ;

  RETURN DATAX;
  
     EXCEPTION
     When EXCECAO_utente THEN
            RAISE_APPLICATION_ERROR(-20501, 'Utente Inexistente');
        WHEN EXCECAO_Local THEN                                                           
            RAISE_APPLICATION_ERROR(-20502, 'Local Inexistente');
        When EXCECAO_VACINA THEN
            RAISE_APPLICATION_ERROR(-20503, 'Vacina Inexistente');
        When EXCECAO_LocalArmazenamento THEN
            RAISE_APPLICATION_ERROR(-20508, 'Local de Armazenamento inexistente');
END;

SELECT ck3_e_data_ultima_convocatoria(2)
FROM DUAL;

create or replace PROCEDURE chk3_f_transporta_frascos(vidTransporte number, vidArmazena number, vidlocalVacina varchar , quantidade NUMBER,destino varchar, origem varchar,DATAtransporte DATE)
IS
loc number;
vac number;
armaz number;
excecao_local exception;
Excecao_vacina exception;
Excecao_LocalArmazenamento exception;
BEGIN

Select count(local.LOCALVACINACAO) into loc
    from local,utente,convocatoria
     where local.LOCALVACINACAO=vidlocalVacina;

    if loc=0 then 
        Raise Excecao_Local;
    end if;
    
    Select count(armazem.id_armazem) into armaz
    from armazem,transporte
    where armazem.ID_ARMAZEM=vidArmazena;
    
     if armaz=0 then 
        Raise Excecao_LocalArmazenamento;
    end if;

INSERT INTO TRANSPORTE (ID_TRANSPORTE,ID_ARMAZEM,LOCALVACINACAO,N_FRASCOS,DESTINO,ORIGEM,DATA)
VALUES (vidTransporte,vidArmazena,vidlocalVacina,quantidade,destino,origem,DATAtransporte);

 EXCEPTION
      WHEN EXCECAO_Local THEN                                                           
            RAISE_APPLICATION_ERROR(-20502, 'Local de Vacinação Inexistente');
        When EXCECAO_LocalArmazenamento THEN
            RAISE_APPLICATION_ERROR(-20508, 'Local de Armazenamento inexistente');

END;

EXEC chk3_f_transporta_frascos('7', '4', 'Ginásio Municipal de Soure', '300','Soure','lisboa','21.03.30');


create or replace PROCEDURE chk3_h_abre_frasco( vidfrasco number)
IS 
numerodoses number;
frasc number;
faberto number;
tativo number;
estadofrasco frasco.estado%TYPE;
excecao_frasco exception;
excecao_narmazem exception;
excecao_faberto exception;
excecao_tativo exception;
BEGIN

Select count(ID_FRASCO) into frasc
    from frasco
     where ID_FRASCO=vidfrasco
     ;

if frasc=0 then
Raise excecao_frasco;
end if;

Select estado into faberto
    from frasco
     where ID_FRASCO=vidfrasco
     ;
if faberto = 'Aberto' then
raise excecao_faberto;
end if;

select count(id_turno) into tativo
from turno
where turno.ATIVO=0;

if tativo=0 then
RAISE excecao_tativo;
end if;


select estado into estadofrasco
from frasco
where id_frasco = vidfrasco;

IF estadofrasco = 'Aberto' THEN
  SELECT DISTINCT(seringas.quantidade)into numerodoses
FROM SERINGAS,FRASCO
WHERE SERINGAS.ID_FRASCO = vidfrasco;

UPDATE frasco
SET n_doses = numerodoses
WHERE id_frasco = vidfrasco;
END IF;

 EXCEPTION
      WHEN EXCECAO_frasco THEN                                                           
            RAISE_APPLICATION_ERROR(-20511, 'Frasco Inexistente');
        When EXCECAO_narmazem THEN
            RAISE_APPLICATION_ERROR(-20512, 'Frasco não está no local de armazenamento.');
        When EXCECAO_faberto THEN
            RAISE_APPLICATION_ERROR(-20513, 'Frasco já foi aberto.');
        When EXCECAO_tativo THEN
            RAISE_APPLICATION_ERROR(-20513, 'Não existe um truno de vacinação ativo.');

END;



CREATE OR REPLACE TRIGGER chk3_k_tg_apos_toma
AFTER INSERT ON TOMA
FOR EACH ROW
DECLARE
  LOCALA LOCAL.LOCALVACINACAO%TYPE;
  SERINGAA SERINGAS.ID_SERINGA%TYPE;
BEGIN  
  
  UPDATE SERINGAS                                              --ATUALIZA O ESTADO DA SERINGA UTILIZADA
  SET ESTADO ='Utilizada'
  WHERE SERINGAS.ID_TOMA=:NEW.ID_TOMA;
  
  
  SELECT LOCAL.LOCALVACINACAO INTO LOCALA
  FROM LOCAL,CONVOCATORIA
  WHERE LOCAL.LOCALVACINACAO=CONVOCATORIA.LOCALVACINACAO
  AND CONVOCATORIA.ID_CONVOCATORIA=:NEW.id_convocatoria;

  UPDATE Local                                               --ATUALIZA O numero de vacinas disponiveis no local
  SET NUMVACINASDISPONIVEIS = NUMVACINASDISPONIVEIS-1
  WHERE LOCALVACINACAO=LOCALA;
  
END;

insert into TOMA values('201','1','1','3',to_date('2021-06-11','yyyy-mm-dd'),'1');

SELECT ck3_e_data_ultima_convocatoria(3)
FROM DUAL;

CREATE OR REPLACE TRIGGER chk3_l_tg_convoca_proximo
after UPDATE OF REJEITOU ON UTENTE
FOR EACH ROW
DECLARE
      IDNCONV UTENTE.ID_UTENTE%TYPE;
      convoc CONVOCATORIA.ID_CONVOCATORIA%type;
BEGIN  
  SELECT UTENTE.ID_UTENTE into IDNCONV
  FROM UTENTE
  WHERE CONVOCADO=0
  and rownum = 1
  ;
  
  select CONVOCATORIA.ID_CONVOCATORIA into convoc
  from convocatoria
  where convocatoria.id_utente=IDNCONV;
  
  IF :new.REJEITOU=1 THEN
    UPDATE CONVOCATORIA
    SET id_utente = IDNCONV
    where id_convocatoria=convoc;
    end if;
END;

update utente set rejeitou=1 where id_utente=1;

CREATE OR REPLACE TRIGGER chk3_m_tg_apos_toma
AFTER INSERT ON toma
FOR EACH ROW
DECLARE
 rea number;
  LOCALA LOCAL.LOCALVACINACAO%TYPE;
  SERINGAA SERINGAS.ID_SERINGA%TYPE;
BEGIN  
  
  select count(id_reacao) into rea
  from reacao,toma
  where reacao.ID_TOMA=:New.id_toma;
  
 if rea > 0 then
  UPDATE frasco                                             --ATUALIZA O ESTADO Dos frascos
  SET ESTADO ='inutilzavel';
end if;
  
END;

--retorna quanto tempo um enfermeiro já gastou a vacinar
create or replace FUNCTION CHK3_FUNC_A2018019746(codenf number,numpac number)
RETURN number
IS 
estado enfermeiro.estado_enf%type;
tempovacinacao number;
ritmoenf number;
enferm number;
  Excecao_enfermeiro Exception;
  Excecao_trab Exception;
BEGIN

   Select count(id_enfermeiro) into enferm
    from ENFERMEIRO
    where ID_ENFERMEIRO=codenf;
    
    if enferm=0 then 
        Raise Excecao_enfermeiro;
    end if;
    
    select ENFERMEIRO.ESTADO_ENF into estado
    from enfermeiro
    where ID_ENFERMEIRO=codenf
    ;
    
    if estado != 'Trabalhar' then
        raise excecao_trab;
    end if;

SELECT enfermeiro.RITMO_VACINACAO INTO ritmoenf
FROM ENFERMEIRO
where ID_ENFERMEIRO=codenf;

tempovacinacao:=ritmoenf*numpac;
  RETURN tempovacinacao;
  
     EXCEPTION
     When EXCECAO_enfermeiro THEN
            RAISE_APPLICATION_ERROR(-20504, 'Enfermeiro Inexistente');
            When EXCECAO_trab THEN
            RAISE_APPLICATION_ERROR(-20520, 'Enfermeiro não está a trabalhar');
END;

SELECT CHK3_FUNC_A2018019746(5,10)
FROM DUAL;


--quando um enfermeiro muda o seu estado para não trabalhar updata o turno desse enfermeiro para não ativo

CREATE OR REPLACE TRIGGER  CHK3_Q_TRIG_A2018019746
after update of estado_enf ON enfermeiro
FOR EACH ROW
DECLARE

BEGIN  
  
  if :new.estado_enf = 'não trabalhar' then
  UPDATE turno                                            
  SET ativo = 0
  WHERE turno.id_enfermeiro = :new.id_enfermeiro;
  end if;
  
  
END;

update enfermeiro 
set ESTADO_ENF='não trabalhar'
where ID_ENFERMEIRO=4;


--verifica se um enfermeiro ainda pode receber um numpessoas agendado se não fecha o turno desse enfermeiro

create or replace PROCEDURE CHK3_PROC_A2018019746 (idenf number,numpess number)
IS 
datainic date;
datafim date;
tempoenf number;
tempoturn number;
tativo number;
estado number;
enferm number;
  Excecao_enfermeiro Exception;
  Excecao_trab Exception;
BEGIN

 Select count(id_enfermeiro) into enferm
    from ENFERMEIRO
    where ID_ENFERMEIRO=idenf;
    
    if enferm=0 then 
        Raise Excecao_enfermeiro;
    end if;
    
    select ENFERMEIRO.ESTADO_ENF into estado
    from enfermeiro
    where ID_ENFERMEIRO=idenf
    ;
    
     if estado != 'Trabalhar' then
        raise excecao_trab;
    end if;

select TURNO.DATAINICIOTURNO into datainic
from turno
where turno.ID_ENFERMEIRO=idenf
and ativo=1;

select turno.DATAFIMTURNO into datafim
from turno
where turno.ID_ENFERMEIRO=idenf
and ativo=1;


tempoturn:=to_number(datafim-datainic);
tempoenf:=CHK3_FUNC_A2018019746(idenf,numpess);

select ativo into tativo
from turno
where turno.ID_ENFERMEIRO=idenf
and ativo=1;

if (tempoenf >= tempoturn and tativo=1)then 
UPDATE turno
SET ativo = 0
where turno.ID_ENFERMEIRO=idenf;
end if;

     EXCEPTION
     When EXCECAO_enfermeiro THEN
            RAISE_APPLICATION_ERROR(-20504, 'Enfermeiro Inexistente');
            When EXCECAO_trab THEN
            RAISE_APPLICATION_ERROR(-20520, 'Enfermeiro não está a trabalhar');

END;

create or replace PROCEDURE CHK3_PROC_A2019123778 ( vidutente number)
IS 
ut number;
numerodoses number;
EXCECAO_utente exception;

BEGIN

Select count(utente.id_utente) into ut
    from utente
    where utente.ID_UTENTE=vIdUtente;
    
    if ut=0 then 
        Raise Excecao_utente;
    end if;

select distinct(COUNT(toma.ID_TOMA)) into numerodoses
from TOMA,UTENTE
where toma.id_utente = vidutente;


UPDATE utente
SET NDOSESTOMADAS = numerodoses
where utente.id_utente = vidutente;

 EXCEPTION
     When EXCECAO_utente THEN
            RAISE_APPLICATION_ERROR(-20501, 'Utente Inexistente');



END;

create or replace FUNCTION CHK3_FUNC_A2019123778 (vIdFrasco number)
RETURN frasco.data_aberto%TYPE
IS
frasc number;
Datafrasco frasco.data_aberto%TYPE;
estadofrasco frasco.estado%TYPE;
excecao_frasco exception;
BEGIN

Select count(id_frasco) into frasc
    from frasco
    where ID_frasco=vidfrasco;

    if frasc=0 then 
        Raise Excecao_frasco;
    end if;

select estado into estadofrasco
from frasco
where id_frasco = vidfrasco;

IF estadofrasco = 'Aberto' THEN
SELECT frasco.data_aberto INTO Datafrasco
FROM frasco
where id_frasco = vidfrasco;

END IF;

  RETURN Datafrasco;
  
   EXCEPTION
     When EXCECAO_frasco THEN
            RAISE_APPLICATION_ERROR(-20521, 'Frasco Inexistente');


END;


create or replace PROCEDURE CHK3_G_CONVOCA_UTENTES( vidfase number, vidturnovacinacao number)
IS
LOCALVACINACAO char;
FASE NUMBER;
DATAA DATE;
NUMCONV NUMBER;
idtoma number;
    CURSOR C1 IS --UTENTES DE UMA DETERMINADA FASE
    SELECT utente.ID_UTENTE
    FROM UTENTE,fase,convocatoria
    WHERE fase.nfase=vidfase
    and fase.nfase=convocatoria.nfase
    and convocatoria.id_utente=UTENTE.ID_UTENTE;
    
    CURSOR C2 IS --TODOS OS SLOTS DOS TURNO DISPONIVEIS
    SELECT ID_turno
    FROM  TURNO
    where TURNO.ID_TURNO = VIDTURNOVACINACAO;


BEGIN


    SELECT nfase INTO FASE
    FROM FASE
    WHERE nfase = VIDFASE;

        SELECT DATAINICIOturno,localvacinacao INTO DATAA,LOCALVACINACAO--DATA DO INICIO DO TURNO
        FROM TURNO
        WHERE ID_TURNO = VIDTURNOVACINACAO;

        SELECT COUNT(ID_CONVOCATORIA) INTO NUMCONV FROM CONVOCATORIA;
        
        idtoma:=100;
        
        FOR X IN C1  --percorre utentes da fase não vacinados
            LOOP
                FOR Y IN C2 
                LOOP
                        INSERT INTO CONVOCATORIA VALUES((NUMCONV+1),FASE,X.ID_UTENTE,idtoma,DATAA,1,LOCALVACINACAO);
                    NUMCONV:=NUMCONV+1;
                    idtoma:=idtoma+1;
                END LOOP;
            END LOOP;
END;
