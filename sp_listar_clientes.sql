-- sp_listar_clientes

CREATE OR REPLACE PACKAGE BIBLIO_PKG is

  PROCEDURE sp_realisar_prestamo(idCliente Biblioteca.Clientes.cli_codigo%TYPE, Pdias Biblioteca.Prestamos_Libros.pli_dias%TYPE , idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);
  PROCEDURE sp_mostrar_prestamo(Parametro NUMBER, Registro OUT Sys_refcursor, idCliente Biblioteca.Clientes.cli_codigo%TYPE);
  PROCEDURE sp_listar_libros(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_clientes(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_autores(Parametro NUMBER, Registro OUT Sys_refcursor,Fecha1 Biblioteca.Prestamos.pre_fecha%TYPE, Fecha2 Biblioteca.Prestamos.pre_fecha%TYPE);
  PROCEDURE sp_devoluciones(idCliente Biblioteca.Clientes.cli_codigo%TYPE, idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);

END BIBLIO_PKG;

CREATE OR REPLACE PACKAGE BODY BIBLIO_PKG is

PROCEDURE sp_listar_clientes(Parametro NUMBER, Registro OUT Sys_refcursor) AS
   Script VARCHAR(500) := 'Select Distinct C.cli_codigo, C.cli_nombre FROM Biblioteca.Clientes C ';
   Hoy DATE;

BEGIN

    -- CLIENTES LISTA TOTAL, DEFAULT

    SELECT Trunc(SYSDATE) INTO Hoy FROM DUAL;

     IF (Parametro = 1) THEN -- CLIENTES EN MORA
        Script:=Script || ' INNER JOIN Biblioteca.Prestamos P ON C.cli_codigo=P.pre_cliente INNER JOIN Biblioteca.Prestamos_Libros PL ON PL.pli_prestamo=P.pre_numero Where P.pre_fecha< '|| chr(39) ||Hoy|| chr(39) ||' AND PL.pli_estado=0 ORDER BY cli_codigo';
     ELSE
        IF (Parametro = 2) THEN -- CLIENTES SUSPENDIDOS
          Script:=Script || ' WHERE cli_suspension is not NULL AND cli_suspension>'|| chr(39) ||Hoy|| chr(39);
        END IF;
     END IF;

   -- Dbms_Output.put_line(Script);

   OPEN Registro FOR Script;
END;

END BIBLIO_PKG;

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
/*
SELECT *
FROM clientes;

Select cli_codigo, cli_nombre
FROM Biblioteca.Clientes C
INNER JOIN Biblioteca.Prestamos P ON C.cli_codigo=P.pre_cliente
INNER JOIN Biblioteca.Prestamos_Libros PL ON PL.pli_prestamo=P.pre_numero
Where P.pre_fecha<(SELECT Trunc(SYSDATE) FROM DUAL) AND PL.pli_estado=0;

SELECT *
FROM Biblioteca.Clientes C
INNER JOIN Biblioteca.Prestamos P ON C.cli_codigo=P.pre_cliente
INNER JOIN Biblioteca.Prestamos_Libros PL ON PL.pli_prestamo=P.pre_numero ORDER BY cli_codigo;


UPDATE Biblioteca.Clientes
SET cli_suspension = NULL
WHERE cli_codigo=3;

UPDATE Biblioteca.Prestamos_Libros
SET pli_estado = 0
WHERE pli_prestamo=11;
*/

COMMIT;

