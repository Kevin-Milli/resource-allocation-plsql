/*
    Creazione delle tabelle per la gestione della base dati
*/

create table t_emp (
cod_emp varchar2(4),
desc_emp varchar2(20),
hire_date date
);


create table t_skl(
cod_skl varchar2(4),
desc_skl varchar2(20)
);


create table t_prj(
cod_prj varchar2(4),
desc_prj varchar2(20)
);


create table t_rel_emp_skl(
cod_emp varchar2(4),
cod_skl varchar2(20)
);


create table t_rel_prj_skl(
cod_prj varchar2(4),
cod_skl varchar2(4)
);


create table t_alloc(
cod_emp varchar2(4),
cod_prj varchar2(4),
date_init date,
date_end date,
date_ins date
);


/*
    Aggiunta chiavi esterne
*/


alter table t_emp add (
constraint cod_emp_pk
primary key (cod_emp)
);


alter table t_skl add (
constraint cod_skl_pk
primary key (cod_skl)
);


alter table t_prj add (
constraint cod_prj_pk
primary key (cod_prj)
);


alter table t_rel_emp_skl add (
CONSTRAINT cod_emp_fk
FOREIGN KEY (cod_emp)
REFERENCES T_EMP(cod_emp),
CONSTRAINT cod_skl_fk
FOREIGN KEY (cod_skl)
REFERENCES T_skl(cod_skl)
);


alter table t_rel_prj_skl add (
CONSTRAINT cod_prj_fk
FOREIGN KEY (cod_prj)
REFERENCES T_prj(cod_prj),
CONSTRAINT cod_skl_2_fk
FOREIGN KEY (cod_skl)
REFERENCES T_skl(cod_skl)
);


alter table t_alloc add (
CONSTRAINT cod_prj_2_fk
FOREIGN KEY (cod_prj)
REFERENCES T_prj(cod_prj),
CONSTRAINT cod_emp_2_fk
FOREIGN KEY (cod_emp)
REFERENCES T_emp(cod_emp)
);
