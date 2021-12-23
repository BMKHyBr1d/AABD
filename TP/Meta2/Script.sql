
/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     13/05/2021 19:58:03                          */
/*==============================================================*/


alter table CONVOCATORIA
   drop constraint FK_CONVOCAT_CONVOCA2_UTENTE;

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
   drop constraint FK_UTENTE_CONVOCA_CONVOCAT;

alter table UTENTE
   drop constraint FK_UTENTE_PRATICA_PROFISSA;

alter table UTENTE
   drop constraint FK_UTENTE_SAO_CONCELHO;

drop table ARMAZEM cascade constraints;

drop table CONCELHO cascade constraints;

drop index PARA2_FK;

drop index TEM_FK;

drop index CONVOCA_FK;

drop table CONVOCATORIA cascade constraints;

drop index POSSUI_FK;

drop table DOENCA cascade constraints;

drop table ENFERMEIRO cascade constraints;

drop table ENTREGA cascade constraints;

drop table FASE cascade constraints;

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

drop index CONVOCA_FK2;

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
   NUM_REJEITARAM       NUMBER(10),
   NVACINASDADAS_       NUMBER(10),
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
/* Index: CONVOCA_FK                                            */
/*==============================================================*/
create index CONVOCA_FK on CONVOCATORIA (
   ID_UTENTE ASC
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
   TEMPO_MEDIO          DATE,
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
   NUTENTESPREVISTOS    NUMBER(10),
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
/* Table: LOCAL                                                 */
/*==============================================================*/
create table LOCAL 
(
   LOCALVACINACAO       VARCHAR2(50)         not null,
   ID_CONCELHO          NUMBER(10)           not null,
   DATA                 DATE,
   NVACINADOS           NUMBER(10),
   NVACINASDADOS        NUMBER(10),
   NIMUNIZADOS          NUMBER(10),
   NTOTALTURNOS         NUMBER(10),
   NUMCONVOCADOS      NUMBER(10),
   NUMVACINASDISPONIVEIS NUMBER(10),
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
   ID_CONVOCATORIA      NUMBER(10),
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
/* Index: CONVOCA_FK2                                           */
/*==============================================================*/
create index CONVOCA_FK2 on UTENTE (
   ID_CONVOCATORIA ASC
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
   TEMPO_INTERVALO      DATE,
   DATA_CRIACAO         DATE,
   MARCA                VARCHAR2(50),
   LABORATORIO          VARCHAR2(50),
   constraint PK_VACINA primary key (ID_VACINA)
);

alter table CONVOCATORIA
   add constraint FK_CONVOCAT_CONVOCA2_UTENTE foreign key (ID_UTENTE)
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
   add constraint FK_UTENTE_CONVOCA_CONVOCAT foreign key (ID_CONVOCATORIA)
      references CONVOCATORIA (ID_CONVOCATORIA);

alter table UTENTE
   add constraint FK_UTENTE_PRATICA_PROFISSA foreign key (ID_PROFISSAO)
      references PROFISSAO (ID_PROFISSAO);

alter table UTENTE
   add constraint FK_UTENTE_SAO_CONCELHO foreign key (ID_CONCELHO)
      references CONCELHO (ID_CONCELHO);
/