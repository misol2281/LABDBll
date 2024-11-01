--AFTER TRIGGERS
--1)
CREATE TRIGGER trg_RegistrarHistorialPrecio
ON productos
AFTER UPDATE
AS
BEGIN
    IF UPDATE(precioUnitario)
    BEGIN
        INSERT INTO HistorialPrecios (idProducto, PrecioAnterior, FechaCambio)
        SELECT i.idProducto, d.precioUnitario, GETDATE()
        FROM inserted i
        JOIN deleted d ON i.idProducto = d.idProducto;
    END
END;

--2)
ALTER TABLE clientes
ADD FechaUltimaVisita DATETIME;

CREATE TRIGGER trg_ActualizarFechaUltimaConsulta
ON Clientes
AFTER UPDATE
AS
BEGIN
    IF UPDATE(FechaUltimaVisita)
    BEGIN
        UPDATE Clientes
        SET FechaUltimaVisita = GETDATE()
        FROM Clientes c
        JOIN inserted i ON c.idCliente = i.idCliente;
    END
END;

--3)
CREATE TRIGGER trg_ActualizarStock
ON detallesPedidos
AFTER INSERT, UPDATE
AS
BEGIN
    
    UPDATE inventarios
    SET stockActual = stockActual - i.cantidadVendida 
    FROM inventarios
    INNER JOIN productosFinal ON inventarios.idInventario = productosFinal.idInventario
    INNER JOIN detallesPedidos ON productosFinal.idProductoFinal = detallesPedidos.idProductoFinal
    INNER JOIN inserted i ON detallesPedidos.idProductoFinal = i.idProductoFinal;
END;

--4)
CREATE TRIGGER trg_HistorialCambiosCliente
ON Clientes
AFTER UPDATE
AS
BEGIN
    INSERT INTO clientes (nombreCliente, telefonoCliente, correoCliente,FechaDeNacimiento)
    SELECT d.nombreCliente, d.telefonoCliente, d.correoCliente, d.FechaDeNacimiento, GETDATE()
    FROM deleted d
    JOIN inserted i ON d.idCliente = i.idCliente
    WHERE d.nombreCliente <> i.nombreCliente OR d.telefonoCliente<> i.telefonoCliente OR d.correoCliente <> i.correoCliente
	OR d.FechaDeNacimiento <> i.FechaDeNacimiento;
END;

--5)
CREATE TRIGGER trg_ActualizarTotalFactura
ON detallesPedidos
AFTER INSERT
AS
BEGIN
    UPDATE pedidos
    SET monto = subTotal + i.precioProducto * i.cantidadVendida
    FROM inserted i
    WHERE pedidos.idPedido= i.idPedido;
END;



