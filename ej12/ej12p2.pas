program ej12p2;
const
	valorAlto = 9999;
type
	guardada = record
		nro_usuario: integer;
		nombreUsuario: String;
		nombre: string;
		apellido: string;
		cantidadMailEnviados: integer;
	end;
	
	diaria = record
		nro_usuario: integer;
		cuentaDestino: string;
		cuerpoMensaje: string;
	end;

	log = file of guardada;
	archivo= file of diaria;

procedure instanciar(var maestro: log; var detalle: archivo);
var
	fuenteM,fuenteD: text;
	regm: guardada;
	regd: diaria;
begin
	assign(fuenteM,'log.txt');
	assign(maestro,'log.dat');//'/var/log/logmail.dat'	
	reset(fuenteM);	
	rewrite(maestro);
	
	while (not eof(fuenteM))do
	begin
		readln(fuenteM,regm.nro_usuario,regm.nombreUsuario);
		readln(fuenteM,regm.nombre);
		readln(fuenteM,regm.apellido);
		readln(fuenteM,regm.cantidadMailEnviados);
		write(maestro,regm);
	end;
	assign(detalle, 'informe.dat');
	assign(fuenteD, 'informe.txt');
	reset(fuenteD);
	rewrite(detalle);
	while(not eof(fuenteD))do
	begin
		readln(fuenteD,regd.nro_usuario,regd.cuentaDestino);
		readln(fuenteD,regd.cuerpoMensaje);
		write(detalle,regd);
	end;
	reset(maestro);
	reset(detalle);
end;

procedure leer(var maestro: log; var regm: guardada);
begin
	if(not eof(maestro))then
		read(maestro,regm)
	else
		regm.nro_usuario:= valorAlto;
end;

procedure leerDetalle(var detalle: archivo; var regd: diaria);
begin
	if(not eof(detalle))then
		read(detalle,regd)
	else
		regd.nro_usuario:= valorAlto;
end;

procedure actualizarEImprimirDurante (var maestro: log; var detalle: archivo);
var
	regm: guardada;
	regd: diaria;
	cant,act: integer;
	output: text;   // sin estar comentado por algun motivo deja en Usua
begin
	reset(maestro);
	assign(output,'salida.txt');
	rewrite(output);
	reset(detalle);
	leer(maestro,regm);
	leerDetalle(detalle,regd);
	while (regm.nro_usuario <> valorAlto)do
	begin
		cant:= 0;
		act:= regm.nro_usuario;
		while((regd.nro_usuario = act ))do
			begin
				cant:= cant + 1;
				leerDetalle(detalle,regd);
			end; 
		seek(maestro, filepos(maestro) -1);
		regm.cantidadMailEnviados:= regm.cantidadMailEnviados + cant;
		write(maestro,regm);
		//sin estas dos lineas es el a, con es el b)ii)
		writeln(output,'Usuario: ', regm.nro_usuario, ' cantidad de mails: ', cant);
		leer(maestro,regm);
	end;
	close(output);
	close(detalle);
	close(maestro);
end;

procedure imprimirPost(var maestro:log; var detalle: archivo);
var
	output: text;  // sin estar comentado por algun motivo deja en Usua
	regm: guardada;
	regd:diaria;
	cant,act: integer;
begin
	assign(output,'salida.txt');
	rewrite(output);
	reset(maestro);
	reset(detalle);
	leer(maestro,regm);
	leerDetalle(detalle,regd);
	while (regm.nro_usuario <> valorAlto)do
	begin
		cant:= 0;
		act:= regm.nro_usuario;
		while((regd.nro_usuario = act ))do
			begin
				cant:= cant + 1;
				leerDetalle(detalle,regd);
			end; 
		writeln(output,'Usuario: ', regm.nro_usuario, ' cantidad de mails: ', cant);
		leer(maestro,regm);
	end;
	close(output);
	close(maestro);
	close(detalle);
end;

var
	maestro: log;
	detalle: archivo;
begin
	instanciar(maestro,detalle);
	//actualizarEImprimirDurante(maestro,detalle);
	imprimirPost(maestro,detalle);
end.
