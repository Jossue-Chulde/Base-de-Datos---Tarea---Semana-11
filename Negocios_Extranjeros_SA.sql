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


