-- sp_listar_autores
DECLARE
    vParametro NUMBER;
    vFecha1 Biblioteca.Prestamos.pre_fecha%TYPE;
    vFecha2 Biblioteca.Prestamos.pre_fecha%TYPE;
    vCodigo Biblioteca.Autores.aut_codigo%TYPE;
    vNombre Biblioteca.Autores.aut_nombre%TYPE;
    vRegistro SYS_REFCURSOR;
    vLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE;
    vCount NUMBER;
    Hoy Biblioteca.Prestamos.pre_fecha%TYPE;


BEGIN
     SELECT Trunc(SYSDATE) INTO Hoy FROM DUAL;

     vParametro:=0;            -- 0=Listado General  ||  1=Listado Ordenado Por Libros Prestados
     vFecha1:='01/11/2021';    -- EJEMPLO DE DATE '01/11/2021'             -- ACA VA EL MAYOR
     vFecha2:='15/10/2021';                                                   -- ACA EL MENOR

     Biblioteca.BIBLIO_PKG.sp_listar_autores(vParametro, vRegistro, vFecha1, vFecha2);
     LOOP
      IF (vParametro=0) THEN
        FETCH vRegistro INTO vCodigo, vNombre;
        EXIT WHEN vRegistro%NOTFOUND;
        Dbms_Output.put_line('ID: ' || vCodigo || '  Nombre del Autor: ' || vNombre);
      ELSE
        FETCH vRegistro INTO vLibro, vCodigo, vNombre, vCount;
        EXIT WHEN vRegistro%NOTFOUND;
        Dbms_Output.put_line('ID: ' || vCodigo || '  Nombre del Autor: ' || vNombre);
      END IF;
     END LOOP;
     CLOSE vRegistro;
END;
