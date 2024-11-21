--6 excepciones Usado Procedimientos Almacenados y Triggers 

--1)
CREATE PROCEDURE RegistrarCliente
    @nombreCliente NVARCHAR(100),
    @telefonoCliente NVARCHAR(50),
    @correoCliente NVARCHAR(100),
    @fechaNacimiento DATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM clientes WHERE correoCliente = @correoCliente)
            THROW 50000, 'Error: Ya existe un cliente registrado con este correo.', 1;

        INSERT INTO clientes (nombreCliente, telefonoCliente, correoCliente, FechaDeNacimiento, FechaUltimaVisita)
        VALUES (@nombreCliente, @telefonoCliente, @correoCliente, @fechaNacimiento, NULL);

        PRINT 'Cliente registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;

--2)
CREATE TRIGGER trg_ValidarFechaCaducidad
ON productos
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE fechaCaducidad < GETDATE())
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Error: No se pueden registrar productos con fecha de caducidad vencida.';
    END
END;

--3)
CREATE TRIGGER trg_BloquearEliminacionClientes
ON clientes
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM compras WHERE idCliente IN (SELECT idCliente FROM deleted))
    BEGIN
        PRINT 'Error: No se puede eliminar un cliente con compras registradas.';
    END
    ELSE
    BEGIN
        DELETE FROM clientes WHERE idCliente IN (SELECT idCliente FROM deleted);
        PRINT 'Cliente eliminado exitosamente.';
    END
END;

--4)
CREATE PROCEDURE RealizarVenta
    @idProducto INT,
    @cantidad INT
AS
BEGIN
    BEGIN TRY
        -- Verificar si existe el producto
        IF NOT EXISTS (SELECT 1 FROM productos WHERE idProducto = @idProducto)
            THROW 50001, 'Error: El producto especificado no existe.', 1;

        -- Validar que haya suficiente stock
        IF (SELECT stockCritico FROM productos WHERE idProducto = @idProducto) < @cantidad
            THROW 50002, 'Error: No hay suficiente stock para realizar la venta.', 1;

        -- Si todo está bien, actualizar el stock
        UPDATE productos
        SET stockCritico = stockCritico - @cantidad
        WHERE idProducto = @idProducto;

        PRINT 'Venta realizada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturar el error en caso de fallo
        PRINT ERROR_MESSAGE();
    END CATCH
END;

--5)
CREATE TRIGGER trg_RegistrarHistorialPrecios
ON productos
AFTER UPDATE
AS
BEGIN
    IF UPDATE(precioUnitario)
    BEGIN
        INSERT INTO historial_precios (idProducto, fechaCambio, precioAnterior, precioNuevo)
        SELECT d.idProducto, GETDATE(), d.precioUnitario, i.precioUnitario
        FROM deleted d
        INNER JOIN inserted i ON d.idProducto = i.idProducto;

        PRINT 'Historial de precios actualizado correctamente.';
    END
END;

--6)
CREATE PROCEDURE VerificarDisponibilidadProducto
    @idProducto INT,
    @cantidad INT 
AS
BEGIN
    BEGIN TRY
       
        IF NOT EXISTS (SELECT 1 FROM productos WHERE idProducto = @idProducto)
            THROW 50007, 'Error: El producto especificado no existe.', 1;

       
        IF (SELECT stockCritico FROM productos WHERE idProducto = @idProducto) < @cantidad
            THROW 50008, 'Error: No hay suficiente cantidad para la operación solicitada.', 1;

        PRINT 'El producto está disponible para la operación.';
    END TRY
    BEGIN CATCH
        
        PRINT ERROR_MESSAGE();
    END CATCH
END;



--9 TRASACCIONES

--1)
BEGIN TRANSACTION;

BEGIN TRY
    UPDATE productos
    SET stockCritico = stockCritico + 10
    WHERE idProducto = 3;

    COMMIT TRANSACTION;
    PRINT 'Inventario ajustado manualmente.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH;

--2)
BEGIN TRANSACTION; 

BEGIN TRY
    -- Insertar un nuevo cliente en la tabla clientes
    INSERT INTO clientes (nombreCliente, telefonoCliente, correoCliente, FechaDeNacimiento, FechaUltimaVisita)
    VALUES ('Carlos Pérez', '555987654', 'carlos.perez@panaderia.com', '1987-04-22', GETDATE());
    
   
    COMMIT TRANSACTION;
    PRINT 'Cliente registrado exitosamente.';
END TRY

BEGIN CATCH
    
    ROLLBACK TRANSACTION;
    
    
    PRINT 'Error en la transacción. Se ha revertido la operación de registro de cliente.';
    PRINT ERROR_MESSAGE(); 
END CATCH;

--3)
BEGIN TRANSACTION;  -- Inicia la transacción

BEGIN TRY
   
    UPDATE clientes
    SET telefonoCliente = '555123789', correoCliente = 'carlos.perez@nuevoemail.com'
    WHERE idCliente = 1;
    
   
    COMMIT TRANSACTION;
    PRINT 'Información de contacto actualizada exitosamente.';
END TRY

BEGIN CATCH
   
    ROLLBACK TRANSACTION;
    
   
    PRINT 'Error en la transacción. No se pudo actualizar la información de contacto del cliente.';
    PRINT ERROR_MESSAGE();
END CATCH;

--4)
BEGIN TRANSACTION;  
BEGIN TRY
    
    DELETE FROM clientes
    WHERE idCliente = 2;
    
    
    COMMIT TRANSACTION;
    PRINT 'Cliente eliminado exitosamente.';
END TRY

BEGIN CATCH
   
    ROLLBACK TRANSACTION;
    
    -- Mostrar el mensaje de error
    PRINT 'Error en la transacción. No se pudo eliminar al cliente.';
    PRINT ERROR_MESSAGE();
END CATCH;

--5)
BEGIN TRANSACTION; 

BEGIN TRY
   
    UPDATE clientes
    SET FechaUltimaVisita = GETDATE()
    WHERE idCliente = 1;
    
    
    COMMIT TRANSACTION;
    PRINT 'Fecha de última visita actualizada exitosamente.';
END TRY

BEGIN CATCH
   
    ROLLBACK TRANSACTION;
    
    
    PRINT 'Error en la transacción. No se pudo actualizar la fecha de última visita del cliente.';
    PRINT ERROR_MESSAGE();
END CATCH;

--6)
BEGIN TRANSACTION; 

BEGIN TRY
    
    INSERT INTO clientes (nombreCliente, telefonoCliente, correoCliente, FechaDeNacimiento, FechaUltimaVisita)
    VALUES ('María López', '555987654', 'maria.lopez@panaderia.com', '1990-09-15', GETDATE());
    
    
    COMMIT TRANSACTION;
    PRINT 'Cliente registrado exitosamente y fecha de última visita asignada.';
END TRY

BEGIN CATCH
  
    ROLLBACK TRANSACTION;
    
    
    PRINT 'Error en la transacción. No se pudo registrar el cliente.';
    PRINT ERROR_MESSAGE();
END CATCH;


--7)
BEGIN TRANSACTION;  

BEGIN TRY
    
    UPDATE clientes
    SET nombreCliente = 'Carlos González'
    WHERE idCliente = 1;
    
  
    COMMIT TRANSACTION;
    PRINT 'Nombre del cliente actualizado exitosamente.';
END TRY

BEGIN CATCH
   
    ROLLBACK TRANSACTION;
    
  
    PRINT 'Error en la transacción. No se pudo actualizar el nombre del cliente.';
    PRINT ERROR_MESSAGE();
END CATCH;

--8)
BEGIN TRANSACTION;  
BEGIN TRY
    
    UPDATE clientes
    SET telefonoCliente = '555654321'
    WHERE idCliente = 3;
    
    
    COMMIT TRANSACTION;
    PRINT 'Número de teléfono actualizado exitosamente.';
END TRY

BEGIN CATCH
   
    ROLLBACK TRANSACTION;
    
    
    PRINT 'Error en la transacción. No se pudo actualizar el número de teléfono del cliente.';
    PRINT ERROR_MESSAGE();
END CATCH;


--9)
BEGIN TRANSACTION;  

BEGIN TRY
   
    DECLARE @edad INT;
    SET @edad = DATEDIFF(YEAR, '1995-01-01', GETDATE());  
    
    IF @edad >= 18
    BEGIN
       
        INSERT INTO clientes (nombreCliente, telefonoCliente, correoCliente, FechaDeNacimiento, FechaUltimaVisita)
        VALUES ('Luis Gómez', '555741258', 'luis.gomez@panaderia.com', '1995-01-01', GETDATE());
        
        COMMIT TRANSACTION;
        PRINT 'Cliente registrado exitosamente.';
    END
    ELSE
    BEGIN
       
        ROLLBACK TRANSACTION;
        PRINT 'El cliente no cumple con la edad mínima de 18 años. No se realizó el registro.';
    END
END TRY

BEGIN CATCH
   
    ROLLBACK TRANSACTION;
    
   
    PRINT 'Error en la transacción. No se pudo registrar el cliente.';
    PRINT ERROR_MESSAGE();
END CATCH;
