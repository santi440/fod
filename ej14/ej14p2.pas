program ej14p2;
const
	valorAlto = 9999;
type
	existencia = record
		 codigo_pcia:integer;
		 nombre_prov: string;
		 codigo_loc: integer;
		 nombre_loc: string;
		 sin_luz:integer;
		 sin_gas:integer;
		 viviendas_chapa:integer;
		 sin_agua: integer;
		 sin_sanitarios:integer;
	end;
	
	avance = record
		 codigo_pcia:integer;
		 codigo_loc: integer;
		 con_luz:integer;
		 con_gas:integer;
		 viviendas_construidas:integer;
		 con_agua: integer;
		 con_sanitarios:integer;
	end;

	base_de_datos = file of existencia;
	
	provincia = file of avance;
	nacion = array[1..10] of provincia;
	reg = array[1..10]of avance;

procedure leerDetalles(var detalle: provincia; var reg: avance);
begin
	if(not eof(detalle))then
		read(detalle,reg)
	else
		reg.codigo_pcia:= valorAlto;
end;

procedure leerMaestro(var detalle: base_de_datos; var reg: existencia);
begin
	if(not eof(detalle))then
		read(detalle,reg)
	else
		reg.codigo_pcia:= valorAlto;
end;

procedure humano_maquina (var maestro: base_de_datos; var detalles: nacion; var regd: reg);
var
	fuentes : array[1..10] of text;
	fuenteM: text;
	regm: existencia;
	registroD: avance;
	i:integer;
	filename: string;
begin
	assign(maestro,'maestro');
	assign(fuenteM,'maestro.txt');
	reset(fuenteM);
	rewrite(maestro);
	while (Not eof(fuenteM))do
	begin
		readln(fuenteM,regm.codigo_pcia,regm.nombre_prov);
		readln(fuenteM,regm.codigo_loc,regm.nombre_loc);
		readln(fuenteM,regm.sin_luz,regm.sin_gas, regm.viviendas_chapa, regm.sin_agua, regm.sin_sanitarios);
		write(maestro,regm);
	end;
	for i:= 1 to 10 do
	begin
		Str(i,filename);
		assign(fuentes[i],'det' + filename + '.txt');
		reset(fuentes[i]);
		assign(detalles[i],'det' + filename);
		rewrite(detalles[i]);
		while(not eof(fuentes[i]))do
		begin
			readln(fuentes[i],registroD.codigo_pcia, registroD.codigo_loc,registroD.con_luz,registroD.con_gas, registroD.viviendas_construidas, registroD.con_agua, registroD.con_sanitarios);
			write(detalles[i], registroD);
		end;
		reset(detalles[i]);
		leerDetalles(detalles[i],regd[i]);
	end;
end;

procedure minimo (var detalles: nacion; var regd: reg; var min: avance);
var
	mini,pos,i: integer;
begin
	mini:= valorAlto;
	for i:= 1 to 10 do
	begin
		if(regd[i].codigo_pcia <= mini)then
		begin
			pos:= i;
			mini:= regd[i].codigo_pcia;
		end;
	end;
	min:= regd[pos];
	leerDetalles(detalles[pos], regd[pos]);
end;



var
	maestro: base_de_datos;
	detalles: nacion;
	regm: existencia;
	regd: reg;
	min: avance;
begin
	humano_maquina(maestro,detalles,regd);
	leerMaestro(maestro,regm);
	while (regm.codigo_pcia <> valorAlto)do
	begin
		minimo(detalles,regd,min);
		
		while((min.codigo_pcia <> regm.codigo_pcia) and (min.codigo_loc <> regm.codigo_loc))do
			leerMaestro(maestro,regm);
		
		regm.sin_luz:= regm.sin_luz - min.con_luz;
		regm.sin_agua:= regm.sin_agua - min.con_agua;
		regm.sin_gas:= regm.sin_gas - min.con_gas;
		regm.sin_sanitarios:= regm.sin_sanitarios - min.con_sanitarios;
		regm.viviendas_chapa:= regm.viviendas_chapa - min.viviendas_construidas;
		
	end;
	reset(maestro);
	while(not eof(maestro))do
	begin
		read(maestro,regm);
		if(regm.viviendas_chapa = 0)then
			writeln('Provincia ', regm.codigo_pcia, ' localidad ', regm.codigo_loc , ' no tiene casas de chapa');
	end;
end.
