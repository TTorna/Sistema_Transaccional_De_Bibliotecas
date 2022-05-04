-- sp_listar_libros
DECLARE
    vParametro NUMBER;
    vCodigo Biblioteca.Libros.lib_codigo%TYPE;
    vNombre  Biblioteca.Libros.lib_descripcion%TYPE;
    vRegistro SYS_REFCURSOR;


BEGIN
     vParametro:=1;
     Biblioteca.BIBLIO_PKG.sp_listar_libros(vParametro, vRegistro);
     LOOP
      FETCH vRegistro INTO vCodigo, vNombre;
      EXIT WHEN vRegistro%NOTFOUND;
      Dbms_Output.put_line('ID: ' || vCodigo || '  Nombre del Libro: ' || vNombre);
     END LOOP;
     CLOSE vRegistro;
END;
