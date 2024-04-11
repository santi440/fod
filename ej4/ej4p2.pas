program ej4p2;
const
	valorAlto = 'zzzz';
type
	provincia= record
		nombre: String;
		alfabetizados: integer;
		encuestados: integer;
	end;
	
	archivo = file of provincia;
	
	censo= record
		nombre: String;
		localidad: integer;
		alfabetizados: integer;
		encuestados: integer;
	end;
	detalle = file of censo;
	
procedure leer (var d:detalle; var dato: censo );
begin
	if(not EOF(d))then read(d,dato) else dato.nombre:= valorAlto;
end;

procedure minimo (var min: censo;var a1,a2 : censo; var det1,det2 : detalle);
begin
	if(a1.nombre < a2.nombre) then 
	begin
		min:= a1;
		leer(det1,a1);
	end
	else min:= a2; leer(det2,a2);
end;

procedure crearArchivos(var f1,f2,f3:Text; var d1,d2 : detalle; var m1:archivo);
var 
	p:provincia;
	c:censo;
begin
	reset(f1);
	rewrite(m1);
	while(not EoF(f1))do
	begin
		readln(f1, p.alfabetizados , p.encuestados , p.nombre);
		write(m1,p);
	end;
	reset(f2);
	rewrite(d1);
	while(not EoF(f2))do
	begin
		readln(f2,c.localidad, c.alfabetizados , c.encuestados , c.nombre);
		write(d1,c);
	end;
	reset(f3);
	rewrite(d2);
	while(not EoF(f3))do
	begin
		readln(f3,c.localidad, c.alfabetizados , c.encuestados , c.nombre);
		write(d2,c);
	end;
	Close(f1);
	Close(f2);
	Close(f3);
end;

var
	agencia1,agencia2: detalle;
	maestro: archivo;
	fuente1,fuente2,fuente3: Text;
	d1,d2,min: censo;
	m1: provincia;
begin
	Assign(agencia1,'detalle1');
	Assign(agencia2,'detalle2');
	Assign(maestro,'alfabetizados');
	Assign(fuente1,'alfabetizados.txt');
	Assign(fuente2,'det.txt');
	Assign(fuente3,'det2.txt');
	
	crearArchivos(fuente1,fuente2,fuente3,agencia1,agencia2,maestro);
	
	Reset(agencia1);
	Reset(agencia2);
	Reset(maestro);
	
	leer(agencia1,d1);
	leer(agencia2,d2);
	read(maestro,m1);
	
	minimo(min,d1,d2,agencia1,agencia2);
	
	while(min.nombre<>valorAlto)do
	begin
		while(m1.nombre <> min.nombre)do
			read(maestro,m1);
		while(m1.nombre = min.nombre)do
		begin
			m1.alfabetizados:= m1.alfabetizados + min.alfabetizados;
			m1.encuestados:= m1.encuestados + min.encuestados;
			minimo(min,d1,d2,agencia1,agencia2);
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,m1);
	end;
	reset(maestro);
	while(not EOF (maestro))do
	begin
		read(maestro,m1);
		writeln(m1.nombre, ' tiene ', m1.alfabetizados, ' de ', m1.encuestados);
	end;
	close(maestro);
	close(agencia1);
	close(agencia2);
end.
