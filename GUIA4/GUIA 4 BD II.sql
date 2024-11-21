--1) 
CREATE VIEW VistaEmpleados AS
SELECT e.idEmpleado, 
       e.nombresEmpleado, 
       e.apellidosEmpleado, 
       e.telefonoEmpleado, 
       e.correoEmpleado, 
       e.fechaNacEmpleado, 
       e.duiEmpleado, 
       e.isssEmpleado, 
       c.idCargo
FROM empleados e
INNER JOIN cargos c ON e.idCargo = c.idCargo;  -- Relaciona empleados con su cargo

SELECT * FROM VistaEmpleados;

--2)
CREATE VIEW VistaEmpleadosConDireccion AS
SELECT e.idEmpleado, 
       e.nombresEmpleado, 
       e.apellidosEmpleado, 
       e.telefonoEmpleado, 
       e.correoEmpleado, 
       e.fechaNacEmpleado, 
       e.duiEmpleado, 
       e.isssEmpleado, 
       d.idDireccion, 
       d.idDistrito, 
       d.codigoPostal
FROM empleados e
INNER JOIN direcciones d ON e.idDireccion = d.idDireccion;  -- Relaciona empleados con su dirección


SELECT * FROM VistaEmpleadosConDireccion;

--3)
CREATE VIEW VistaEmpleadosConCargoAntesDe1995 AS
SELECT e.idEmpleado, 
       e.nombresEmpleado, 
       e.apellidosEmpleado, 
       e.telefonoEmpleado, 
       e.correoEmpleado, 
       c.idCargo, 
       e.fechaNacEmpleado
FROM empleados e
INNER JOIN cargos c ON e.idCargo = c.idCargo
WHERE e.fechaNacEmpleado < '1995-01-01';  -- Filtra empleados nacidos antes de 1995

select * from VistaEmpleadosConCargoAntesDe1995;

--4)
CREATE VIEW VistaEmpleadosConCargoYDireccion AS
SELECT e.idEmpleado, 
       e.nombresEmpleado, 
       e.apellidosEmpleado, 
       e.telefonoEmpleado, 
       e.correoEmpleado, 
       c.idCargo, 
       d.idDireccion, 
       d.codigoPostal, 
       d.linea1
FROM empleados e
INNER JOIN cargos c ON e.idCargo = c.idCargo
INNER JOIN direcciones d ON e.idDireccion = d.idDireccion;  -- Relaciona empleados con su cargo y dirección

select * from VistaEmpleadosConCargoYDireccion;

--5)
CREATE VIEW Vw_ProductosFinalConMenuYStock AS
SELECT p.idProductoFinal, 
       p.nombreProducto, 
       p.stockCritico, 
       p.precioProducto, 
       p.fechaCaducidad, 
       p.descripcionProducto, 
       m.nombreMenu, 
       i.stockActual
FROM productosFinal p
LEFT JOIN menus m ON p.idMenu = m.idMenu  -- Relaciona productosFinal con menús
LEFT JOIN inventarios i ON p.idInventario = i.idInventario  -- Relaciona productosFinal con inventarios
WHERE i.stockActual > 0;  -- Filtra solo productos con stock disponible

select * from Vw_ProductosFinalConMenuYStock ;

--6)
CREATE VIEW VistaProductosFinalConMenuInventarioYPrecio AS
SELECT p.idProductoFinal, 
       p.nombreProducto, 
       p.precioProducto, 
       p.descripcionProducto, 
       m.nombreMenu, 
       i.stockActual
FROM productosFinal p
RIGHT JOIN menus m ON p.idMenu = m.idMenu  -- Relaciona productosFinal con menús
RIGHT JOIN inventarios i ON p.idInventario = i.idInventario;  -- Relaciona productosFinal con inventarios

--7)
CREATE VIEW VistaProductosFinalConDescripcionStockYCaducidad AS
SELECT p.idProductoFinal, 
       p.nombreProducto, 
       p.descripcionProducto, 
       p.precioProducto, 
       p.fechaCaducidad, 
       i.stockActual
FROM productosFinal p
LEFT JOIN inventarios i ON p.idInventario = i.idInventario  -- Relaciona productosFinal con inventarios
LEFT JOIN menus m ON p.idMenu = m.idMenu;  -- Relaciona productosFinal con menús

--8)
CREATE VIEW VistaMenuConProductosYInventario AS
SELECT m.idMenu, 
       m.nombreMenu, 
       m.descripcion, 
       p.nombreProducto, 
       p.precioProducto, 
       i.stockActual
FROM menus m
INNER JOIN productosFinal p ON m.idMenu = p.idMenu  -- Relaciona menús con productosFinal
INNER JOIN inventarios i ON p.idInventario = i.idInventario;  -- Relaciona productosFinal con inventarios

--9)
CREATE VIEW VistaMenuConProductosYPrecio AS
SELECT m.idMenu, 
       m.nombreMenu, 
       m.descripcion, 
       p.nombreProducto, 
       p.precioProducto
FROM menus m
LEFT JOIN productosFinal p ON m.idMenu = p.idMenu  -- Relaciona menús con productosFinal
LEFT JOIN inventarios i ON p.idInventario = i.idInventario;  -- Relaciona productosFinal con inventarios

--10)
CREATE VIEW VistaMenuConProductosYCaducidad AS
SELECT m.idMenu, 
       m.nombreMenu, 
       m.descripcion, 
       p.nombreProducto, 
       p.fechaCaducidad
FROM menus m
INNER JOIN productosFinal p ON m.idMenu = p.idMenu  -- Relaciona menús con productosFinal
INNER JOIN inventarios i ON p.idInventario = i.idInventario;  -- Relaciona productosFinal con inventarios

--11)

CREATE VIEW VistaIngredientesConCategoriaYPrecio AS
SELECT i.idIngrediente, 
       i.nombreIngrediente, 
       i.precioUnitario, 
       i.descripcionIngrediente, 
       c.idCategoria
FROM ingredientes i
LEFT JOIN categorias c ON i.idCategoria = c.idCategoria  -- Relaciona ingredientes con categorías
LEFT JOIN inventarios inv ON i.idInventario = inv.idInventario;  -- Relaciona ingredientes con inventarios

--12)
CREATE VIEW VistaRecetasConProductosYIngredientes AS
SELECT r.idReceta, 
       r.nombreReceta, 
       pf.nombreProducto, 
       i.nombreIngrediente, 
       r.cantidadIngrediente
FROM recetas r
INNER JOIN productosFinal pf ON r.idProductoFinal = pf.idProductoFinal  -- Relaciona recetas con productosFinal
INNER JOIN ingredientes i ON r.idIngrediente = i.idIngrediente;  -- Relaciona recetas con ingredientes


--13)
CREATE VIEW VistaRecetasConIngredientesYCategoria AS
SELECT r.idReceta, 
       r.nombreReceta, 
       i.nombreIngrediente, 
       c.Categoria, 
       r.cantidadIngrediente
FROM recetas r
LEFT JOIN ingredientes i ON r.idIngrediente = i.idIngrediente  -- Relaciona recetas con ingredientes
LEFT JOIN categorias c ON i.idCategoria = c.idCategoria;  -- Relaciona ingredientes con categorías

--14)
CREATE VIEW VistaRecetasConProductosYPrecio AS
SELECT r.idReceta, 
       r.nombreReceta, 
       pf.nombreProducto, 
       pf.precioProducto, 
       r.cantidadIngrediente
FROM recetas r
LEFT JOIN productosFinal pf ON r.idProductoFinal = pf.idProductoFinal  -- Relaciona recetas con productosFinal
LEFT JOIN ingredientes i ON r.idIngrediente = i.idIngrediente;  -- Relaciona recetas con ingredientes

--15)

CREATE VIEW VistaRecetasConProductosYCategorias AS
SELECT r.idReceta, 
       r.nombreReceta, 
       pf.nombreProducto, 
       c.idCategoria
FROM recetas r
RIGHT JOIN productosFinal pf ON r.idProductoFinal = pf.idProductoFinal  -- Relaciona recetas con productosFinal
LEFT JOIN categorias c ON r.idIngrediente = c.idCategoria;  -- Relaciona recetas con categorías
