CREATE TABLE dbo.autor  
   (k_id int PRIMARY KEY NOT NULL IDENTITY(1,1),
   n_nombre varchar(255) NOT NULL,
   n_ciudad varchar(58) NOT NULL,
   n_correo varchar(320) NOT NULL UNIQUE,
   f_nacimiento date NOT NULL)
GO  
CREATE TABLE dbo.editorial  
   (k_id int PRIMARY KEY NOT NULL IDENTITY(1,1),
   n_nombre varchar(255) NOT NULL,
   n_direccion varchar(128) NOT NULL,
   n_correo varchar(320) NOT NULL UNIQUE,
   n_telefono varchar(20) NOT NULL,
   i_max_libros int NULL,
   i_total_libros DEFAULT 0 NOT NULL)
GO  
CREATE TABLE dbo.libro  
   (k_id int PRIMARY KEY NOT NULL IDENTITY(1,1),
   n_titulo varchar(255) NOT NULL,
   i_anho int NOT NULL,
   i_paginas int NOT NULL,
   n_genero varchar(30) NOT NULL,
   fk_editorial int FOREIGN KEY REFERENCES editorial(k_id) ON DELETE CASCADE NOT NULL,
   fk_autor int FOREIGN KEY REFERENCES autor(k_id) ON DELETE CASCADE NOT NULL)
GO

CREATE TRIGGER sumarlibro
ON libro
FOR INSERT
AS
	DECLARE @fk_editorial int = (SELECT fk_editorial FROM inserted)
	UPDATE editorial SET i_total_actual = (SELECT COUNT(k_id) FROM libro WHERE fk_editorial = @fk_editorial) 
										   WHERE k_id = @fk_editorial
GO

ALTER TABLE editorial
	ADD CONSTRAINT ck_max_libros
	check (i_max_libros >= COUNT(k_id) OR i_max_libros IS NULL);

ALTER TABLE libro
	ADD CONSTRAINT ck_anho
	check (i_anho <= YEAR(GETDATE()));