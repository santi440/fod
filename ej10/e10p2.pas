program e10p2;
const
	valorAlto= 'zzzzz';

type
	empleado = record
		departamento:String;
		division:string;
		numero: integer;
		categoria: integer;
		horas_extras:integer;
	end;
	
	empresa = file of empleado;
	
	valores = array[1..15] of real;
	
procedure inicializar(var maestro: empresa);
var
	fuente: text;
	regm: empleado;
begin
	assign(fuente,'maestro.txt');
	assign(maestro,'maestro');
	reset(fuente);
	rewrite(maestro);
	while(not eof(fuente))do
	begin
		readln(fuente,regm.departamento);
		readln(fuente,regm.division);
		readln(fuente,regm.numero, regm.categoria,regm.horas_extras);
		write(maestro,regm);
	end;
	close(maestro);
	close(fuente);
end;

procedure leer(var maestro:empresa; var e:empleado);
begin
	if(not eof(maestro))then
		read(maestro,e)
	else
		e.departamento:= valorAlto;
end;

procedure PrecioHoraExtra(var extra: valores);
var
	fuente: text;
	pos: integer;
	valor: real;
begin
	assign(fuente,'valores_horas_extra.txt');
	reset(fuente);
	while(not Eof(fuente))do  // seria un for si supiera que tengo las 15 categorias en el archivo fuente
		begin
			readln(fuente,pos,valor);
			extra[pos]:= valor;
		end;
	close(fuente);
end;

procedure imprimir (var maestro: empresa; precio: valores);
var
	dep,divi: String;
	tdivision,tdepartamento: integer;
	mdivision,mdepartamento,importe: real;
	emp: empleado;
begin
	reset(maestro);
	leer(maestro,emp);
	while(emp.departamento <> valorAlto)do
	begin
		dep:= emp.departamento;
		tdepartamento:= 0;
		mdepartamento:= 0;
		writeln('***********************');
		writeln(dep, ':');
		while(emp.departamento = dep)do
		begin
			divi:= emp.division;
			tdivision:= 0;
			mdivision:= 0;
			writeln(divi,': ');
			while ((emp.departamento = dep) and(emp.division = divi))do
			begin
				importe := emp.horas_extras*precio[emp.categoria];
				writeln('Empleado ', emp.numero, ' : ', emp.horas_extras, ' $', importe:0:2);
				mdivision:= mdivision + importe;
				tdivision:= tdivision + emp.horas_extras;
				leer(maestro,emp);
			end;
			tdepartamento:= tdepartamento + tdivision;
			mdepartamento:= mdepartamento + mdepartamento;
			writeln('Total de Horas division: ', tdivision);
			writeln('Monto total por division:', mdivision:0:2);
		end;
		writeln('Total de Horas departamento: ', tdepartamento);
		writeln('Monto total por departamento:', mdepartamento:0:2);
	end;
end;

var
	maestro: empresa;
	extra: valores;
begin
	inicializar(maestro);
	PrecioHoraExtra(extra);
	imprimir(maestro,extra);
end.
