/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     15/05/2021 16:17:31                          */
/*==============================================================*/


alter table CONVOCATORIA
   drop constraint FK_CONVOCAT_CONVOCA_UTENTE;

alter table CONVOCATORIA
   drop constraint FK_CONVOCAT_PARA2_TOMA;

alter table CONVOCATORIA
   drop constraint FK_CONVOCAT_TEM_FASE;

alter table DOENCA
   drop constraint FK_DOENCA_DE2_FASE;

alter table DOENCA
   drop constraint FK_DOENCA_POSSUI_UTENTE;

alter table FASE
   drop constraint FK_FASE_DA2_PROFISSA;

alter table FRASCO
   drop constraint FK_FRASCO_CARREGA_TRANSPOR;

alter table FRASCO
   drop constraint FK_FRASCO_COM_LOTES;

alter table FRASCO
   drop constraint FK_FRASCO_CONTENDO_VACINA;

alter table LOCAL
   drop constraint FK_LOCAL_PERTENCE_CONCELHO;

alter table LOTES
   drop constraint FK_LOTES_ADQUIRIDO_ENTREGA;

alter table LOTES
   drop constraint FK_LOTES_ARMAZENAM_ARMAZEM;

alter table LOTES
   drop constraint FK_LOTES_CONTEM_VACINA;

alter table REACAO
   drop constraint FK_REACAO_LIGADA_VACINA;

alter table REACAO
   drop constraint FK_REACAO_POSSIVEL_TOMA;

alter table SERINGAS
   drop constraint FK_SERINGAS_LIQUIDO_FRASCO;

alter table SERINGAS
   drop constraint FK_SERINGAS_NAS_TOMA;

alter table TOMA
   drop constraint FK_TOMA_LEVA_UTENTE;

alter table TOMA
   drop constraint FK_TOMA_PARTICIPA_TURNO;

alter table TRANSPORTE
   drop constraint FK_TRANSPOR_BUSCA_ARMAZEM;

alter table TRANSPORTE
   drop constraint FK_TRANSPOR_TRANSPORT_LOCAL;

alter table TURNO
   drop constraint FK_TURNO_ATUA_ENFERMEI;

alter table TURNO
   drop constraint FK_TURNO_USA_LOCAL;

alter table UTENTE
   drop constraint FK_UTENTE_PRATICA_PROFISSA;

alter table UTENTE
   drop constraint FK_UTENTE_SAO_CONCELHO;

drop table ARMAZEM cascade constraints;

drop table CONCELHO cascade constraints;

drop index PARA2_FK;

drop index TEM_FK;

drop table CONVOCATORIA cascade constraints;

drop index POSSUI_FK;

drop table DOENCA cascade constraints;

drop table ENFERMEIRO cascade constraints;

drop table ENTREGA cascade constraints;

drop table FASE cascade constraints;

drop index CONTENDO_FK;

drop index CARREGA_FK;

drop index COM_FK;

drop table FRASCO cascade constraints;

drop index PERTENCE_FK;

drop table LOCAL cascade constraints;

drop index ADQUIRIDO_FK;

drop index ARMAZENAM_FK;

drop index CONTEM_FK;

drop table LOTES cascade constraints;

drop table PROFISSAO cascade constraints;

drop table REACAO cascade constraints;

drop index LIQUIDO_FK;

drop table SERINGAS cascade constraints;

drop index PARTICIPA_FK;

drop index LEVA_FK;

drop table TOMA cascade constraints;

drop index BUSCA_FK;

drop index TRANSPORTA_FK;

drop table TRANSPORTE cascade constraints;

drop index USA_FK;

drop index ATUA_FK;

drop table TURNO cascade constraints;

drop index PRATICA_FK;

drop index SAO_FK;

drop table UTENTE cascade constraints;

drop table VACINA cascade constraints;

/*==============================================================*/
/* Table: ARMAZEM                                               */
/*==============================================================*/
create table ARMAZEM 
(
   ID_ARMAZEM           NUMBER(10)           not null,
   LOCAL                VARCHAR2(50),
   constraint PK_ARMAZEM primary key (ID_ARMAZEM)
);

/*==============================================================*/
/* Table: CONCELHO                                              */
/*==============================================================*/
create table CONCELHO 
(
   ID_CONCELHO          NUMBER(10)           not null,
   NOME_CONCELHO        VARCHAR2(50),
   REGIAO               VARCHAR2(50)         not null,
   constraint PK_CONCELHO primary key (ID_CONCELHO)
);

/*==============================================================*/
/* Table: CONVOCATORIA                                          */
/*==============================================================*/
create table CONVOCATORIA 
(
   ID_CONVOCATORIA      NUMBER(10)           not null,
   NFASE                NUMBER(3),
   ID_UTENTE            NUMBER(10)           not null,
   ID_TOMA              NUMBER(5)            not null,
   DATA_CONVOCATORIA    DATE,
   RESPOSTA             SMALLINT,
   constraint PK_CONVOCATORIA primary key (ID_CONVOCATORIA)
);

/*==============================================================*/
/* Index: TEM_FK                                                */
/*==============================================================*/
create index TEM_FK on CONVOCATORIA (
   NFASE ASC
);

/*==============================================================*/
/* Index: PARA2_FK                                              */
/*==============================================================*/
create index PARA2_FK on CONVOCATORIA (
   ID_TOMA ASC
);

/*==============================================================*/
/* Table: DOENCA                                                */
/*==============================================================*/
create table DOENCA 
(
   ID_DOENCA            NUMBER(5)            not null,
   NFASE                NUMBER(3),
   ID_UTENTE            NUMBER(10)           not null,
   NOME                 VARCHAR2(50),
   DESCRICAO            VARCHAR2(100),
   constraint PK_DOENCA primary key (ID_DOENCA)
);

/*==============================================================*/
/* Index: POSSUI_FK                                             */
/*==============================================================*/
create index POSSUI_FK on DOENCA (
   ID_UTENTE ASC
);

/*==============================================================*/
/* Table: ENFERMEIRO                                            */
/*==============================================================*/
create table ENFERMEIRO 
(
   ID_ENFERMEIRO        NUMBER(10)           not null,
   NOME                 VARCHAR2(50),
   IDADE                NUMBER(10),
   TEMPO_MEDIO          NUMBER,
   ESTADO_ENF           VARCHAR2(50),
   RITMO_VACINACAO      VARCHAR2(50),
   constraint PK_ENFERMEIRO primary key (ID_ENFERMEIRO)
);

/*==============================================================*/
/* Table: ENTREGA                                               */
/*==============================================================*/
create table ENTREGA 
(
   ID_ENTREGA           NUMBER(5)            not null,
   DATA_ENTREGA         DATE,
   LOCAL_ENTREGA        VARCHAR2(50),
   constraint PK_ENTREGA primary key (ID_ENTREGA)
);

/*==============================================================*/
/* Table: FASE                                                  */
/*==============================================================*/
create table FASE 
(
   NFASE                NUMBER(3)            not null,
   ID_PROFISSAO         NUMBER,
   DATAINICIOTURNO      DATE,
   DATAFIMTURNO         DATE,
   IDADE_MINIMA         NUMBER(5),
   IDADE_MAXIMA         NUMBER(5),
   constraint PK_FASE primary key (NFASE)
);

/*==============================================================*/
/* Table: FRASCO                                                */
/*==============================================================*/
create table FRASCO 
(
   ID_FRASCO            NUMBER(10)           not null,
   ID_TRANSPORTE        NUMBER(10),
   ID_VACINA            NUMBER(10)           not null,
   ID_LOTE              NUMBER(10)           not null,
   N_DOSES              NUMBER,
   DATA_ABERTO          DATE,
   LOCAL                VARCHAR2(50),
   ESTADO               VARCHAR2(50),
   constraint PK_FRASCO primary key (ID_FRASCO)
);

/*==============================================================*/
/* Index: COM_FK                                                */
/*==============================================================*/
create index COM_FK on FRASCO (
   ID_LOTE ASC
);

/*==============================================================*/
/* Index: CARREGA_FK                                            */
/*==============================================================*/
create index CARREGA_FK on FRASCO (
   ID_TRANSPORTE ASC
);

/*==============================================================*/
/* Index: CONTENDO_FK                                           */
/*==============================================================*/
create index CONTENDO_FK on FRASCO (
   ID_VACINA ASC
);

/*==============================================================*/
/* Table: LOCAL                                                 */
/*==============================================================*/
create table LOCAL 
(
   LOCALVACINACAO       VARCHAR2(50)         not null,
   DATA                 DATE,
   NUMVACINASDISPONIVEIS NUMBER(10),
   ID_CONCELHO          NUMBER(10)           not null,
   constraint PK_LOCAL primary key (LOCALVACINACAO)
);

/*==============================================================*/
/* Index: PERTENCE_FK                                           */
/*==============================================================*/
create index PERTENCE_FK on LOCAL (
   ID_CONCELHO ASC
);

/*==============================================================*/
/* Table: LOTES                                                 */
/*==============================================================*/
create table LOTES 
(
   ID_LOTE              NUMBER(10)           not null,
   ID_ENTREGA           NUMBER(5),
   ID_VACINA            NUMBER(10)           not null,
   ID_ARMAZEM           NUMBER(10),
   N_FRASCOS            NUMBER(10),
   DATA_PRODUCAO        DATE,
   DATA_VALIDADE        DATE,
   constraint PK_LOTES primary key (ID_LOTE)
);

/*==============================================================*/
/* Index: CONTEM_FK                                             */
/*==============================================================*/
create index CONTEM_FK on LOTES (
   ID_VACINA ASC
);

/*==============================================================*/
/* Index: ARMAZENAM_FK                                          */
/*==============================================================*/
create index ARMAZENAM_FK on LOTES (
   ID_ARMAZEM ASC
);

/*==============================================================*/
/* Index: ADQUIRIDO_FK                                          */
/*==============================================================*/
create index ADQUIRIDO_FK on LOTES (
   ID_ENTREGA ASC
);

/*==============================================================*/
/* Table: PROFISSAO                                             */
/*==============================================================*/
create table PROFISSAO 
(
   NOME_PROFISSAO       VARCHAR2(50)         not null,
   ID_PROFISSAO         NUMBER               not null,
   constraint PK_PROFISSAO primary key (ID_PROFISSAO)
);

/*==============================================================*/
/* Table: REACAO                                                */
/*==============================================================*/
create table REACAO 
(
   ID_REACAO            NUMBER(10)           not null,
   ID_VACINA            NUMBER(10)           not null,
   ID_TOMA              NUMBER(5)            not null,
   DESCRICAO            VARCHAR2(100),
   constraint PK_REACAO primary key (ID_REACAO)
);

/*==============================================================*/
/* Table: SERINGAS                                              */
/*==============================================================*/
create table SERINGAS 
(
   ID_SERINGA           NUMBER(5)            not null,
   ID_TOMA              NUMBER(5),
   ID_FRASCO            NUMBER(10)           not null,
   QUANTIDADE           NUMBER(10),
   ESTADO               VARCHAR2(50),
   constraint PK_SERINGAS primary key (ID_SERINGA)
);

/*==============================================================*/
/* Index: LIQUIDO_FK                                            */
/*==============================================================*/
create index LIQUIDO_FK on SERINGAS (
   ID_FRASCO ASC
);

/*==============================================================*/
/* Table: TOMA                                                  */
/*==============================================================*/
create table TOMA 
(
   ID_TOMA              NUMBER(5)            not null,
   ID_CONVOCATORIA      NUMBER(10),
   ID_UTENTE            NUMBER(10)           not null,
   ID_TURNO             NUMBER(10)           not null,
   DATA_TOMA            DATE,
   COMPARECEU           SMALLINT,
   constraint PK_TOMA primary key (ID_TOMA)
);

/*==============================================================*/
/* Index: LEVA_FK                                               */
/*==============================================================*/
create index LEVA_FK on TOMA (
   ID_UTENTE ASC
);

/*==============================================================*/
/* Index: PARTICIPA_FK                                          */
/*==============================================================*/
create index PARTICIPA_FK on TOMA (
   ID_TURNO ASC
);

/*==============================================================*/
/* Table: TRANSPORTE                                            */
/*==============================================================*/
create table TRANSPORTE 
(
   ID_TRANSPORTE        NUMBER(10)           not null,
   ID_ARMAZEM           NUMBER(10)           not null,
   LOCALVACINACAO       VARCHAR2(50)         not null,
   N_FRASCOS            NUMBER(10),
   DESTINO              VARCHAR2(50),
   ORIGEM               VARCHAR2(50),
   DATA                 DATE,
   constraint PK_TRANSPORTE primary key (ID_TRANSPORTE)
);

/*==============================================================*/
/* Index: TRANSPORTA_FK                                         */
/*==============================================================*/
create index TRANSPORTA_FK on TRANSPORTE (
   LOCALVACINACAO ASC
);

/*==============================================================*/
/* Index: BUSCA_FK                                              */
/*==============================================================*/
create index BUSCA_FK on TRANSPORTE (
   ID_ARMAZEM ASC
);

/*==============================================================*/
/* Table: TURNO                                                 */
/*==============================================================*/
create table TURNO 
(
   ID_TURNO             NUMBER(10)           not null,
   ID_ENFERMEIRO        NUMBER(10)           not null,
   LOCALVACINACAO       VARCHAR2(50)         not null,
   DATAINICIOTURNO      DATE,
   DATAFIMTURNO         DATE,
   ATIVO                SMALLINT,
   constraint PK_TURNO primary key (ID_TURNO)
);

/*==============================================================*/
/* Index: ATUA_FK                                               */
/*==============================================================*/
create index ATUA_FK on TURNO (
   ID_ENFERMEIRO ASC
);

/*==============================================================*/
/* Index: USA_FK                                                */
/*==============================================================*/
create index USA_FK on TURNO (
   LOCALVACINACAO ASC
);

/*==============================================================*/
/* Table: UTENTE                                                */
/*==============================================================*/
create table UTENTE 
(
   ID_UTENTE            NUMBER(10)           not null,
   ID_CONCELHO          NUMBER(10)           not null,
   ID_PROFISSAO         NUMBER               not null,
   NOME                 VARCHAR2(50),
   IDADE                NUMBER(10),
   IMUNIZADO            SMALLINT,
   LOCALDETRABALHO      VARCHAR2(50),
   DATADENASCIMENTO     DATE,
   REJEITOU             SMALLINT,
   CONVOCADO            SMALLINT,
   NDOSESTOMADAS        NUMBER(3),
   DATAULTIMADOSE       DATE,
   CENTRO_SAUDE         VARCHAR2(50),
   constraint PK_UTENTE primary key (ID_UTENTE)
);

/*==============================================================*/
/* Index: SAO_FK                                                */
/*==============================================================*/
create index SAO_FK on UTENTE (
   ID_CONCELHO ASC
);

/*==============================================================*/
/* Index: PRATICA_FK                                            */
/*==============================================================*/
create index PRATICA_FK on UTENTE (
   ID_PROFISSAO ASC
);

/*==============================================================*/
/* Table: VACINA                                                */
/*==============================================================*/
create table VACINA 
(
   ID_VACINA            NUMBER(10)           not null,
   NOME                 VARCHAR2(50),
   DATAAPROVACAO        DATE,
   NDOSESNECESSARIAS    NUMBER(3),
   TEMPO_INTERVALO      NUMBER,
   DATA_CRIACAO         DATE,
   MARCA                VARCHAR2(50),
   LABORATORIO          VARCHAR2(50),
   constraint PK_VACINA primary key (ID_VACINA)
);

alter table CONVOCATORIA
   add constraint FK_CONVOCAT_CONVOCA_UTENTE foreign key (ID_UTENTE)
      references UTENTE (ID_UTENTE);

alter table CONVOCATORIA
   add constraint FK_CONVOCAT_PARA2_TOMA foreign key (ID_TOMA)
      references TOMA (ID_TOMA);

alter table CONVOCATORIA
   add constraint FK_CONVOCAT_TEM_FASE foreign key (NFASE)
      references FASE (NFASE);

alter table DOENCA
   add constraint FK_DOENCA_DE2_FASE foreign key (NFASE)
      references FASE (NFASE);

alter table DOENCA
   add constraint FK_DOENCA_POSSUI_UTENTE foreign key (ID_UTENTE)
      references UTENTE (ID_UTENTE);

alter table FASE
   add constraint FK_FASE_DA2_PROFISSA foreign key (ID_PROFISSAO)
      references PROFISSAO (ID_PROFISSAO);

alter table FRASCO
   add constraint FK_FRASCO_CARREGA_TRANSPOR foreign key (ID_TRANSPORTE)
      references TRANSPORTE (ID_TRANSPORTE);

alter table FRASCO
   add constraint FK_FRASCO_COM_LOTES foreign key (ID_LOTE)
      references LOTES (ID_LOTE);

alter table FRASCO
   add constraint FK_FRASCO_CONTENDO_VACINA foreign key (ID_VACINA)
      references VACINA (ID_VACINA);

alter table LOCAL
   add constraint FK_LOCAL_PERTENCE_CONCELHO foreign key (ID_CONCELHO)
      references CONCELHO (ID_CONCELHO);

alter table LOTES
   add constraint FK_LOTES_ADQUIRIDO_ENTREGA foreign key (ID_ENTREGA)
      references ENTREGA (ID_ENTREGA);

alter table LOTES
   add constraint FK_LOTES_ARMAZENAM_ARMAZEM foreign key (ID_ARMAZEM)
      references ARMAZEM (ID_ARMAZEM);

alter table LOTES
   add constraint FK_LOTES_CONTEM_VACINA foreign key (ID_VACINA)
      references VACINA (ID_VACINA);

alter table REACAO
   add constraint FK_REACAO_LIGADA_VACINA foreign key (ID_VACINA)
      references VACINA (ID_VACINA);

alter table REACAO
   add constraint FK_REACAO_POSSIVEL_TOMA foreign key (ID_TOMA)
      references TOMA (ID_TOMA);

alter table SERINGAS
   add constraint FK_SERINGAS_LIQUIDO_FRASCO foreign key (ID_FRASCO)
      references FRASCO (ID_FRASCO);

alter table SERINGAS
   add constraint FK_SERINGAS_NAS_TOMA foreign key (ID_SERINGA)
      references TOMA (ID_SERINGA);

alter table TOMA
   add constraint FK_TOMA_LEVA_UTENTE foreign key (ID_UTENTE)
      references UTENTE (ID_UTENTE);

alter table TOMA
   add constraint FK_TOMA_PARTICIPA_TURNO foreign key (ID_TURNO)
      references TURNO (ID_TURNO);

alter table TRANSPORTE
   add constraint FK_TRANSPOR_BUSCA_ARMAZEM foreign key (ID_ARMAZEM)
      references ARMAZEM (ID_ARMAZEM);

alter table TRANSPORTE
   add constraint FK_TRANSPOR_TRANSPORT_LOCAL foreign key (LOCALVACINACAO)
      references LOCAL (LOCALVACINACAO);

alter table TURNO
   add constraint FK_TURNO_ATUA_ENFERMEI foreign key (ID_ENFERMEIRO)
      references ENFERMEIRO (ID_ENFERMEIRO);

alter table TURNO
   add constraint FK_TURNO_USA_LOCAL foreign key (LOCALVACINACAO)
      references LOCAL (LOCALVACINACAO);

alter table UTENTE
   add constraint FK_UTENTE_PRATICA_PROFISSA foreign key (ID_PROFISSAO)
      references PROFISSAO (ID_PROFISSAO);

alter table UTENTE
   add constraint FK_UTENTE_SAO_CONCELHO foreign key (ID_CONCELHO)
      references CONCELHO (ID_CONCELHO);
    
    ALTER TABLE CONVOCATORIA
    ADD LOCALVACINACAO VARCHAR(50);
    
    ALTER TABLE CONVOCATORIA
    add foreign key (LOCALVACINCACAO)
    references LOCAL (LOCALVACINACAO);

/*a) VIEW_A que, para cada local de vacina??o e por m?s, mostre o n?mero de vacinas administradas, o n?mero de pessoas vacinadas (com 1 ou mais tomas) e o n?mero de pessoas com a vacina??o completa (que tomaram o n?mero de tomas especificadas para essa vacina). Ordene o resultado pelo local de vacina e descendentemente pelo m?s.
*/

  CREATE VIEW Vista_A  AS 
   Select local.localvacinacao as local,EXTRACT(MONTH FROM local.data) as mes ,count(toma.id_toma) as NVacinasDadas ,count(utente.id_utente) as Nvacinados,count(utente.id_utente)as NImunizados
from local,toma,utente,concelho
where toma.compareceu=1 and utente.Ndosestomadas >= 1 and utente.Imunizado=1
and local.id_concelho=concelho.id_concelho 
and concelho.id_concelho=utente.id_concelho
and toma.id_utente=utente.id_utente 
group by local.localvacinacao, EXTRACT(MONTH FROM local.data) 
order by LOCALVACINACAO,mes desc;


create view Vista_B as
Select Unique concelho.regiao,vacina.NOME, EXTRACT(MONTH FROM local.data) as mes,count (entrega.id_entrega) as Nentregues, (select count(id_toma) 
                                                                                                                      from toma
                                                                                                                      where toma.compareceu=1
                                                                                                                      ) as NVacinasDadas,(select count(id_utente) 
                                                                                                                                           from utente where Ndosestomadas >= 1) NVACINADOS,(select count(id_utente) 
                                                                                                                                                                                              from utente where convocado=1 
                                                                                                                                                                                              ) NIncritos
from entrega,lotes,armazem,transporte,local,vacina,frasco,concelho,utente
where entrega.id_entrega=lotes.id_entrega
and lotes.id_armazem=armazem.id_armazem
and armazem.id_armazem=transporte.id_armazem
and transporte.LocalVacinacao=local.localvacinacao
and local.ID_CONCELHO=concelho.id_concelho
and utente.id_concelho=concelho.id_concelho 
group by concelho.regiao, vacina.NOME, EXTRACT(MONTH FROM local.data) 
;

create view Vista_C as 

select concelho.regiao,vacina.nome,EXTRACT(MONTH FROM local.data) as mes,count(entrega.id_entrega) NEntregues,(select count(id_toma) 
                                                                                                                      from toma
                                                                                                                      where toma.compareceu=1
                                                                                                                      ) as NVacinasDadas,(select count(id_utente) 
                                                                                                                                           from utente 
                                                                                                                                           where Ndosestomadas >= 1) NVACINADOS,(select count(id_utente)
                                                                                                                                                                                    from utente
                                                                                                                                                                                    where utente.convocado=1
                                                                                                                                                                                    and utente.rejeitou=0) as NINscritos

from entrega,lotes,armazem,transporte,local,vacina,frasco,concelho,utente
where entrega.id_entrega=lotes.id_entrega
and lotes.id_armazem=armazem.id_armazem
and armazem.id_armazem=transporte.id_armazem
and transporte.LocalVacinacao=local.localvacinacao
and local.ID_CONCELHO=concelho.id_concelho
and utente.id_concelho=concelho.id_concelho 
group by concelho.regiao, vacina.nome, EXTRACT(MONTH FROM local.data) 
;


Create or replace view Vista_d as
select concelho.REGIAO,count(utente.id_utente) as N_de_utente,(select count(id_toma) 
                                                                from toma
                                                                 where toma.compareceu=1
                                                                 ) as NVacinasDadas,ROUND( ( ( select COUNT(ID_convocatoria) from convocatoria a where resposta=1 )* 100) / (select count(convocatoria.id_convocatoria) from convocatoria),2) || '%' AS PERCENTAGEMIMUNIZADA
from concelho, utente,toma,seringas,frasco
where concelho.id_concelho=utente.id_concelho
and utente.id_utente=toma.id_utente
and seringas.id_toma=toma.id_toma
AND FRASCO.ID_FRASCO =  SERINGAS.ID_FRASCO 
group by concelho.REGIAO 
;


Create or replace view Vista_e as 
SELECT NFASE,COUNT(ID_CONVOCATORIA) AS NUtentesPrevistos,ROUND( (  ( SELECT COUNT(*) 
      FROM   UTENTE
      WHERE IMUNIZADO > 0)* 100) / (SELECT COUNT(*)
      FROM UTENTE),2) || '%' AS PERCENTAGEMIMUNIZADA,
(
      SELECT COUNT(*) 
      FROM   UTENTE
      WHERE NDOSESTOMADAS > 0
      ) AS NVACINADOS,
      (
        SELECT COUNT(*) 
      FROM   UTENTE
      WHERE IMUNIZADO > 0
      ) AS NIMUNIZADOS
FROM UTENTE,CONVOCATORIA
WHERE utente.id_utente = convocatoria.id_utente
GROUP BY NFASE;

create or replace view Vista_f as
SELECT  Vacina.nome, EXTRACT(MONTH FROM frasco.data_aberto) as mes, COUNT(ID_SERINGA) AS Num_doses_utilizadas ,SUM(FRASCO.N_DOSES) AS NUM_DOSES_FORNECIDAS, ROUND( ( ( COUNT(ID_SERINGA))* 100) / (SUM(FRASCO.N_DOSES)),2) || '%' AS Percent_utilizacao
FROM FRASCO,VACINA,SERINGAS
WHERE VACINA.ID_VACINA= FRASCO.ID_VACINA AND FRASCO.ID_FRASCO =  SERINGAS.ID_FRASCO 
group by vacina.nome, EXTRACT(MONTH FROM frasco.data_aberto)
ORDER BY NUM_DOSES_FORNECIDAS DESC;

create or replace view Vista_G as 
 select concelho.nome_concelho,local.localvacinacao,COUNT(TOMA.ID_CONVOCATORIA) AS NUMCONVOCADOS, max(ROUND( ( ( select COUNT(ID_convocatoria) from convocatoria a where resposta=1 )* 100) / (select count(convocatoria.id_convocatoria) from convocatoria),2)) || '%' AS PERCENTAGEMIMUNIZADA
from utente,concelho,local,convocatoria,toma
where concelho.id_concelho=local.id_concelho 
and utente.id_utente=convocatoria.ID_CONVOCATORIA
and utente.id_concelho=concelho.id_concelho
and toma.id_convocatoria=convocatoria.id_convocatoria
group by concelho.nome_concelho, local.localvacinacao
order by 4 desc
;

Create or replace view Vista_H as
SELECT convocatoria.LOCALVACINACAO, COUNT(toma.ID_TURNO) AS NUMTURNOS , COUNT(TOMA.ID_CONVOCATORIA) AS NUMCONVOCADOS , COUNT(TOMA.ID_UTENTE) AS NUMVACINADOS , COUNT (TOMA.ID_TOMA) AS NVACINASDADAS
FROM LOCAL ,CONVOCATORIA,TURNO,UTENTE,TOMA
WHERE TOMA.ID_TURNO = turno.id_turno 
AND UTENTE.ID_UTENTE = convocatoria.id_utente 
AND UTENTE.ID_UTENTE = TOMA.ID_UTENTE
and local.localvacinacao=CONVOCATORIA.LOCALVACINACAO
GROUP BY convocatoria.LOCALVACINACAO
ORDER BY NVACINASDADAS DESC;



Create view Vista_I as 
    select Nome_concelho,count(utente.id_utente) as num_utentes,(select count(utente.id_utente) from utente where utente.imunizado=1) as NumImunizados,ROUND( ( (select count(utente.id_utente) from utente where utente.imunizado=1)* 100) / count(utente.id_utente),2) || '%' AS PERCENTAGEMIMUNIZADA
    from concelho, utente,toma,seringas,frasco
    where concelho.id_concelho=utente.id_concelho
    and utente.id_utente=toma.id_utente
    and seringas.id_toma=toma.id_toma
    AND FRASCO.ID_FRASCO =  SERINGAS.ID_FRASCO 
    and rownum <=10
    group by nome_concelho
    order by 4 desc
;


--Mostra a vacina e quantas rea??es essa vacina tem
Create view Vista_J_a2018019746 as
select vacina.nome,count(reacao.id_reacao) as Num_Reacoes
from vacina,reacao
where reacao.id_vacina=vacina.id_vacina
group by vacina.nome
order by 2 desc;


Create view Vista_K_a2018019746 as
SELECT utente.idade as Maior_idade,reacao.descricao as Reacao,vacina.nome as Vacina
FROM utente,toma,reacao,vacina
WHERE utente.id_utente=toma.id_utente
and toma.id_toma=reacao.id_toma
and reacao.id_vacina=vacina.id_vacina
AND utente.idade =
(SELECT max(idade)
FROM utente
);


-- esta vista apenas ve quantas pessoas s?o doentes por idade, ? bastante simples mas pode ser ?til
create view Vista_J_a2019123778 as 
SELECT COUNT(DOENCA.ID_doenca) AS NUMDOENTES, utente.idade
FROM UTENTE,DOENCA
WHERE UTENTE.id_utente = DOENCA.ID_UTENTE 
GROUP BY UTENTE.IDADE;

--Esta vista mostra quais vacinas com mais de duas doses t?m o tempo de intervalo entre a toma das doses abaixo da m?dia, para a?m disto mostra o total de frascos transportados de todas as vacinas.
create view Vista_K_a2019123778 as
SELECT VACINA.NOME,
(SELECT SUM(TRANSPORTE.N_FRASCOS)
FROM FRASCO,TRANSPORTE
WHERE FRASCO.ID_TRANSPORTE = TRANSPORTE.ID_TRANSPORTE) AS NUM_FRASCOS_TRANSPORTADOS
from VACINA,FRASCO
where tempo_intervalo<(select avg(tempo_intervalo) from vacina where ndosesnecessarias > 1) AND VACINA.ID_VACINA = FRASCO.ID_VACINA
ORDER BY DATA_CRIACAO

;


--VISTA_J_a2017015954
--Vista para ver quantas seringas s?o usadas por dia
Create view VISTA_J_a2017015954 as
select count(id_seringa) as NumSeringasUsadasPorDia,data_toma as Data
from seringas,toma
where seringas.id_toma=toma.id_toma 
group by data_toma
order by data_toma asc;

--VISTA_k_a2017015954
--Verifica que enfermeiro tem um tempo m?dio de vacina??o a baixo da m?dia.
create view VISTA_k_a2017015954 as
select id_enfermeiro,nome
from enfermeiro
where tempo_medio<(select avg(tempo_medio) from enfermeiro);


commit;


