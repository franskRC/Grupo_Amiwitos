/* =====================================================================
   SIGAF - AbastecimientoFarmaceutico: BASE DE DATOS ACTUALIZADA (un solo script)
   Ejecutar completo sobre un servidor SQL Server (recomendado: base nueva).
     Parte 1: esquema original (13 tablas base)
     Parte 2: migracion (Lote/Ingreso/Salida/Ajuste/Inventario, vistas, triggers)
     Parte 3: datos de prueba (usuarios con clave: clave123)
   ===================================================================== */
IF DB_ID(N'AbastecimientoFarmaceutico') IS NULL
    CREATE DATABASE [AbastecimientoFarmaceutico];
GO

/* ############################ PARTE 1: ESQUEMA ############################ */
USE [AbastecimientoFarmaceutico]
GO
/****** Object:  Table [dbo].[Historial]    Script Date: 21/10/2026 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Historial](
	[CodHistorial] [int] IDENTITY(1,1) NOT NULL,
	[CodUsuario] [int] NOT NULL,
	[FechaHora] [datetime] NOT NULL,
	[TipoOperacion] [nvarchar](30) NOT NULL,
	[ElementoAfectado] [nvarchar](20) NOT NULL,
	[CodElemento] [int] NOT NULL,
	[Descripcion] [nvarchar](255) NOT NULL,
	[Motivo] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodHistorial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenCompra]    Script Date: 21/10/2026 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenCompra](
	[CodOrden] [int] IDENTITY(1,1) NOT NULL,
	[CodSolicitud] [int] NOT NULL,
	[CodProveedor] [int] NOT NULL,
	[CodUsuarioEmisor] [int] NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[CantidadPedida] [decimal](10, 2) NOT NULL,
	[Estado] [nvarchar](20) NOT NULL,
	[Observaciones] [nvarchar](255) NULL,
	[PrecioUnitario] [decimal](10, 2) NOT NULL,
	[PrecioTotal]  AS ([PrecioUnitario]*[CantidadPedida]) PERSISTED,
PRIMARY KEY CLUSTERED 
(
	[CodOrden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Orden_Solicitud] UNIQUE NONCLUSTERED 
(
	[CodSolicitud] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrecioProveedor]    Script Date: 21/10/2026 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrecioProveedor](
	[CodPrecio] [int] IDENTITY(1,1) NOT NULL,
	[CodProducto] [int] NOT NULL,
	[CodProveedor] [int] NOT NULL,
	[PrecioUnitario] [decimal](10, 2) NOT NULL,
	[FechaActualizacion] [datetime] NOT NULL,
	[Estado] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPrecio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Precio_ProductoProveedor] UNIQUE NONCLUSTERED 
(
	[CodProducto] ASC,
	[CodProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 21/10/2026 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[CodProducto] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Tipo] [nvarchar](15) NOT NULL,
	[UnidadMedida] [nvarchar](20) NOT NULL,
	[StockActual] [decimal](10, 2) NOT NULL,
	[Estado] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedor]    Script Date: 21/10/2026 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedor](
	[CodProveedor] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Telefono] [nvarchar](20) NULL,
	[Correo] [nvarchar](100) NULL,
	[Estado] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recepcion]    Script Date: 21/10/2026 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recepcion](
	[CodRecepcion] [int] IDENTITY(1,1) NOT NULL,
	[CodOrden] [int] NOT NULL,
	[FechaRecepcion] [datetime] NOT NULL,
	[CodUsuarioReceptor] [int] NOT NULL,
	[CantidadRecibida] [decimal](10, 2) NOT NULL,
	[CantidadAceptada] [decimal](10, 2) NOT NULL,
	[CantidadRechazada] [decimal](10, 2) NOT NULL,
	[MotivoRechazo] [nvarchar](20) NULL,
	[Observaciones] [nvarchar](255) NULL,
	[Estado] [nvarchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodRecepcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Solicitud]    Script Date: 21/10/2026 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Solicitud](
	[CodSolicitud] [int] IDENTITY(1,1) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
	[CodUsuarioSolicitante] [int] NOT NULL,
	[CodProducto] [int] NOT NULL,
	[CantidadSolicitada] [decimal](10, 2) NOT NULL,
	[Justificacion] [nvarchar](255) NOT NULL,
	[Estado] [nvarchar](30) NOT NULL,
	[CodUsuarioEvaluador] [int] NULL,
	[FechaEvaluacion] [datetime] NULL,
	[MotivoEvaluacion] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodSolicitud] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 21/10/2026 22:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[CodUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Nombres] [nvarchar](80) NOT NULL,
	[Apellidos] [nvarchar](80) NOT NULL,
	[NombreUsuario] [nvarchar](40) NOT NULL,
	[Contraseña] [nvarchar](255) NOT NULL,
	[Rol] [nvarchar](40) NOT NULL,
	[Estado] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Usuario_NombreUsuario] UNIQUE NONCLUSTERED 
(
	[NombreUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Historial] ADD  DEFAULT (getdate()) FOR [FechaHora]
GO
ALTER TABLE [dbo].[OrdenCompra] ADD  DEFAULT (getdate()) FOR [FechaEmision]
GO
ALTER TABLE [dbo].[OrdenCompra] ADD  DEFAULT (N'Emitida') FOR [Estado]
GO
ALTER TABLE [dbo].[PrecioProveedor] ADD  DEFAULT (getdate()) FOR [FechaActualizacion]
GO
ALTER TABLE [dbo].[PrecioProveedor] ADD  DEFAULT (N'Activo') FOR [Estado]
GO
ALTER TABLE [dbo].[Producto] ADD  DEFAULT ((0)) FOR [StockActual]
GO
ALTER TABLE [dbo].[Producto] ADD  DEFAULT (N'Activo') FOR [Estado]
GO
ALTER TABLE [dbo].[Proveedor] ADD  DEFAULT (N'Activo') FOR [Estado]
GO
ALTER TABLE [dbo].[Recepcion] ADD  DEFAULT (getdate()) FOR [FechaRecepcion]
GO
ALTER TABLE [dbo].[Recepcion] ADD  DEFAULT ((0)) FOR [CantidadRechazada]
GO
ALTER TABLE [dbo].[Recepcion] ADD  DEFAULT (N'Registrada') FOR [Estado]
GO
ALTER TABLE [dbo].[Solicitud] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Solicitud] ADD  DEFAULT (N'Borrador') FOR [Estado]
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT (N'Activo') FOR [Estado]
GO
ALTER TABLE [dbo].[Historial]  WITH CHECK ADD  CONSTRAINT [FK_Historial_Usuario] FOREIGN KEY([CodUsuario])
REFERENCES [dbo].[Usuario] ([CodUsuario])
GO
ALTER TABLE [dbo].[Historial] CHECK CONSTRAINT [FK_Historial_Usuario]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_Orden_Emisor] FOREIGN KEY([CodUsuarioEmisor])
REFERENCES [dbo].[Usuario] ([CodUsuario])
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [FK_Orden_Emisor]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_Orden_Proveedor] FOREIGN KEY([CodProveedor])
REFERENCES [dbo].[Proveedor] ([CodProveedor])
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [FK_Orden_Proveedor]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_Orden_Solicitud] FOREIGN KEY([CodSolicitud])
REFERENCES [dbo].[Solicitud] ([CodSolicitud])
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [FK_Orden_Solicitud]
GO
ALTER TABLE [dbo].[PrecioProveedor]  WITH CHECK ADD  CONSTRAINT [FK_Precio_Producto] FOREIGN KEY([CodProducto])
REFERENCES [dbo].[Producto] ([CodProducto])
GO
ALTER TABLE [dbo].[PrecioProveedor] CHECK CONSTRAINT [FK_Precio_Producto]
GO
ALTER TABLE [dbo].[PrecioProveedor]  WITH CHECK ADD  CONSTRAINT [FK_Precio_Proveedor] FOREIGN KEY([CodProveedor])
REFERENCES [dbo].[Proveedor] ([CodProveedor])
GO
ALTER TABLE [dbo].[PrecioProveedor] CHECK CONSTRAINT [FK_Precio_Proveedor]
GO
ALTER TABLE [dbo].[Recepcion]  WITH CHECK ADD  CONSTRAINT [FK_Recepcion_Orden] FOREIGN KEY([CodOrden])
REFERENCES [dbo].[OrdenCompra] ([CodOrden])
GO
ALTER TABLE [dbo].[Recepcion] CHECK CONSTRAINT [FK_Recepcion_Orden]
GO
ALTER TABLE [dbo].[Recepcion]  WITH CHECK ADD  CONSTRAINT [FK_Recepcion_Receptor] FOREIGN KEY([CodUsuarioReceptor])
REFERENCES [dbo].[Usuario] ([CodUsuario])
GO
ALTER TABLE [dbo].[Recepcion] CHECK CONSTRAINT [FK_Recepcion_Receptor]
GO
ALTER TABLE [dbo].[Solicitud]  WITH CHECK ADD  CONSTRAINT [FK_Solicitud_Evaluador] FOREIGN KEY([CodUsuarioEvaluador])
REFERENCES [dbo].[Usuario] ([CodUsuario])
GO
ALTER TABLE [dbo].[Solicitud] CHECK CONSTRAINT [FK_Solicitud_Evaluador]
GO
ALTER TABLE [dbo].[Solicitud]  WITH CHECK ADD  CONSTRAINT [FK_Solicitud_Producto] FOREIGN KEY([CodProducto])
REFERENCES [dbo].[Producto] ([CodProducto])
GO
ALTER TABLE [dbo].[Solicitud] CHECK CONSTRAINT [FK_Solicitud_Producto]
GO
ALTER TABLE [dbo].[Solicitud]  WITH CHECK ADD  CONSTRAINT [FK_Solicitud_Solicitante] FOREIGN KEY([CodUsuarioSolicitante])
REFERENCES [dbo].[Usuario] ([CodUsuario])
GO
ALTER TABLE [dbo].[Solicitud] CHECK CONSTRAINT [FK_Solicitud_Solicitante]
GO
ALTER TABLE [dbo].[Historial]  WITH CHECK ADD  CONSTRAINT [CK_Historial_Elemento] CHECK  (([ElementoAfectado]=N'Recepción' OR [ElementoAfectado]=N'Orden de Compra' OR [ElementoAfectado]=N'Solicitud'))
GO
ALTER TABLE [dbo].[Historial] CHECK CONSTRAINT [CK_Historial_Elemento]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [CK_Orden_Cantidad] CHECK  (([CantidadPedida]>(0)))
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [CK_Orden_Cantidad]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [CK_Orden_Estado] CHECK  (([Estado]=N'Cerrada' OR [Estado]=N'Recibida completa' OR [Estado]=N'Recibida parcial' OR [Estado]=N'Emitida'))
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [CK_Orden_Estado]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [CK_Orden_Precio] CHECK  (([PrecioUnitario]>(0)))
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [CK_Orden_Precio]
GO
ALTER TABLE [dbo].[PrecioProveedor]  WITH CHECK ADD  CONSTRAINT [CK_Precio_Estado] CHECK  (([Estado]=N'Inactivo' OR [Estado]=N'Activo'))
GO
ALTER TABLE [dbo].[PrecioProveedor] CHECK CONSTRAINT [CK_Precio_Estado]
GO
ALTER TABLE [dbo].[PrecioProveedor]  WITH CHECK ADD  CONSTRAINT [CK_Precio_Valor] CHECK  (([PrecioUnitario]>(0)))
GO
ALTER TABLE [dbo].[PrecioProveedor] CHECK CONSTRAINT [CK_Precio_Valor]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [CK_Producto_Estado] CHECK  (([Estado]=N'Inactivo' OR [Estado]=N'Activo'))
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [CK_Producto_Estado]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [CK_Producto_Stock] CHECK  (([StockActual]>=(0)))
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [CK_Producto_Stock]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [CK_Producto_Tipo] CHECK  (([Tipo]=N'Insumo' OR [Tipo]=N'Medicamento'))
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [CK_Producto_Tipo]
GO
ALTER TABLE [dbo].[Proveedor]  WITH CHECK ADD  CONSTRAINT [CK_Proveedor_Estado] CHECK  (([Estado]=N'Inactivo' OR [Estado]=N'Activo'))
GO
ALTER TABLE [dbo].[Proveedor] CHECK CONSTRAINT [CK_Proveedor_Estado]
GO
ALTER TABLE [dbo].[Recepcion]  WITH CHECK ADD  CONSTRAINT [CK_Recepcion_Cantidades] CHECK  (([CantidadRecibida]>=(0) AND [CantidadAceptada]>=(0) AND [CantidadRechazada]>=(0) AND ([CantidadAceptada]+[CantidadRechazada])=[CantidadRecibida]))
GO
ALTER TABLE [dbo].[Recepcion] CHECK CONSTRAINT [CK_Recepcion_Cantidades]
GO
ALTER TABLE [dbo].[Recepcion]  WITH CHECK ADD  CONSTRAINT [CK_Recepcion_Estado] CHECK  (([Estado]=N'Confirmada' OR [Estado]=N'Registrada'))
GO
ALTER TABLE [dbo].[Recepcion] CHECK CONSTRAINT [CK_Recepcion_Estado]
GO
ALTER TABLE [dbo].[Recepcion]  WITH CHECK ADD  CONSTRAINT [CK_Recepcion_Motivo] CHECK  (([MotivoRechazo] IS NULL OR ([MotivoRechazo]=N'Otro' OR [MotivoRechazo]=N'Exceso' OR [MotivoRechazo]=N'Incorrecto' OR [MotivoRechazo]=N'Dañado')))
GO
ALTER TABLE [dbo].[Recepcion] CHECK CONSTRAINT [CK_Recepcion_Motivo]
GO
ALTER TABLE [dbo].[Recepcion]  WITH CHECK ADD  CONSTRAINT [CK_Recepcion_MotivoObligatorio] CHECK  (([CantidadRechazada]=(0) OR [MotivoRechazo] IS NOT NULL))
GO
ALTER TABLE [dbo].[Recepcion] CHECK CONSTRAINT [CK_Recepcion_MotivoObligatorio]
GO
ALTER TABLE [dbo].[Solicitud]  WITH CHECK ADD  CONSTRAINT [CK_Solicitud_Cantidad] CHECK  (([CantidadSolicitada]>(0)))
GO
ALTER TABLE [dbo].[Solicitud] CHECK CONSTRAINT [CK_Solicitud_Cantidad]
GO
ALTER TABLE [dbo].[Solicitud]  WITH CHECK ADD  CONSTRAINT [CK_Solicitud_Estado] CHECK  (([Estado]=N'Rechazada' OR [Estado]=N'Autorizada' OR [Estado]=N'Devuelta para corrección' OR [Estado]=N'Pendiente de evaluación' OR [Estado]=N'Borrador'))
GO
ALTER TABLE [dbo].[Solicitud] CHECK CONSTRAINT [CK_Solicitud_Estado]
GO
ALTER TABLE [dbo].[Solicitud]  WITH CHECK ADD  CONSTRAINT [CK_Solicitud_Motivo] CHECK  ((NOT ([Estado]=N'Devuelta para corrección' OR [Estado]=N'Rechazada') OR [MotivoEvaluacion] IS NOT NULL))
GO
ALTER TABLE [dbo].[Solicitud] CHECK CONSTRAINT [CK_Solicitud_Motivo]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [CK_Usuario_Estado] CHECK  (([Estado]=N'Inactivo' OR [Estado]=N'Activo'))
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [CK_Usuario_Estado]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [CK_Usuario_Rol] CHECK  (([Rol]=N'Responsable de Recepción' OR [Rol]=N'Responsable de Abastecimiento' OR [Rol]=N'Operador de Almacén'))
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [CK_Usuario_Rol]
GO
GO

/* ############################ PARTE 2: MIGRACION ########################## */
/* =====================================================================
   MIGRACIÓN: AbastecimientoFarmaceutico
   Orden: 1) modificar tablas  2) crear tablas  3) vistas  4) triggers
   Ejecutar sobre la BD creada con bdfarma.sql
   ===================================================================== */
USE [AbastecimientoFarmaceutico]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/* =====================================================================
   1. MODIFICACIÓN DE TABLAS EXISTENTES
   ===================================================================== */

/* ---- 1.1 Usuario: agregar rol Administrador ---- */
ALTER TABLE dbo.Usuario DROP CONSTRAINT CK_Usuario_Rol;
ALTER TABLE dbo.Usuario ADD CONSTRAINT CK_Usuario_Rol CHECK (Rol IN
    (N'Administrador', N'Operador de Almacén',
     N'Responsable de Abastecimiento', N'Responsable de Recepción'));
GO

/* ---- 1.2 Producto: eliminar StockActual (el stock ahora se calcula) ----
   OJO: si la BD ya tuviera stock cargado, primero hay que pasarlo a
   Lote + Ingreso; al borrar la columna ese dato se pierde. */
DECLARE @df sysname;
SELECT @df = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c ON c.object_id = dc.parent_object_id
                  AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID(N'dbo.Producto') AND c.name = N'StockActual';
IF @df IS NOT NULL EXEC(N'ALTER TABLE dbo.Producto DROP CONSTRAINT ' + @df);

IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_Producto_Stock')
    ALTER TABLE dbo.Producto DROP CONSTRAINT CK_Producto_Stock;

ALTER TABLE dbo.Producto DROP COLUMN StockActual;
GO

/* ---- 1.3 Recepcion: Lote y FechaVencimiento ----
   Se crean NULL para no romper filas antiguas; el CHECK WITH NOCHECK
   obliga a que toda recepción NUEVA (insert/update) los traiga. */
ALTER TABLE dbo.Recepcion ADD
    Lote             nvarchar(30) NULL,
    FechaVencimiento date         NULL;
GO
ALTER TABLE dbo.Recepcion WITH NOCHECK ADD CONSTRAINT CK_Recepcion_LoteObligatorio
    CHECK (Lote IS NOT NULL AND LEN(LTRIM(RTRIM(Lote))) > 0 AND FechaVencimiento IS NOT NULL);
GO

/* ---- 1.4 Historial: ampliar ElementoAfectado ----
   TipoOperacion NO tiene CHECK en tu script, así que queda libre
   (Registro, Generación, Desactivación, Modificación, etc.). */
ALTER TABLE dbo.Historial DROP CONSTRAINT CK_Historial_Elemento;
ALTER TABLE dbo.Historial ADD CONSTRAINT CK_Historial_Elemento CHECK (ElementoAfectado IN
    (N'Solicitud', N'Orden de Compra', N'Recepción', N'Ingreso', N'Salida',
     N'Ajuste', N'Inventario', N'Usuario', N'Producto', N'Precio'));
GO

/* ---- 1.5 Cantidades a int (las unidades son discretas: caja, frasco, unidad...)
   Igual que en el diagrama de clases. Hay que soltar y recrear las
   restricciones/defaults que usan cada columna, y la columna calculada
   PrecioTotal. Si ya hubiera cantidades con decimales, se truncarían. */

-- Solicitud
ALTER TABLE dbo.Solicitud DROP CONSTRAINT CK_Solicitud_Cantidad;
GO
ALTER TABLE dbo.Solicitud ALTER COLUMN CantidadSolicitada int NOT NULL;
GO
ALTER TABLE dbo.Solicitud ADD CONSTRAINT CK_Solicitud_Cantidad CHECK (CantidadSolicitada > 0);
GO

-- OrdenCompra (PrecioTotal depende de CantidadPedida: se recrea igual)
ALTER TABLE dbo.OrdenCompra DROP CONSTRAINT CK_Orden_Cantidad;
ALTER TABLE dbo.OrdenCompra DROP COLUMN PrecioTotal;
GO
ALTER TABLE dbo.OrdenCompra ALTER COLUMN CantidadPedida int NOT NULL;
GO
ALTER TABLE dbo.OrdenCompra ADD CONSTRAINT CK_Orden_Cantidad CHECK (CantidadPedida > 0);
ALTER TABLE dbo.OrdenCompra ADD PrecioTotal AS (PrecioUnitario * CantidadPedida) PERSISTED;
GO

-- Recepcion (default sin nombre en CantidadRechazada: se busca dinámicamente)
DECLARE @df sysname;
SELECT @df = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c ON c.object_id = dc.parent_object_id
                  AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID(N'dbo.Recepcion') AND c.name = N'CantidadRechazada';
IF @df IS NOT NULL EXEC(N'ALTER TABLE dbo.Recepcion DROP CONSTRAINT ' + @df);
ALTER TABLE dbo.Recepcion DROP CONSTRAINT CK_Recepcion_Cantidades;
ALTER TABLE dbo.Recepcion DROP CONSTRAINT CK_Recepcion_MotivoObligatorio;
GO
ALTER TABLE dbo.Recepcion ALTER COLUMN CantidadRecibida  int NOT NULL;
ALTER TABLE dbo.Recepcion ALTER COLUMN CantidadAceptada  int NOT NULL;
ALTER TABLE dbo.Recepcion ALTER COLUMN CantidadRechazada int NOT NULL;
GO
ALTER TABLE dbo.Recepcion ADD CONSTRAINT DF_Recepcion_CantidadRechazada DEFAULT (0) FOR CantidadRechazada;
ALTER TABLE dbo.Recepcion ADD CONSTRAINT CK_Recepcion_Cantidades CHECK
    (CantidadRecibida >= 0 AND CantidadAceptada >= 0 AND CantidadRechazada >= 0
     AND (CantidadAceptada + CantidadRechazada) = CantidadRecibida);
ALTER TABLE dbo.Recepcion ADD CONSTRAINT CK_Recepcion_MotivoObligatorio CHECK
    (CantidadRechazada = 0 OR MotivoRechazo IS NOT NULL);
GO

/* =====================================================================
   2. TABLAS NUEVAS
   ===================================================================== */

/* ---- Lote ---- */
CREATE TABLE dbo.Lote(
    CodLote          int IDENTITY(1,1) NOT NULL,
    CodProducto      int           NOT NULL,
    NumeroLote       nvarchar(30)  NOT NULL,
    FechaVencimiento date          NOT NULL,
    CONSTRAINT PK_Lote PRIMARY KEY CLUSTERED (CodLote),
    CONSTRAINT FK_Lote_Producto FOREIGN KEY (CodProducto) REFERENCES dbo.Producto(CodProducto),
    CONSTRAINT UQ_Lote_ProductoNumero UNIQUE (CodProducto, NumeroLote),
    CONSTRAINT CK_Lote_Numero CHECK (LEN(LTRIM(RTRIM(NumeroLote))) > 0)
);
GO

/* ---- Ingreso ---- */
CREATE TABLE dbo.Ingreso(
    CodIngreso    int IDENTITY(1,1) NOT NULL,
    CodLote       int            NOT NULL,
    CodProveedor  int            NOT NULL,
    CodUsuario    int            NOT NULL,
    CodRecepcion  int            NULL,      -- NULL = ingreso manual
    FechaIngreso  datetime       NOT NULL CONSTRAINT DF_Ingreso_Fecha DEFAULT (getdate()),
    Cantidad      int            NOT NULL,
    PrecioCompra  decimal(10,2)  NOT NULL,
    Observaciones nvarchar(255)  NULL,
    CONSTRAINT PK_Ingreso PRIMARY KEY CLUSTERED (CodIngreso),
    CONSTRAINT FK_Ingreso_Lote       FOREIGN KEY (CodLote)      REFERENCES dbo.Lote(CodLote),
    CONSTRAINT FK_Ingreso_Proveedor  FOREIGN KEY (CodProveedor) REFERENCES dbo.Proveedor(CodProveedor),
    CONSTRAINT FK_Ingreso_Usuario    FOREIGN KEY (CodUsuario)   REFERENCES dbo.Usuario(CodUsuario),
    CONSTRAINT FK_Ingreso_Recepcion  FOREIGN KEY (CodRecepcion) REFERENCES dbo.Recepcion(CodRecepcion),
    CONSTRAINT CK_Ingreso_Cantidad   CHECK (Cantidad > 0),
    CONSTRAINT CK_Ingreso_Precio     CHECK (PrecioCompra > 0)
);
GO
/* UNIQUE(CodRecepcion) con índice filtrado: un UNIQUE normal solo
   admitiría UN ingreso manual (un solo NULL). */
CREATE UNIQUE NONCLUSTERED INDEX UQ_Ingreso_Recepcion
    ON dbo.Ingreso(CodRecepcion) WHERE CodRecepcion IS NOT NULL;
GO

/* ---- Salida ---- */
CREATE TABLE dbo.Salida(
    CodSalida     int IDENTITY(1,1) NOT NULL,
    CodLote       int            NOT NULL,
    CodUsuario    int            NOT NULL,
    FechaSalida   datetime       NOT NULL CONSTRAINT DF_Salida_Fecha DEFAULT (getdate()),
    Cantidad      int            NOT NULL,
    TipoSalida    nvarchar(25)   NOT NULL,
    Justificacion nvarchar(255)  NOT NULL,
    CONSTRAINT PK_Salida PRIMARY KEY CLUSTERED (CodSalida),
    CONSTRAINT FK_Salida_Lote    FOREIGN KEY (CodLote)    REFERENCES dbo.Lote(CodLote),
    CONSTRAINT FK_Salida_Usuario FOREIGN KEY (CodUsuario) REFERENCES dbo.Usuario(CodUsuario),
    CONSTRAINT CK_Salida_Cantidad CHECK (Cantidad > 0),
    CONSTRAINT CK_Salida_Tipo CHECK (TipoSalida IN
        (N'Consumo / Uso', N'Devolución a proveedor', N'Merma', N'Vencimiento',
         N'Daño / Deterioro', N'Pérdida / Robo', N'Retiro de lote', N'Otro')),
    CONSTRAINT CK_Salida_Justificacion CHECK (LEN(LTRIM(RTRIM(Justificacion))) > 0)
);
GO

/* ---- AjusteInventario ---- */
CREATE TABLE dbo.AjusteInventario(
    CodAjuste       int IDENTITY(1,1) NOT NULL,
    CodLote         int            NOT NULL,
    CodUsuario      int            NOT NULL,   -- solo Administrador (trigger abajo)
    FechaAjuste     datetime       NOT NULL CONSTRAINT DF_Ajuste_Fecha DEFAULT (getdate()),
    CantidadSistema int            NOT NULL,
    CantidadFisica  int            NOT NULL,
    Diferencia      AS (CantidadFisica - CantidadSistema) PERSISTED,
    Motivo          nvarchar(255)  NOT NULL,
    CONSTRAINT PK_Ajuste PRIMARY KEY CLUSTERED (CodAjuste),
    CONSTRAINT FK_Ajuste_Lote    FOREIGN KEY (CodLote)    REFERENCES dbo.Lote(CodLote),
    CONSTRAINT FK_Ajuste_Usuario FOREIGN KEY (CodUsuario) REFERENCES dbo.Usuario(CodUsuario),
    CONSTRAINT CK_Ajuste_Fisica     CHECK (CantidadFisica >= 0),
    CONSTRAINT CK_Ajuste_Diferencia CHECK (CantidadFisica <> CantidadSistema),
    CONSTRAINT CK_Ajuste_Motivo     CHECK (LEN(LTRIM(RTRIM(Motivo))) > 0)
);
GO

/* ---- InventarioDiario (cabecera) ---- */
CREATE TABLE dbo.InventarioDiario(
    CodInventario    int IDENTITY(1,1) NOT NULL,
    Fecha            date     NOT NULL,
    CodUsuarioGenera int      NOT NULL,   -- solo Administrador (trigger abajo)
    FechaGeneracion  datetime NOT NULL CONSTRAINT DF_InvDiario_FechaGen DEFAULT (getdate()),
    CONSTRAINT PK_InventarioDiario PRIMARY KEY CLUSTERED (CodInventario),
    CONSTRAINT UQ_InventarioDiario_Fecha UNIQUE (Fecha),
    CONSTRAINT FK_InvDiario_Usuario FOREIGN KEY (CodUsuarioGenera) REFERENCES dbo.Usuario(CodUsuario)
);
GO

/* ---- DetalleInventarioDiario ---- */
CREATE TABLE dbo.DetalleInventarioDiario(
    CodDetalle    int IDENTITY(1,1) NOT NULL,
    CodInventario int NOT NULL,
    CodProducto   int NOT NULL,
    StockSistema  int NOT NULL,
    CONSTRAINT PK_DetalleInvDiario PRIMARY KEY CLUSTERED (CodDetalle),
    CONSTRAINT FK_DetInv_Inventario FOREIGN KEY (CodInventario) REFERENCES dbo.InventarioDiario(CodInventario),
    CONSTRAINT FK_DetInv_Producto   FOREIGN KEY (CodProducto)   REFERENCES dbo.Producto(CodProducto),
    CONSTRAINT UQ_DetInv_InvProducto UNIQUE (CodInventario, CodProducto),
    CONSTRAINT CK_DetInv_Stock CHECK (StockSistema >= 0)
);
GO

/* =====================================================================
   3. VISTAS DE STOCK (el stock ya no se guarda)
   Stock lote = Σ Ingresos − Σ Salidas + Σ Diferencias de ajustes
   ===================================================================== */
CREATE OR ALTER VIEW dbo.vw_StockLote AS
SELECT  l.CodLote, l.CodProducto, l.NumeroLote, l.FechaVencimiento,
        ISNULL(i.Cant,0) - ISNULL(s.Cant,0) + ISNULL(a.Dif,0) AS StockLote
FROM dbo.Lote l
LEFT JOIN (SELECT CodLote, SUM(Cantidad)   Cant FROM dbo.Ingreso         GROUP BY CodLote) i ON i.CodLote = l.CodLote
LEFT JOIN (SELECT CodLote, SUM(Cantidad)   Cant FROM dbo.Salida          GROUP BY CodLote) s ON s.CodLote = l.CodLote
LEFT JOIN (SELECT CodLote, SUM(Diferencia) Dif  FROM dbo.AjusteInventario GROUP BY CodLote) a ON a.CodLote = l.CodLote;
GO

CREATE OR ALTER VIEW dbo.vw_StockProducto AS
SELECT  p.CodProducto, p.Nombre, p.Tipo, p.UnidadMedida, p.Estado,
        ISNULL(SUM(v.StockLote),0) AS StockActual
FROM dbo.Producto p
LEFT JOIN dbo.vw_StockLote v ON v.CodProducto = p.CodProducto
GROUP BY p.CodProducto, p.Nombre, p.Tipo, p.UnidadMedida, p.Estado;
GO

/* =====================================================================
   4. TRIGGERS
   (El de Historial lo crea registro_actualizado.sql: TR_Historial_SoloInsercion)
   ===================================================================== */

/* ---- 4.1 Reglas de negocio ---- */

/* RN-15: no registrar salida si el lote no tiene stock suficiente */
CREATE OR ALTER TRIGGER dbo.trg_Salida_StockSuficiente
ON dbo.Salida AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.vw_StockLote v
               WHERE v.CodLote IN (SELECT CodLote FROM inserted) AND v.StockLote < 0)
    BEGIN
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW 50002, N'Stock insuficiente en el lote para registrar la salida.', 1;
    END
END
GO

/* RN-17 + CU10: solo el Administrador ajusta, y tras el ajuste el stock
   del lote debe quedar IGUAL al stock físico contado. Esto también evita
   negativos y ajustes con CantidadSistema desactualizada.
   (Supone un ajuste por lote en cada INSERT.) */
CREATE OR ALTER TRIGGER dbo.trg_Ajuste_Validar
ON dbo.AjusteInventario AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted i JOIN dbo.Usuario u ON u.CodUsuario = i.CodUsuario
               WHERE u.Rol <> N'Administrador')
    BEGIN
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW 50003, N'Solo el Administrador puede registrar ajustes de inventario.', 1;
    END

    IF EXISTS (SELECT 1 FROM inserted i JOIN dbo.vw_StockLote v ON v.CodLote = i.CodLote
               WHERE v.StockLote <> i.CantidadFisica)
    BEGIN
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW 50005, N'El stock del sistema cambió o el ajuste es inconsistente: el lote no quedaría igual al stock físico.', 1;
    END
END
GO

/* RN-17: solo el Administrador genera inventarios */
CREATE OR ALTER TRIGGER dbo.trg_InventarioDiario_SoloAdmin
ON dbo.InventarioDiario AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted i JOIN dbo.Usuario u ON u.CodUsuario = i.CodUsuarioGenera
               WHERE u.Rol <> N'Administrador')
    BEGIN
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW 50004, N'Solo el Administrador puede generar el inventario diario.', 1;
    END
END
GO

/* ---- 4.2 Inmutabilidad (RN-05, RNF05, CU11): los movimientos y los
   inventarios guardados no se modifican ni se eliminan. Para limpiar datos
   de prueba hay que recrear la base o desactivar el trigger un momento
   (DISABLE TRIGGER nombre ON tabla). ---- */
CREATE OR ALTER TRIGGER dbo.trg_Ingreso_Inmutable
ON dbo.Ingreso INSTEAD OF UPDATE, DELETE
AS
BEGIN
    THROW 50006, N'Los ingresos no pueden modificarse ni eliminarse.', 1;
END
GO
CREATE OR ALTER TRIGGER dbo.trg_Salida_Inmutable
ON dbo.Salida INSTEAD OF UPDATE, DELETE
AS
BEGIN
    THROW 50007, N'Las salidas no pueden modificarse ni eliminarse.', 1;
END
GO
CREATE OR ALTER TRIGGER dbo.trg_Ajuste_Inmutable
ON dbo.AjusteInventario INSTEAD OF UPDATE, DELETE
AS
BEGIN
    THROW 50008, N'Los ajustes no pueden modificarse ni eliminarse.', 1;
END
GO
CREATE OR ALTER TRIGGER dbo.trg_InventarioDiario_Inmutable
ON dbo.InventarioDiario INSTEAD OF UPDATE, DELETE
AS
BEGIN
    THROW 50009, N'El inventario generado no puede modificarse ni eliminarse.', 1;
END
GO
CREATE OR ALTER TRIGGER dbo.trg_DetalleInventario_Inmutable
ON dbo.DetalleInventarioDiario INSTEAD OF UPDATE, DELETE
AS
BEGIN
    THROW 50010, N'El detalle del inventario generado no puede modificarse ni eliminarse.', 1;
END
GO
GO

/* ############################ PARTE 3: DATOS DE PRUEBA #################### */
-- =====================================================================
-- SIGAF - Carga completa de datos de prueba (version con Lote/Ingreso)
-- Requisitos:
--   1) Haber ejecutado antes migracion_bdfarma.sql
--   2) Las tablas estan VACIAS
-- Contrasena de todos los usuarios: clave123 (solo para pruebas)
-- OJO: la migracion deja triggers que impiden UPDATE/DELETE en Ingreso, Salida,
-- AjusteInventario, InventarioDiario, DetalleInventarioDiario e Historial.
-- Para volver a cargar datos: recrear la base y correr migracion + este script.
-- El stock ya no se guarda: se calcula con vw_StockLote / vw_StockProducto
-- =====================================================================
USE AbastecimientoFarmaceutico;
GO
SET QUOTED_IDENTIFIER ON;   -- necesario por el indice filtrado de Ingreso
SET ANSI_NULLS ON;
GO

-- 1. USUARIOS (codigos 1 al 7; el 7 es Administrador)
INSERT INTO Usuario (Nombres, Apellidos, NombreUsuario, Contraseña, Rol) VALUES
(N'Ana',      N'Pérez',   N'aperez',   CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Operador de Almacén'),
(N'Luis',     N'Gómez',   N'lgomez',   CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Responsable de Abastecimiento'),
(N'María',    N'Torres',  N'mtorres',  CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Responsable de Recepción'),
(N'Carlos',   N'Ramírez', N'cramirez', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Operador de Almacén'),
(N'Rosa',     N'Quispe',  N'rquispe',  CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Operador de Almacén'),
(N'Jorge',    N'Salazar', N'jsalazar', CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Responsable de Recepción'),
(N'Patricia', N'Vargas',  N'pvargas',  CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', N'clave123'), 2), N'Administrador');

-- 2. PROVEEDORES (codigos 1 al 5; todos activos)
INSERT INTO Proveedor (Nombre, Telefono, Correo, Estado) VALUES
(N'Farmacéutica Andina S.A.',         N'987654321', N'ventas@farmaceuticaandina.com', N'Activo'),
(N'Distribuidora Médica Lima',        N'912345678', N'contacto@dmlima.com',           N'Activo'),
(N'Insumos Salud E.I.R.L.',           N'965432187', N'info@insumossalud.com',         N'Activo'),
(N'Laboratorios del Pacífico S.A.C.', N'944556677', N'ventas@labpacifico.com',        N'Activo'),
(N'Medic Import Perú S.A.',           N'933221144', N'contacto@medicimport.com',      N'Activo');

-- 3. PRODUCTOS (codigos 1 al 16, todos activos) - sin StockActual
INSERT INTO Producto (Nombre, Tipo, UnidadMedida, Estado) VALUES
(N'Paracetamol 500 mg',    N'Medicamento', N'Caja',    N'Activo'),
(N'Amoxicilina 500 mg',    N'Medicamento', N'Caja',    N'Activo'),
(N'Ibuprofeno 400 mg',     N'Medicamento', N'Caja',    N'Activo'),
(N'Suero fisiológico 1 L', N'Insumo',      N'Frasco',  N'Activo'),
(N'Jeringa 5 ml',          N'Insumo',      N'Unidad',  N'Activo'),
(N'Guantes de látex',      N'Insumo',      N'Caja',    N'Activo'),
(N'Alcohol 70%',           N'Insumo',      N'Frasco',  N'Activo'),
(N'Gasa estéril',          N'Insumo',      N'Paquete', N'Activo'),
(N'Omeprazol 20 mg',       N'Medicamento', N'Caja',    N'Activo'),
(N'Diclofenaco 50 mg',     N'Medicamento', N'Caja',    N'Activo'),
(N'Loratadina 10 mg',      N'Medicamento', N'Caja',    N'Activo'),
(N'Metformina 850 mg',     N'Medicamento', N'Caja',    N'Activo'),
(N'Salbutamol inhalador',  N'Medicamento', N'Unidad',  N'Activo'),
(N'Mascarilla quirúrgica', N'Insumo',      N'Caja',    N'Activo'),
(N'Termómetro digital',    N'Insumo',      N'Unidad',  N'Activo'),
(N'Algodón hidrófilo',     N'Insumo',      N'Paquete', N'Activo');

-- 4. PRECIOS POR PROVEEDOR (RF11)
INSERT INTO PrecioProveedor (CodProducto, CodProveedor, PrecioUnitario) VALUES
(1,  1,  8.50), (1,  2,  9.20),
(2,  1, 15.00), (2,  2, 14.50),
(3,  1, 10.00), (3,  2, 10.80),
(4,  2,  4.20), (4,  1,  4.60), (4,  3,  4.10),
(5,  1,  0.90), (5,  2,  1.10),
(6,  1, 12.00), (6,  2, 11.50),
(7,  2,  3.50), (7,  1,  3.80), (7,  3,  3.40),
(8,  2,  2.50), (8,  3,  2.30),
(9,  2,  6.80), (9,  4,  6.50),
(10, 4,  5.40), (10, 5,  5.60),
(11, 4,  7.20), (11, 5,  7.50),
(12, 5,  9.90), (12, 2, 10.20),
-- Productos 3, 4, 7, 11 y 12: se agrega un segundo proveedor.
-- Proveedor 3 (Insumos Salud): precios de insumos (4, 7, 8, 14, 16). Gasa (8): proveedores 2 y 3.
-- Productos 13 a 16: el primero es el proveedor/precio del stock inicial; el segundo es nuevo.
(13, 4, 18.00), (13, 2, 18.60),
(14, 5, 12.00), (14, 2, 12.40), (14, 3, 11.80),
(15, 5, 15.00), (15, 4, 14.70),
(16, 2,  2.80), (16, 1,  3.00), (16, 3,  2.60);

-- 5. STOCK INICIAL: cada StockActual antiguo pasa a un Lote + un Ingreso manual
--    (CodRecepcion NULL). El Paracetamol se reparte en 2 lotes.
--    Los ingresos manuales los registra el Responsable de Recepcion (usuario 3, RF13).
--    Proveedor/precio: los de PrecioProveedor cuando existian; para los
--    productos 13 a 16 el precio es supuesto y se registra tambien en PrecioProveedor;
--    el del producto 8 (Gasa) tambien es supuesto y se registra en PrecioProveedor.
CREATE TABLE #StockInicial (
    CodProducto int, NumeroLote nvarchar(30), FechaVencimiento date,
    Stock int, CodProveedor int, PrecioCompra decimal(10,2));

INSERT INTO #StockInicial VALUES
(1,  N'PAR-2601-A', '2027-03-31',  80, 1,  8.50),
(1,  N'PAR-2606-B', '2028-02-29',  40, 1,  8.50),
(2,  N'AMO-2601',   '2026-12-15',  15, 1, 15.00),
(3,  N'IBU-2601',   '2028-04-30',  60, 1, 10.00),
(4,  N'SUE-2601',   '2028-01-31',  30, 2,  4.20),
(5,  N'JER-2601',   '2029-06-30',  40, 1,  0.90),
(6,  N'GUA-2601',   '2029-03-31',   8, 1, 12.00),
(7,  N'ALC-2601',   '2028-09-30',  25, 2,  3.50),
(8,  N'GAS-2512',   '2026-06-30',  50, 2,  2.50),
(9,  N'OME-2601',   '2028-05-31',  45, 2,  6.80),
(10, N'DIC-2601',   '2028-03-31',  35, 4,  5.40),
(11, N'LOR-2601',   '2028-06-30',  20, 4,  7.20),
(12, N'MET-2601',   '2028-10-31',  18, 5,  9.90),
(13, N'SAL-2601',   '2027-09-30',  12, 4, 18.00),
(14, N'MAS-2601',   '2029-02-28',  70, 5, 12.00),
(15, N'TER-2601',   '2031-12-31',  10, 5, 15.00),
(16, N'ALG-2601',   '2029-04-30',  22, 2,  2.80);

INSERT INTO Lote (CodProducto, NumeroLote, FechaVencimiento)
SELECT CodProducto, NumeroLote, FechaVencimiento FROM #StockInicial;

INSERT INTO Ingreso (CodLote, CodProveedor, CodUsuario, CodRecepcion, FechaIngreso, Cantidad, PrecioCompra, Observaciones)
SELECT l.CodLote, s.CodProveedor, 3, NULL, DATEADD(DAY, -60, GETDATE()), s.Stock, s.PrecioCompra,
       N'Stock inicial al implantar el sistema'
FROM #StockInicial s
JOIN Lote l ON l.CodProducto = s.CodProducto AND l.NumeroLote = s.NumeroLote;

DROP TABLE #StockInicial;

-- 6. SOLICITUDES (codigos 1 al 12)
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

-- 7. ORDENES DE COMPRA (codigos 1 al 3)
-- Orden 1: 200 x 0.90 = 180.00 | Orden 2: 100 x 6.80 = 680.00 | Orden 3: 60 x 5.40 = 324.00
INSERT INTO OrdenCompra (CodSolicitud, CodProveedor, CodUsuarioEmisor, CantidadPedida, PrecioUnitario, Estado, Observaciones) VALUES
(5,  1, 2, 200, 0.90, N'Recibida parcial',  N'Entrega en dos partes'),
(9,  2, 2, 100, 6.80, N'Recibida completa', N'Entrega única'),
(10, 4, 2,  60, 5.40, N'Recibida completa', N'Entrega con unidades en exceso');

-- 8. RECEPCIONES (codigos 1 al 3), ya confirmadas. Ahora con Lote y FechaVencimiento.
INSERT INTO Recepcion (CodOrden, CodUsuarioReceptor, CantidadRecibida, CantidadAceptada, CantidadRechazada, MotivoRechazo, Observaciones, Estado, Lote, FechaVencimiento) VALUES
(1, 3, 120, 110, 10, N'Dañado', N'10 unidades con empaque roto',                N'Confirmada', N'JER-2611', '2029-11-30'),
(2, 3, 100, 100,  0, NULL,      N'Entrega completa y conforme',                 N'Confirmada', N'OME-2611', '2029-01-31'),
(3, 6,  70,  60, 10, N'Exceso', N'Llegaron 10 unidades más de las solicitadas', N'Confirmada', N'DIC-2611', '2029-02-28');

-- 9. LOTES E INGRESOS GENERADOS POR LAS RECEPCIONES (reemplaza los UPDATE al stock)
--    Reproduce confirmarRecepcion(): crea/reutiliza el lote y genera el Ingreso
--    con la cantidad ACEPTADA, el proveedor y el precio de la orden.
INSERT INTO Lote (CodProducto, NumeroLote, FechaVencimiento)
SELECT DISTINCT s.CodProducto, r.Lote, r.FechaVencimiento
FROM Recepcion r
JOIN OrdenCompra oc ON oc.CodOrden = r.CodOrden
JOIN Solicitud   s  ON s.CodSolicitud = oc.CodSolicitud
WHERE r.Estado = N'Confirmada'
  AND NOT EXISTS (SELECT 1 FROM Lote x WHERE x.CodProducto = s.CodProducto AND x.NumeroLote = r.Lote);

INSERT INTO Ingreso (CodLote, CodProveedor, CodUsuario, CodRecepcion, FechaIngreso, Cantidad, PrecioCompra, Observaciones)
SELECT l.CodLote, oc.CodProveedor, r.CodUsuarioReceptor, r.CodRecepcion, r.FechaRecepcion,
       CAST(r.CantidadAceptada AS int), oc.PrecioUnitario,
       N'Ingreso generado al confirmar la recepción ' + CAST(r.CodRecepcion AS nvarchar(10))
FROM Recepcion r
JOIN OrdenCompra oc ON oc.CodOrden = r.CodOrden
JOIN Solicitud   s  ON s.CodSolicitud = oc.CodSolicitud
JOIN Lote        l  ON l.CodProducto = s.CodProducto AND l.NumeroLote = r.Lote
WHERE r.Estado = N'Confirmada';

-- 10. SALIDAS (cubren varios TipoSalida; ninguna deja el lote en negativo)
INSERT INTO Salida (CodLote, CodUsuario, FechaSalida, Cantidad, TipoSalida, Justificacion)
SELECT l.CodLote, v.CodUsuario, v.FechaSalida, v.Cantidad, v.TipoSalida, v.Justificacion
FROM (VALUES
 (1,  N'PAR-2601-A', 1, DATEADD(DAY,-20,GETDATE()), 20, N'Consumo / Uso',          N'Dispensación a consulta externa'),
 (3,  N'IBU-2601',   4, DATEADD(DAY,-15,GETDATE()), 10, N'Consumo / Uso',          N'Entrega al servicio de emergencia'),
 (4,  N'SUE-2601',   5, DATEADD(DAY,-12,GETDATE()),  5, N'Daño / Deterioro',       N'Frascos dañados durante el traslado interno'),
 (8,  N'GAS-2512',   1, DATEADD(DAY,-30,GETDATE()), 50, N'Vencimiento',            N'Lote vencido retirado del almacén'),
 (2,  N'AMO-2601',   4, DATEADD(DAY,-10,GETDATE()),  2, N'Merma',                  N'Blísteres rotos durante la manipulación'),
 (6,  N'GUA-2601',   1, DATEADD(DAY,-8, GETDATE()),  2, N'Devolución a proveedor', N'Cajas con talla incorrecta devueltas al proveedor'),
 (11, N'LOR-2601',   5, DATEADD(DAY,-6, GETDATE()),  3, N'Otro',                   N'Muestras para capacitación del personal'),
 (5,  N'JER-2611',   4, GETDATE(),                  30, N'Consumo / Uso',          N'Uso en el área de curaciones'),
 (9,  N'OME-2611',   1, GETDATE(),                  25, N'Consumo / Uso',          N'Dispensación a hospitalización'),
 (10, N'DIC-2611',   5, GETDATE(),                  10, N'Consumo / Uso',          N'Dispensación a consulta externa')
) AS v(CodProducto, NumeroLote, CodUsuario, FechaSalida, Cantidad, TipoSalida, Justificacion)
JOIN Lote l ON l.CodProducto = v.CodProducto AND l.NumeroLote = v.NumeroLote;

-- 11. AJUSTES DE INVENTARIO (solo Administrador = usuario 7)
--     CantidadSistema se toma del stock calculado del lote en este momento.
INSERT INTO AjusteInventario (CodLote, CodUsuario, FechaAjuste, CantidadSistema, CantidadFisica, Motivo)
SELECT l.CodLote, 7, GETDATE(), sl.StockLote, v.CantidadFisica, v.Motivo
FROM (VALUES
 (2,  N'AMO-2601', 12, N'Conteo físico: falta 1 caja en el estante'),
 (14, N'MAS-2601', 72, N'Conteo físico: 2 cajas sin registrar en un ingreso anterior')
) AS v(CodProducto, NumeroLote, CantidadFisica, Motivo)
JOIN Lote l ON l.CodProducto = v.CodProducto AND l.NumeroLote = v.NumeroLote
JOIN vw_StockLote sl ON sl.CodLote = l.CodLote;

-- 12. INVENTARIOS DIARIOS (solo el Administrador; se guardan y no se modifican)
-- 12a. Inventario de hace 30 dias: stock calculado solo con los movimientos
--      hasta el final de ese dia (ingresos - salidas + ajustes), como en el CU11.
DECLARE @FechaInv date     = CAST(DATEADD(DAY, -30, GETDATE()) AS date);
DECLARE @LimiteInv datetime = DATEADD(DAY, 1, CAST(@FechaInv AS datetime));  -- exclusivo

INSERT INTO InventarioDiario (Fecha, CodUsuarioGenera) VALUES (@FechaInv, 7);

INSERT INTO DetalleInventarioDiario (CodInventario, CodProducto, StockSistema)
SELECT (SELECT CodInventario FROM InventarioDiario WHERE Fecha = @FechaInv),
       p.CodProducto,
       ISNULL((SELECT SUM(i.Cantidad)   FROM Ingreso i          JOIN Lote l ON l.CodLote = i.CodLote
               WHERE l.CodProducto = p.CodProducto AND i.FechaIngreso < @LimiteInv), 0)
     - ISNULL((SELECT SUM(s.Cantidad)   FROM Salida s           JOIN Lote l ON l.CodLote = s.CodLote
               WHERE l.CodProducto = p.CodProducto AND s.FechaSalida  < @LimiteInv), 0)
     + ISNULL((SELECT SUM(a.Diferencia) FROM AjusteInventario a JOIN Lote l ON l.CodLote = a.CodLote
               WHERE l.CodProducto = p.CodProducto AND a.FechaAjuste  < @LimiteInv), 0)
FROM Producto p;

-- 12b. Inventario de hoy (foto del stock calculado de todos los productos)
INSERT INTO InventarioDiario (Fecha, CodUsuarioGenera) VALUES (CAST(GETDATE() AS date), 7);

INSERT INTO DetalleInventarioDiario (CodInventario, CodProducto, StockSistema)
SELECT (SELECT CodInventario FROM InventarioDiario WHERE Fecha = CAST(GETDATE() AS date)),
       CodProducto, CAST(StockActual AS int)
FROM vw_StockProducto;

-- 13. HISTORIAL
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
(2, N'Rechazo',      N'Solicitud',       11, N'Solicitud rechazada', N'Ya existe una solicitud similar en curso'),
(7, N'Registro',     N'Usuario',         7,  N'Usuario administrador registrado', NULL);

-- Historial de las operaciones nuevas, generado desde las propias tablas
INSERT INTO Historial (CodUsuario, TipoOperacion, ElementoAfectado, CodElemento, Descripcion, Motivo)
SELECT CodUsuario, N'Registro', N'Ingreso', CodIngreso, N'Ingreso manual de stock inicial', NULL
FROM Ingreso WHERE CodRecepcion IS NULL;

INSERT INTO Historial (CodUsuario, TipoOperacion, ElementoAfectado, CodElemento, Descripcion, Motivo)
SELECT CodUsuario, N'Generación', N'Ingreso', CodIngreso,
       N'Ingreso generado por la confirmación de la recepción ' + CAST(CodRecepcion AS nvarchar(10)), NULL
FROM Ingreso WHERE CodRecepcion IS NOT NULL;

INSERT INTO Historial (CodUsuario, TipoOperacion, ElementoAfectado, CodElemento, Descripcion, Motivo)
SELECT CodUsuario, N'Registro', N'Salida', CodSalida, N'Salida registrada: ' + TipoSalida, Justificacion
FROM Salida;

INSERT INTO Historial (CodUsuario, TipoOperacion, ElementoAfectado, CodElemento, Descripcion, Motivo)
SELECT CodUsuario, N'Registro', N'Ajuste', CodAjuste, N'Ajuste de inventario registrado', Motivo
FROM AjusteInventario;

INSERT INTO Historial (CodUsuario, TipoOperacion, ElementoAfectado, CodElemento, Descripcion, Motivo)
SELECT CodUsuarioGenera, N'Generación', N'Inventario', CodInventario, N'Inventario diario generado', NULL
FROM InventarioDiario;
GO

-- 14. TRIGGER: el historial no se puede modificar ni eliminar (RNF03)
IF OBJECT_ID(N'TR_Historial_SoloInsercion', N'TR') IS NULL
    EXEC(N'CREATE TRIGGER TR_Historial_SoloInsercion
           ON Historial
           INSTEAD OF UPDATE, DELETE
           AS
           BEGIN
               RAISERROR (N''El historial no puede modificarse ni eliminarse.'', 16, 1);
           END');
GO

-- 15. VERIFICACION (resultados esperados)
SELECT CodOrden, CantidadPedida, PrecioUnitario, PrecioTotal FROM OrdenCompra;
-- Esperado: 180.00 | 680.00 | 324.00

SELECT CodProducto, Nombre, StockActual FROM vw_StockProducto ORDER BY CodProducto;
-- Esperado (1..16): 100, 12, 50, 25, 120, 6, 25, 0, 120, 85, 17, 18, 12, 72, 10, 22
-- (Jeringa 40+110-30, Omeprazol 45+100-25, Diclofenaco 35+60-10, Amoxicilina 15-2-1 ajuste,
--  Mascarilla 70+2 ajuste, Gasa 50-50 por vencimiento)

SELECT CodRecepcion, CodIngreso, Cantidad FROM Ingreso WHERE CodRecepcion IS NOT NULL;
-- Esperado: 1->110 | 2->100 | 3->60 (cantidad aceptada de cada recepcion)

SELECT CodLote, NumeroLote, FechaVencimiento, StockLote
FROM vw_StockLote WHERE FechaVencimiento < CAST(GETDATE() AS date);
-- Esperado: solo GAS-2512 (vencido, stock 0)

SELECT COUNT(*) AS Detalles FROM DetalleInventarioDiario;
-- Esperado: 32 (16 productos x 2 inventarios)

SELECT d.CodProducto, d.StockSistema
FROM DetalleInventarioDiario d
JOIN InventarioDiario i ON i.CodInventario = d.CodInventario
WHERE i.Fecha = CAST(DATEADD(DAY, -30, GETDATE()) AS date)
ORDER BY d.CodProducto;
-- Esperado inventario de hace 30 dias (1..16): 120, 15, 60, 30, 40, 8, 25, 0, 45, 35, 20, 18, 12, 70, 10, 22

SELECT COUNT(*) AS Precios FROM PrecioProveedor;
-- Esperado: 36

SELECT p.CodProducto, p.Nombre, COUNT(*) AS ProveedoresConPrecio
FROM Producto p
JOIN PrecioProveedor pp ON pp.CodProducto = p.CodProducto
JOIN Proveedor v ON v.CodProveedor = pp.CodProveedor AND v.Estado = N'Activo'
WHERE p.Estado = N'Activo'
GROUP BY p.CodProducto, p.Nombre
HAVING COUNT(*) < 2;
-- Esperado: ninguna fila (todo producto activo tiene al menos 2 proveedores activos con precio)

SELECT (SELECT COUNT(*) FROM Producto  WHERE Estado <> N'Activo') AS ProductosInactivos,
       (SELECT COUNT(*) FROM Proveedor WHERE Estado <> N'Activo') AS ProveedoresInactivos;
-- Esperado: 0 | 0
GO
