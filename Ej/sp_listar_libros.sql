-- sp_listar_libros

CREATE OR REPLACE PACKAGE BIBLIO_PKG is

  PROCEDURE sp_realisar_prestamo(idCliente Biblioteca.Clientes.cli_codigo%TYPE, Pdias Biblioteca.Prestamos_Libros.pli_dias%TYPE , idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);
  PROCEDURE sp_mostrar_prestamo(Parametro NUMBER, Registro OUT Sys_refcursor, idCliente Biblioteca.Clientes.cli_codigo%TYPE);
  PROCEDURE sp_listar_libros(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_clientes(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_autores(Parametro NUMBER, Registro OUT Sys_refcursor,Fecha1 Biblioteca.Prestamos.pre_fecha%TYPE, Fecha2 Biblioteca.Prestamos.pre_fecha%TYPE);
  PROCEDURE sp_devoluciones(idCliente Biblioteca.Clientes.cli_codigo%TYPE, idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);

END BIBLIO_PKG;

CREATE OR REPLACE PACKAGE BODY BIBLIO_PKG is

PROCEDURE sp_listar_libros(Parametro NUMBER, Registro OUT Sys_refcursor) AS
   Script VARCHAR(500) := 'Select Distinct L.lib_codigo, L.lib_descripcion FROM Biblioteca.Libros L ';

BEGIN

    -- LIBROS LISTA TOTAL, DEFAULT

     IF (Parametro = 1) THEN -- LIBROS SEGUN CANTIDAD DISPONIBLE
        Script:=Script || ' Order By L.lib_cantidad Desc';
     END IF;

   -- Dbms_Output.put_line(Script);

   OPEN Registro FOR Script;
END;

END BIBLIO_PKG;

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

COMMIT;

