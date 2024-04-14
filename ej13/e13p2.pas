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

procedure minimo (var vuelo1,vuelo2,vueloMasChico: vuelo; var det1,det2: archivo);
begin
	// Comparamos por destino
    if vuelo1.destino < vuelo2.destino then
    begin
        vueloMasChico := vuelo1;
        leer(det1,vuelo1);
    end
    else if vuelo1.destino > vuelo2.destino then
    begin
        vueloMasChico := vuelo2;
        leer(det2,vuelo2);
    end
    else begin
        // Si los destinos son iguales, comparamos por fecha
        if (vuelo1.fecha.anno < vuelo2.fecha.anno) or
           ((vuelo1.fecha.anno = vuelo2.fecha.anno) and (vuelo1.fecha.mes < vuelo2.fecha.mes)) or
           ((vuelo1.fecha.anno = vuelo2.fecha.anno) and (vuelo1.fecha.mes = vuelo2.fecha.mes) and (vuelo1.fecha.dia < vuelo2.fecha.dia)) then
            begin
				vueloMasChico := vuelo1;
				leer(det1,vuelo1);
			end
        else if (vuelo1.fecha.anno > vuelo2.fecha.anno) or
                ((vuelo1.fecha.anno = vuelo2.fecha.anno) and(vuelo1.fecha.mes > vuelo2.fecha.mes)) or
                ((vuelo1.fecha.anno = vuelo2.fecha.anno) and (vuelo1.fecha.mes = vuelo2.fecha.mes) and(vuelo1.fecha.dia > vuelo2.fecha.dia)) then
            begin
				vueloMasChico := vuelo2;
				leer(det2,vuelo2);
			end
        else begin
            // Si las fechas son iguales, comparamos por hora
            if (vuelo1.hora.hora < vuelo2.hora.hora) or
               ((vuelo1.hora.hora = vuelo2.hora.hora) and (vuelo1.hora.min < vuelo2.hora.min)) then
                begin
					vueloMasChico := vuelo1;
					leer(det1,vuelo1);
				end
            else begin
                vueloMasChico := vuelo2;
                leer(det2,vuelo2);
            end;
        end;
    end;
end;

procedure informar (var output:text;regm:vuelo; minima: integer);
begin	
	if(regm.asientos < minima)then
	begin
		writeln(output,'destino: ', regm.destino,
					   ' fecha: ', regm.fecha.dia,'/',regm.fecha.mes,'/',regm.fecha.anno,
					   ' hora: ',regm.hora.hora,':',regm.hora.min,
					   ' asientos disponibles: ',regm.asientos);
	end;
end;

procedure actualizar (var maestro,det1,det2: archivo; minima:integer);
var
	regm, reg1,reg2,min: vuelo;
	dest:string;
	fecha: tfecha;
	hora:thora; 
	output: text;
begin
	assign(output,'informe.txt');
	rewrite(output);
	reset(maestro);
	reset(det1);
	reset(det2);
	leer(maestro,regm);
	leer(det1,reg1);
	leer(det2,reg2);
	minimo(reg1,reg2,min,det1,det2);
	while (regm.destino <> valorAlto)do  //hasta final del maestro
	begin
		while (min.destino <> regm.destino)do
			read(maestro,regm);
		
		dest:= regm.destino;
			
		while(dest = min.destino)do  //vuelos al mismo destino
		begin
			
			fecha:= regm.fecha;
				
			while((min.destino = dest) and (fechaIgual(fecha,min.fecha)))do //vuelos al mismo lugar y mismo dia
			begin
					
				hora:= regm.hora;

				while((min.destino = dest) and (fechaIgual(fecha,min.fecha)) and (horaIgual(min.hora, hora)))do //mismo vuelo
				begin
					regm.asientos:= regm.asientos - min.asientos;
					minimo(reg1,reg2,min,det1,det2);
				end;
				informar(output,regm,minima);
				seek(maestro,filepos(maestro)-1);
				write(maestro,regm);
				leer(maestro,regm);
			end;
		end;
	end;
	close(maestro);
	close(det1);
	close(det2);
	close(output);
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
begin
	inicializarDeTexto(maestro,det1,det2);
	write('Ingresa el minimo de votos para el informe: ');
	readln(minima);
	actualizar(maestro,det1,det2,minima);
	imprimir(maestro);
end.
