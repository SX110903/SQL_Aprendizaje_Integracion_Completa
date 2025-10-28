-- ============================================================
-- BASE DE DATOS OPTIMIZADA: ESTANCOS INFORMACION ADICIONAL LOS COMENTARIOS ESTAN HECHO CON LA IA ChatGPT 5.0, 
-- Lo siento QUIM pero ami el tema de los comentarios me malea y el español lo tengo a medias,
-- Características:
-- - InnoDB Engine para todas las tablas
-- - Foreign Keys con nombres descriptivos
-- - ON DELETE y ON UPDATE optimizados
-- - Índices para mejorar rendimiento
-- - Triggers para sincronización automática
-- ============================================================

DROP DATABASE IF EXISTS estancos;
CREATE DATABASE estancos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE estancos;

-- ============================================================
-- TABLA: estancos
-- Almacena información de los establecimientos
-- ============================================================
CREATE TABLE IF NOT EXISTS estancos (
    id_estanco INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_estanco),
    INDEX idx_ciudad (ciudad),
    INDEX idx_codigo_postal (codigo_postal),
    INDEX idx_activo (activo),
    INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: proveedores
-- Debe crearse ANTES de productos (dependencia FK)
-- ============================================================
CREATE TABLE IF NOT EXISTS proveedores (
    id_proveedor INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(15),
    email VARCHAR(100),
    direccion VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_proveedor),
    INDEX idx_nombre_proveedor (nombre),
    INDEX idx_activo_proveedor (activo),
    UNIQUE KEY uk_email_proveedor (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: empleados
-- Relación con estancos
-- ============================================================
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT AUTO_INCREMENT,
    id_estanco INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(20) NOT NULL,
    puesto VARCHAR(100),
    salario DECIMAL(10, 2),
    fecha_contratacion DATE NOT NULL DEFAULT (CURRENT_DATE),
    fecha_baja DATE NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_empleado),
    UNIQUE KEY uk_dni_empleado (dni),
    INDEX idx_estanco (id_estanco),
    INDEX idx_apellido (apellido),
    INDEX idx_activo_empleado (activo),
    INDEX idx_fecha_contratacion (fecha_contratacion),

    CONSTRAINT fk_empleado_estanco
        FOREIGN KEY (id_estanco)
        REFERENCES estancos(id_estanco)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: productos
-- Relación con proveedores
-- ============================================================
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT,
    id_proveedor INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    codigo_barras VARCHAR(50),
    precio_coste DECIMAL(10, 2) NOT NULL,
    precio_venta DECIMAL(10, 2) NOT NULL,
    stock_minimo INT DEFAULT 10,
    stock_actual INT DEFAULT 0,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_producto),
    UNIQUE KEY uk_codigo_barras (codigo_barras),
    INDEX idx_nombre_producto (nombre),
    INDEX idx_proveedor (id_proveedor),
    INDEX idx_activo_producto (activo),
    INDEX idx_stock (stock_actual),
    INDEX idx_precio_venta (precio_venta),

    CONSTRAINT fk_producto_proveedor
        FOREIGN KEY (id_proveedor)
        REFERENCES proveedores(id_proveedor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_precio_venta_mayor_coste
        CHECK (precio_venta >= precio_coste),
    CONSTRAINT chk_stock_positivo
        CHECK (stock_actual >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: inventario_estanco
-- Relación muchos a muchos entre estancos y productos
-- ============================================================
CREATE TABLE IF NOT EXISTS inventario_estanco (
    id_inventario INT AUTO_INCREMENT,
    id_estanco INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,
    ubicacion VARCHAR(50),
    fecha_ultima_entrada TIMESTAMP NULL,
    fecha_ultima_salida TIMESTAMP NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id_inventario),
    UNIQUE KEY uk_estanco_producto (id_estanco, id_producto),
    INDEX idx_estanco_inv (id_estanco),
    INDEX idx_producto_inv (id_producto),
    INDEX idx_cantidad (cantidad),

    CONSTRAINT fk_inventario_estanco
        FOREIGN KEY (id_estanco)
        REFERENCES estancos(id_estanco)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_cantidad_positiva
        CHECK (cantidad >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: ventas
-- Registra las ventas realizadas
-- ============================================================
CREATE TABLE IF NOT EXISTS ventas (
    id_venta INT AUTO_INCREMENT,
    id_estanco INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'bizum') DEFAULT 'efectivo',
    estado ENUM('completada', 'cancelada', 'pendiente') DEFAULT 'completada',

    PRIMARY KEY (id_venta),
    INDEX idx_estanco_venta (id_estanco),
    INDEX idx_empleado_venta (id_empleado),
    INDEX idx_fecha_venta (fecha_venta),
    INDEX idx_estado_venta (estado),
    INDEX idx_total (total),

    CONSTRAINT fk_venta_estanco
        FOREIGN KEY (id_estanco)
        REFERENCES estancos(id_estanco)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_venta_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES empleados(id_empleado)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_total_positivo
        CHECK (total >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: detalle_venta
-- Detalles de los productos vendidos en cada venta
-- ============================================================
CREATE TABLE IF NOT EXISTS detalle_venta (
    id_detalle INT AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (id_detalle),
    INDEX idx_venta_detalle (id_venta),
    INDEX idx_producto_detalle (id_producto),

    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (id_venta)
        REFERENCES ventas(id_venta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_cantidad_detalle_positiva
        CHECK (cantidad > 0),
    CONSTRAINT chk_precio_unitario_positivo
        CHECK (precio_unitario > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: pedidos_proveedor
-- Gestión de pedidos a proveedores
-- ============================================================
CREATE TABLE IF NOT EXISTS pedidos_proveedor (
    id_pedido INT AUTO_INCREMENT,
    id_proveedor INT NOT NULL,
    id_estanco INT NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega_estimada DATE,
    fecha_entrega_real DATE NULL,
    estado ENUM('pendiente', 'en_transito', 'recibido', 'cancelado') DEFAULT 'pendiente',
    total DECIMAL(10, 2) DEFAULT 0.00,

    PRIMARY KEY (id_pedido),
    INDEX idx_proveedor_pedido (id_proveedor),
    INDEX idx_estanco_pedido (id_estanco),
    INDEX idx_fecha_pedido (fecha_pedido),
    INDEX idx_estado_pedido (estado),

    CONSTRAINT fk_pedido_proveedor
        FOREIGN KEY (id_proveedor)
        REFERENCES proveedores(id_proveedor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_pedido_estanco
        FOREIGN KEY (id_estanco)
        REFERENCES estancos(id_estanco)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: detalle_pedido
-- Detalles de productos en cada pedido
-- ============================================================
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_detalle_pedido INT AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (id_detalle_pedido),
    INDEX idx_pedido_detalle (id_pedido),
    INDEX idx_producto_pedido (id_producto),

    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos_proveedor(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_detalle_pedido_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_cantidad_pedido_positiva
        CHECK (cantidad > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLA: historial_precios
-- Auditoría de cambios de precios
-- ============================================================
CREATE TABLE IF NOT EXISTS historial_precios (
    id_historial INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    precio_coste_anterior DECIMAL(10, 2),
    precio_coste_nuevo DECIMAL(10, 2),
    precio_venta_anterior DECIMAL(10, 2),
    precio_venta_nuevo DECIMAL(10, 2),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100),

    PRIMARY KEY (id_historial),
    INDEX idx_producto_historial (id_producto),
    INDEX idx_fecha_cambio (fecha_cambio),

    CONSTRAINT fk_historial_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TRIGGERS: SINCRONIZACIÓN AUTOMÁTICA
-- ============================================================

-- TRIGGER 1: Actualizar total de venta al insertar detalle
DELIMITER //
CREATE TRIGGER trg_after_insert_detalle_venta
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    UPDATE ventas
    SET total = (
        SELECT SUM(subtotal)
        FROM detalle_venta
        WHERE id_venta = NEW.id_venta
    )
    WHERE id_venta = NEW.id_venta;
END//
DELIMITER ;

-- TRIGGER 2: Actualizar total de venta al actualizar detalle
DELIMITER //
CREATE TRIGGER trg_after_update_detalle_venta
AFTER UPDATE ON detalle_venta
FOR EACH ROW
BEGIN
    UPDATE ventas
    SET total = (
        SELECT SUM(subtotal)
        FROM detalle_venta
        WHERE id_venta = NEW.id_venta
    )
    WHERE id_venta = NEW.id_venta;
END//
DELIMITER ;

-- TRIGGER 3: Actualizar total de venta al eliminar detalle
DELIMITER //
CREATE TRIGGER trg_after_delete_detalle_venta
AFTER DELETE ON detalle_venta
FOR EACH ROW
BEGIN
    UPDATE ventas
    SET total = COALESCE((
        SELECT SUM(subtotal)
        FROM detalle_venta
        WHERE id_venta = OLD.id_venta
    ), 0.00)
    WHERE id_venta = OLD.id_venta;
END//
DELIMITER ;

-- TRIGGER 4: Calcular subtotal automáticamente en detalle_venta
DELIMITER //
CREATE TRIGGER trg_before_insert_detalle_venta
BEFORE INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    SET NEW.subtotal = NEW.cantidad * NEW.precio_unitario;
END//
DELIMITER ;

-- TRIGGER 5: Actualizar subtotal al modificar detalle_venta
DELIMITER //
CREATE TRIGGER trg_before_update_detalle_venta
BEFORE UPDATE ON detalle_venta
FOR EACH ROW
BEGIN
    SET NEW.subtotal = NEW.cantidad * NEW.precio_unitario;
END//
DELIMITER ;

-- TRIGGER 6: Reducir inventario al realizar venta
DELIMITER //
CREATE TRIGGER trg_after_insert_detalle_venta_stock
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    DECLARE v_id_estanco INT;

    -- Obtener el estanco de la venta
    SELECT id_estanco INTO v_id_estanco
    FROM ventas
    WHERE id_venta = NEW.id_venta;

    -- Reducir cantidad en inventario del estanco
    UPDATE inventario_estanco
    SET cantidad = cantidad - NEW.cantidad,
        fecha_ultima_salida = CURRENT_TIMESTAMP
    WHERE id_estanco = v_id_estanco
      AND id_producto = NEW.id_producto;

    -- Reducir stock global del producto
    UPDATE productos
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END//
DELIMITER ;

-- TRIGGER 7: Actualizar total pedido al insertar detalle
DELIMITER //
CREATE TRIGGER trg_after_insert_detalle_pedido
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE pedidos_proveedor
    SET total = (
        SELECT SUM(subtotal)
        FROM detalle_pedido
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
END//
DELIMITER ;

-- TRIGGER 8: Calcular subtotal en detalle_pedido
DELIMITER //
CREATE TRIGGER trg_before_insert_detalle_pedido
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    SET NEW.subtotal = NEW.cantidad * NEW.precio_unitario;
END//
DELIMITER ;

-- TRIGGER 9: Actualizar inventario al recibir pedido
DELIMITER //
CREATE TRIGGER trg_after_update_pedido_recibido
AFTER UPDATE ON pedidos_proveedor
FOR EACH ROW
BEGIN
    IF NEW.estado = 'recibido' AND OLD.estado != 'recibido' THEN
        -- Actualizar inventario para cada producto del pedido
        UPDATE inventario_estanco ie
        INNER JOIN detalle_pedido dp ON ie.id_producto = dp.id_producto
        SET ie.cantidad = ie.cantidad + dp.cantidad,
            ie.fecha_ultima_entrada = CURRENT_TIMESTAMP
        WHERE dp.id_pedido = NEW.id_pedido
          AND ie.id_estanco = NEW.id_estanco;

        -- Actualizar stock global de productos
        UPDATE productos p
        INNER JOIN detalle_pedido dp ON p.id_producto = dp.id_producto
        SET p.stock_actual = p.stock_actual + dp.cantidad
        WHERE dp.id_pedido = NEW.id_pedido;
    END IF;
END//
DELIMITER ;

-- TRIGGER 10: Auditoría de cambios de precios
DELIMITER //
CREATE TRIGGER trg_after_update_precio_producto
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    IF OLD.precio_coste != NEW.precio_coste OR OLD.precio_venta != NEW.precio_venta THEN
        INSERT INTO historial_precios (
            id_producto,
            precio_coste_anterior,
            precio_coste_nuevo,
            precio_venta_anterior,
            precio_venta_nuevo,
            usuario
        ) VALUES (
            NEW.id_producto,
            OLD.precio_coste,
            NEW.precio_coste,
            OLD.precio_venta,
            NEW.precio_venta,
            USER()
        );
    END IF;
END//
DELIMITER ;

-- ============================================================
-- VISTAS OPTIMIZADAS
-- ============================================================

-- Vista: Inventario bajo (productos que necesitan reposición)
CREATE OR REPLACE VIEW vista_inventario_bajo AS
SELECT
    p.id_producto,
    p.nombre AS producto,
    p.stock_actual,
    p.stock_minimo,
    pr.nombre AS proveedor,
    pr.telefono AS telefono_proveedor
FROM productos p
INNER JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor
WHERE p.stock_actual <= p.stock_minimo
  AND p.activo = TRUE;

-- Vista: Ventas por estanco
CREATE OR REPLACE VIEW vista_ventas_por_estanco AS
SELECT
    e.id_estanco,
    e.nombre AS estanco,
    e.ciudad,
    COUNT(v.id_venta) AS total_ventas,
    COALESCE(SUM(v.total), 0) AS ingresos_totales,
    COALESCE(AVG(v.total), 0) AS ticket_promedio
FROM estancos e
LEFT JOIN ventas v ON e.id_estanco = v.id_estanco
WHERE v.estado = 'completada'
GROUP BY e.id_estanco, e.nombre, e.ciudad;

-- Vista: Productos más vendidos
CREATE OR REPLACE VIEW vista_productos_mas_vendidos AS
SELECT
    p.id_producto,
    p.nombre AS producto,
    p.codigo_barras,
    COUNT(dv.id_detalle) AS veces_vendido,
    SUM(dv.cantidad) AS cantidad_total_vendida,
    SUM(dv.subtotal) AS ingresos_totales
FROM productos p
INNER JOIN detalle_venta dv ON p.id_producto = dv.id_producto
INNER JOIN ventas v ON dv.id_venta = v.id_venta
WHERE v.estado = 'completada'
GROUP BY p.id_producto, p.nombre, p.codigo_barras
ORDER BY cantidad_total_vendida DESC;

-- Vista: Rendimiento de empleados
CREATE OR REPLACE VIEW vista_rendimiento_empleados AS
SELECT
    emp.id_empleado,
    CONCAT(emp.nombre, ' ', emp.apellido) AS empleado,
    emp.puesto,
    est.nombre AS estanco,
    COUNT(v.id_venta) AS ventas_realizadas,
    COALESCE(SUM(v.total), 0) AS ventas_totales
FROM empleados emp
LEFT JOIN ventas v ON emp.id_empleado = v.id_empleado
INNER JOIN estancos est ON emp.id_estanco = est.id_estanco
WHERE emp.activo = TRUE
  AND (v.estado = 'completada' OR v.id_venta IS NULL)
GROUP BY emp.id_empleado, empleado, emp.puesto, est.nombre;

-- ============================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================================

-- Procedimiento: Registrar venta completa
DELIMITER //
CREATE PROCEDURE sp_registrar_venta(
    IN p_id_estanco INT,
    IN p_id_empleado INT,
    IN p_metodo_pago VARCHAR(20)
)
BEGIN
    DECLARE v_id_venta INT;

    -- Insertar venta
    INSERT INTO ventas (id_estanco, id_empleado, metodo_pago, estado)
    VALUES (p_id_estanco, p_id_empleado, p_metodo_pago, 'completada');

    -- Obtener ID de la venta creada
    SET v_id_venta = LAST_INSERT_ID();

    -- Retornar ID de venta para agregar detalles
    SELECT v_id_venta AS id_venta;
END//
DELIMITER ;

-- Procedimiento: Crear pedido a proveedor para productos con stock bajo
DELIMITER //
CREATE PROCEDURE sp_crear_pedido_automatico(
    IN p_id_estanco INT,
    IN p_id_proveedor INT
)
BEGIN
    DECLARE v_id_pedido INT;

    -- Crear pedido
    INSERT INTO pedidos_proveedor (id_proveedor, id_estanco, estado)
    VALUES (p_id_proveedor, p_id_estanco, 'pendiente');

    SET v_id_pedido = LAST_INSERT_ID();

    -- Agregar productos con stock bajo
    INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
    SELECT
        v_id_pedido,
        p.id_producto,
        (p.stock_minimo * 2) - p.stock_actual AS cantidad,
        p.precio_coste,
        ((p.stock_minimo * 2) - p.stock_actual) * p.precio_coste
    FROM productos p
    WHERE p.id_proveedor = p_id_proveedor
      AND p.stock_actual <= p.stock_minimo
      AND p.activo = TRUE;

    SELECT v_id_pedido AS id_pedido;
END//
DELIMITER ;

-- ============================================================
-- DATOS DE EJEMPLO (OPCIONAL)
-- ============================================================

-- Insertar estancos
INSERT INTO estancos (nombre, direccion, ciudad, codigo_postal, telefono, email) VALUES
('Estanco Central', 'Calle Mayor 15', 'Madrid', '28001', '910123456', 'central@estanco.com'),
('Estanco Norte', 'Avenida Norte 45', 'Madrid', '28034', '910234567', 'norte@estanco.com'),
('Estanco Sur', 'Calle Sur 23', 'Barcelona', '08001', '930345678', 'sur@estanco.com');

-- Insertar proveedores
INSERT INTO proveedores (nombre, contacto, telefono, email, direccion) VALUES
('Tabacalera Española', 'Juan Pérez', '915111111', 'contacto@tabacalera.com', 'Polígono Industrial 1'),
('Distribuciones López', 'María López', '916222222', 'info@dislopez.com', 'Calle Industria 45'),
('Suministros Globales', 'Pedro García', '917333333', 'ventas@sumglobal.com', 'Avenida Empresarial 12');

-- Insertar empleados
INSERT INTO empleados (id_estanco, nombre, apellido, dni, puesto, salario, fecha_contratacion) VALUES
(1, 'Carlos', 'Martínez', '12345678A', 'Gerente', 2500.00, '2023-01-15'),
(1, 'Ana', 'Rodríguez', '23456789B', 'Vendedor', 1500.00, '2023-03-20'),
(2, 'Luis', 'González', '34567890C', 'Gerente', 2500.00, '2023-02-10'),
(3, 'Laura', 'Fernández', '45678901D', 'Vendedor', 1500.00, '2023-04-05');

-- Insertar productos
INSERT INTO productos (id_proveedor, nombre, descripcion, codigo_barras, precio_coste, precio_venta, stock_minimo, stock_actual) VALUES
(1, 'Tabaco Rubio Pack 20', 'Cigarrillos rubios paquete de 20 unidades', '8411111111111', 4.50, 5.50, 50, 100),
(1, 'Tabaco Negro Pack 20', 'Cigarrillos negros paquete de 20 unidades', '8422222222222', 4.20, 5.20, 50, 80),
(2, 'Mechero BIC', 'Mechero desechable BIC', '8433333333333', 0.50, 1.50, 100, 200),
(2, 'Papel Fumar OCB', 'Papel de fumar OCB slim', '8444444444444', 0.30, 0.80, 150, 300),
(3, 'Lotería Nacional', 'Décimo lotería nacional', '8455555555555', 15.00, 20.00, 20, 50);

-- Insertar inventario inicial
INSERT INTO inventario_estanco (id_estanco, id_producto, cantidad, ubicacion) VALUES
(1, 1, 100, 'Estantería A1'),
(1, 2, 80, 'Estantería A2'),
(1, 3, 200, 'Mostrador'),
(1, 4, 300, 'Estantería B1'),
(1, 5, 50, 'Caja fuerte'),
(2, 1, 50, 'Estantería Principal'),
(2, 3, 100, 'Mostrador'),
(3, 2, 60, 'Vitrina');

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================