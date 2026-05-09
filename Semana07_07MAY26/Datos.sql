-- ============================================================
--  DATOS DE PRUEBA — SISTEMA DE LIBRERÍA
--  Versión : 2.0  (script autosuficiente — todas las tablas)
--  Volumen :
--    - 4  categorías
--    - 4  tipos de cliente  (con porcentaje de descuento)
--    - 12 autores
--    - 6  editoriales
--    - 8  temas
--    - 40 productos         (10 por categoría)
--    - 4  empleados
--    - 28 clientes          (7 por tipo)
--    - 180 ventas           (5 por mes × 12 meses × 3 años)
--      con 2 a 4 líneas de detalle por venta
-- ============================================================

USE LibreriaDB;
GO

-- ============================================================
--  SECCIÓN 1: CATEGORIA (4 registros)
-- ============================================================

SET IDENTITY_INSERT CATEGORIA ON;
INSERT INTO CATEGORIA (id_categoria, nombre, descripcion) VALUES
    (1, 'LIBRO',      'Libros académicos, técnicos y literarios'),
    (2, 'SUVENIR',    'Artículos de recuerdo y merchandising'),
    (3, 'PAPELERÍA',  'Útiles de escritorio y material de oficina'),
    (4, 'OTRO',       'Artículos varios no categorizados');
SET IDENTITY_INSERT CATEGORIA OFF;
GO

-- ============================================================
--  SECCIÓN 2: TIPO_CLIENTE (4 registros)
--  EXTERNO: pct_descuento = 0 (sin beneficio, por definición)
-- ============================================================

SET IDENTITY_INSERT TIPO_CLIENTE ON;
INSERT INTO TIPO_CLIENTE (id_tipo_cliente, nombre, descripcion, pct_descuento) VALUES
    (1, 'ESTUDIANTE', 'Estudiante matriculado en institución educativa',    15.00),
    (2, 'DOCENTE',    'Docente o profesor en actividad',                    20.00),
    (3, 'TRABAJADOR', 'Trabajador administrativo o técnico',                10.00),
    (4, 'EXTERNO',    'Cliente externo sin beneficio de descuento',          0.00);
SET IDENTITY_INSERT TIPO_CLIENTE OFF;
GO

-- ============================================================
--  SECCIÓN 3: AUTORES (12 registros)
-- ============================================================

SET IDENTITY_INSERT AUTOR ON;
INSERT INTO AUTOR (id_autor, nombres, apellidos, nacionalidad) VALUES
    ( 1, 'Ramez',        'Elmasri',        'Estadounidense'),
    ( 2, 'Shamkant',     'Navathe',        'Indio-Estadounidense'),
    ( 3, 'Robert C.',    'Martin',         'Estadounidense'),
    ( 4, 'Martin',       'Fowler',         'Británico'),
    ( 5, 'Andrew S.',    'Tanenbaum',      'Estadounidense'),
    ( 6, 'Donald E.',    'Knuth',          'Estadounidense'),
    ( 7, 'Erich',        'Gamma',          'Suizo'),
    ( 8, 'Thomas H.',    'Cormen',         'Estadounidense'),
    ( 9, 'Ian',          'Sommerville',    'Británico'),
    (10, 'Roger S.',     'Pressman',       'Estadounidense'),
    (11, 'Abraham',      'Silberschatz',   'Estadounidense'),
    (12, 'Andrej',       'Karpathy',       'Eslovaco-Estadounidense');
SET IDENTITY_INSERT AUTOR OFF;
GO

-- ============================================================
--  SECCIÓN 4: EDITORIALES (6 registros)
-- ============================================================

SET IDENTITY_INSERT EDITORIAL ON;
INSERT INTO EDITORIAL (id_editorial, nombre, pais) VALUES
    (1, 'Pearson',            'Estados Unidos'),
    (2, 'Addison-Wesley',     'Estados Unidos'),
    (3, 'O''Reilly Media',    'Estados Unidos'),
    (4, 'McGraw-Hill',        'Estados Unidos'),
    (5, 'Prentice Hall',      'Estados Unidos'),
    (6, 'MIT Press',          'Estados Unidos');
SET IDENTITY_INSERT EDITORIAL OFF;
GO

-- ============================================================
--  SECCIÓN 5: TEMAS (8 registros)
-- ============================================================

SET IDENTITY_INSERT TEMA ON;
INSERT INTO TEMA (id_tema, nombre) VALUES
    (1, 'Ingeniería de Software'),
    (2, 'Base de Datos'),
    (3, 'Inteligencia Artificial'),
    (4, 'Matemáticas'),
    (5, 'Estructuras de Datos'),
    (6, 'Redes y Sistemas'),
    (7, 'Arquitectura de Software'),
    (8, 'Metodologías Ágiles');
SET IDENTITY_INSERT TEMA OFF;
GO

-- ============================================================
--  SECCIÓN 6: PRODUCTOS (40 registros — 10 por categoría)
--  Categorías:
--    1 = LIBRO
--    2 = SUVENIR
--    3 = PAPELERÍA
--    4 = OTRO
-- ============================================================

SET IDENTITY_INSERT PRODUCTO ON;

-- ----------------------------------------------------------
--  LIBROS (id_categoria = 1)
--  FK a AUTOR, EDITORIAL y TEMA obligatorias.
-- ----------------------------------------------------------
INSERT INTO PRODUCTO
    (id_producto, id_categoria, id_autor, id_editorial, id_tema,
     codigo, nombre, isbn, edicion, anio_publicacion,
     precio_unitario, stock)
VALUES
    ( 1, 1,  1, 1, 2, 'LIB-001', 'Fundamentos de Sistemas de Bases de Datos',
      '978-0133970777', '7ma', 2016, 185.00, 30),
    ( 2, 1,  3, 2, 1, 'LIB-002', 'Código Limpio: Manual de Artesanía del Software Ágil',
      '978-0132350884', '1ra', 2008, 120.00, 25),
    ( 3, 1,  4, 2, 7, 'LIB-003', 'Patrones de Arquitectura de Aplicaciones Empresariales',
      '978-0321127426', '1ra', 2002, 145.00, 20),
    ( 4, 1,  7, 2, 7, 'LIB-004', 'Patrones de Diseño: Elementos de Software Orientado a Objetos',
      '978-0201633610', '1ra', 1994, 160.00, 15),
    ( 5, 1,  8, 5, 5, 'LIB-005', 'Introducción a los Algoritmos',
      '978-0262033848', '3ra', 2009, 210.00, 18),
    ( 6, 1,  9, 1, 1, 'LIB-006', 'Ingeniería del Software',
      '978-0133943030', '10ma', 2015, 175.00, 22),
    ( 7, 1, 10, 4, 1, 'LIB-007', 'Ingeniería del Software: Un Enfoque Práctico',
      '978-0078022128', '8va', 2014, 168.00, 20),
    ( 8, 1, 11, 4, 2, 'LIB-008', 'Fundamentos de Sistemas Operativos y Bases de Datos',
      '978-0073523354', '9na', 2010, 155.00, 12),
    ( 9, 1,  5, 5, 6, 'LIB-009', 'Redes de Computadoras',
      '978-0132126953', '5ta', 2011, 190.00, 14),
    (10, 1,  2, 1, 3, 'LIB-010', 'Inteligencia Artificial: Un Enfoque Moderno',
      '978-0136042594', '4ta', 2020, 220.00, 10);

-- ----------------------------------------------------------
--  SOUVENIRS (id_categoria = 2)
--  Sin autor, editorial ni tema.
-- ----------------------------------------------------------
INSERT INTO PRODUCTO
    (id_producto, id_categoria, id_autor, id_editorial, id_tema,
     codigo, nombre, isbn, edicion, anio_publicacion,
     precio_unitario, stock)
VALUES
    (11, 2, NULL, NULL, NULL, 'SUV-001', 'Taza "Keep Calm and Code"',         NULL, NULL, NULL,  25.00, 50),
    (12, 2, NULL, NULL, NULL, 'SUV-002', 'Polo estampado "Hello World"',       NULL, NULL, NULL,  45.00, 40),
    (13, 2, NULL, NULL, NULL, 'SUV-003', 'Mouse pad "Clean Code"',             NULL, NULL, NULL,  20.00, 60),
    (14, 2, NULL, NULL, NULL, 'SUV-004', 'Llavero "Git Push"',                 NULL, NULL, NULL,   8.00, 100),
    (15, 2, NULL, NULL, NULL, 'SUV-005', 'Bolso tela "Bookworm"',              NULL, NULL, NULL,  35.00, 35),
    (16, 2, NULL, NULL, NULL, 'SUV-006', 'Separador magnético colección libros',NULL, NULL, NULL,  12.00, 80),
    (17, 2, NULL, NULL, NULL, 'SUV-007', 'Cuaderno Moleskine A5 tapa dura',    NULL, NULL, NULL,  55.00, 45),
    (18, 2, NULL, NULL, NULL, 'SUV-008', 'Figura decorativa "Lectura"',        NULL, NULL, NULL,  38.00, 25),
    (19, 2, NULL, NULL, NULL, 'SUV-009', 'Pin metálico "Read More"',           NULL, NULL, NULL,   6.00, 120),
    (20, 2, NULL, NULL, NULL, 'SUV-010', 'Poster motivacional "Libraries"',    NULL, NULL, NULL,  18.00, 55);

-- ----------------------------------------------------------
--  PAPELERÍA (id_categoria = 3)
-- ----------------------------------------------------------
INSERT INTO PRODUCTO
    (id_producto, id_categoria, id_autor, id_editorial, id_tema,
     codigo, nombre, isbn, edicion, anio_publicacion,
     precio_unitario, stock)
VALUES
    (21, 3, NULL, NULL, NULL, 'PAP-001', 'Resaltador fluorescente set x5',     NULL, NULL, NULL,  12.00, 90),
    (22, 3, NULL, NULL, NULL, 'PAP-002', 'Lapicero tinta gel azul x12',        NULL, NULL, NULL,  15.00, 75),
    (23, 3, NULL, NULL, NULL, 'PAP-003', 'Cuaderno universitario 100 hojas',   NULL, NULL, NULL,  18.00, 65),
    (24, 3, NULL, NULL, NULL, 'PAP-004', 'Post-it colores surtidos 4 blocks',  NULL, NULL, NULL,  14.00, 85),
    (25, 3, NULL, NULL, NULL, 'PAP-005', 'Folder Manila A4 x25 unidades',      NULL, NULL, NULL,  10.00, 100),
    (26, 3, NULL, NULL, NULL, 'PAP-006', 'Regla metálica 30 cm',               NULL, NULL, NULL,   8.00, 70),
    (27, 3, NULL, NULL, NULL, 'PAP-007', 'Corrector líquido x3 unidades',      NULL, NULL, NULL,   9.00, 80),
    (28, 3, NULL, NULL, NULL, 'PAP-008', 'Sobre manila A4 x50 unidades',       NULL, NULL, NULL,  16.00, 55),
    (29, 3, NULL, NULL, NULL, 'PAP-009', 'Calculadora científica Casio FX-82', NULL, NULL, NULL,  85.00, 30),
    (30, 3, NULL, NULL, NULL, 'PAP-010', 'Cinta adhesiva x6 rollos',           NULL, NULL, NULL,  11.00, 90);

-- ----------------------------------------------------------
--  OTRO (id_categoria = 4)
-- ----------------------------------------------------------
INSERT INTO PRODUCTO
    (id_producto, id_categoria, id_autor, id_editorial, id_tema,
     codigo, nombre, isbn, edicion, anio_publicacion,
     precio_unitario, stock)
VALUES
    (31, 4, NULL, NULL, NULL, 'OTR-001', 'Organizador de escritorio 5 compartimientos', NULL, NULL, NULL, 42.00, 30),
    (32, 4, NULL, NULL, NULL, 'OTR-002', 'Lámpara LED escritorio recargable',           NULL, NULL, NULL, 95.00, 20),
    (33, 4, NULL, NULL, NULL, 'OTR-003', 'Porta libros metálico ajustable',             NULL, NULL, NULL, 38.00, 25),
    (34, 4, NULL, NULL, NULL, 'OTR-004', 'Atril de lectura regulable',                  NULL, NULL, NULL, 65.00, 15),
    (35, 4, NULL, NULL, NULL, 'OTR-005', 'Marcador de páginas digital USB',             NULL, NULL, NULL, 28.00, 40),
    (36, 4, NULL, NULL, NULL, 'OTR-006', 'Funda protectora para tablet 10"',            NULL, NULL, NULL, 55.00, 22),
    (37, 4, NULL, NULL, NULL, 'OTR-007', 'Auriculares con cancelación de ruido',        NULL, NULL, NULL,180.00, 12),
    (38, 4, NULL, NULL, NULL, 'OTR-008', 'Cojín lumbar para silla de estudio',          NULL, NULL, NULL, 75.00, 18),
    (39, 4, NULL, NULL, NULL, 'OTR-009', 'Reloj de escritorio silencioso',              NULL, NULL, NULL, 48.00, 20),
    (40, 4, NULL, NULL, NULL, 'OTR-010', 'Kit limpieza pantallas y teclado',            NULL, NULL, NULL, 22.00, 50);

SET IDENTITY_INSERT PRODUCTO OFF;
GO

-- ============================================================
--  SECCIÓN 7: EMPLEADOS (4 registros)
-- ============================================================

SET IDENTITY_INSERT EMPLEADO ON;
INSERT INTO EMPLEADO (id_empleado, nombres, apellidos, num_documento, cargo, correo, fecha_ingreso) VALUES
    (1, 'Carlos',    'Mendoza Ríos',     '45123678', 'Vendedor Senior',    'c.mendoza@libreria.pe',   '2018-03-01'),
    (2, 'Ana',       'Torres Vega',      '47892341', 'Vendedora',          'a.torres@libreria.pe',    '2019-07-15'),
    (3, 'Luis',      'Paredes Huanca',   '43567891', 'Cajero',             'l.paredes@libreria.pe',   '2020-01-10'),
    (4, 'María',     'Quispe Flores',    '48234567', 'Vendedora Junior',   'm.quispe@libreria.pe',    '2021-06-01');
SET IDENTITY_INSERT EMPLEADO OFF;
GO

-- ============================================================
--  SECCIÓN 8: CLIENTES (28 registros — 7 por tipo)
--  Tipos:  1=ESTUDIANTE  2=DOCENTE  3=TRABAJADOR  4=EXTERNO
-- ============================================================

SET IDENTITY_INSERT CLIENTE ON;
INSERT INTO CLIENTE (id_cliente, id_tipo_cliente, nombres, apellidos, num_documento, correo, telefono) VALUES
-- ESTUDIANTE (id_tipo_cliente = 1)
    ( 1, 1, 'Diego',      'Alvarado Cruz',      '75234891', 'dalvarado@uni.edu.pe',      '987654321'),
    ( 2, 1, 'Valeria',    'Benites Soto',        '76345902', 'vbenites@uni.edu.pe',       '976543210'),
    ( 3, 1, 'Rodrigo',    'Ccahuana Mamani',     '77456013', 'rccahuana@uni.edu.pe',      '965432109'),
    ( 4, 1, 'Camila',     'Díaz Palomino',       '78567124', 'cdiaz@pucp.edu.pe',         '954321098'),
    ( 5, 1, 'Sebastián',  'Espinoza Tapia',      '79678235', 'sespinoza@unmsm.edu.pe',    '943210987'),
    ( 6, 1, 'Luciana',    'Fuentes Vargas',      '80789346', 'lfuentes@upc.edu.pe',       '932109876'),
    ( 7, 1, 'Adrián',     'Gutiérrez León',      '81890457', 'agutierrez@uni.edu.pe',     '921098765'),
-- DOCENTE (id_tipo_cliente = 2)
    ( 8, 2, 'Patricia',   'Herrera Jiménez',     '20123456', 'pherrera@uni.edu.pe',       '912345678'),
    ( 9, 2, 'Jorge',      'Ibáñez Romero',       '21234567', 'jibanez@pucp.edu.pe',       '901234567'),
    (10, 2, 'Carmen',     'Jara Cárdenas',       '22345678', 'cjara@unmsm.edu.pe',        '890123456'),
    (11, 2, 'Roberto',    'Landa Porras',        '23456789', 'rlanda@ulima.edu.pe',       '879012345'),
    (12, 2, 'Silvia',     'Morales Aquino',      '24567890', 'smorales@uni.edu.pe',       '868901234'),
    (13, 2, 'Fernando',   'Núñez Castillo',      '25678901', 'fnunez@upc.edu.pe',         '857890123'),
    (14, 2, 'Giovanna',   'Ochoa Delgado',       '26789012', 'gochoa@uni.edu.pe',         '846789012'),
-- TRABAJADOR (id_tipo_cliente = 3)
    (15, 3, 'Marco',      'Peña Huamán',         '30123456', 'mpena@empresa1.com.pe',     '835678901'),
    (16, 3, 'Rosa',       'Quispe Condori',      '31234567', 'rquispe@empresa2.com.pe',   '824567890'),
    (17, 3, 'Hugo',       'Ramos Salazar',       '32345678', 'hramos@empresa3.com.pe',    '813456789'),
    (18, 3, 'Elena',      'Soto Bravo',          '33456789', 'esoto@empresa4.com.pe',     '802345678'),
    (19, 3, 'César',      'Torres Infante',      '34567890', 'ctorres@empresa5.com.pe',   '791234567'),
    (20, 3, 'Miriam',     'Ugarte Palacios',     '35678901', 'mugarte@empresa6.com.pe',   '780123456'),
    (21, 3, 'Víctor',     'Vargas Quispe',       '36789012', 'vvargas@empresa7.com.pe',   '769012345'),
-- EXTERNO (id_tipo_cliente = 4)
    (22, 4, 'Andrea',     'Williams Torres',     '40123456', 'awilliams@gmail.com',       '758901234'),
    (23, 4, 'Renato',     'Xu Paredes',          '41234567', 'rxu@hotmail.com',           '747890123'),
    (24, 4, 'Natalia',    'Yépez Cabrera',       '42345678', 'nyepez@gmail.com',          '736789012'),
    (25, 4, 'Bruno',      'Zanabria Díaz',       '43456789', 'bzanabria@outlook.com',     '725678901'),
    (26, 4, 'Isabella',   'Arce Medina',         '44567890', 'iarce@yahoo.com',           '714567890'),
    (27, 4, 'Maximiliano','Bernal Fuentes',      '45678901', 'mbernal@gmail.com',         '703456789'),
    (28, 4, 'Alejandra',  'Castillo Reyes',      '46789012', 'acastillo@hotmail.com',     '692345678');
SET IDENTITY_INSERT CLIENTE OFF;
GO

-- ============================================================
--  SECCIÓN 9: VENTAS Y DETALLE
--  180 ventas: 5 por mes × 12 meses × 3 años (2022, 2023, 2024)
--  Distribución de clientes y empleados de forma cíclica.
--  Detalle: 2 a 4 líneas por venta, productos variados.
-- ============================================================

-- ============================================================
--  PASO 1 DE 2: Insertar cabeceras de VENTA
--  SQL Server no permite IDENTITY_INSERT en dos tablas
--  simultáneamente, por lo que se separa en dos bloques GO.
-- ============================================================

SET IDENTITY_INSERT VENTA ON;

DECLARE @anio       INT;
DECLARE @mes        INT;
DECLARE @dia        INT;
DECLARE @venta_num  INT;
DECLARE @id_cliente INT;
DECLARE @id_emp     INT;
DECLARE @pct        DECIMAL(5,2);
DECLARE @id_venta_seq INT = 1;

DECLARE @dias TABLE (num INT, dia INT);
INSERT INTO @dias VALUES (1,3),(2,8),(3,14),(4,19),(5,25);

SET @anio = 2022;
WHILE @anio <= 2024
BEGIN
    SET @mes = 1;
    WHILE @mes <= 12
    BEGIN
        SET @venta_num = 1;
        WHILE @venta_num <= 5
        BEGIN
            SELECT @dia = dia FROM @dias WHERE num = @venta_num;

            SET @id_cliente = ((@id_venta_seq - 1) % 28) + 1;
            SET @id_emp     = ((@id_venta_seq - 1) % 4)  + 1;

            SELECT @pct = tc.pct_descuento
            FROM   CLIENTE c
            JOIN   TIPO_CLIENTE tc ON c.id_tipo_cliente = tc.id_tipo_cliente
            WHERE  c.id_cliente = @id_cliente;

            -- Cabecera con totales en cero; se actualizan en el Paso 2
            INSERT INTO VENTA
                (id_venta, id_cliente, id_empleado, fecha_venta,
                 subtotal, pct_descuento, monto_descuento, total)
            VALUES
                (@id_venta_seq, @id_cliente, @id_emp,
                 DATEFROMPARTS(@anio, @mes, @dia),
                 0, @pct, 0, 0);

            SET @id_venta_seq += 1;
            SET @venta_num    += 1;
        END;
        SET @mes  += 1;
    END;
    SET @anio += 1;
END;

SET IDENTITY_INSERT VENTA OFF;
GO

-- ============================================================
--  PASO 2 DE 2: Insertar DETALLE_VENTA y actualizar totales
-- ============================================================

SET IDENTITY_INSERT DETALLE_VENTA ON;

DECLARE @id_venta_seq2   INT = 1;
DECLARE @id_detalle_seq  INT = 1;
DECLARE @num_lineas      INT;
DECLARE @linea           INT;
DECLARE @id_prod         INT;
DECLARE @cant            INT;
DECLARE @precio_u        DECIMAL(10,2);
DECLARE @pct2            DECIMAL(5,2);
DECLARE @subtotal        DECIMAL(10,2);
DECLARE @descuento       DECIMAL(10,2);
DECLARE @total           DECIMAL(10,2);

WHILE @id_venta_seq2 <= 180
BEGIN
    SET @num_lineas = ((@id_venta_seq2 - 1) % 3) + 2;  -- 2, 3 o 4 líneas
    SET @linea      = 1;

    WHILE @linea <= @num_lineas
    BEGIN
        SET @id_prod = ((@id_venta_seq2 + @linea * 7 - 1) % 40) + 1;
        SET @cant    = (@linea % 3) + 1;  -- 1, 2 o 3 unidades

        SELECT @precio_u = precio_unitario
        FROM   PRODUCTO
        WHERE  id_producto = @id_prod;

        INSERT INTO DETALLE_VENTA
            (id_detalle, id_venta, id_producto, cantidad, precio_unitario)
        VALUES
            (@id_detalle_seq, @id_venta_seq2, @id_prod, @cant, @precio_u);

        SET @id_detalle_seq += 1;
        SET @linea          += 1;
    END;

    -- Obtener pct_descuento de la cabecera ya insertada
    SELECT @pct2 = pct_descuento
    FROM   VENTA
    WHERE  id_venta = @id_venta_seq2;

    -- Calcular y actualizar totales en la cabecera
    SELECT @subtotal = SUM(subtotal_linea)
    FROM   DETALLE_VENTA
    WHERE  id_venta = @id_venta_seq2;

    SET @descuento = ROUND(@subtotal * @pct2 / 100, 2);
    SET @total     = @subtotal - @descuento;

    UPDATE VENTA
    SET    subtotal        = @subtotal,
           monto_descuento = @descuento,
           total           = @total
    WHERE  id_venta        = @id_venta_seq2;

    SET @id_venta_seq2 += 1;
END;

SET IDENTITY_INSERT DETALLE_VENTA OFF;
GO

-- ============================================================
--  SECCIÓN 10: VERIFICACIÓN DE CARGA
-- ============================================================

SELECT 'CATEGORIA'      AS tabla, COUNT(*) AS registros FROM CATEGORIA      UNION ALL
SELECT 'TIPO_CLIENTE',             COUNT(*)              FROM TIPO_CLIENTE   UNION ALL
SELECT 'AUTOR',                    COUNT(*)              FROM AUTOR          UNION ALL
SELECT 'EDITORIAL',                COUNT(*)              FROM EDITORIAL      UNION ALL
SELECT 'TEMA',                     COUNT(*)              FROM TEMA           UNION ALL
SELECT 'PRODUCTO',                 COUNT(*)              FROM PRODUCTO       UNION ALL
SELECT 'EMPLEADO',                 COUNT(*)              FROM EMPLEADO       UNION ALL
SELECT 'CLIENTE',                  COUNT(*)              FROM CLIENTE        UNION ALL
SELECT 'VENTA',                    COUNT(*)              FROM VENTA          UNION ALL
SELECT 'DETALLE_VENTA',            COUNT(*)              FROM DETALLE_VENTA;
GO

-- ============================================================
--  SECCIÓN 11: CONSULTAS DE VALIDACIÓN
-- ============================================================

-- Productos por categoría
SELECT cat.nombre AS categoria, COUNT(*) AS total_productos
FROM   PRODUCTO p
JOIN   CATEGORIA cat ON p.id_categoria = cat.id_categoria
GROUP  BY cat.nombre
ORDER  BY cat.nombre;
GO

-- Clientes por tipo
SELECT tc.nombre AS tipo_cliente, COUNT(*) AS total_clientes
FROM   CLIENTE c
JOIN   TIPO_CLIENTE tc ON c.id_tipo_cliente = tc.id_tipo_cliente
GROUP  BY tc.nombre
ORDER  BY tc.nombre;
GO

-- Ventas por año y mes
SELECT
    YEAR(fecha_venta)  AS anio,
    MONTH(fecha_venta) AS mes,
    COUNT(*)           AS total_ventas,
    SUM(subtotal)      AS subtotal_total,
    SUM(monto_descuento) AS descuento_total,
    SUM(total)         AS total_ingresos
FROM   VENTA
GROUP  BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER  BY anio, mes;
GO

-- Ventas por tipo de cliente (verifica descuentos)
SELECT
    tc.nombre        AS tipo_cliente,
    tc.pct_descuento AS descuento_pct,
    COUNT(v.id_venta) AS total_ventas,
    SUM(v.subtotal)   AS subtotal_acumulado,
    SUM(v.monto_descuento) AS descuento_acumulado,
    SUM(v.total)      AS ingreso_neto
FROM   VENTA v
JOIN   CLIENTE      c  ON v.id_cliente      = c.id_cliente
JOIN   TIPO_CLIENTE tc ON c.id_tipo_cliente = tc.id_tipo_cliente
GROUP  BY tc.nombre, tc.pct_descuento
ORDER  BY tc.nombre;
GO