--NO CYCLE

--1)
-- Crear secuencia para inventarios, no reinicia al alcanzar el valor máximo
create sequence dbo.SecuenciaInventarios
    start with 5000 -- Iniciando el valor en 5000
    increment by 5 -- Incrementando de 5 en 5
    no cycle; -- No reinicia al alcanzar el máximo

-- Crear tabla temporal para evitar conflictos con Identity
create table dbo.InventariosTemp (
    Id_Inventario int primary key,  -- Sin IDENTITY
    Stock int not null,
    Nombre_producto varchar(255) not null,
    Precio decimal(10, 2) not null
);

-- Insertar un nuevo inventario usando la secuencia para el ID de inventario
insert into dbo.InventariosTemp (Id_Inventario, Stock, Nombre_producto, Precio)
values (next value for dbo.SecuenciaInventarios, 100, 'Tarta de Fresa', 15.99);

-- Ver el valor actual de la secuencia
select current_value as ValorActual
from sys.sequences
where name = 'SecuenciaInventarios';

--2)
-- Secuencia para los empleados, sin reiniciar al alcanzar el máximo
create sequence dbo.SecuenciaEmpleados
    start with 100 -- Inicia en 100
    increment by 1 -- Incrementa de 1 en 1
    no cycle; -- No reinicia al alcanzar el máximo

--3)
	-- Secuencia para los clientes, sin reiniciar al alcanzar el máximo
create sequence dbo.SecuenciaClientes
    start with 200 -- Inicia en 200
    increment by 1 -- Incrementa de 1 en 1
    no cycle; -- No reinicia al alcanzar el máximo



--4)
-- Secuencia para las ventas, sin reiniciar al alcanzar el máximo
create sequence dbo.SecuenciaVentas
    start with 1000 -- Inicia en 1000
    increment by 1 -- Incrementa de 1 en 1
    no cycle; -- No reinicia al alcanzar el máximo

--5)
-- Secuencia para productos, sin reiniciar al alcanzar el máximo
create sequence dbo.SecuenciaProductos
    start with 1000 -- Inicia en 1000
    increment by 5 -- Incrementa de 5 en 5
    no cycle; -- No reinicia al alcanzar el máximo


--CON CYCLE

--1)
-- Secuencia para empleados, reinicia al alcanzar el máximo
create sequence dbo.SecuenciaEmpleadosCycle
    start with 1 -- Inicia en 1
    increment by 1 -- Incrementa de 1 en 1
    cycle; -- Reinicia al alcanzar el máximo

--2)
-- Secuencia para clientes, reinicia al alcanzar el máximo
create sequence dbo.SecuenciaClientesCycle
    start with 1 -- Inicia en 1
    increment by 1 -- Incrementa de 1 en 1
    cycle; -- Reinicia al alcanzar el máximo

--3)
-- Secuencia para ventas, reinicia al alcanzar el máximo
create sequence dbo.SecuenciaVentasCycle
    start with 1 -- Inicia en 1
    increment by 1 -- Incrementa de 1 en 1
    cycle; -- Reinicia al alcanzar el máximo

--4)
-- Secuencia para productos, reinicia al alcanzar el máximo
create sequence dbo.SecuenciaProductosCycle
    start with 1000 -- Inicia en 1000
    increment by 10 -- Incrementa de 10 en 10
    cycle; -- Reinicia al alcanzar el máximo

--5)
-- Secuencia para inventarios, reinicia al alcanzar el máximo
create sequence dbo.SecuenciaInventariosCycle
    start with 1 -- Inicia en 1
    increment by 1 -- Incrementa de 1 en 1
    cycle; -- Reinicia al alcanzar el máximo
