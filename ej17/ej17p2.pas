program ej17p2;
const
	valorAlto = 'zzzzzz';
type
	COVID= record
	codigo_loc:integer;
	nombre_loc: string;
	codigo_muni:integer;
	nombre_muni:string;
	codigo_hospital:integer;
	nombre_hospital: string;
	fecha: string; // me desentiendo porque total no lo uso, de otra manera se pueden tres variable int o un registro fecha 
	cant_casos:integer;
	end;

	master= file of COVID;
	
procedure textoABinario (var maestro: master);
var
	texto: text;
	regm: COVID;
begin
	assign(texto,'maestro.txt');
	reset(texto);
	rewrite(maestro);
	
	while (not eof(texto))do
	begin
		readln(texto,regm.codigo_loc, regm.nombre_loc);
		readln(texto,regm.codigo_muni, regm.nombre_muni);
		readln(texto,regm.codigo_hospital, regm.nombre_hospital);
		readln(texto,regm.fecha);
		readln(texto,regm.cant_casos);
		write(maestro, regm);
	end;
	
	close(texto);
	close(maestro);
end;

procedure leer(var maestro: master; var regm:COVID);
begin
	if(not eof(maestro))then 
		read(maestro,regm)
	else
		regm.nombre_loc:= valorAlto;
end;


var 
	maestro: master;
	regm: COVID;
	totalLoc,totalMuni,totalHospital,total: integer;
	actLoc,actMuni,actHospital: String;
	output: text;
begin
	assign(output,'salida.txt');
	rewrite(output);
	assign(maestro,'maestro');
	textoABinario(maestro);
	reset(maestro);
	leer(maestro,regm);
	total:=0;
	while(regm.nombre_loc <> valorAlto)do
	begin
		actLoc:= regm.nombre_loc;
		totalLoc:= 0;
		writeln('Nombre Localidad: ', actLoc);
		while(regm.nombre_loc = actLoc) do
		begin
			actMuni:= regm.nombre_muni;
			totalMuni:= 0;
			writeln('	Nombre Municipio: ', actMuni);
			while ((regm.nombre_loc = actLoc) and (regm.nombre_muni = actMuni))do
			begin
				actHospital:= regm.nombre_hospital;
				totalHospital:= 0;
				while ((regm.nombre_loc = actLoc) and (regm.nombre_muni = actMuni) and  (regm.nombre_hospital = actHospital))do
				begin
					totalHospital := totalHospital + regm.cant_casos;
					leer(maestro,regm);
				end;
				writeln('		Nombre Hospital: ', actHospital , ' cant casos: ', totalHospital);
				totalMuni:= totalMuni + totalHospital;
			end;
			if(totalMuni >= 1500)then
			begin
				writeln(output,actLoc);
				writeln(output,totalMuni,' ', actMuni);
			end;
			writeln('	Cantidad de casos de la municipalidad: ' , totalMuni);
			totalLoc:= totalLoc + totalMuni;
		end;
		writeln('Cantidad de casos de la localidad: ' , totalLoc);
		total:= total + totalLoc;
	end;
	writeln('Cantidad de casos de la provincia: ' , total);
	close(output);
end.
