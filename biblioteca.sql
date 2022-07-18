DROP DATABASE biblioteca;

CREATE DATABASE biblioteca;

\c biblioteca


CREATE TABLE comunas(
    id INT ,
    nombre_comuna VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE socios(
    rut VARCHAR(10) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono INT,
    comuna INT,
    FOREIGN KEY (comuna) REFERENCES comunas(id),
    PRIMARY KEY (rut)
);

CREATE TABLE autor(
    cod_autor SERIAL ,
    nombre_autor VARCHAR(50),
    apellido_autor VARCHAR(50),
    fecha_nac INT,
    fecha_def INT,
    PRIMARY KEY (cod_autor)
);

CREATE TABLE libros(
    isbn VARCHAR(20) NOT NULL,
    titulo VARCHAR(255),
    paginas INT,
    autor INT NOT NULL,
    coautor INT,
    FOREIGN KEY (autor) REFERENCES autor(cod_autor),
    FOREIGN KEY (coautor) REFERENCES autor(cod_autor),
    PRIMARY KEY (isbn)
);

CREATE TABLE prestamos(
    id SERIAL ,
    fecha_inicio DATE,
    fecha_termino DATE,
    rut VARCHAR(10) NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    FOREIGN KEY (rut) REFERENCES socios(rut),
    FOREIGN KEY (isbn) REFERENCES libros(isbn),
    PRIMARY KEY (id)
);





-- INSERTAR VALORES A TABLA COMUNA
\copy comunas FROM 'listado_comuna.csv' csv header;

-- INSERTAR VALORES A TABLA SOCIO
INSERT INTO socios(rut, nombre, apellido, direccion, telefono, comuna)
VALUES
('1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1', '911111111', 279),
('2222222-2', 'ANA', 'PEREZ', 'PASAJE 2', '922222222', 279),
('3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2', '933333333', 279),
('4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3', '944444444', 279),
('5555555-5', 'SILVANA', 'MUNOZ', 'PASAJE 3', '955555555', 279);

-- INSERTAR VALORES A TABLA AUTOR
INSERT INTO autor(nombre_autor, apellido_autor, fecha_nac)
VALUES('ANDRES', 'ULLOA', 1982);
INSERT INTO autor(nombre_autor, apellido_autor, fecha_nac, fecha_def)
VALUES('SERGIO', 'MARDONES', 1950, 2012);
INSERT INTO autor(nombre_autor, apellido_autor, fecha_nac, fecha_def)
VALUES ('JOSE', 'SALGADO',  1968, 2020);
INSERT INTO autor(nombre_autor, apellido_autor, fecha_nac)
VALUES('ANA', 'SALGADO', 1972);
INSERT INTO autor(nombre_autor, apellido_autor, fecha_nac)
VALUES('MARTIN', 'PORTA', 1976);

-- INSERTAR VALORES A TABLA LIBROS
INSERT INTO libros(isbn, titulo, paginas, autor, coautor)
VALUES ('111-1111111-111', 'CUENTOS DE TERROR', 344, 3, 4);
INSERT INTO libros(isbn, titulo, paginas, autor)
VALUES ('222-2222222-222', 'POESIAS CONTEMPORANEAS', 167, 1);
INSERT INTO libros(isbn, titulo, paginas, autor)
VALUES ('333-3333333-333', 'HISTORIA DE ASIA', 511, 2);
INSERT INTO libros(isbn, titulo, paginas, autor)
VALUES ('444-4444444-444', 'MANUAL DE MECANICA', 298, 5);

-- INSERTAR VALORES A TABLA PRESTAMOS
INSERT INTO prestamos(fecha_inicio, fecha_termino, rut, isbn)
VALUES
('2020-01-20', '2020-01-27', '1111111-1', '111-1111111-111'),
('2020-01-20', '2020-01-30', '5555555-5', '222-2222222-222'),
('2020-01-22', '2020-01-30', '3333333-3', '333-3333333-333'),
('2020-01-23', '2020-01-30', '4444444-4', '444-4444444-444'),
('2020-01-27', '2020-02-04', '2222222-2', '111-1111111-111'),
('2020-01-31', '2020-02-12', '1111111-1', '444-4444444-444'),
('2020-01-31', '2020-02-12', '3333333-3', '222-2222222-222');


--1. Mostrar todos los libros que posean menos de 300 páginas:

SELECT titulo, paginas FROM libros WHERE paginas < 300 ORDER BY paginas ASC;


--2. Mostrar todos los autores que hayan nacido después del 01-01-1970

SELECT nombre_autor, apellido_autor, fecha_nac FROM autor WHERE fecha_nac >= 1970 ORDER BY fecha_nac ASC;

--3. ¿Cuál es el libro más solicitado?

SELECT titulo, COUNT(*) as numero_prestamos FROM libros
INNER JOIN prestamos
ON libros.isbn = prestamos.isbn
GROUP BY libros.titulo ORDER BY numero_prestamos DESC;

--4. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días:

SELECT prestamos.id, socios.rut,((fecha_termino - fecha_inicio) - 7)*100 AS "monto_adeudado" FROM prestamos
INNER JOIN socios
ON prestamos.rut=socios.rut
WHERE ((fecha_termino - fecha_inicio) - 7) > 0
ORDER BY prestamos.id;