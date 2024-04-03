program EJ1P2;
const
	valorAlto = 9999;
type 
	empleado = record
		codigo : integer;
		nombre : String;
		monto: real;
	end;
	archivo_empleados = file of empleado;
procedure crear (var archivo: Text); //lo use para generar el archivo que se dispone
var
	emp : empleado;
	nuevo: archivo_empleados;
begin
	Reset(archivo);
	Assign(nuevo, 'empleados');
	Rewrite(nuevo);
	while(not EOF(archivo)) do
	begin
		Readln(archivo, emp.codigo,emp.monto,emp.nombre);
		write(nuevo,emp);
	end;
	Close(archivo);
	close(nuevo);
end;

procedure imprimir (var a: archivo_empleados);
var 
	em: empleado;
begin
	Reset(a);
	while(not EOF(a))do
	begin
		read(a,em);
		writeln('Codigo: ',em.codigo, ' Nombre: ', em.nombre, ' comision: ' , em.monto:0:2);
	end;
	Close(a);
end;

procedure leer(var a: archivo_empleados; var dato: empleado);
begin
	if(not EOF(a)) then
		read(a, dato)
	else
		dato.codigo := valorAlto;
end;

procedure fusion(var archivo,nuevo: archivo_empleados);
var 
	emp,act:empleado;
begin
	Reset(archivo);
	Rewrite(nuevo);
	leer(archivo,emp);
	while(emp.codigo <> valorAlto)do
	begin
		act := emp;
		act.monto:= 0;
		while (act.codigo = emp.codigo )do
		begin
			act.monto := act.monto + emp.monto;
			leer(archivo,emp);
		end;
		write(nuevo,act);
	end;
end;
var
	archivo ,nuevo: archivo_empleados;
begin
	Assign(archivo,'empleados');
	Assign(nuevo,'empleados_simplificados');
	fusion(archivo,nuevo);
	imprimir(nuevo);
end.
