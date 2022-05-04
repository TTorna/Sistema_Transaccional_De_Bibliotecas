CREATE TABLE Biblioteca.Autores(
aut_codigo NUMBER(3),
aut_nombre VARCHAR(30),
aut_nacionalidad VARCHAR(30),
CONSTRAINT AutCodigo PRIMARY KEY (aut_codigo)

);


CREATE TABLE Biblioteca.Libros(
lib_codigo NUMBER(10),
lib_descripcion VARCHAR(50),
lib_cantidad NUMBER(6),
lib_precio NUMBER(7),
lib_edicion NUMBER(1),
lib_observacion VARCHAR(50),
CONSTRAINT LibreriaCod PRIMARY KEY (lib_codigo)

);

CREATE TABLE Biblioteca.Ciudades(
ciu_codigo NUMBER(3),
aut_descripcion VARCHAR(30),
CONSTRAINT CiuCodigo PRIMARY KEY (ciu_codigo)

);

CREATE TABLE Biblioteca.Libros_Autores(
lau_libro NUMBER(10),
lau_autor NUMBER(3),
FOREIGN KEY (lau_autor) REFERENCES Biblioteca.Autores (aut_codigo),
FOREIGN KEY (lau_libro) REFERENCES Biblioteca.Libros (lib_codigo)

);
CREATE INDEX indice1 ON Biblioteca.Libros_Autores(lau_libro);
CREATE INDEX indice2 ON Biblioteca.Libros_Autores(lau_autor);

CREATE TABLE Biblioteca.Clientes(
cli_codigo NUMBER(3),
cli_nombre VARCHAR(30),
cli_direccion VARCHAR(30),
cli_ciudad NUMBER(3),
cli_suspension DATE,
cli_obs VARCHAR(50),
CONSTRAINT CliCodigo PRIMARY KEY (cli_codigo),
FOREIGN KEY (cli_ciudad) REFERENCES Biblioteca.Ciudades (ciu_codigo)

);
CREATE INDEX indice1 ON Biblioteca.Clientes(cli_ciudad);


CREATE TABLE Biblioteca.Prestamos(
pre_numero NUMBER(10),
pre_cliente NUMBER(3),
pre_fecha DATE,
pre_observacion VARCHAR(50),
CONSTRAINT biblio1 PRIMARY KEY (pre_numero)

);
CREATE INDEX indice1 ON Biblioteca.Prestamos(pre_cliente);

CREATE SEQUENCE PkPresSeq;

CREATE OR REPLACE TRIGGER Prestamos
  BEFORE INSERT ON Biblioteca.Prestamos
  FOR EACH ROW
BEGIN
  SELECT PkPresSeq.NEXTVAL
  INTO :NEW.pre_numero
  FROM dual;
 END;


CREATE TABLE Biblioteca.Prestamos_Libros(
pli_libro NUMBER(10),
pli_prestamo NUMBER(10),
pli_estado NUMBER(1),
pli_dias NUMBER(2),
pli_valor  NUMBER(12,2),
pli_multa NUMBER(12,2),
FOREIGN KEY (pli_libro) REFERENCES Biblioteca.Libros (lib_codigo),
FOREIGN KEY (pli_prestamo) REFERENCES Biblioteca.Prestamos (pre_numero)

);
CREATE INDEX indice1 ON Biblioteca.Prestamos_Libros(pli_prestamo);
CREATE INDEX indice2 ON Biblioteca.Prestamos_Libros(pli_libro);

CREATE SEQUENCE PkPresLibSeq;

CREATE OR REPLACE TRIGGER Prestamos_Libros
  BEFORE INSERT ON Biblioteca.Prestamos_Libros
  FOR EACH ROW
BEGIN
  SELECT PkPresLibSeq.NEXTVAL
  INTO :NEW.pli_prestamo
  FROM dual;
 END;

-- FIN