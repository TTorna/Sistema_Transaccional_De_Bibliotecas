-- sp_listar_clientes
DECLARE
    vParametro NUMBER;
    vCodigo Biblioteca.Clientes.cli_codigo%TYPE;
    vNombre  Biblioteca.Clientes.cli_nombre%TYPE;
    vRegistro SYS_REFCURSOR;


BEGIN
     vParametro:=0;
     Biblioteca.BIBLIO_PKG.sp_listar_clientes(vParametro, vRegistro);
     LOOP
      FETCH vRegistro INTO vCodigo, vNombre;
      EXIT WHEN vRegistro%NOTFOUND;
      Dbms_Output.put_line('ID: ' || vCodigo || '  Nombre del Cliente: ' || vNombre);
     END LOOP;
     CLOSE vRegistro;
END;