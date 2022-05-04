-- sp_listar_autores

CREATE OR REPLACE PACKAGE BIBLIO_PKG is

  PROCEDURE sp_realisar_prestamo(idCliente Biblioteca.Clientes.cli_codigo%TYPE, Pdias Biblioteca.Prestamos_Libros.pli_dias%TYPE , idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);
  PROCEDURE sp_mostrar_prestamo(Parametro NUMBER, Registro OUT Sys_refcursor, idCliente Biblioteca.Clientes.cli_codigo%TYPE);
  PROCEDURE sp_listar_libros(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_clientes(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_autores(Parametro NUMBER, Registro OUT Sys_refcursor,Fecha1 Biblioteca.Prestamos.pre_fecha%TYPE, Fecha2 Biblioteca.Prestamos.pre_fecha%TYPE);
  PROCEDURE sp_devoluciones(idCliente Biblioteca.Clientes.cli_codigo%TYPE, idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);

END BIBLIO_PKG;

CREATE OR REPLACE PACKAGE BODY BIBLIO_PKG is

PROCEDURE sp_listar_autores(Parametro NUMBER, Registro OUT Sys_refcursor,Fecha1 Biblioteca.Prestamos.pre_fecha%TYPE, Fecha2 Biblioteca.Prestamos.pre_fecha%TYPE) AS
   Script VARCHAR(1000);

BEGIN

  IF (Parametro =0) THEN
     Script:= Script || ' Select aut_codigo, aut_nombre
                          From Biblioteca.Autores';

  ELSE
    IF (Parametro = 1) THEN

      Script:=Script || '   Select PL.pli_libro, A.aut_codigo, A.aut_nombre,  Count(*)
                            FROM Biblioteca.Autores A
                            Inner join Biblioteca.Libros_Autores LA ON A.aut_codigo= LA.lau_autor
                            Inner join Biblioteca.Libros L ON LA.lau_libro= L.lib_codigo
                            Inner join Biblioteca.Prestamos_Libros PL ON PL.pli_libro= L.lib_codigo
                            Inner join Biblioteca.Prestamos P ON PL.pli_prestamo= P.pre_numero
                            WHERE L.lib_codigo=PL.pli_libro AND P.pre_fecha<='|| chr(39) || Fecha1 || chr(39) || ' AND P.pre_fecha>='|| chr(39) || Fecha2 || chr(39) ||'
                            GROUP BY
                              PL.pli_libro,
                              A.aut_codigo,
                              A.aut_nombre
                            ORDER BY PL.pli_libro desc';

    END IF;
   END IF;

   OPEN Registro FOR Script;

END;

END BIBLIO_PKG;

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



                            Select pli_libro, aut_codigo, aut_nombre,  Count(*) "Cant. de libros en prestamo"                 -- EJEMPLO DEL PARAMETRO EN "1"
                              FROM Biblioteca.Autores A
                              Inner join Biblioteca.Libros_Autores LA ON A.aut_codigo= LA.lau_autor
                              Inner join Biblioteca.Libros L ON LA.lau_libro= L.lib_codigo
                              Inner join Biblioteca.Prestamos_Libros PL ON PL.pli_libro= L.lib_codigo
                              Inner join Biblioteca.Prestamos P ON PL.pli_prestamo= P.pre_numero
                            WHERE L.lib_codigo=PL.pli_libro AND P.pre_fecha<='01/11/2021' AND P.pre_fecha>='15/10/2021'
                            GROUP BY
                              pli_libro,
                              aut_codigo,
                              aut_nombre
                            ORDER BY pli_libro DESC;




COMMIT;

