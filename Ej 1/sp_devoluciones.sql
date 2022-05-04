-- sp_devoluciones

CREATE OR REPLACE PACKAGE BIBLIO_PKG is

  PROCEDURE sp_realisar_prestamo(idCliente Biblioteca.Clientes.cli_codigo%TYPE, Pdias Biblioteca.Prestamos_Libros.pli_dias%TYPE , idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);
  PROCEDURE sp_mostrar_prestamo(Parametro NUMBER, Registro OUT Sys_refcursor, idCliente Biblioteca.Clientes.cli_codigo%TYPE);
  PROCEDURE sp_listar_libros(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_clientes(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_autores(Parametro NUMBER, Registro OUT Sys_refcursor,Fecha1 Biblioteca.Prestamos.pre_fecha%TYPE, Fecha2 Biblioteca.Prestamos.pre_fecha%TYPE);
  PROCEDURE sp_devoluciones(idCliente Biblioteca.Clientes.cli_codigo%TYPE, idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);

END BIBLIO_PKG;

CREATE OR REPLACE PACKAGE BODY BIBLIO_PKG is

PROCEDURE sp_devoluciones(idCliente Biblioteca.Clientes.cli_codigo%TYPE, idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE) AS
   Hoy DATE;
   EstadoC NUMBER;
   Fecha DATE;
   Multa NUMBER;
   Suspension DATE;


BEGIN

   SELECT Trunc(SYSDATE) INTO Hoy FROM DUAL;


        BEGIN
          SELECT P.pre_fecha, PL.pli_valor
          INTO Fecha, Multa
          FROM Biblioteca.Prestamos P
                INNER JOIN Biblioteca.Prestamos_Libros PL ON PL.pli_prestamo = P.pre_numero
          WHERE P.pre_cliente=idCliente AND pli_estado=0 AND idLibro=pli_libro;-- Cuando "pli_estado" es 0 cuando el prestamo sigue en curso, es 1 cuando fue devuelto el libro
        EXCEPTION
            WHEN No_Data_Found THEN
              Fecha := NULL;
        END;


    --Dbms_Output.put_line('O1');
    IF (Fecha IS NOT NULL) THEN

        EstadoC:=1;

       IF (Fecha<Hoy) THEN

        Multa:=Multa*(1+((Hoy-Fecha)*0.001));

          IF ((Hoy-Fecha)>15) THEN

             Suspension:=Hoy+90;

             UPDATE Biblioteca.Clientes
             SET cli_suspension = Suspension
             WHERE cli_codigo = idCliente;

             Dbms_Output.put_line('Quedo suspendido por 90 dias');

          END IF;
       ELSE

       Multa:=0;

       END IF;



       BEGIN

        UPDATE (SELECT PL.pli_estado, PL.pli_multa
                FROM Biblioteca.Prestamos_Libros PL
                INNER JOIN Biblioteca.Prestamos P ON P.pre_numero=PL.pli_prestamo
                WHERE PL.pli_libro = idLibro AND P.pre_cliente=idCliente)
        SET pli_estado = EstadoC,
        pli_multa = Multa;

        UPDATE Biblioteca.Libros
        SET lib_cantidad = lib_cantidad + 1,
          lib_precio = lib_precio * 0.91
        WHERE lib_codigo = idLibro;

        Dbms_Output.put_line('Se ha devulto con exito');

        EXCEPTION

        WHEN No_Data_Found THEN
        DBMS_OUTPUT.PUT_LINE ('Mensaje de Error :' || SQLERRM );
        DBMS_OUTPUT.PUT_LINE ('Codigo de Error :' || SQLCODE );

        END;

    ELSE
        Dbms_Output.put_line('No tiene prestamos pendientes con este libro');

    END IF;
END;

END BIBLIO_PKG;


DECLARE
    vIdCliente Biblioteca.Clientes.cli_codigo%TYPE;
    vIdLibro  Biblioteca.Prestamos_Libros.pli_libro%TYPE;


BEGIN
     vIdCliente :=4;
     vIdLibro :=7;

     Biblioteca.BIBLIO_PKG.sp_devoluciones(vIdCliente, vIdLibro);

END;

-- SELECT'S PARA PROBARLO
select pli_libro, pre_cliente, pli_prestamo, pli_estado, pre_fecha,pli_valor ,pli_multa, cli_codigo, cli_nombre, cli_suspension
from Biblioteca.Prestamos_Libros PL
INNER JOIN Biblioteca.Prestamos P ON P.pre_numero=PL.pli_prestamo
INNER JOIN Biblioteca.Clientes C ON P.pre_cliente=C.cli_codigo;

select *
from Biblioteca.Prestamos_Libros;

select *
from Biblioteca.Libros;

COMMIT;
