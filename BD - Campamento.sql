CREATE DATABASE campamento;
USE campamento;

CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellidos VARCHAR(50),
    fecha_nacimiento DATE,
    direccion VARCHAR(100),
    telefono VARCHAR(15)
);

CREATE TABLE pago_campamento (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha_pago DATE,
    monto DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);
----------------------------------------------------------------------------------
-- Creación de Usuarios
CREATE USER 'PP_GRILLO'@'localhost' identified BY 'pp123';
CREATE USER 'user_Dolores_de _Barriga'@'localhost' identified BY 'db123';
CREATE USER 'user_Paco_ Mer'@'localhost' identified BY 'pm123';
----------------------------------------------------------------------------------
-- Asignar Privilegios
-- Privilegios para user_Dolores_de _Barriga:
GRANT SELECT, INSERT, UPDATE ON campamento.clientes TO 'user_Dolores_de _Barriga'@'localhost';
flush privileges;

GRANT SELECT ON campamento.pago_campamento TO 'user_Dolores_de _Barriga'@'localhost';
flush privileges;

-- Privilegios para user_Paco_ Mer:
GRANT SELECT, INSERT, DELETE ON campamento.pago_campamento TO 'user_Paco_ Mer'@'localhost';
flush privileges;

GRANT SELECT ON campamento.clientes TO 'user_Paco_ Mer'@'localhost';
flush privileges;

------------------------------------------------------------------------------------------------
-- Práctica 2: Asignar Privilegios al usuario PP_GRILLO.
GRANT SELECT, INSERT ON campamento.* TO 'PP_GRILLO'@'localhost';
flush privileges;
------------------------------------------------------------------------------------------------
/* Muestra todos los usuarios creados en el sistema con toda
la información necesaria para identificar sus atribuciones. */
SELECT user, host from mysql.user;
------------------------------------------------------------------------------------------------
-- Revoca el permiso de inserción del usuario PP_GRILLO
revoke insert on campamento.* from 'PP_GRILLO'@'localhost';
------------------------------------------------------------------------------------------------
-- Cambia la contraseña del usuario PP_GRILLO a 5012.
ALTER USER 'PP_GRILLO'@'localhost' identified BY '5012';
------------------------------------------------------------------------------------------------
-- Asigna al usuario PP_GRILLO permisos de actualización en la base de datos campamento.
GRANT INSERT, UPDATE ON campamento.* TO 'PP_GRILLO'@'localhost';
flush privileges;
------------------------------------------------------------------------------------------------
-- Crea un usuario super_admin con todos los privilegios en todas las bases de datos.
CREATE USER 'super_admin'@'localhost' identified by 'super123';
GRANT ALL PRIVILEGES on *.* to 'super_admin'@'localhost';
flush privileges;
------------------------------------------------------------------------------------------------
/* Otorga permisos de CRUD (Create, Read, Update, Delete)
en la tabla clientes al usuario PP_grillo. */
grant create, select, update, delete on campamento.clientes to 'PP_GRILLO'@'localhost';
flush privileges;
------------------------------------------------------------------------------------------------
-- Otorga permisos de solo selección en la tabla pago_campamento al usuario PP_grillo.
grant select on campamento.pago_campamento to 'PP_GRILLO'@'localhost';
flush privileges;
------------------------------------------------------------------------------------------------
-- Verifica los permisos asignados al usuario PP_GRILLO y muestra los permisos.
show grants for 'PP_GRILLO'@'localhost';
