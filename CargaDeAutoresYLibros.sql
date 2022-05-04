
SELECT * FROM Biblioteca.Libros;

INSERT INTO Biblioteca.Libros VALUES (1,'Todo se desmorona',10,150,1,'EJ Nº1');
INSERT INTO Biblioteca.Libros VALUES (2,'Cuentos infantiles',7,57,3,'EJ Nº2');
INSERT INTO Biblioteca.Libros VALUES (3,'Divina comedia',14,199,1,'EJ.3');
INSERT INTO Biblioteca.Libros VALUES (4,'Orgullo y prejuicio',12,299,2,'EJ Nº4');
INSERT INTO Biblioteca.Libros VALUES (5,'Papá Goriot',8,100,1,'EJ Nº5');
INSERT INTO Biblioteca.Libros VALUES (6,'Decamerón',15,999,2,'EJ Nº6');
INSERT INTO Biblioteca.Libros VALUES (7,'Ficciones',5,509,3,'EJ Nº7');
INSERT INTO Biblioteca.Libros VALUES (8,'Cumbres Borrascosas',11,177,7,'EJ Nº8');
INSERT INTO Biblioteca.Libros VALUES (9,'El extranjero',14,777,2,'EJ Nº9');
INSERT INTO Biblioteca.Libros VALUES (10,'Viaje al fin de la noche',23,111,1,'EJ Nº10');
INSERT INTO Biblioteca.Libros VALUES (11,'Don Quijote de la Mancha',9,100,2,'EJ Nº11');
INSERT INTO Biblioteca.Libros VALUES (12,'Crimen y castigo',12,50,1,'EJ Nº12');
INSERT INTO Biblioteca.Libros VALUES (13,'El idiota',13,200,3,'EJ Nº13');
INSERT INTO Biblioteca.Libros VALUES (14,'Los endemoniados',17,430,3,'EJ Nº14');
INSERT INTO Biblioteca.Libros VALUES (15,'Los hermanos Karamazov',20,133,1,'EJ Nº15');



SELECT * FROM Biblioteca.Autores;

INSERT INTO Biblioteca.Autores VALUES (1,'Chinua Achebe','Nigeria');
INSERT INTO Biblioteca.Autores VALUES (2,'Hans Christian Alighieri','Dinamarca');
INSERT INTO Biblioteca.Autores VALUES (3,'Dante Alighieri','Italia');
INSERT INTO Biblioteca.Autores VALUES (4,'Jane Austen','Reino Unido');
INSERT INTO Biblioteca.Autores VALUES (5,'Honoré de Balzac','Francia');
INSERT INTO Biblioteca.Autores VALUES (6,'Giovanni Boccaccio','Ravena');
INSERT INTO Biblioteca.Autores VALUES (7,'Jorge Luis Borges','Argentina');
INSERT INTO Biblioteca.Autores VALUES (8,'Emily Brontë','Reino Unido');
INSERT INTO Biblioteca.Autores VALUES (9,'Albert Camus','Francia');
INSERT INTO Biblioteca.Autores VALUES (10,'Louis-Ferdinand Céline','Francia');
INSERT INTO Biblioteca.Autores VALUES (11,'Miguel de Cervantes','España');
INSERT INTO Biblioteca.Autores VALUES (12,'Fiódor Dostoievski','Rusia');


SELECT * From Biblioteca.Libros_Autores;

INSERT INTO Biblioteca.Libros_Autores VALUES (1,1);
INSERT INTO Biblioteca.Libros_Autores VALUES (2,2);
INSERT INTO Biblioteca.Libros_Autores VALUES (3,3);
INSERT INTO Biblioteca.Libros_Autores VALUES (4,4);
INSERT INTO Biblioteca.Libros_Autores VALUES (5,5);
INSERT INTO Biblioteca.Libros_Autores VALUES (6,6);
INSERT INTO Biblioteca.Libros_Autores VALUES (7,7);
INSERT INTO Biblioteca.Libros_Autores VALUES (8,8);
INSERT INTO Biblioteca.Libros_Autores VALUES (9,9);
INSERT INTO Biblioteca.Libros_Autores VALUES (10,10);
INSERT INTO Biblioteca.Libros_Autores VALUES (11,11);
INSERT INTO Biblioteca.Libros_Autores VALUES (12,12);
INSERT INTO Biblioteca.Libros_Autores VALUES (13,12);
INSERT INTO Biblioteca.Libros_Autores VALUES (14,12);
INSERT into biblioteca.libros_autores VALUES (15,12);


COMMIT;