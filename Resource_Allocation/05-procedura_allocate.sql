create or replace procedure allocate(p_cod_prj varchar2, months number) is

    -- Data di inizio progetto (fittizia)
    today_date date := to_date('01/02/2013', 'dd/mm/yyyy'); -- data di test

    -- Numero totale di skill di un dipendente
    tot_skills number;

    -- Numero di skill richieste dal progetto
    nr_skills_required number;

    -- Controllo esistenza progetto e assegnazioni
    is_already_a_prj number;
    v_count number;

    -- Dati del dipendente e progetto
    id_emp varchar2(10);
    hire_date date;
    date_start_p date;
    date_end_p date;
    cod_prj_p varchar2(10);

    -- Cursor per trovare i dipendenti e le loro skill
    cursor c_emp is
        select e.cod_emp, e.hire_date, count(res.cod_skl) nr_skills
        from t_emp e
        join t_rel_emp_skl res on e.cod_emp = res.cod_emp
        join t_rel_prj_skl rps on res.cod_skl = rps.cod_skl
        where rps.cod_prj = p_cod_prj
        group by e.cod_emp, e.hire_date
        order by count(res.cod_skl) desc, e.hire_date asc;

    -- Cursor per trovare le skill mancanti
    cursor c_missing_skl(p_emp_cod varchar2) is
        select e.cod_emp, res.cod_skl, rps.cod_prj
        from t_emp e
        join t_rel_emp_skl res on e.cod_emp = res.cod_emp
        join t_rel_prj_skl rps on res.cod_skl = rps.cod_skl
        where rps.cod_prj = p_cod_prj
        and res.cod_skl not in (
            select res_inner.cod_skl
            from t_rel_emp_skl res_inner
            where res_inner.cod_emp = p_emp_cod
        );

    -- Variabili per la data di fine del progetto
    date_end_p2 date := add_months(today_date, months);
    new_code_emp varchar2(10);
    missing_skl varchar2(20);
    prj_cod_skl varchar2(10);

begin

    -- 1. Verifico che il progetto esista
    select count(*) into v_count
    from t_prj
    where cod_prj = p_cod_prj;

    if v_count = 0 then
        raise_application_error(-20001, 'Progetto non supportato.');
    end if;

    -- 2. Verifico se il progetto ha precedenti assegnazioni
    select count(*) into is_already_a_prj
    from t_alloc
    where cod_prj = p_cod_prj;

    -- 3. Numero di skill richieste dal progetto
    select count(*) into nr_skills_required
    from t_rel_prj_skl
    where t_rel_prj_skl.cod_prj = p_cod_prj;

    -- 4. Se il progetto ha già assegnazioni
    if is_already_a_prj > 0 then

        -- Ciclo sui dipendenti già assegnati al progetto
        for emp in (select cod_emp, cod_prj, date_init, date_end
                    from t_alloc
                    where cod_prj = p_cod_prj) loop

            id_emp := emp.cod_emp;
            date_start_p := emp.date_init;
            date_end_p := emp.date_end;
            cod_prj_p := emp.cod_prj;

            -- Controllo delle skill del dipendente
            select count(res.cod_skl) into tot_skills
            from t_emp e
            join t_rel_emp_skl res on e.cod_emp = res.cod_emp
            where e.cod_emp = id_emp;

            -- Se le skill del dipendente sono sufficienti
            if tot_skills = nr_skills_required then
                return; -- Esce dalla procedura

            -- Se il dipendente ha meno skill di quelle richieste
            elsif tot_skills < nr_skills_required then
                open c_missing_skl(id_emp);
                loop
                    fetch c_missing_skl into new_code_emp, missing_skl, prj_cod_skl;
                    exit when c_missing_skl%notfound;

                    -- Assegno un nuovo dipendente con le skill mancanti
                    insert into t_alloc(cod_emp, cod_prj, date_init, date_end, date_ins)
                    values (new_code_emp, cod_prj_p, date_start_p, date_end_p, sysdate);

                end loop;
                close c_missing_skl;
            end if;
        end loop;

    -- 5. Se il progetto non ha ancora assegnazioni, nuovo dipendente
    else
        open c_emp;
        loop
            fetch c_emp into id_emp, hire_date, tot_skills;
            exit when c_emp%notfound;

            -- Se il dipendente soddisfa tutte le skill richieste
            if tot_skills = nr_skills_required then
                insert into t_alloc(cod_emp, cod_prj, date_init, date_end, date_ins)
                values (id_emp, p_cod_prj, today_date, date_end_p2, sysdate);
                return;

            -- Se il dipendente ha meno skill di quelle richieste
            elsif tot_skills < nr_skills_required then
                open c_missing_skl(id_emp);
                loop
                    fetch c_missing_skl into new_code_emp, missing_skl, prj_cod_skl;
                    exit when c_missing_skl%notfound;

                    -- Assegno un nuovo dipendente con le skill mancanti
                    insert into t_alloc(cod_emp, cod_prj, date_init, date_end, date_ins)
                    values (new_code_emp, p_cod_prj, today_date, date_end_p2, sysdate);

                end loop;
                close c_missing_skl;
            end if;
        end loop;
        close c_emp;
    end if;

exception
    when others then
        pkg_utils.plog('Errore in allocate: ', sqlcode, sqlerrm);

end;
