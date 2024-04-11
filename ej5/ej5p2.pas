program ej5p2;
const
	valorAlto= 9999;
type
		producto = record
		codigo: integer;
		nombre: string;
		descripcion:string;
		stock_disponible:integer;
		stock_minimo:integer;
		precio:real;
	end;
	
	venta= record
		codigo:integer;
		cant: integer;
	end;
	
	productos= file of producto;
	
	detalle= file of venta;
	ventas= array[1..30] of detalle;
	reg_venta = array[1..30] of venta;
	
	
procedure Asignacion (var maestro: productos;var detalles: ventas);
var
	fuente: Text;
	det: array[1..30] of Text;
	p: producto;
	v:venta;
	i:integer;
	filename:string;
begin
	Assign(fuente,'maestro.txt');
	Assign(maestro,'maestro');
	Reset(fuente);
	rewrite(maestro);
	while (not EOF (fuente))do
	begin
		readln(fuente,p.nombre);
		readln(fuente,p.codigo,p.stock_disponible,p.stock_minimo,p.precio,p.descripcion);
		write(maestro,p);
	end;
	writeln('maestro creado');
	for i:= 1 to 30 do
	begin
		Str(i,filename);
		Assign(det[i],'det' + filename +'.txt');
		Assign(detalles[i], 'det' + filename);
		reset(det[i]);
		rewrite(detalles[i]);
		while(not eof(det[i]))do
			begin
				readln(det[i],v.codigo,v.cant);
				write(detalles[i], v);
			end;
		writeln('detalle ', i, ' creado');
	end;
end;

procedure leer(var v:venta; var d:detalle);
begin
	if(not eof(d))then
		read(d,v)
	else
		v.codigo:= valorAlto;
end;

procedure minimo (var registros: reg_venta; var detalles: ventas; var min: venta);
var
	i:integer;
	cod_min: integer;
	pos: integer;
begin
	cod_min:= 10000;
	for i:=1 to 30 do
	begin
		if(registros[i].codigo < cod_min)then
		begin
			cod_min := registros[i].codigo;
			pos:= i;
		end;
	end;
	writeln('valor pos ', pos);
	min:= registros[pos];
	leer(registros[pos], detalles[pos]);
end;

procedure ActualizarConOutput (var maestro:productos;var detalles:ventas);
var
	regm: producto;
	registros: reg_venta;
	output:Text;
	i:integer;
	min: venta;
begin
	Assign(output,'Informe.txt');
	rewrite(output);
	reset (maestro);
	for i:= 1 to 30 do
	begin
		reset(detalles[i]);
		leer(registros[i],detalles[i]);
	end;
	minimo(registros,detalles,min);
	read(maestro,regm);
	while (min.codigo <> valorAlto)do
	begin
		while(regm.codigo <> min.codigo)do
			read(maestro,regm);
		while(regm.codigo = min.codigo)do
		begin
			regm.stock_disponible:= regm.stock_disponible - min.cant;
			minimo(registros,detalles,min);
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regm);
		if(regm.stock_disponible < regm.stock_minimo)then
			begin
			write(output,'El producto ', regm.nombre, ' descripcion: ', regm.descripcion, ' tiene ', regm.stock_disponible, ' productos a $', regm.precio, '. Se encuentra por debajo del minimo');
			writeln('actualizado', regm.codigo);
			end;
	end;
	close(maestro);
	close(output);
end;

procedure ActualizarPostOutput (var maestro:productos;var detalles:ventas);
var
	regm: producto;
	registros: reg_venta;
	output:Text;
	i:integer;
	min: venta;
begin
	Assign(output,'Informe.txt');
	rewrite(output);
	reset (maestro);
	read(maestro,regm);
	for i:= 1 to 30 do
	begin
		reset(detalles[i]);
		leer(registros[i],detalles[i]);
	end;
	minimo(registros,detalles,min);
	while (min.codigo <>valorAlto)do
	begin
		while(regm.codigo <> min.codigo)do
			read(maestro,regm);
		while(regm.codigo = min.codigo)do
		begin
			regm.stock_disponible:= regm.stock_disponible - min.cant;
			minimo(registros,detalles,min);
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regm);
	end;
	reset(maestro);
	while not EOF(maestro) do
	begin
		read(maestro,regm);
		if(regm.stock_disponible < regm.stock_minimo)then
			begin
			writeln(output,'El producto ', regm.nombre, ' descripcion: ', regm.descripcion, ' tiene ', regm.stock_disponible, ' productos a $', regm.precio, '. Se encuentra por debajo del minimo');
			writeln('actualizado ', regm.codigo);
			end;
	end;
	close(maestro);
	close(output);
end;

var
	maestro: productos;
	detalles: ventas;
begin
	Asignacion(maestro,detalles);
	//ActualizarConOutput(maestro,detalles);
	ActualizarPostOutput(maestro,detalles);
end.
