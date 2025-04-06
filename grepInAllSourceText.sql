create or replace function grepInAllSourceText(keywords in sys.odcivarchar2list)
    return sys.odcivarchar2list is
    keywordTemplate constant varchar2(100) := 'select distinct name from all_source where instr(lower(text), ''?keyword?'') > 0';
    results      sys.odcivarchar2list;
    dynamicQuery clob;
begin
    if keywords.count < 1 then
        return sys.odcivarchar2list();
    end if;
    dynamicQuery := replace(keywordTemplate, '?keyword?', keywords(1));
    for i in 2 .. keywords.count loop
        dynamicQuery := dynamicQuery || ' intersect ' || replace(keywordTemplate, '?keyword?', keywords(i));
    end loop;

    execute immediate dynamicQuery bulk collect into results;
    return results;
end;
/
