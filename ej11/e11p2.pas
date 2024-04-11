program e11p2;
const
	valorAlto = 32767;
type
	acceso = record
		anio: integer;
		mes: integer;
		dia: integer;
		idUsuario: integer;
		tiempo_acceso : real;
	end;
	
	servidor = file of acceso;

procedure leer(var maestro: servidor; var d:acceso);
begin
	if(not eof (maestro))then
		read(maestro,d)
	else
		d.anio := valorAlto;
end;

procedure inicializar (var maes: servidor);
var
	fuente: text;
	regm: acceso;
begin
	assign(fuente,'servidor.txt');
	assign(maes,'maestro');
	reset(fuente);
	rewrite(maes);
	while (not eof (fuente))do
	begin
		readln(fuente, regm.anio,regm.mes,regm.dia,regm.idUsuario, regm.tiempo_acceso);
		write(maes,regm);
	end;
	close(fuente);
	reset(maes);
end;


var 
	maestro : servidor;
	anio: integer;
	tDia,tMes,tAnio: real;
	actDia,actMes: integer;
	regm: acceso;
begin
	inicializar(maestro);
	write('Ingrese anio a buscar: ');
	readln(anio);
	leer(maestro,regm);
	while((regm.anio <> valorAlto) and (regm.anio <> anio))do
		leer(maestro,regm);
	if(regm.anio = anio)then
	begin
		tAnio:= 0;
		writeln('Anio ', anio, ': ');
		while (anio = regm.anio) do
		begin
			actMes:= regm.mes;
			tMes:= 0;
			writeln('     Mes ', actMes, ': ');
			while((regm.anio = anio) and (regm.mes = actMes))do
			begin
				actDia:= regm.dia;
				tDia:= 0;
				writeln('        Dia ', actDia, ': ');
				while((regm.anio = anio) and (regm.mes = actMes) and (regm.dia = actDia))do
				begin
					writeln('            Usario: ', regm.idUsuario, 'Tiempo Total de acceso en el dia ', actDia, ' mes ',  actMes, ' ', regm.tiempo_acceso:0:2);
					tDia := tDia + regm.tiempo_acceso;
					leer(maestro,regm);
				end;
				writeln('Tiempo total acceso dia ', actDia, ' mes ', actMes, ': ', tDia:0:2);
				tMes:= tDia + tMes;
			end;
			writeln('Tiempo total acceso mes ', actMes, ': ', tMes:0:2);
			tAnio:= tAnio + tMes;
		end;
		writeln('Tiempo total acceso anio ', anio, ': ', tAnio:0:2);
	end
	else
		writeln('anio no encontrado')
		
end.
