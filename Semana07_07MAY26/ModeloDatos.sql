-- ============================================================
--  SISTEMA DE LIBRERÍA
--  Base de datos: SQL Server
--  Versión: 2.0 — Fiel al diagrama ER original
--  Tablas: AUTOR, EDITORIAL, TEMA, CATEGORIA,
--          PRODUCTO, CLIENTE, EMPLEADO,
--          VENTA, DETALLE_VENTA
--          + TIPO_CLIENTE (catálogo de clasificación)
-- ============================================================

USE master;
GO

IF DB_ID('LibreriaDB') IS NOT NULL
    DROP DATABASE LibreriaDB;
GO

CREATE DATABASE LibreriaDB
    COLLATE SQL_Latin1_General_CP1_CI_AI;
GO

USE LibreriaDB;
GO

-- ============================================================
--  SECCIÓN 1: TABLAS CATÁLOGO
-- ============================================================

-- ------------------------------------------------------------
--  CATEGORIA
--  Clasifica el producto: LIBRO, SUVENIR, etc.
-- ------------------------------------------------------------
CREATE TABLE CATEGORIA (
    id_categoria    INT           NOT NULL IDENTITY(1,1),
    nombre          VARCHAR(60)   NOT NULL,
    descripcion     VARCHAR(255)      NULL,
    activo          BIT           NOT NULL DEFAULT 1,
    CONSTRAINT PK_CATEGORIA        PRIMARY KEY (id_categoria),
    CONSTRAINT UQ_CATEGORIA_NOMBRE UNIQUE      (nombre)
);
GO

-- ------------------------------------------------------------
--  TEMA
--  Solo aplicable a libros (cardinalidad 1:1 con PRODUCTO
--  de tipo LIBRO, según restricción del negocio).
-- ------------------------------------------------------------
CREATE TABLE TEMA (
    id_tema         INT           NOT NULL IDENTITY(1,1),
    nombre          VARCHAR(100)  NOT NULL,
    descripcion     VARCHAR(255)      NULL,
    activo          BIT           NOT NULL DEFAULT 1,
    CONSTRAINT PK_TEMA        PRIMARY KEY (id_tema),
    CONSTRAINT UQ_TEMA_NOMBRE UNIQUE      (nombre)
);
GO

-- ------------------------------------------------------------
--  AUTOR
--  Solo aplicable a libros (1 autor por libro).
-- ------------------------------------------------------------
CREATE TABLE AUTOR (
    id_autor        INT           NOT NULL IDENTITY(1,1),
    nombres         VARCHAR(100)  NOT NULL,
    apellidos       VARCHAR(100)  NOT NULL,
    nacionalidad    VARCHAR(80)       NULL,
    activo          BIT           NOT NULL DEFAULT 1,
    CONSTRAINT PK_AUTOR PRIMARY KEY (id_autor)
);
GO

-- ------------------------------------------------------------
--  EDITORIAL
--  Solo aplicable a libros (1 editorial por libro).
-- ------------------------------------------------------------
CREATE TABLE EDITORIAL (
    id_editorial    INT           NOT NULL IDENTITY(1,1),
    nombre          VARCHAR(150)  NOT NULL,
    pais            VARCHAR(80)       NULL,
    activo          BIT           NOT NULL DEFAULT 1,
    CONSTRAINT PK_EDITORIAL        PRIMARY KEY (id_editorial),
    CONSTRAINT UQ_EDITORIAL_NOMBRE UNIQUE      (nombre)
);
GO

-- ------------------------------------------------------------
--  TIPO_CLIENTE
--  Catálogo: ESTUDIANTE, DOCENTE, TRABAJADOR, EXTERNO.
--  El porcentaje de descuento es propiedad del tipo:
--  EXTERNO tiene pct_descuento = 0.00 (sin descuento).
-- ------------------------------------------------------------
CREATE TABLE TIPO_CLIENTE (
    id_tipo_cliente INT             NOT NULL IDENTITY(1,1),
    nombre          VARCHAR(60)     NOT NULL,
    descripcion     VARCHAR(255)        NULL,
    pct_descuento   DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    activo          BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_TIPO_CLIENTE        PRIMARY KEY (id_tipo_cliente),
    CONSTRAINT UQ_TIPO_CLIENTE_NOMBRE UNIQUE      (nombre),
    CONSTRAINT CK_TIPO_CLIENTE_PCT    CHECK (pct_descuento >= 0 AND pct_descuento < 100)
);
GO

-- ============================================================
--  SECCIÓN 2: ENTIDADES PRINCIPALES
-- ============================================================

-- ------------------------------------------------------------
--  CLIENTE
-- ------------------------------------------------------------
CREATE TABLE CLIENTE (
    id_cliente      INT           NOT NULL IDENTITY(1,1),
    id_tipo_cliente INT           NOT NULL,
    nombres         VARCHAR(100)  NOT NULL,
    apellidos       VARCHAR(100)  NOT NULL,
    num_documento   VARCHAR(20)   NOT NULL,
    correo          VARCHAR(150)      NULL,
    telefono        VARCHAR(20)       NULL,
    direccion       VARCHAR(255)      NULL,
    fecha_registro  DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    activo          BIT           NOT NULL DEFAULT 1,
    CONSTRAINT PK_CLIENTE          PRIMARY KEY (id_cliente),
    CONSTRAINT UQ_CLIENTE_DOC      UNIQUE      (num_documento),
    CONSTRAINT FK_CLIENTE_TIPO     FOREIGN KEY (id_tipo_cliente)
        REFERENCES TIPO_CLIENTE (id_tipo_cliente)
);
GO

-- ------------------------------------------------------------
--  EMPLEADO
-- ------------------------------------------------------------
CREATE TABLE EMPLEADO (
    id_empleado     INT           NOT NULL IDENTITY(1,1),
    nombres         VARCHAR(100)  NOT NULL,
    apellidos       VARCHAR(100)  NOT NULL,
    num_documento   VARCHAR(20)   NOT NULL,
    cargo           VARCHAR(100)      NULL,
    correo          VARCHAR(150)      NULL,
    fecha_ingreso   DATE              NULL,
    activo          BIT           NOT NULL DEFAULT 1,
    CONSTRAINT PK_EMPLEADO      PRIMARY KEY (id_empleado),
    CONSTRAINT UQ_EMPLEADO_DOC  UNIQUE      (num_documento)
);
GO

-- ============================================================
--  SECCIÓN 3: PRODUCTO
--  Las FK a AUTOR, EDITORIAL y TEMA son opcionales (NULL),
--  ya que solo los libros las utilizan.
--  La integridad de negocio ("solo libros tienen autor")
--  se refuerza mediante un CHECK con función escalar.
-- ============================================================

CREATE TABLE PRODUCTO (
    id_producto     INT             NOT NULL IDENTITY(1,1),
    id_categoria    INT             NOT NULL,
    id_autor        INT                 NULL,   -- Solo si es LIBRO
    id_editorial    INT                 NULL,   -- Solo si es LIBRO
    id_tema         INT                 NULL,   -- Solo si es LIBRO
    codigo          VARCHAR(30)     NOT NULL,
    nombre          VARCHAR(200)    NOT NULL,
    descripcion     VARCHAR(500)        NULL,
    isbn            VARCHAR(20)         NULL,   -- Solo si es LIBRO
    edicion         VARCHAR(50)         NULL,   -- Solo si es LIBRO
    anio_publicacion SMALLINT           NULL,   -- Solo si es LIBRO
    precio_unitario DECIMAL(10,2)   NOT NULL,
    stock           INT             NOT NULL DEFAULT 0,
    activo          BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_PRODUCTO         PRIMARY KEY (id_producto),
    CONSTRAINT UQ_PRODUCTO_CODIGO  UNIQUE      (codigo),
    CONSTRAINT FK_PRODUCTO_CAT     FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA    (id_categoria),
    CONSTRAINT FK_PRODUCTO_AUTOR   FOREIGN KEY (id_autor)
        REFERENCES AUTOR        (id_autor),
    CONSTRAINT FK_PRODUCTO_EDIT    FOREIGN KEY (id_editorial)
        REFERENCES EDITORIAL    (id_editorial),
    CONSTRAINT FK_PRODUCTO_TEMA    FOREIGN KEY (id_tema)
        REFERENCES TEMA         (id_tema),
    CONSTRAINT CK_PRODUCTO_PRECIO  CHECK (precio_unitario >= 0),
    CONSTRAINT CK_PRODUCTO_STOCK   CHECK (stock >= 0)
);
GO

-- ------------------------------------------------------------
--  Función escalar auxiliar para el CHECK de coherencia:
--  verifica que AUTOR/EDITORIAL/TEMA solo se asignen
--  a productos cuya categoría sea 'LIBRO'.
-- ------------------------------------------------------------
CREATE FUNCTION fn_EsLibro (@id_categoria INT)
RETURNS BIT
AS
BEGIN
    RETURN (
        SELECT CASE WHEN nombre = 'LIBRO' THEN 1 ELSE 0 END
        FROM CATEGORIA
        WHERE id_categoria = @id_categoria
    );
END;
GO

ALTER TABLE PRODUCTO
    ADD CONSTRAINT CK_PRODUCTO_LIBRO_CAMPOS
    CHECK (
        -- Si no es libro, los campos exclusivos deben ser NULL
        dbo.fn_EsLibro(id_categoria) = 1
        OR (id_autor IS NULL AND id_editorial IS NULL AND id_tema IS NULL)
    );
GO

-- ============================================================
--  SECCIÓN 4: TRANSACCIONES
-- ============================================================

-- ------------------------------------------------------------
--  VENTA
--  pct_descuento: snapshot del descuento al momento de venta.
--  Aplica para ESTUDIANTE, DOCENTE y TRABAJADOR.
--  EXTERNO: pct_descuento = 0, total = subtotal.
-- ------------------------------------------------------------
CREATE TABLE VENTA (
    id_venta        INT             NOT NULL IDENTITY(1,1),
    id_cliente      INT             NOT NULL,
    id_empleado     INT             NOT NULL,
    fecha_venta     DATETIME        NOT NULL DEFAULT GETDATE(),
    subtotal        DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    pct_descuento   DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    monto_descuento DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    total           DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    observaciones   VARCHAR(500)        NULL,
    CONSTRAINT PK_VENTA        PRIMARY KEY (id_venta),
    CONSTRAINT FK_VENTA_CLI    FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE  (id_cliente),
    CONSTRAINT FK_VENTA_EMP    FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADO (id_empleado),
    CONSTRAINT CK_VENTA_PCT    CHECK (pct_descuento >= 0 AND pct_descuento < 100),
    CONSTRAINT CK_VENTA_TOTAL  CHECK (total >= 0)
);
GO

-- ------------------------------------------------------------
--  DETALLE_VENTA
--  precio_unitario: snapshot del precio al momento de venta.
--  subtotal_linea: columna calculada persistida.
-- ------------------------------------------------------------
CREATE TABLE DETALLE_VENTA (
    id_detalle      INT             NOT NULL IDENTITY(1,1),
    id_venta        INT             NOT NULL,
    id_producto     INT             NOT NULL,
    cantidad        INT             NOT NULL,
    precio_unitario DECIMAL(10,2)   NOT NULL,
    subtotal_linea  AS (cantidad * precio_unitario) PERSISTED,
    CONSTRAINT PK_DETALLE_VENTA  PRIMARY KEY (id_detalle),
    CONSTRAINT FK_DV_VENTA       FOREIGN KEY (id_venta)
        REFERENCES VENTA    (id_venta),
    CONSTRAINT FK_DV_PRODUCTO    FOREIGN KEY (id_producto)
        REFERENCES PRODUCTO (id_producto),
    CONSTRAINT CK_DV_CANTIDAD    CHECK (cantidad > 0),
    CONSTRAINT CK_DV_PRECIO      CHECK (precio_unitario >= 0)
);
GO

-- ============================================================
--  SECCIÓN 5: ÍNDICES
-- ============================================================

CREATE INDEX IX_PRODUCTO_CATEGORIA  ON PRODUCTO      (id_categoria);
CREATE INDEX IX_PRODUCTO_AUTOR      ON PRODUCTO      (id_autor);
CREATE INDEX IX_CLIENTE_TIPO        ON CLIENTE       (id_tipo_cliente);
CREATE INDEX IX_VENTA_CLIENTE       ON VENTA         (id_cliente);
CREATE INDEX IX_VENTA_EMPLEADO      ON VENTA         (id_empleado);
CREATE INDEX IX_VENTA_FECHA         ON VENTA         (fecha_venta);
CREATE INDEX IX_DV_VENTA            ON DETALLE_VENTA (id_venta);
CREATE INDEX IX_DV_PRODUCTO         ON DETALLE_VENTA (id_producto);
GO

/*
-- ============================================================
--  SECCIÓN 6: DATOS INICIALES
-- ============================================================

INSERT INTO CATEGORIA (nombre, descripcion) VALUES
    ('LIBRO',     'Libros académicos, técnicos y literarios'),
    ('SUVENIR',   'Artículos de recuerdo y merchandising'),
    ('PAPELERÍA', 'Útiles de escritorio y material de oficina'),
    ('OTRO',      'Artículos varios');
GO

-- EXTERNO: 0% — sin descuento (regla de negocio explícita)
INSERT INTO TIPO_CLIENTE (nombre, descripcion, pct_descuento) VALUES
    ('ESTUDIANTE', 'Estudiante matriculado',                  15.00),
    ('DOCENTE',    'Docente en actividad',                    20.00),
    ('TRABAJADOR', 'Trabajador administrativo o técnico',     10.00),
    ('EXTERNO',    'Cliente externo, sin beneficio de descuento', 0.00);
GO

INSERT INTO TEMA (nombre) VALUES
    ('Ingeniería de Software'),
    ('Base de Datos'),
    ('Inteligencia Artificial'),
    ('Matemáticas'),
    ('Literatura');
GO

INSERT INTO AUTOR (nombres, apellidos, nacionalidad) VALUES
    ('Ramez',     'Elmasri',  'Estadounidense'),
    ('Robert C.', 'Martin',   'Estadounidense'),
    ('Martin',    'Fowler',   'Británico');
GO

INSERT INTO EDITORIAL (nombre, pais) VALUES
    ('Pearson',        'Estados Unidos'),
    ('Addison-Wesley', 'Estados Unidos'),
    ('O''Reilly Media','Estados Unidos');
GO
*/

-- ============================================================
--  SECCIÓN 7: VISTAS
-- ============================================================

CREATE VIEW VW_CLIENTES AS
SELECT
    c.id_cliente,
    c.nombres + ' ' + c.apellidos  AS nombre_completo,
    c.num_documento,
    c.correo,
    tc.nombre                       AS tipo_cliente,
    tc.pct_descuento
FROM CLIENTE c
JOIN TIPO_CLIENTE tc ON c.id_tipo_cliente = tc.id_tipo_cliente;
GO

CREATE VIEW VW_PRODUCTOS AS
SELECT
    p.id_producto,
    p.codigo,
    p.nombre,
    cat.nombre                        AS categoria,
    p.precio_unitario,
    p.stock,
    a.nombres + ' ' + a.apellidos     AS autor,
    e.nombre                          AS editorial,
    t.nombre                          AS tema,
    p.isbn,
    p.edicion,
    p.anio_publicacion
FROM PRODUCTO p
JOIN  CATEGORIA cat   ON p.id_categoria  = cat.id_categoria
LEFT JOIN AUTOR a     ON p.id_autor      = a.id_autor
LEFT JOIN EDITORIAL e ON p.id_editorial  = e.id_editorial
LEFT JOIN TEMA t      ON p.id_tema       = t.id_tema;
GO

CREATE VIEW VW_VENTAS AS
SELECT
    v.id_venta,
    v.fecha_venta,
    c.nombres + ' ' + c.apellidos     AS cliente,
    tc.nombre                          AS tipo_cliente,
    emp.nombres + ' ' + emp.apellidos  AS empleado,
    v.subtotal,
    v.pct_descuento,
    v.monto_descuento,
    v.total
FROM VENTA v
JOIN CLIENTE      c   ON v.id_cliente    = c.id_cliente
JOIN TIPO_CLIENTE tc  ON c.id_tipo_cliente = tc.id_tipo_cliente
JOIN EMPLEADO     emp ON v.id_empleado   = emp.id_empleado;
GO




