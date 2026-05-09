-- ============================================================
--  SISTEMA DE LIBRERÍA
--  Base de datos: SQL Server
--  Versión: 2.0 — Fiel al diagrama ER original
--  Tablas: AUTOR, EDITORIAL, TEMA, CATEGORIA,
--          PRODUCTO, CLIENTE, EMPLEADO,
--          VENTA, DETALLE_VENTA
--          + TIPO_CLIENTE (catálogo de clasificación)
-- ============================================================

USE LibreriaDB;
GO




-- ============================================================
--  SECCIÓN 8: STORED PROCEDURES
-- ============================================================

-- ------------------------------------------------------------
--  sp_RegistrarVenta
--  Crea la cabecera de venta tomando el descuento vigente
--  del tipo de cliente en ese momento (snapshot).
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_RegistrarVenta
    @id_cliente     INT,
    @id_empleado    INT,
    @observaciones  VARCHAR(500) = NULL,
    @id_venta       INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @pct_descuento DECIMAL(5,2);

    SELECT @pct_descuento = tc.pct_descuento
    FROM   CLIENTE c
    JOIN   TIPO_CLIENTE tc ON c.id_tipo_cliente = tc.id_tipo_cliente
    WHERE  c.id_cliente = @id_cliente AND c.activo = 1;

    IF @pct_descuento IS NULL
    BEGIN
        RAISERROR('Cliente no encontrado, inactivo o sin tipo asignado.', 16, 1);
        RETURN;
    END

    INSERT INTO VENTA (id_cliente, id_empleado, pct_descuento, observaciones)
    VALUES (@id_cliente, @id_empleado, @pct_descuento, @observaciones);

    SET @id_venta = SCOPE_IDENTITY();
END;
GO

-- ------------------------------------------------------------
--  sp_AgregarDetalleVenta
--  Inserta una línea, descuenta stock y recalcula totales.
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_AgregarDetalleVenta
    @id_venta    INT,
    @id_producto INT,
    @cantidad    INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY

        DECLARE @precio    DECIMAL(10,2);
        DECLARE @stock_act INT;

        SELECT @precio = precio_unitario, @stock_act = stock
        FROM   PRODUCTO
        WHERE  id_producto = @id_producto AND activo = 1;

        IF @precio IS NULL
        BEGIN
            RAISERROR('Producto no encontrado o inactivo.', 16, 1);
            ROLLBACK; RETURN;
        END

        IF @stock_act < @cantidad
        BEGIN
            RAISERROR('Stock insuficiente.', 16, 1);
            ROLLBACK; RETURN;
        END

        INSERT INTO DETALLE_VENTA (id_venta, id_producto, cantidad, precio_unitario)
        VALUES (@id_venta, @id_producto, @cantidad, @precio);

        UPDATE PRODUCTO
        SET    stock = stock - @cantidad
        WHERE  id_producto = @id_producto;

        -- Recalcular totales en cabecera
        UPDATE v
        SET
            subtotal        = agg.subtotal,
            monto_descuento = ROUND(agg.subtotal * v.pct_descuento / 100, 2),
            total           = agg.subtotal - ROUND(agg.subtotal * v.pct_descuento / 100, 2)
        FROM VENTA v
        CROSS APPLY (
            SELECT SUM(subtotal_linea) AS subtotal
            FROM   DETALLE_VENTA
            WHERE  id_venta = v.id_venta
        ) agg
        WHERE v.id_venta = @id_venta;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO

-- ============================================================
--  RESUMEN
--  Tablas  : 9  (CATEGORIA, TEMA, AUTOR, EDITORIAL,
--                TIPO_CLIENTE, CLIENTE, EMPLEADO,
--                PRODUCTO, VENTA, DETALLE_VENTA)
--  Vistas  : 3
--  SPs     : 2
--  Índices : 8
-- ============================================================



