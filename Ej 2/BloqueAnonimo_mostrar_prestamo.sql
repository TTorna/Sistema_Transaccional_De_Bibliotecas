-- sp_mostrar_prestamo
DECLARE
    vParametro NUMBER;
    vIdCliente Biblioteca.Prestamos.pre_cliente%TYPE;
    vRegistro SYS_REFCURSOR;
    vPrestamo Biblioteca.Prestamos.pre_numero%TYPE;
    vFecha Biblioteca.Prestamos.pre_fecha%TYPE;
    --vCliente Biblioteca.Prestamos.pre_cliente%TYPE;

BEGIN
     vParametro:=0;     -- 0=LISTADO TOTAL      1=LISTA POR CLIENTE       2=LISTADO DE MOROSOS
     vIdCliente:=7;

     Biblioteca.BIBLIO_PKG.sp_mostrar_prestamo(vParametro, vRegistro, vIdCliente);
     LOOP
      FETCH vRegistro INTO vIdCliente, vPrestamo, vFecha;
      EXIT WHEN vRegistro%NOTFOUND;
      Dbms_Output.put_line('Cliente: ' || vIdCliente || '  Prestamo Nº: ' || vPrestamo ||'  Fecha de entrega: '|| vFecha);
     END LOOP;
     CLOSE vRegistro;
END;
