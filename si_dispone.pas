program ej3p2;
type
	provincia= record
		nombre: String;
		codigo: integer;
		alfabetizados: integer;
		encuestados: integer;
	end;
	archivo = file of provincia;

var
	fuente: Text;
	nuevo: archivo;
	p: provincia;
begin
	Assign(fuente, 'det2.txt');
	Assign(nuevo,'detalle2');
	reset(fuente);
	rewrite(nuevo);
	while(not EoF(fuente))do
	begin
		readln(fuente,p.codigo, p.alfabetizados , p.encuestados , p.nombre);
		write(nuevo,p);
	end;
	reset(nuevo);
	while(not EOF(nuevo))do
	begin
		read(nuevo,p);
		writeln('Provincia :', p.nombre, ' ', ' alfabetizados ', p.alfabetizados, ' encuestados: ', p.encuestados , ' lo otro ', p.codigo);
	end;
end.
