program e9p2;
const
	valorAlto = 9999;
type
	mesa = record
		 codigo_provin: integer;
		 codigo_loc: integer;
		 numero: integer;
		 votos: integer;
	end;
	
	electorado = file of mesa;
procedure inicializar (var maestro: electorado );
var
	fuente: text;
	regm: mesa;
begin
	assign(fuente,'maestro.txt');
	assign(maestro,'maestro');
	reset(fuente);
	rewrite(maestro);
	while(not eof(fuente))do
		begin
			readln(fuente,regm.codigo_provin, regm.codigo_loc,regm.numero,regm.votos);
			write(maestro,regm);
		end;
	close(maestro);
	close(fuente);
end;

procedure leer(var maestro:electorado; var regm:mesa);
begin
	if(not eof(maestro))then
		read(maestro,regm)
	else
		regm.codigo_provin:= valorAlto;
end;

var
	maestro: electorado;
	total,tprovincia,tloc,provinAct,locAct: integer;
	regm: mesa;
begin
	inicializar(maestro);
	reset(maestro);
	leer(maestro,regm);
	total:= 0;
	while(regm.codigo_provin <> valorAlto)do
	begin
		writeln('******************************');
		tprovincia:= 0;
		provinAct:= regm.codigo_provin;
		writeln('Provincia: ', provinAct);
		while(regm.codigo_provin = provinAct) do
		begin
			locAct:= regm.codigo_loc;
			tloc:= 0;
			while((regm.codigo_provin = provinAct) and(regm.codigo_loc = locAct))do
			begin
				tloc:= tloc + regm.votos;
				leer(maestro,regm);
			end;
			writeln('     Localidad: ', locAct, ' Total de votos: ', tloc );
			tprovincia:= tprovincia + tloc;
		end;
		writeln('Total de Votos Provincia: ' ,tprovincia);
		total:= total + tprovincia;
	end;
	writeln('Total General de Votos: ', total);
end.
