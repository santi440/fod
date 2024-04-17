program ej15p2;
const
	valorAlto = 9999;
	valorBajo = -9999;
	dimF = 100;
type 
	calendario = record
		dia: integer;
		mes: integer;
		anno: integer;
	end;
	
	emision = record
		fecha: calendario;
		codigo: integer;
		nombre: string;
		descripcion: string; 
		precio: real; 
		total: integer;
		vendidos: integer;
	end;
	
	maestro = file of emision;
	
	venta= record
		fecha: calendario;
		codigo:integer;
		vendidos: integer;
	end;
	
	detalle = file of venta;
	vendido = array[1..dimF] of detalle;
	registros = array[1..dimF] of venta;
	
procedure textoABinario(var m:maestro; var v: vendido);
var
	fuenteM: text;
	fuenteD: array[1..dimF] of text;
	regm: emision;
	regd: venta;
	i:integer;
	filename: string;
begin
	assign(m,'maestro');
	assign(fuenteM,'maestro.txt');
	reset(fuenteM);
	rewrite(m);
	while not eof(fuenteM)do
	begin
		readln(fuenteM,regm.fecha.anno, regm.fecha.mes, regm.fecha.dia, regm.codigo, regm.precio,regm.total, regm.vendidos, regm.nombre);
		readln(fuenteM,regm.descripcion);
		write(m,regm);
	end;
	close(m);
	close(fuenteM);
	
	for i:= 1 to dimF do
	begin
		str(i,filename);
		assign(v[i],'detalles/detalle' + filename);
		assign(fuenteD[i],'detalles/detalle'+ filename + '.txt');
		reset(fuenteD[i]);
		rewrite(v[i]);
		while not eof(fuenteD[i])do
		begin
			readln(fuenteD[i],regd.fecha.anno, regd.fecha.mes, regd.fecha.dia, regd.codigo, regd.vendidos);
			write(v[i],regd);
		end;
		close(v[i]);
		close(fuenteD[i]);
	end;
end;

procedure leerDetalles(var det:detalle; var regd:venta);
begin
	if (not eof(det))then
		read(det,regd)
	else
		regd.fecha.anno := valorAlto;
end;

procedure inicializarVector(var ventas:vendido; var reg: registros);
var
	i:integer;
begin
	for i:= 1 to dimF do
	begin
		reset(ventas[i]);
		leerDetalles(ventas[i], reg[i]);
	end;
end;

procedure cerrarDetalles (var ventas:vendido);
var
	i:integer;
begin
	for i:= 1 to dimF do
	begin
		close(ventas[i]);
	end;
end;

procedure minimo (var reg: registros; var ventas:vendido; var min: venta);
var
	i,pos: integer;
	bajo: venta;
begin
	bajo.fecha.anno := valorAlto;
	bajo.fecha.mes := valorAlto;
	bajo.fecha.dia := valorAlto;
	bajo.codigo:= valorAlto;
	pos:= 1;
	for i:= 1 to dimF do
	begin
		if (reg[i].fecha.anno < bajo.fecha.anno) or
		   ((reg[i].fecha.anno = bajo.fecha.anno) and (reg[i].fecha.mes < bajo.fecha.mes)) or
		   ((reg[i].fecha.anno = bajo.fecha.anno) and (reg[i].fecha.mes = bajo.fecha.mes) and (reg[i].fecha.dia < bajo.fecha.dia)) or
		   ((reg[i].fecha.anno = bajo.fecha.anno) and (reg[i].fecha.mes = bajo.fecha.mes) and (reg[i].fecha.dia = bajo.fecha.dia) and  (reg[i].codigo < bajo.codigo))then
			begin
				bajo:= reg[i];
				pos:= i;
			end;
	end;
	min:= reg[pos];
	leerDetalles(ventas[pos], reg[pos]);
end;

procedure imprimirRegm (reg: emision);
begin
	writeln(reg.fecha.dia, '/', reg.fecha.mes, '/', reg.fecha.anno, ' codigo: ', reg.codigo, ' con ', reg.vendidos, ' semanarios vendidos');
end;

function mismaRevista(regm:emision; regd:venta):boolean;
begin
	mismaRevista:= ((regm.fecha.anno = regd.fecha.anno) and (regm.fecha.mes = regd.fecha.mes) and (regm.fecha.dia = regd.fecha.dia) and  (regm.codigo = regd.codigo))
end;

procedure actualizar (var revistas:maestro; var ventas:vendido);
var
	reg: registros;
	regm,maxVentas,minVentas: emision;
	min,act:venta;
begin
	reset(revistas);
	inicializarVector(ventas,reg);
	minimo(reg,ventas,min);
	
	maxVentas.vendidos:= valorBajo;
	minVentas.vendidos:= valorAlto;
	
	while(min.fecha.anno <> valorAlto)do
	begin
		read(revistas,regm);
		
		//revista que acabo de leer no es la mas chica (no se vendio nada)
		while(not mismaRevista(regm,min)) do
			read(revistas,regm);
		
		//iguales
		act:= min;
		while ((min.fecha.anno <> valorAlto) and(act.fecha.anno = min.fecha.anno) and (act.fecha.mes = min.fecha.mes) and (act.fecha.dia = min.fecha.dia) and  (act.codigo = min.codigo))do
		begin
			regm.vendidos:= regm.vendidos + min.vendidos;
			minimo(reg,ventas,min);
		end;
		//termine con ese en los 100 registros
		
		if(regm.vendidos < minVentas.vendidos) then
			minVentas:= regm
		else
			if(regm.vendidos > maxVentas.vendidos)then
				maxVentas:= regm;
		
		seek(revistas,filepos(revistas)-1);
		write(revistas,regm);
	end;
	close(revistas);
	cerrarDetalles(ventas);
    writeln('Actualizacion realizada con exito.');
    writeln('El semanario mas vendido fue: ');
    imprimirRegm(maxVentas);
    writeln('El semanario menos vendido fue: ');
    imprimirRegm(minVentas);
end;

var
	revistas: maestro;
	ventas: vendido;
begin
	textoABinario(revistas,ventas);
	actualizar(revistas,ventas);
end.
