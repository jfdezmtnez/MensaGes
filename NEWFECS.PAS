program change_fec_index;
uses defs,config;
type
	new_fec_index=RECORD
		fecha     : longint;
		pos       : longint;
		facturado : boolean
	end;

var
	new_fich_ndx : file of new_fec_index;
	old_index    : t_index2;
	new_index    : new_fec_index;
	i,j          : longint; {Contadores}
	last_fecha   : longint; {Ultima fecha de facturaci¢n}
begin


	last_fecha:=19960705;  {Poner el valor correspondiente}

	clrscr;
	writeln(' Indices traducidos : ');
	write(' Albaranes facturados : ');
	init;
	assign(new_fich_ndx,ini.work+'fecha.tmp');
	{$I-}
	reset(fec_ndx);
	rewrite(new_fich_ndx);
	{$I+}
	if ioresult=0 then begin
		i:=0;
		j:=0;
		while not eof(fec_ndx) do
			begin
				read(fec_ndx,old_index);
				with new_index do
					begin
						fecha    := old_index.fecha;
						pos      := old_index.pos;
					{ Control del flag por last_fecha }
						if fecha<last_fecha then
							begin
								facturado:=true;
								inc(j);
							end
							else facturado:= false
					end;
				write(new_fich_ndx,new_index);
				inc(i);
				gotoxy(23,1);
				clreol;
				write(i);
				gotoxy(23,2);
				clreol;
				write(j)
			end;
		close(fec_ndx);
		close(new_fich_ndx);
		erase(fec_ndx);
		rename(new_fich_ndx,'fecha.ndx');
	end
end.