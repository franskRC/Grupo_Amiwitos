=====================================================================
-- SIGAF - Carga completa de datos de prueba
-- Requisito: las tablas ya existen y estan VACIAS (esquema con
-- PrecioProveedor y PrecioUnitario/PrecioTotal en OrdenCompra).
-- Contrasena de todos los usuarios: clave123 (solo para pruebas)
-- =====================================================================
USE AbastecimientoFarmaceutico;
GO

-- 1. USUARIOS (codigos 1 al 6)
INSERT INTO Usuario (Nombres, Apellidos, NombreUsuario, Contraseña, Rol) VALUES
(N'Ana',    N'Pérez',   N'aperez',   CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Operador de Almacén'),
(N'Luis',   N'Gómez',   N'lgomez',   CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Responsable de Abastecimiento'),
(N'María',  N'Torres',  N'mtorres',  CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Responsable de Recepción'),
(N'Carlos', N'Ramírez', N'cramirez', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Operador de Almacén'),
(N'Rosa',   N'Quispe',  N'rquispe',  CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Operador de Almacén'),
(N'Jorge',  N'Salazar', N'jsalazar', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Responsable de Recepción');

-- 2. PROVEEDORES (codigos 1 al 5; el 3 esta inactivo)
INSERT INTO Proveedor (Nombre, Telefono, Correo, Estado) VALUES
(N'Farmacéutica Andina S.A.',         N'987654321', N'ventas@farmaceuticaandina.com', N'Activo'),
(N'Distribuidora Médica Lima',        N'912345678', N'contacto@dmlima.com',           N'Activo'),
(N'Insumos Salud E.I.R.L.',           N'965432187', N'info@insumossalud.com',         N'Inactivo'),
(N'Laboratorios del Pacífico S.A.C.', N'944556677', N'ventas@labpacifico.com',        N'Activo'),
(N'Medic Import Perú S.A.',           N'933221144', N'contacto@medicimport.com',      N'Activo');

-- 3. PRODUCTOS (codigos 1 al 16)
INSERT INTO Producto (Nombre, Tipo, UnidadMedida, StockActual, Estado) VALUES
(N'Paracetamol 500 mg',    N'Medicamento', N'Caja',    120, N'Activo'),
(N'Amoxicilina 500 mg',    N'Medicamento', N'Caja',     15, N'Activo'),
(N'Ibuprofeno 400 mg',     N'Medicamento', N'Caja',     60, N'Activo'),
(N'Suero fisiológico 1 L', N'Insumo',      N'Frasco',   30, N'Activo'),
(N'Jeringa 5 ml',          N'Insumo',      N'Unidad',   40, N'Activo'),
(N'Guantes de látex',      N'Insumo',      N'Caja',      8, N'Activo'),
(N'Alcohol 70%',           N'Insumo',      N'Frasco',   25, N'Activo'),
(N'Gasa estéril',          N'Insumo',      N'Paquete',  50, N'Inactivo'),
(N'Omeprazol 20 mg',       N'Medicamento', N'Caja',     45, N'Activo'),
(N'Diclofenaco 50 mg',     N'Medicamento', N'Caja',     35, N'Activo'),
(N'Loratadina 10 mg',      N'Medicamento', N'Caja',     20, N'Activo'),
(N'Metformina 850 mg',     N'Medicamento', N'Caja',     18, N'Activo'),
(N'Salbutamol inhalador',  N'Medicamento', N'Unidad',   12, N'Activo'),
(N'Mascarilla quirúrgica', N'Insumo',      N'Caja',     70, N'Activo'),
(N'Termómetro digital',    N'Insumo',      N'Unidad',   10, N'Activo'),
(N'Algodón hidrófilo',     N'Insumo',      N'Paquete',  22, N'Activo');

-- 4. PRECIOS POR PROVEEDOR (RF11)
-- Un mismo producto tiene precios distintos segun el proveedor.
INSERT INTO PrecioProveedor (CodProducto, CodProveedor, PrecioUnitario) VALUES
(1,  1,  8.50), (1,  2,  9.20),
(2,  1, 15.00), (2,  2, 14.50),
(3,  1, 10.00),
(4,  2,  4.20),
(5,  1,  0.90), (5,  2,  1.10),
(6,  1, 12.00), (6,  2, 11.50),
(7,  2,  3.50),
(9,  2,  6.80), (9,  4,  6.50),
(10, 4,  5.40), (10, 5,  5.60),
(11, 4,  7.20),
(12, 5,  9.90);

-- 5. SOLICITUDES (codigos 1 al 12)
INSERT INTO Solicitud (CodUsuarioSolicitante, CodProducto, CantidadSolicitada, Justificacion, Estado, CodUsuarioEvaluador, FechaEvaluacion, MotivoEvaluacion) VALUES
(1,  1,  50, N'Reposición mensual',                   N'Borrador',                 NULL, NULL,      NULL),
(1,  2,  30, N'Stock bajo el nivel de seguridad',     N'Pendiente de evaluación',  NULL, NULL,      NULL),
(1,  3,  40, N'Aumento de consumo',                   N'Devuelta para corrección', 2,    GETDATE(), N'Falta indicar la cantidad correcta'),
(4,  4,  20, N'Reposición',                           N'Rechazada',                2,    GETDATE(), N'Stock suficiente por ahora'),
(1,  5, 200, N'Stock casi agotado',                   N'Autorizada',               2,    GETDATE(), NULL),
(4,  6,  50, N'Necesario para el área de curaciones', N'Autorizada',               2,    GETDATE(), NULL),
(1, 11,  80, N'Aumento de pacientes alérgicos',       N'Pendiente de evaluación',  NULL, NULL,      NULL),
(5, 12,  25, N'Stock bajo para pacientes crónicos',   N'Pendiente de evaluación',  NULL, NULL,      NULL),
(1,  9, 100, N'Reposición trimestral',                N'Autorizada',               2,    GETDATE(), NULL),
(5, 10,  60, N'Alta demanda en consulta externa',     N'Autorizada',               2,    GETDATE(), NULL),
(4, 13,  15, N'Solicitud duplicada',                  N'Rechazada',                2,    GETDATE(), N'Ya existe una solicitud similar en curso'),
(4, 14,  35, N'Reposición de insumos de enfermería',  N'Borrador',                 NULL, NULL,      NULL);

-- 6. ORDENES DE COMPRA (codigos 1 al 3)
-- PrecioTotal es columna calculada: no se inserta.
-- Orden 1: 200 x 0.90 = 180.00 | Orden 2: 100 x 6.80 = 680.00 | Orden 3: 60 x 5.40 = 324.00
INSERT INTO OrdenCompra (CodSolicitud, CodProveedor, CodUsuarioEmisor, CantidadPedida, PrecioUnitario, Estado, Observaciones) VALUES
(5,  1, 2, 200, 0.90, N'Recibida parcial',  N'Entrega en dos partes'),
(9,  2, 2, 100, 6.80, N'Recibida completa', N'Entrega única'),
(10, 4, 2,  60, 5.40, N'Recibida completa', N'Entrega con unidades en exceso');

-- 7. RECEPCIONES (codigos 1 al 3), ya confirmadas
INSERT INTO Recepcion (CodOrden, CodUsuarioReceptor, CantidadRecibida, CantidadAceptada, CantidadRechazada, MotivoRechazo, Observaciones, Estado) VALUES
(1, 3, 120, 110, 10, N'Dañado', N'10 unidades con empaque roto',                 N'Confirmada'),
(2, 3, 100, 100,  0, NULL,      N'Entrega completa y conforme',                  N'Confirmada'),
(3, 6,  70,  60, 10, N'Exceso', N'Llegaron 10 unidades más de las solicitadas',  N'Confirmada');

-- 8. STOCK: solo se suman las cantidades aceptadas
UPDATE Producto SET StockActual = StockActual + 110 WHERE CodProducto = 5;
UPDATE Producto SET StockActual = StockActual + 100 WHERE CodProducto = 9;
UPDATE Producto SET StockActual = StockActual + 60  WHERE CodProducto = 10;

-- 9. HISTORIAL
INSERT INTO Historial (CodUsuario, TipoOperacion, ElementoAfectado, CodElemento, Descripcion, Motivo) VALUES
(1, N'Creación',     N'Solicitud',       5,  N'Solicitud de abastecimiento registrada', NULL),
(2, N'Autorización', N'Solicitud',       5,  N'Solicitud autorizada', NULL),
(2, N'Emisión',      N'Orden de Compra', 1,  N'Orden de compra emitida al proveedor Farmacéutica Andina S.A.', NULL),
(3, N'Recepción',    N'Recepción',       1,  N'Recepción parcial registrada', N'10 unidades dañadas'),
(1, N'Creación',     N'Solicitud',       9,  N'Solicitud de abastecimiento registrada', NULL),
(2, N'Autorización', N'Solicitud',       9,  N'Solicitud autorizada', NULL),
(2, N'Emisión',      N'Orden de Compra', 2,  N'Orden de compra emitida al proveedor Distribuidora Médica Lima', NULL),
(3, N'Recepción',    N'Recepción',       2,  N'Recepción completa registrada', NULL),
(5, N'Creación',     N'Solicitud',       10, N'Solicitud de abastecimiento registrada', NULL),
(2, N'Autorización', N'Solicitud',       10, N'Solicitud autorizada', NULL),
(2, N'Emisión',      N'Orden de Compra', 3,  N'Orden de compra emitida al proveedor Laboratorios del Pacífico S.A.C.', NULL),
(6, N'Recepción',    N'Recepción',       3,  N'Recepción con exceso: excedente rechazado', N'10 unidades en exceso'),
(2, N'Rechazo',      N'Solicitud',       11, N'Solicitud rechazada', N'Ya existe una solicitud similar en curso');
GO

-- 10. TRIGGER: el historial no se puede modificar ni eliminar (RNF03)
-- Va al final para no estorbar a los INSERT anteriores.
IF OBJECT_ID(N'TR_Historial_SoloInsercion', N'TR') IS NULL
    EXEC(N'CREATE TRIGGER TR_Historial_SoloInsercion
           ON Historial
           INSTEAD OF UPDATE, DELETE
           AS
           BEGIN
               RAISERROR (N''El historial no puede modificarse ni eliminarse.'', 16, 1);
           END');
GO

-- 11. VERIFICACION (resultados esperados)
SELECT CodOrden, CantidadPedida, PrecioUnitario, PrecioTotal FROM OrdenCompra;
-- Esperado: 180.00 | 680.00 | 324.00
SELECT CodProducto, Nombre, StockActual FROM Producto WHERE CodProducto IN (5, 9, 10);
-- Esperado: Jeringa 150 | Omeprazol 145 | Diclofenaco 95
GO