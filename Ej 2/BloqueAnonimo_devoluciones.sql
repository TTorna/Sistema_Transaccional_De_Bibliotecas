-- sp_devoluciones
DECLARE
    vIdCliente Biblioteca.Clientes.cli_codigo%TYPE;
    vIdLibro  Biblioteca.Prestamos_Libros.pli_libro%TYPE;


BEGIN
     vIdCliente :=4;
     vIdLibro :=7;

     Biblioteca.BIBLIO_PKG.sp_devoluciones(vIdCliente, vIdLibro);

END;
