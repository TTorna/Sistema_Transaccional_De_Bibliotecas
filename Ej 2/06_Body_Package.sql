-- sp_realisar_prestamo 1
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
            WHERE idLibro=PL.pli_libro AND C.cli_codigo=idCliente AND PL.pli_estado=0;

                --Dbms_Output.put_line('O2');

            IF (MismoLibro < 1) THEN

                    SELECT Count(1) INTO CantLibros
                      FROM Biblioteca.Prestamos P
                      INNER JOIN Biblioteca.Clientes C ON C.cli_codigo = P.pre_cliente
                      INNER JOIN Biblioteca.Prestamos_Libros PL ON PL.pli_prestamo=P.pre_numero
                      WHERE C.cli_codigo=idCliente AND PL.pli_estado=0;

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
                                    Dbms_Output.put_line('No puede pedir el libro por mas de 7 dias maximo');
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
                                    Dbms_Output.put_line('No puede pedir el libro por mas de 15 dias maximo');
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
END sp_realisar_prestamo;


/*
select *
from Biblioteca.Clientes C
INNER JOIN Biblioteca.prestamos P ON C.cli_codigo=P.pre_cliente
INNER JOIN Biblioteca.prestamos_Libros PL ON PL.pli_prestamo=P.pre_numero
ORDER BY cli_codigo Desc;

select *
from Biblioteca.Libros;
*/

-- sp_mostrar_prestamo
PROCEDURE sp_mostrar_prestamo(Parametro NUMBER, Registro OUT Sys_refcursor, idCliente Biblioteca.Clientes.cli_codigo%TYPE) AS
   Script VARCHAR(300) := ' Select P.pre_cliente, P.pre_numero, P.pre_fecha
                            FROM Biblioteca.Prestamos P
                            INNER JOIN Biblioteca.Prestamos_libros PL ON P.pre_numero=PL.pli_prestamo
                            Where PL.pli_estado=0';
   Hoy DATE;

BEGIN

    SELECT Trunc(SYSDATE) INTO Hoy FROM DUAL;


                              -- LISTADO TOTAL NO LO PONGO PORQUE ES EL SCRIPT DEFAULT

      IF (Parametro = 1) THEN -- LISTA POR CLIENTE
         Script:=Script || ' AND pre_cliente=' || idCliente;
      ELSE
          IF (Parametro = 2) THEN -- LISTADO DE MOROSOS

                Script:=Script || ' AND pre_fecha < '|| Chr(39) || Hoy || Chr(39);

          END IF;
      END IF;

   -- Dbms_Output.put_line(Script);

   OPEN Registro FOR Script;
END sp_mostrar_prestamo;

/*
SELECT * FROM Biblioteca.Prestamos_Libros PL INNER JOIN Biblioteca.Prestamos P ON pre_numero=pli_prestamo --WHERE P.pre_cliente=3;

SELECT pre_cliente, pre_numero FROM Biblioteca.Prestamos P INNER JOIN Biblioteca.Prestamos_libros PL ON P.pre_numero=PL.pli_prestamo Where PL.pli_estado=0 AND pre_fecha < (SELECT Trunc(SYSDATE) FROM DUAL)
*/


-- sp_devoluciones
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

        Multa:=Multa*((Hoy-Fecha)*0.001);

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
END sp_devoluciones;

/*
-- SELECT'S PARA PROBARLO
select pli_libro, pre_cliente, pli_prestamo, pli_estado, pre_fecha,pli_valor ,pli_multa, cli_codigo, cli_nombre, cli_suspension
from Biblioteca.Prestamos_Libros PL
INNER JOIN Biblioteca.Prestamos P ON P.pre_numero=PL.pli_prestamo
INNER JOIN Biblioteca.Clientes C ON P.pre_cliente=C.cli_codigo;

select *
from Biblioteca.Prestamos_Libros;

select *
from Biblioteca.Libros;
*/


-- sp_listar_clientes
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
END sp_listar_clientes;

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


-- sp_listar_libros
PROCEDURE sp_listar_libros(Parametro NUMBER, Registro OUT Sys_refcursor) AS
   Script VARCHAR(500) := 'Select Distinct L.lib_codigo, L.lib_descripcion FROM Biblioteca.Libros L ';

BEGIN

    -- LIBROS LISTA TOTAL, DEFAULT

     IF (Parametro = 1) THEN -- LIBROS SEGUN CANTIDAD DISPONIBLE
        Script:=Script || ' Order By L.lib_cantidad Desc';
     END IF;

   -- Dbms_Output.put_line(Script);

   OPEN Registro FOR Script;
END sp_listar_libros;


-- sp_listar_autores
PROCEDURE sp_listar_autores(Parametro NUMBER, Registro OUT Sys_refcursor,Fecha1 Biblioteca.Prestamos.pre_fecha%TYPE, Fecha2 Biblioteca.Prestamos.pre_fecha%TYPE) AS
   Script VARCHAR(1000);

BEGIN

  IF (Parametro =0) THEN
     Script:= Script || ' Select aut_codigo, aut_nombre
                          From Biblioteca.Autores';

  ELSE
    IF (Parametro = 1) THEN

      Script:=Script || '   Select PL.pli_libro, A.aut_codigo, A.aut_nombre,  Count(1)
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
                            ORDER BY Count(1) desc';

    END IF;
   END IF;

   OPEN Registro FOR Script;

END sp_listar_autores;

/*
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
*/


END BIBLIO_PKG;
