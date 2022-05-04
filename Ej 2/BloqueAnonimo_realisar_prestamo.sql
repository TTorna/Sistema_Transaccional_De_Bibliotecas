-- sp_realisar_prestamo
DECLARE
    vIdCliente Biblioteca.Clientes.cli_codigo%TYPE;
    vPdias Biblioteca.Prestamos_Libros.pli_dias%TYPE;
    vIdLibro  Biblioteca.Prestamos_Libros.pli_libro%TYPE;


BEGIN
     vIdCliente :=9;      -- ID DEL CLIENTE
     vPdias :=7;          -- CANTIDAD DE DURACION DEL PRESTAMO EN DIAS
     vIdLibro :=14;       -- ID DEL LIBRO

     Biblioteca.BIBLIO_PKG.sp_realisar_prestamo(vIdCliente, vPdias , vIdLibro);

END;
