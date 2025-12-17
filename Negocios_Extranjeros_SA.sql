-- Creación de la Base de Datos
create database Negocios_Extranjeros_SA;
use Negocios_Extranjeros_SA;
------------------------------------------------------------
-- Creacion de las Tablas
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    pais VARCHAR(50) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE inversionistas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('Individual', 'Institucional') NOT NULL,
    capital_invertido DECIMAL(15,2) DEFAULT 0,
    fecha_inicio DATE NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE ventas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    producto VARCHAR(150) NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente', 'Completada', 'Cancelada') DEFAULT 'Pendiente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT
);

CREATE TABLE audit_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(50) NOT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    tabla_afectada VARCHAR(50) NOT NULL,
    operacion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    valor_anterior JSON,
    valor_nuevo JSON,
    ip_conexion VARCHAR(45)
);

------------------------------------------------------------
-- Creación de Usuarios
create user 'Analista'@'localhost' IDENTIFIED BY 'Analista123';
create user 'Visor'@'localhost' identified by 'Visor123';
-- Asignarles permiso
GRANT SELECT, INSERT, UPDATE, DELETE ON Negocios_Extranjeros_SA.clientes TO 'Analista'@'localhost';
FLUSH PRIVILEGES;
GRANT SELECT, INSERT, UPDATE, DELETE ON Negocios_Extranjeros_SA.inversionistas TO 'Analista'@'localhost';
FLUSH PRIVILEGES;
GRANT SELECT, INSERT, UPDATE, DELETE ON Negocios_Extranjeros_SA.ventas TO 'Analista'@'localhost';
FLUSH PRIVILEGES;

-- Privilegios limitados para el Visor (solo SELECT)
GRANT SELECT ON Negocios_Extranjeros_SA.clientes TO 'Visor'@'localhost';
FLUSH PRIVILEGES;
GRANT SELECT ON Negocios_Extranjeros_SA.inversionistas TO 'Visor'@'localhost';
FLUSH PRIVILEGES;
GRANT SELECT ON Negocios_Extranjeros_SA.ventas TO 'Visor'@'localhost';
FLUSH PRIVILEGES;

-- Ambos pueden ver la auditoría (solo lectura)
GRANT SELECT ON Negocios_Extranjeros_SA.audit_log TO 'Analista'@'localhost', 'Visor'@'localhost';
FLUSH PRIVILEGES;
---------------------------------------------------------------------
-- Creación de triggers
-- Trigger para INSERT en clientes
DELIMITER $$
CREATE TRIGGER tr_clientes_after_insert
AFTER INSERT ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (usuario, tabla_afectada, operacion,
    valor_anterior, valor_nuevo, ip_conexion
    )
    VALUES (USER(), 'clientes', 'INSERT', NULL, JSON_OBJECT(
            'id', NEW.id, 'nombre', NEW.nombre,
            'email', NEW.email, 'pais', NEW.pais,
            'fecha_registro', NEW.fecha_registro,
            'activo', NEW.activo), CONNECTION_ID()
    );
END$$

--------------------------------------------
-- Trigger para DELETE en clientes
DELIMITER $$
CREATE TRIGGER tr_clientes_after_delete
AFTER DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (usuario,tabla_afectada, operacion,
		valor_anterior, valor_nuevo, ip_conexion)
        VALUES (USER(),'clientes', 'DELETE',
        JSON_OBJECT(
            'id', OLD.id,
            'nombre', OLD.nombre,
            'email', OLD.email,
            'pais', OLD.pais,
            'fecha_registro', OLD.fecha_registro,
            'activo', OLD.activo
        ),NULL,
        (SELECT SUBSTRING_INDEX(USER(), '@', -1))
    );
END$$
DELIMITER ;
-------------------------------------------------
-- Trigger para INSERT en inversionistas
DELIMITER $$
CREATE TRIGGER tr_inversionistas_after_insert
AFTER INSERT ON inversionistas
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (usuario, tabla_afectada, operacion,
        valor_anterior, valor_nuevo, ip_conexion)
        VALUES (USER(), 'inversionistas','INSERT',NULL,JSON_OBJECT(
            'id', NEW.id,
            'nombre', NEW.nombre,
            'tipo', NEW.tipo,
            'capital_invertido', NEW.capital_invertido,
            'fecha_inicio', NEW.fecha_inicio,
            'activo', NEW.activo
        ),
        (SELECT SUBSTRING_INDEX(USER(), '@', -1))
    );
END$$
DELIMITER ;
----------------------------------------------------------
-- Trigger para DELETE en inversionistas
DELIMITER $$
CREATE TRIGGER tr_inversionistas_after_delete
AFTER DELETE ON inversionistas
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (
        usuario,
        tabla_afectada,
        operacion,
        valor_anterior,
        valor_nuevo,
        ip_conexion
    ) VALUES (
        USER(),
        'inversionistas',
        'DELETE',
        JSON_OBJECT(
            'id', OLD.id,
            'nombre', OLD.nombre,
            'tipo', OLD.tipo,
            'capital_invertido', OLD.capital_invertido,
            'fecha_inicio', OLD.fecha_inicio,
            'activo', OLD.activo
        ),
        NULL,
        (SELECT SUBSTRING_INDEX(USER(), '@', -1))
    );
END$$
DELIMITER ;
---------------------------------------------
-- Trigger para INSERT en ventas
DELIMITER $$
CREATE TRIGGER tr_ventas_after_insert
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (usuario, tabla_afectada, operacion,
        valor_anterior, valor_nuevo, ip_conexion)
        VALUES (USER(), 'ventas', 'INSERT', NULL,
        JSON_OBJECT(
            'id', NEW.id,
            'cliente_id', NEW.cliente_id,
            'producto', NEW.producto,
            'monto', NEW.monto,
            'fecha_venta', NEW.fecha_venta,
            'estado', NEW.estado
        ),
        (SELECT SUBSTRING_INDEX(USER(), '@', -1))
    );
END$$
DELIMITER ;

-- Trigger para DELETE en ventas
DELIMITER $$
CREATE TRIGGER tr_ventas_after_delete
AFTER DELETE ON ventas
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (usuario, tabla_afectada, operacion,
        valor_anterior, valor_nuevo, ip_conexion)
    VALUES (USER(), 'ventas', 'DELETE',
        JSON_OBJECT(
            'id', OLD.id,
            'cliente_id', OLD.cliente_id,
            'producto', OLD.producto,
            'monto', OLD.monto,
            'fecha_venta', OLD.fecha_venta,
            'estado', OLD.estado
        ),
        NULL, (SELECT SUBSTRING_INDEX(USER(), '@', -1))
    );
END$$
DELIMITER ;
