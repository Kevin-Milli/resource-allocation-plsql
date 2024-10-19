/*
    Creazione tabelle di log degli errori
*/

CREATE TABLE tlog_error(
caller varchar2(30),
orcl_code varchar(10),
ORCL_MSG varchar2(100),
time_stamp date
);


/*
    crezione package di log per semplificazione operazioni di inserimento
*/


create or replace package pkg_utils is
    procedure tlog(p_caller varchar2, p_orcl_code varchar2, p_orcl_msg varchar2);
end;
/

create or replace package body pkg_utils is 
    procedure tlog(p_caller varchar2, p_orcl_code varchar2, p_orcl_msg varchar2) is
            time_stmp date := sysdate;
        begin 
        
            insert into tlog_error(
                caller,
                orcl_code,
                ORCL_MSG,
                time_stamp
            )
            values(
                p_caller,
                p_orcl_code,
                p_orcl_msg,
                time_stmp
            );
            commit;
            
        end;

end;
/













