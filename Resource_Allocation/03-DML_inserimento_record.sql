/*
    Popolamento tabelle
*/

DELETE from T_rel_emp_skl;
DELETE from T_rel_prj_skl;
DELETE from T_EMP;
DELETE from T_SKL;
DELETE from T_PRJ;


Insert into T_EMP(COD_EMP, DESC_EMP, HIRE_DATE) Values('AAA', 'ANTONIO', TO_DATE('2013/01/25','yyyy/mm/dd'));

Insert into T_EMP(COD_EMP, DESC_EMP, HIRE_DATE) Values('BBB', 'BRUNO', TO_DATE('2011/09/13', 'yyyy/mm/dd'));

Insert into T_EMP(COD_EMP, DESC_EMP, HIRE_DATE) Values('CCC', 'CLAUDIO', TO_DATE('2013/06/12','yyyy/mm/dd'));

Insert into T_EMP(COD_EMP, DESC_EMP, HIRE_DATE) Values('DDD', 'DANIELE', TO_DATE('2009/08/12','yyyy/mm/dd'));

Insert into T_EMP(COD_EMP, DESC_EMP, HIRE_DATE) Values('EEE', 'ENRICO', TO_DATE('2012/03/14', 'yyyy/mm/dd'));
COMMIT;
/

Insert into T_PRJ(COD_PRJ, DESC_PRJ) Values('P1', 'DB IN ORACLE');

Insert into T_PRJ(COD_PRJ, DESC_PRJ) Values('P2', 'VICINI DI CASA');

Insert into T_PRJ(COD_PRJ, DESC_PRJ) Values('P3', 'CENTRALE NUCLEARE');

Insert into T_PRJ(COD_PRJ, DESC_PRJ) Values('P4', 'BANCA');
COMMIT;
/

Insert into T_SKL(COD_SKL, DESC_SKL) Values('SK1', 'ORACLE');

Insert into T_SKL(COD_SKL, DESC_SKL) Values('SK2', 'JAVA');

Insert into T_SKL(COD_SKL, DESC_SKL) Values('SK3', 'C#');

Insert into T_SKL(COD_SKL, DESC_SKL) Values('SK4', 'ANDROID');
COMMIT;
/

Insert into T_rel_emp_skl(COD_EMP, COD_SKL) Values('AAA', 'SK1');

Insert into T_rel_emp_skl(COD_EMP, COD_SKL) Values('BBB', 'SK3');

Insert into T_rel_emp_skl(COD_EMP, COD_SKL) Values('CCC', 'SK4');

Insert into T_rel_emp_skl(COD_EMP, COD_SKL) Values('DDD', 'SK2');

Insert into T_rel_emp_skl(COD_EMP, COD_SKL) Values('EEE', 'SK2');

Insert into T_rel_emp_skl(COD_EMP, COD_SKL) Values('CCC', 'SK1');

Insert into T_rel_emp_skl(COD_EMP, COD_SKL) Values('EEE', 'SK1');
COMMIT;
/

Insert into T_rel_Prj_skl(COD_PRJ, COD_SKL) Values('P1', 'SK2');

Insert into T_rel_Prj_skl(COD_PRJ, COD_SKL) Values('P2', 'SK4');

Insert into T_rel_Prj_skl(COD_PRJ, COD_SKL) Values('P4', 'SK1');

Insert into T_rel_Prj_skl(COD_PRJ, COD_SKL) Values('P3', 'SK3');

Insert into T_rel_Prj_skl(COD_PRJ, COD_SKL) Values('P4', 'SK2');

Insert into T_rel_Prj_skl(COD_PRJ, COD_SKL) Values('P2', 'SK3');
COMMIT;
/
