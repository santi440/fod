program e8p2;
const
	valorAlto = 9999;
type
	cliente =record
		cod: integer;
		nombre:string;
		apellido:string;
	end;
	
	venta = record
		cli: cliente;
		anio:integer;
		mes: integer;
		dia: integer;
		monto: real;
	end;
	
	balance = file of venta;
	
	
procedure leer (var maes:balance; var regd:venta);
begin
	if(not eof(maes))then
		read(maes,regd)
	else
		regd.cli.cod := valorAlto;
end;

procedure inicializar (var maes:balance);
var
	fuente: Text;
	regm: venta;
begin
	Assign(fuente,'maestro.txt');
	Assign(maes,'maestro');
	reset(fuente);
	rewrite(maes);
	while(not eof(fuente)) do
		begin
			readln(fuente,regm.cli.cod, regm.cli.nombre);
			readln(fuente,regm.cli.apellido);
			readln(fuente,regm.anio,regm.mes,regm.dia,regm.monto);
			write(maes,regm);
		end;
	close(fuente);
	close(maes);
end;



var
	maes: balance;
	regm: venta;
	act,mes: integer;
	tmes,tanio,total: real;

begin
	inicializar(maes);
	reset(maes);
	leer(maes,regm);
	total:= 0;
	while(regm.cli.cod <> valorAlto)do
		begin
			act:= regm.cli.cod;
			writeln('******************************************');
			writeln('Cliente: ', regm.cli.cod , ' nombre: ', regm.cli.nombre,' ', regm.cli.apellido);
			tanio:= 0;
			while (regm.cli.cod = act)do
			begin
				mes:= regm.mes;
				tmes:= 0;
				while((regm.cli.cod = act )and (regm.mes  = mes))do
				begin
					tmes:= tmes + regm.monto;
					leer(maes,regm);
				end;
				if(tmes > 0)then
					writeln('En el mes ', mes, ' compro un total de: $', tmes:0:2);
				tanio:= tanio + tmes;
			end;
			writeln('Total anual : $', tanio:0:2);
			total:= total + tanio;
		end;
	writeln('Feliciataciones! su empresa gano $', total:0:2);
end.
