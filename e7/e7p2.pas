program e7p2;
const
	valorAlto = 9999;
type
	municipio= record
		codigo_loc: integer;
		codigo_cepa: integer;
		cant_activos: integer;
		cant_nuevos: integer;
		cant_recuperados: integer;
		cant_fallecidos: integer;
	end;

	covid= record
		codigo_loc: integer;
		nombre_loc: String;
		codigo_cepa: integer;
		nombre_cepa: String;
		cant_activos: integer;
		cant_nuevos: integer;
		cant_recuperados: integer;
		cant_fallecidos: integer;
	end;
	
	detalle = file of municipio;
	v_detalle = array[1..10] of detalle;
	v_regDetalle = array [1..10] of municipio;
	
	maestro = file of covid;

procedure leer (var d:detalle; var v: municipio);
begin	
	if(not EOF(d))then read(d,v) 
	else v.codigo_loc:= valorAlto;
end;

procedure Asignacion (var maes : maestro;var detalles :v_detalle;var v_regd: v_regDetalle);
var
	i:integer;
	fuenteM: Text;
	regm: covid;
	regd: municipio;
	fuenteD: array[1..10] of Text;
	filename:String;
begin
	Assign(maes, 'maestro');
	Assign(fuenteM,'maestro.txt');
	reset(fuenteM);
	rewrite(maes);
	while( not EOF (fuenteM))do
	begin
		readln(fuenteM,regm.codigo_loc,regm.nombre_loc);
		readln(fuenteM,regm.codigo_cepa,regm.nombre_cepa);
		readln(fuenteM,regm.cant_activos,regm.cant_nuevos,regm.cant_recuperados, regm.cant_fallecidos);
		write(maes,regm);
	end;
	
	for i:= 1 to 10 do
	begin
		Str(i,filename);
		Assign(detalles[i], 'det'+ filename);
		Assign(fuenteD[i],'det' + filename + '.txt');
		reset(fuenteD[i]);
		rewrite(detalles[i]);
		while( not EOF (fuenteD[i]))do
		begin
			readln(fuenteD[i],regd.codigo_loc,regd.codigo_cepa,regd.cant_activos,regd.cant_nuevos,regd.cant_recuperados,regd.cant_fallecidos);
			write(detalles[i],regd);
		end;
		reset(detalles[i]);
		leer(detalles[i], v_regd[i]);
	end;
end;

procedure minimo (var detalles: v_detalle; var minimo: municipio;var v_regd:v_regDetalle);
var
	min,pos,i: integer;
begin
	min:= 9999;
	for i:= 1 to 10 do
		begin
			if(v_regd[i].codigo_loc <= min)then
			begin
				pos:= i;
				min:= v_regd[i].codigo_loc;
			end;
		end;
	minimo:= v_regd[pos];
	writeln(minimo.codigo_loc, ' ' , pos);
	leer(detalles[pos],v_regd[pos]);
end;

procedure actualizar (var maes: maestro; var detalles:v_detalle; var v_regd: v_regDetalle);
var
	min: municipio;
	regm: covid; 
begin
	minimo(detalles,min,v_regd);
	reset(maes);
	read(maes,regm);
	while (min.codigo_loc <> valorAlto)do
	begin
	
		while((regm.codigo_loc <> min.codigo_loc) and (regm.codigo_cepa <> min.codigo_cepa))do
			read(maes,regm);
			
		regm.cant_activos:= min.cant_activos;
		regm.cant_nuevos:= min.cant_nuevos;
		regm.cant_fallecidos:= regm.cant_fallecidos + min.cant_fallecidos;
		regm.cant_recuperados:= regm.cant_recuperados + min.cant_recuperados;
		//writeln(regm.codigo_loc, ' ', regm.codigo_cepa);
		seek(maes,filepos(maes) -1);
		write(maes,regm);
		minimo(detalles,min,v_regd);

		//writeln('termino');
	end;
end;

var
	maes : maestro;
	detalles :v_detalle;
	v_regd: v_regDetalle;
	output: TEXT;
	regm: covid;
begin
	Asignacion(maes,detalles,v_regd);
	actualizar(maes,detalles,v_regd);
	Assign(output,'salida.txt');
	rewrite(output);
	reset(maes);
	while(not eof(maes))do
	begin
		read(maes,regm);
		if(regm.cant_activos>50)then
			writeln(output, 'Nombre municio ', regm.nombre_loc, ' nombre cepa ', regm.nombre_cepa ,' ',  regm.cant_activos, ' ', regm.cant_nuevos,' ', regm.cant_recuperados, ' ', regm.cant_fallecidos)
	end;
end.
