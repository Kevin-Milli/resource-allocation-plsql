create or replace procedure deallocate(p_cod_prj varchar2) is

    -- Variabili
    v_project_end_date date;
    v_project_duration number;
    v_count number;

    -- Cursori
    cursor c_emp_proj is
        select cod_emp, date_init, date_end
        from t_alloc
        where cod_prj = p_cod_prj;

    -- Record di cursore
    rec_emp_proj c_emp_proj%rowtype;

begin
    -- Verifico se il progetto esiste
    select count(*)
    into v_count
    from t_prj
    where cod_prj = p_cod_prj;

    if v_count = 0 then
        raise_application_error(-20001, 'Progetto non trovato.');
    end if;

    -- Recupero la durata del progetto da eliminare
    select max(date_end) - min(date_init)
    into v_project_duration
    from t_alloc
    where cod_prj = p_cod_prj;

    -- Recupero la data di fine del progetto da eliminare
    select max(date_end)
    into v_project_end_date
    from t_alloc
    where cod_prj = p_cod_prj;

    -- Elimino tutte le allocazioni del progetto
    delete from t_alloc
    where cod_prj = p_cod_prj;
	
exception
    when others then
        pkg_utils.plog('Errore in deallocate: ', sqlcode, sqlerrm);


end;
/
