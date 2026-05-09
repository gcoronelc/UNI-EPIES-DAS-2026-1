select * from TIPO_CLIENTE;
go

select * from CLIENTE;
go

select * from PRODUCTO;
go


select * from VENTA;
go

declare @id int;
set @id = 150;
select * from VENTA where id_venta = @id;
select * from DETALLE_VENTA where id_venta = @id;
go






