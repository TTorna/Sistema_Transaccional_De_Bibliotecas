CREATE OR REPLACE PACKAGE BIBLIO_PKG is

  PROCEDURE sp_realisar_prestamo(idCliente Biblioteca.Clientes.cli_codigo%TYPE, Pdias Biblioteca.Prestamos_Libros.pli_dias%TYPE , idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);
  PROCEDURE sp_mostrar_prestamo(Parametro NUMBER, Registro OUT Sys_refcursor, idCliente Biblioteca.Clientes.cli_codigo%TYPE);
  PROCEDURE sp_devoluciones(idCliente Biblioteca.Clientes.cli_codigo%TYPE, idLibro Biblioteca.Prestamos_Libros.pli_libro%TYPE);
  PROCEDURE sp_listar_clientes(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_libros(Parametro NUMBER, Registro OUT Sys_refcursor);
  PROCEDURE sp_listar_autores(Parametro NUMBER, Registro OUT Sys_refcursor,Fecha1 Biblioteca.Prestamos.pre_fecha%TYPE, Fecha2 Biblioteca.Prestamos.pre_fecha%TYPE);


END BIBLIO_PKG;