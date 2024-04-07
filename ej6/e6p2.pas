program ej6p2;
const 
	valorAlto= 9999;
type
	calendario = record
		dia: integer;
		mes: integer;
		anio: integer;
	end;
	
	log = record
	cod_usuario:integer;
	fecha: calendario;
	tiempo_sesion:real;
	end;
	
	archivo= file of log;
	v_detalles= array[1..5] of archivo;
	reg_detalles = array[1..5] of log;

procedure leer (var regd: log; var detalle: archivo);
begin
	if(not eof (detalle))then
		read(detalle,regd)
	else
		regd.cod_usuario:= valorAlto;
end;
	
procedure crearEntorno(var maestro: archivo; var detalles: v_detalles; var regd: reg_detalles);
var
	fuentes: array[1..5] of Text;
	i: integer;
	filename:string;
	l: log;
begin
	Assign(maestro,'maestro'); //'/var/log/maestro' para que se cree ahi
	rewrite(maestro);
	for i:= 1 to 5 do
	begin
		Str(i,filename);
		Assign(fuentes[i], 'maquina' + filename + '.txt');
		Assign(detalles[i], 'maquina' + filename);
		reset(fuentes[i]);
		rewrite(detalles[i]);
		//crea archivos en base a txts
		while (Not eof (fuentes[i]))do
		begin
			readln(fuentes[i], l.cod_usuario, l.fecha.anio, l.fecha.mes, l.fecha.dia, l.tiempo_sesion);
			write(detalles[i], l);
		end;
		//inicializa vector de registros con el primer elemento del archivo que creo recien
		reset(detalles[i]);
		leer(regd[i], detalles[i]);
	end;
end;

procedure minimo (var detalles: v_detalles; var regd: reg_detalles; var min: log);
var
	i:integer;
	min_cod,pos : integer;
begin
	min_cod:= 9999;
	for i:= 1 to 5 do
	begin
		if(regd[i].cod_usuario <= min_cod) then
		begin
			min_cod:= regd[i].cod_usuario;
			pos:= i;
		end;
	end;
	min:= regd[pos];
	leer(regd[pos], detalles[pos]);
end;



var
	maestro:archivo;
	detalles: v_detalles; 
	min,act: log;
	regd: reg_detalles;
	output: text;
begin
	crearEntorno(maestro,detalles,regd);
	minimo(detalles,regd,min);
	while (min.cod_usuario <> valorAlto)do
		begin
			act.fecha:= min.fecha;
			while((min.cod_usuario <> valorAlto) and(min.fecha.dia = act.fecha.dia) and (min.fecha.mes = act.fecha.mes) and (min.fecha.anio = act.fecha.anio)) do
			begin
				act.cod_usuario:= min.cod_usuario;
				act.tiempo_sesion:= 0;
				while(act.cod_usuario = min.cod_usuario) do
				begin
					act.tiempo_sesion:= act.tiempo_sesion + min.tiempo_sesion;
					minimo(detalles,regd,min);
				end;
				write(maestro,act);
			end;
		end;
	reset (maestro);
	assign(output,'maestro.txt');
	rewrite(output);
	while not eof(maestro)do
	begin
		read(maestro,act);
		writeln(output, act.cod_usuario ,' ', act.fecha.dia, ' ', act.fecha.mes, ' ', act.fecha.anio, ' ', act.tiempo_sesion:0:2);
	end;
end.
