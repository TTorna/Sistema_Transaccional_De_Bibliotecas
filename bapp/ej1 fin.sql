-- sp_listar_libros

CREATE OR REPLACE PACKAGE BIBLIO_PKG is

  PROCEDURE sp_realisar_prestamo(idCliente Biblioteca.Clientes.cli_codigo%TYPE, Pdias Biblioteca.Prestamos_Libros.pli_dias%TYPE , idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);

END BIBLIO_PKG;

CREATE OR REPLACE PACKAGE BODY BIBLIO_PKG is

PROCEDURE sp_realisar_prestamo(idCliente Biblioteca.Clientes.cli_codigo%TYPE, Pdias Biblioteca.Prestamos_Libros.pli_dias%TYPE , idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE) AS
   Hoy DATE;
   FPres DATE;
   Mora NUMBER;
   Suspension DATE;
   MismoLibro NUMBER;
   CantLibros NUMBER;
   DiasPrestamo NUMBER;
   Devolucion DATE;
   PrestamosProximos NUMBER;
   EstadoC NUMBER;
   PreciosLib NUMBER;
   PrecioFinal NUMBER;

BEGIN

   EstadoC:=0;

   SELECT Trunc(SYSDATE) INTO Hoy FROM DUAL;

   SELECT cli_suspension
   INTO Suspension
   FROM Biblioteca.Clientes
   WHERE cli_codigo=idCliente;



  IF (Suspension is NULL OR Suspension<Hoy) THEN

   BEGIN
    SELECT Count(1)
    INTO Mora
    FROM Biblioteca.Prestamos P
          INNER JOIN Biblioteca.Prestamos_Libros PL ON PL.pli_prestamo = P.pre_numero
          INNER JOIN Biblioteca.Clientes C ON C.cli_codigo = P.pre_cliente
    WHERE C.cli_codigo=idCliente AND pli_estado=0 AND P.pre_fecha<Hoy;-- Cuando "pli_estado" es 0 cuando el prestamo sigue en curso, es 1 cuando fue devuelto el libro
   EXCEPTION
      WHEN No_Data_Found THEN
        Mora := 0;
   END;

    --Dbms_Output.put_line('O1');
     IF (Mora<1) THEN

            SELECT Count(1)
            INTO MismoLibro
            FROM Biblioteca.Prestamos_Libros PL
              INNER JOIN Biblioteca.Prestamos P ON PL.pli_prestamo = P.pre_numero
              INNER JOIN Biblioteca.Clientes C ON C.cli_codigo = P.pre_cliente
            WHERE idLibro=PL.pli_libro AND C.cli_codigo=idCliente;

                --Dbms_Output.put_line('O2');

            IF (MismoLibro < 1) THEN

                    SELECT Count(1) INTO CantLibros
                      FROM Biblioteca.Prestamos P
                      INNER JOIN Biblioteca.Clientes C ON C.cli_codigo = P.pre_cliente
                    WHERE C.cli_codigo=idCliente;

                        --Dbms_Output.put_line('O3');

                    IF (CantLibros < 3) THEN

                                Devolucion:=Hoy+Pdias;
                                --Dbms_Output.put_line('4');
                                SELECT Count(lib_cantidad) "1" INTO DiasPrestamo
                                  FROM Biblioteca.Libros
                                WHERE lib_codigo=idLibro;
                                --Dbms_Output.put_line('5');
                                SELECT Count(1) INTO PrestamosProximos
                                FROM Biblioteca.Prestamos P
                                INNER JOIN Biblioteca.Prestamos_Libros PL ON PL.pli_prestamo=P.pre_numero
                                INNER JOIN Biblioteca.Libros L ON L.lib_codigo=PL.pli_libro
                                WHERE L.lib_codigo=idLibro AND P.pre_fecha<Hoy+3 AND P.pre_fecha>Hoy;

                                IF (DiasPrestamo=1 AND PrestamosProximos<1) THEN

                                  IF (Pdias<=7)THEN

                                    SELECT lib_precio
                                    INTO PreciosLib
                                    FROM Biblioteca.Libros
                                    WHERE lib_codigo = idLibro;



                                    BEGIN

                                      PrecioFinal:=PreciosLib;

                                    UPDATE Biblioteca.Libros
                                    SET lib_cantidad = lib_cantidad - 1,
                                      lib_precio = lib_precio * 1.10
                                    WHERE lib_codigo = idLibro;

                                    INSERT INTO Biblioteca.Prestamos (pre_cliente,pre_fecha,pre_observacion)
                                    VALUES (idCliente,HOY + Pdias,' ');




                                      INSERT INTO Biblioteca.Prestamos_Libros (pli_libro, pli_estado, pli_dias, pli_valor, pli_multa)
                                      VALUES (idLibro,  EstadoC, Pdias, PrecioFinal, 0);
                                    EXCEPTION
                                    WHEN No_Data_Found THEN
                                          DBMS_OUTPUT.PUT_LINE ('Mensaje de Error :' || SQLERRM );
                                          DBMS_OUTPUT.PUT_LINE ('Codigo de Error :' || SQLCODE );
                                    END;


                                    Dbms_Output.put_line('Se ha Prestado correctamente el libro ' || idLibro || ' a un precio de ' || PrecioFinal || '.');

                                  ELSE
                                    Dbms_Output.put_line('No puede pedir el libros por mas de 7 dias maximo');
                                  END IF;
                                    --Dbms_Output.put_line('O5');

                                ELSE
                                  IF (Pdias<=15)THEN

                                    SELECT lib_precio
                                    INTO PreciosLib
                                    FROM Biblioteca.Libros
                                    WHERE lib_codigo = idLibro;



                                    BEGIN

                                      PrecioFinal:=PreciosLib;

                                    UPDATE Biblioteca.Libros
                                    SET lib_cantidad = lib_cantidad - 1,
                                      lib_precio = lib_precio * 1.10
                                    WHERE lib_codigo = idLibro;

                                    INSERT INTO Biblioteca.Prestamos (pre_cliente,pre_fecha,pre_observacion)
                                    VALUES (idCliente,HOY + Pdias,' ');




                                      INSERT INTO Biblioteca.Prestamos_Libros (pli_libro, pli_estado, pli_dias, pli_valor, pli_multa)
                                      VALUES (idLibro,  EstadoC, Pdias, PrecioFinal, 0);
                                    EXCEPTION
                                    WHEN No_Data_Found THEN
                                          DBMS_OUTPUT.PUT_LINE ('Mensaje de Error :' || SQLERRM );
                                          DBMS_OUTPUT.PUT_LINE ('Codigo de Error :' || SQLCODE );
                                    END;

                                    Dbms_Output.put_line('Se ha Prestado correctamente el libro ' || idLibro || ' a un precio de ' || PrecioFinal || '.');

                                  ELSE
                                    Dbms_Output.put_line('No puede pedir el libros por mas de 15 dias maximo');
                                  END IF;
                                END IF;
                    Else
                       Dbms_Output.put_line('No puede pedir libros MOTIVOS: Ya tiene en prestamo 3 libros');
                    END IF;
            ELSE
              Dbms_Output.put_line('No puede pedir libros MOTIVOS: Ya tiene ese libro');

            END IF;
    ELSE
        Dbms_Output.put_line('No puede pedir libros MOTIVOS: Tiene Libros en Demora');

   END IF;
  ELSE
    Dbms_Output.put_line('No puede pedir libros MOTIVOS: Ust. esta suspendido');

  END IF;

/*
   UPDATE Biblioteca.Prestamos_libros PL
   SET pli_estado := 1
    INNER JOIN Biblioteca.Prestamos P ON PL.pli_prestamo = P.pre_numero
    INNER JOIN Biblioteca.Cliente C P ON C.cli_codigo = P.pre_cliente
   WHERE pre_cliente=idCliente;

  Dbms_Output.put_line('Estas suspendido, No podes pedir Libros');
*/
END;

END BIBLIO_PKG;


DECLARE
    vIdCliente Biblioteca.Clientes.cli_codigo%TYPE;
    vPdias Biblioteca.Prestamos_Libros.pli_dias%TYPE;
    vIdLibro  Biblioteca.Prestamos_Libros.pli_libro%TYPE;


BEGIN
     vIdCliente :=4;
     vPdias :=15;
     vIdLibro :=7;

     Biblioteca.BIBLIO_PKG.sp_realisar_prestamo(vIdCliente, vPdias , vIdLibro);

END;


select *
from Biblioteca.Clientes C
INNER JOIN Biblioteca.prestamos P ON C.cli_codigo=P.pre_cliente;

select *
from Biblioteca.Libros;

COMMIT;
