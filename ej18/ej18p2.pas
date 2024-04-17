program ej18p2;
const
	dimF = 50;
	valorAlto = 9999;

type
	dir = record
		calle: string;
		nro: integer;
		piso:integer;
		depto:string;
		ciudad:string;
	end;
	
	nacidos = record
		partida_nacimiento: integer;
		nombre:string;
		apellido:string;
		direccion:dir;
		matricula_medico: integer;
		nombre_apellido_madre:string;
		DNI_madre:integer;
		nombre_apellido_padre:string;
		DNI_padre:integer;
	end;

	fallecidos = record
		partida_nacimiento: integer;
		DNI: integer;
		nombre:string;
		apellido:string;
		matricula_medico: integer;
		fecha : string; // podria ser un record pero no lo uso y es mas molesto de manejar que un simple stirng;
		hora: string;
		lugar: string;
	end;
	
	persona = record
		partida_nacimiento: integer;
		nombre:string;
		apellido:string;
		direccion:dir;
		matricula_medico: integer;
		nombre_apellido_madre:string;
		DNI_madre:integer;
		nombre_apellido_padre:string;
		DNI_padre:integer;
		fallecio: boolean;
		matricula_medicoF: integer;
		fecha : string; // podria ser un record pero no lo uso y es mas molesto de manejar que un simple stirng;
		hora: string;
		lugar: string;
	end;
	
	natalidad = file of nacidos;
	mortalidad = file of fallecidos;
	
	nacimientos = array[1..dimF] of natalidad;
	registroNacio = array [1..dimF] of nacidos;
	fallecimientos = array[1.. dimF] of mortalidad;
	registroFallecido = array[1..dimF] of fallecidos;
	
	master = file of persona;
	
procedure textoABinario (var born: nacimientos; var dead: fallecimientos);
var
	regn: nacidos;
	regf:fallecidos;
	fuenteN, fuenteF: text;
	i: integer;
	filename: string;
begin
	for i:= 1 to dimF do 
	begin
		str(i,filename);
		//nacimientos
		assign(born[i],'nacimientos' + filename);
		assign(fuenteN,'nacidos' + filename + '.txt');
		reset(fuenteN);
		rewrite(born[i]);
		
		readln(fuenteN, regn.partida_nacimiento, regn.nombre);
		readln(fuenteN, regn.apellido);
		//(calle,nro, piso, depto, ciudad)
		readln(fuenteN, regn.direccion.calle);
		readln(fuenteN, regn.direccion.nro, regn.direccion.piso, regn.direccion.depto);
		readln(fuenteN, regn.direccion.ciudad);
		readln(fuenteN, regn.matricula_medico);
		
		readln(fuenteN, regn.nombre_apellido_madre);
		readln(fuenteN, regn.DNI_madre);
		
		readln(fuenteN, regn.nombre_apellido_padre);
		readln(fuenteN, regn.DNI_padre);
		
		write(born[i],regn);
		
		//fallecidos
		assign(dead[i],'muertos' + filename);
		assign(fuenteF,'muertos' + filename + '.txt');
		rewrite(dead[i]);
		reset(fuenteF);
		{nro partida nacimiento, DNI, nombre y apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y lugar.}
		readln(fuenteF, regf.partida_nacimiento, regf.DNI, regf.nombre);
		readln(fuenteF, regf.apellido);
		readln(fuenteF, regf.matricula_medico);
		readln(fuenteF, regf.fecha);
		readln(fuenteF, regf.hora);
		readln(fuenteF, regf.lugar);
		write(dead[i],regf);
		
		//cierro lo que use
		close(fuenteF);
		close(fuenteN);
		close(born[i]);
		close(dead[i]);
	end;
end;

procedure leerNatalidad(var det:natalidad; var reg: nacidos);
begin
	if(not eof(det))then
		read(det,reg)
	else
		reg.partida_nacimiento:= valorAlto;
end;

procedure leerMortalidad(var det:mortalidad; var reg: fallecidos);
begin
	if(not eof(det))then
		read(det,reg)
	else
		reg.partida_nacimiento:= valorAlto;
end;

procedure inicializarVectores(var detn: nacimientos; var regn: registroNacio; var detf: fallecimientos; var regf: registroFallecido);
var
	i:integer;
begin
	for i:= 1 to dimF do
	begin
		reset(detn[i]);
		leerNatalidad(detn[i],regn[i]);
		reset(detf[i]);
		leerMortalidad(detf[i], regf[i]);
	end;
end;

procedure cerrarTodo(var detn: nacimientos; var detf: fallecimientos);
var
	i:integer;
begin
	for i:= 1 to dimF do
	begin
		close(detn[i]);
		close(detf[i]);
	end;
end;

procedure minimoNatalidad(var detn: nacimientos; var regn: registroNacio; var min:nacidos);
var
	partidaChica: integer;
	i,pos:integer;
begin
	pos:= 1;
	partidaChica:= valorAlto;
	for i:= 1 to dimF do
	begin
		if(regn[i].partida_nacimiento < partidaChica)then
		begin
			partidaChica:= regn[i].partida_nacimiento;
			pos:= i;
		end;
	end;
	min:= regn[pos];
	leerNatalidad(detn[pos], regn[pos]);
end;

procedure minimoMortalidad(var detf: fallecimientos; var regf: registroFallecido;var min: fallecidos);
var
	partidaChica: integer;
	i,pos:integer;
begin
	pos:= 1;
	partidaChica:= valorAlto;
	for i:= 1 to dimF do
	begin
		if(regf[i].partida_nacimiento < partidaChica)then
		begin
			partidaChica:= regf[i].partida_nacimiento;
			pos:= i;
		end;
	end;
	min:= regf[pos];
	leerMortalidad(detf[pos], regf[pos]);
end;

procedure merge(var born: nacimientos;var dead: fallecimientos);
var
	maestro: master;
	output: text;
	//reg 
	registrosN: registroNacio;
	registrosF: registroFallecido;
	minN: nacidos;
	minF: fallecidos;
	per: persona;
begin
	assign(maestro,'maestro');
	assign(output,'info de personas.txt');
	rewrite(maestro);
	rewrite(output);
	inicializarVectores(born,registrosN,dead,registrosF);
	minimoMortalidad(dead,registrosF,minF);
	minimoNatalidad(born,registrosN,minN);
	while (minN.partida_nacimiento <> valorAlto)do
	begin
		per.partida_nacimiento:= minN.partida_nacimiento;
		per.nombre:= minN.nombre;
		per.apellido:= minN.apellido;
		per.direccion:= minN.direccion;
		per.matricula_medico:= minN.matricula_medico;
		per.nombre_apellido_madre:= minN.nombre_apellido_madre;
		per.DNI_madre:= minN.DNI_madre;
		per.nombre_apellido_padre:= minN.nombre_apellido_padre;
		per.DNI_padre:= minN.DNI_padre;
		
		writeln(output,'Nacio: ', per.partida_nacimiento,': ', per.nombre,' ', per.apellido);
		writeln(output, 'Lugar de nacimiento: ',per.direccion.calle, ' ', per.direccion.nro,' ', per.direccion.piso,'', per.direccion.depto, ', ', per.direccion.ciudad);
		writeln(output, 'Medico: ', per.matricula_medico);
		writeln(output,'Padres: ', per.DNI_madre,' ', per.nombre_apellido_madre, ' y ', per.DNI_padre, ' ', per.nombre_apellido_padre);
		
		
		if(minN.partida_nacimiento = minF.partida_nacimiento)then
		begin
			per.fallecio:= true;
			per.matricula_medicoF:= minF.matricula_medico;
			per.fecha:= minF.fecha;
			per.hora:= minF.hora;
			per.lugar:= minF.lugar;
			
			writeln(output,'Murio ');
			writeln(output, 'Da fe el medico ', per.matricula_medicoF);
			writeln(output, 'Fecha y lugar: ', per.fecha,' ', per.hora,' ', per.lugar);
			
			minimoMortalidad(dead,registrosF,minF);
		end;
		write(maestro,per);
		minimoNatalidad(born,registrosN,minN);
	end;
	close(maestro);
	close(output);
end;
var
	//archivos
	born: nacimientos;
	dead: fallecimientos;

begin
	textoABinario(born,dead);
	merge(born,dead);
end.
