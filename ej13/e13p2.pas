program ej13p2;
const
	valorAlto = 'zzzzz';
type
	tfecha= record
		dia: integer;
		mes: integer;
		anno: integer;
	end;
	
	thora = record
		hora:integer;
		min: integer;
	end;
	vuelo = record
		destino: String;
		fecha: tfecha;
		hora: thora;
		asientos: integer;
	end;
	
	archivo= file of vuelo;
	
procedure leer ( var a: archivo; var reg: vuelo);
begin
	if(not eof(a))then
		read(a,reg)
	else
		reg.destino:= valorAlto;
end;

procedure inicializarDeTexto(var maestro,det1,det2: archivo);
var
	f1,f2,f3: Text;
	aux: vuelo;
begin
	assign(maestro,'maestro');
	assign(f1,'maestro.txt');
	reset(f1);
	rewrite(maestro);
	while(not eof (f1))do
	begin
		readln(f1,aux.destino);
		readln(f1,aux.fecha.dia,aux.fecha.mes,aux.fecha.anno);
		readln(f1,aux.hora.hora,aux.hora.min);
		readln(f1,aux.asientos);
		write(maestro,aux);
	end;
	
	assign(det1,'det1');
	assign(f2,'det1.txt');
	reset(f2);
	rewrite(det1);
	while(not eof (f2))do
	begin
		readln(f2,aux.destino);
		readln(f2,aux.fecha.dia,aux.fecha.mes,aux.fecha.anno);
		readln(f2,aux.hora.hora,aux.hora.min);
		readln(f2,aux.asientos);
		write(det1,aux);
	end;
	
	assign(det2,'det2');
	assign(f3,'det2.txt');
	reset(f3);
	rewrite(det2);
	while(not eof (f3))do
	begin
		readln(f3,aux.destino);
		readln(f3,aux.fecha.dia,aux.fecha.mes,aux.fecha.anno);
		readln(f3,aux.hora.hora,aux.hora.min);
		readln(f3,aux.asientos);
		write(det2,aux);
	end;
	close(f1);
	close(f2);
	close(f3);
end;

function fechaIgual(f1,f2: tfecha):boolean;
begin
	fechaIgual:= ((f1.dia = f2.dia)and (f1.mes = f2.mes) and (f1.anno = f2.anno));
end;

function horaIgual(h1,h2: thora):boolean;
begin
	horaIgual:= ((h1.hora = h2.hora)and (h1.min = h2.min));
end;

procedure minimo (var reg1,reg2,min: vuelo; var det1,det2: archivo);
begin
	if(reg1.destino < reg2.destino)then //primero por destino
	begin
		min:= reg1;
		leer(det1,reg1);
	end
	else
		if(reg1.destino > reg2.destino)then
		begin
			min:= reg2;
			leer(det2,reg2);
		end
	else 
		if(reg1.destino = reg2.destino)then
		begin
			if((reg1.fecha.dia < reg2.fecha.dia) or (reg1.fecha.mes < reg2.fecha.mes) or (reg1.fecha.anno < reg2.fecha.anno))then //por fecha
			begin
				min:= reg1;
				leer(det1,reg1);
			end
			else 
				if((reg1.fecha.dia > reg2.fecha.dia) or (reg1.fecha.mes > reg2.fecha.mes) or (reg1.fecha.anno > reg2.fecha.anno))then
				begin
						min:= reg2;
						leer(det2,reg2);
				end
				else
				begin
					if((reg1.hora.hora < reg2.hora.hora) and (reg1.hora.min < reg2.hora.min))then // por hora
					begin
						min:= reg1;
						leer(det1,reg1);
					end
					else //son iguales
					begin
						min:= reg2;
						leer(det2,reg2);
					end;
				end;
		end;
end;

procedure informar (var output:text;regm:vuelo; minima: integer);
begin	
	if(regm.asientos < minima)then
	begin
		writeln(output,'Destino: ', regm.destino,
					   ' fecha: ', regm.fecha.dia,'/',regm.fecha.mes,'/',regm.fecha.anno,
					   ' hora: ',regm.hora.hora,':',regm.hora.min,
					   ' asientos disponibles: ',regm.asientos);
	end;
end;

procedure actualizar (var maestro,det1,det2: archivo; minima:integer; var output:text);
var
	regm, reg1,reg2,min: vuelo;
	dest:string;
	fecha: tfecha;
	hora:thora; 
begin
	reset(maestro);
	reset(det1);
	reset(det2);
	leer(maestro,regm);
	leer(det1,reg1);
	leer(det2,reg2);
	minimo(reg1,reg2,min,det1,det2);
	while (regm.destino <> valorAlto)do
	begin
		dest:= regm.destino;
		writeln('maestro: ', regm.destino);
		writeln('min: ', min.destino);
		while (min.destino <> dest)do
			read(maestro,regm);
			
		while(dest = min.destino)do
		begin
			fecha:= regm.fecha;
			while (not fechaIgual(fecha,min.fecha))do
				read(maestro,regm);
				
			while((min.destino = dest) and (fechaIgual(fecha,min.fecha)))do
			begin
				hora:= regm.hora;
				while (not horaIgual(min.hora, hora))do
					read(maestro,regm);

				while((min.destino = dest) and (fechaIgual(fecha,min.fecha)) and (horaIgual(min.hora, hora)))do
				begin
					regm.asientos:= regm.asientos - min.asientos;
					minimo(reg1,reg2,min,det1,det2);
					writeln('min: ', min.destino);
				end;
				writeln('escribo ', regm.asientos);
				informar(output,regm,minima);
				seek(maestro,filepos(maestro)-1);
				write(maestro,regm);
				leer(maestro,regm);
				writeln('maestro: ', regm.destino);
			end;
		end;
	end;
	close(maestro);
	close(det1);
	close(det2);
end;

procedure imprimir (var maestro: archivo);
var
	regm: vuelo;
begin
	reset(maestro);
	while (not eof(maestro))do
	begin
		read(maestro,regm);
		writeln('Destino: ', regm.destino,
			    ' fecha: ', regm.fecha.dia,'/',regm.fecha.mes,'/',regm.fecha.anno,
				' hora: ',regm.hora.hora,':',regm.hora.min,
				' asientos disponibles: ',regm.asientos);
	end;
	close(maestro);
end;


var
	maestro,det1,det2: archivo;
	minima: integer; 
	output: text;
begin
	inicializarDeTexto(maestro,det1,det2);
	write('Ingresa el minimo de votos para el informe: ');
	readln(minima);
	assign(output,'informe.txt');
	rewrite(output);
	actualizar(maestro,det1,det2,minima,output);
	imprimir(maestro);
end.
