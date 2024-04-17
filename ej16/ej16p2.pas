program ej16p2;
const
	valorAlto = 9999;
	dimF = 10;
type
	moto= record
		codigo: integer;
		nombre:string;
		descripcion:string;
		modelo:string;
		marca:string;
		stock: integer; 
	end;
	
	master = file of moto;
	
	venta = record
		codigo: integer;
		precio: real;
		dia: integer;
		mes: integer;
		anno: integer;
	end;

	vendedor = file of venta;
	detalles = array[1..dimF] of vendedor;
	reg = array[1..dimF] of venta;

procedure textoABinario(var m:master; var v: detalles);
var
	fuenteM: text;
	fuenteD: array[1..dimF] of text;
	regm: moto;
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
		readln(fuenteM, regm.codigo,regm.nombre); 
		readln(fuenteM, regm.descripcion);
		readln(fuenteM, regm.modelo);
		readln(fuenteM, regm.marca, regm.stock);
		write(m,regm);
	end;
	close(m);
	close(fuenteM);
	
	for i:= 1 to dimF do
	begin
		str(i,filename);
		assign(v[i],'detalle' + filename);
		assign(fuenteD[i],'det'+ filename + '.txt');
		reset(fuenteD[i]);
		rewrite(v[i]);
		while not eof(fuenteD[i])do
		begin
			readln(fuenteD[i],regd.codigo, regd.precio, regd.anno, regd.mes, regd.dia);
			write(v[i],regd);
		end;
		close(v[i]);
		close(fuenteD[i]);
	end;
end;

procedure leerDetalles(var det:vendedor; var regd: venta);
begin
	if(not eof(det)) then
		read(det,regd)
	else
		regd.codigo:= valorAlto;
end;

procedure inicializarVector(var ventas:detalles; var regd: reg);
var
	i:integer;
begin
	for i:= 1 to dimF do
	begin
		reset(ventas[i]);
		leerDetalles(ventas[i], regd[i]);
	end;
end;

procedure cerrarDetalles (var ventas:detalles);
var
	i:integer;
begin
	for i:= 1 to dimF do
	begin
		close(ventas[i]);
	end;
end;

procedure minimo(var dets:detalles; var regd: reg; var min:venta );
var
	i:integer;
	chico,pos: integer;
begin
	chico:= valorAlto;
	pos:= 1;
	for i:= 1 to dimF do
	begin
		if(regd[i].codigo < chico)then
		begin
			chico:= regd[i].codigo;
			pos:= i;
		end;
	end;
	min:=regd[pos];
	leerDetalles(dets[pos], regd[pos]);
end;

procedure actualizar (var maestro:master; var det:detalles);
var
	regd: reg;
	regm,maxAct: moto;
	min: venta;
	cant,maxCant:integer;
begin
	
	reset(maestro);
	inicializarVector(det,regd);
	minimo(det,regd,min);
	maxCant:= 0;
	
	while (min.codigo <> valorAlto)do
	begin
		read(maestro,regm);
		while(min.codigo <> regm.codigo)do
			read(maestro,regm);
		
		cant:= 0;
		while(min.codigo = regm.codigo)do
		begin
			regm.stock:= regm.stock - 1;
			cant:= cant + 1;
			minimo(det,regd,min);
		end;
		if(cant > maxCant)then
		begin
			maxCant:= cant;
			maxAct:= regm;
		end;
		
		seek(maestro,filepos(maestro)-1);
		write(maestro,regm);
	end;
	
	if(maxCant > 0)then
		writeln('La moto que mas se vendio fue: ', maxAct.nombre, ' ', maxAct.modelo, ' ', maxAct.marca, ' con un total de ', maxCant, ' unidades vendidas');
end;

var
	maestro:master;
	det:detalles;
begin
	textoABinario(maestro,det);
	actualizar(maestro,det);
end.
