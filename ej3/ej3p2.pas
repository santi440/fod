program ej3p2;
type
	producto= record
		codigo: integer;
		precio: real;
		stock: integer;
		minimo: integer;
		nombre: String;
	end;
	venta = record
		codigo: integer;
		cant: integer;
	end;

	maestro = file of producto;
	detalle = file of venta;

	
procedure actualizar(var m: maestro; var d: detalle);
var
	produM : producto;
	ventaD: venta;
begin
	Reset(m);
	reset(d);
	while(not EOF (d))do
	begin
		read(m,produM);
		read(d,ventaD);
		while(produM.codigo <> ventaD.codigo)do
		begin
			read(m,produM);
		end;
		while(produM.codigo = ventaD.codigo)do
		begin
			produM.stock:= produM.stock - ventaD.cant;
			read(d,ventaD);
		end;
		seek(m, filepos(m) -1);
		write(m,produM);
	end;
	close(m);
	close(d);
end;

procedure exportar(var m:maestro);
var
	p: producto;
	output: Text;
begin
	Reset(m);
	Assign(output,'stock_minimo.txt');
	rewrite(output);
	while(not EOF(m))do
	begin
		read(m,p);
		if(p.stock < p.minimo) then
		begin
			writeln(output,'El producto ', p.codigo, ' tiene ', p.stock, ' existencias y minimamente deberia tener ', p.minimo, '.Faltan  ', p.minimo - p.stock, ' ', p.nombre);
			writeln(p.codigo, ' cumplio');
		end;
	end;
	close(m);
	close(output);
end;

var
	maes: maestro;
	det: detalle;
	op:integer;
begin
	Assign(maes, 'maestro');
	Assign(det,'detalle');
	writeln('*********MENU**********');
	writeln('(1) Actualizar');
	writeln('(2) Exportar');
	write('Elegi una opcion: ');
	readln(op);
	writeln('***********************');
	case op of
		1: actualizar(maes,det);
		2: exportar(maes);
	end;
	
end.
