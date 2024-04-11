program generar;
var
    det: array[1..30] of Text;
    i:integer;
    filename: string;
begin
    for i:= 1 to 30 do
    begin
		Str(i,filename);
        Assign(det[i],'det' + filename + '.txt');
        rewrite(det[i]);
    end;
end.
