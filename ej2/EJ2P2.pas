program EJ2P2;
type 
	alumno = record
		codigo : integer;
		nombre: String[20];
		apellido: String[30];
		cursadas : integer;
		aprobadas: integer;
	end;
	
	datos= record
		codigo: integer;
		info: String;
	end;
	
maestro= file of alumno;
detalle= file of datos;

procedure actualizar(var m: maestro; var d: detalle);
var
	alu_d: datos ; alu_m: alumno;
begin
	Reset(m);
	Reset(d);
	while(not EOF (d))do
	begin
		read(d,alu_d);
		read(m,alu_m);
		while (alu_d.codigo <> alu_m.codigo)do
			read(m,alu_m);
		while(alu_d.codigo = alu_m.codigo)do
		begin
			if(alu_d.info = 'cursada')then
				alu_m.cursadas:= alu_m.cursadas + 1
			else
				begin
				alu_m.aprobadas:= alu_m.aprobadas +1;
				alu_m.cursadas:= alu_m.cursadas -1;
				end;
			read(d,alu_d);
		end;
		seek(m, filepos(m)-1);
		write(m,alu_m);
	end;
	Close(m);
	close(d);
end;

procedure exportar(var a:maestro);
var
	alu: alumno;
	output: Text;
begin
	Assign(output, 'exportado.txt');
	rewrite(output);
	reset(a);
	while (not EOF(a))do
	begin
		read(a,alu);
		writeln(output, 'Alumno:  codigo: ', alu.codigo,' Nombre: ', alu.nombre, ' ', alu.apellido, ' Materias solo cursadas: ', alu.cursadas, ' Materias aprobadas con final: ', alu.aprobadas);
	end;
	close(a);
	close(output);
end;

var 
	alumnos: maestro;
	det: detalle;
	op: integer;
begin
	Assign(alumnos,'alumnos');
	Assign(det, 'detalle');
	writeln('*********MENU**********');
	writeln('(1) Actualizar');
	writeln('(2) Exportar');
	write('Elegi una opcion: ');
	readln(op);
	case op of
		1: actualizar(alumnos,det);
		2: exportar(alumnos);
	end;
end.
