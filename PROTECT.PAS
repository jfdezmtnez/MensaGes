unit protect;

interface

	function registered:boolean;
	procedure check_prorroga;

implementation

	uses crt,defs,common,dos;


	procedure notice_register;
	begin
		textcolor(CYAN);
		textbackground(BLUE);
		writeln;
		writeln('SIGNUM DATABASE - 1.0                                          ');
		lowvideo;
		writeln('          This is a SHAREWARE program. In order to use it      ');
		writeln('       you must register. To do so contact :                   ');
		writeln('                                                               ');
		writeln('                SIGNUM TECHNOLOGIES - Vigo                     ');
		writeln('                    c\Urz iz,114; 2§ B                         ');
		writeln('                      36200 - Vigo                             ');
		writeln('                                                               ');
		writeln('               Tfno. -(986) 417707  (14:00 a 20:00)            ');
		writeln('               Tfno. -(986) 356942  (09:00 a 14:00)            ');
		writeln;
		writeln;
		textcolor(7);
		textbackground(BLACK);
	end;


{ funci¢n para comprobar la clave introducida }
	function false_entry:byte;
	var
		entry : str_40;
		fin   : byte;
		i     : byte;
	begin
		i:=1;
		fin:=1;
		gotoxy(10,5);
		write('Clave : ');
		textcolor(0);
		textbackground(0);
		read(entry);
		if entry='Jal s' then false_entry:=2

			else if length(entry)<>10 then false_entry:=0

				else begin
					repeat
						if(ord(entry[i])<>(ini.key[i]-100)) then fin:=0
							else inc(i);
					until((fin=0)or(i=11));

					false_entry:=fin

				end;

		textcolor(7)
	end;



{ Comprueba si el usuario est  registrado }
	function registered : boolean;
	var
		ctrl  : byte;
		codice: aga;
		fich  : file of aga;
		f:file;

	 { Mira si se encuentra a£n a prueba }
		function trial_period:boolean;
		var actual:longint;
		begin
			actual:=fecha_sistema.year;
			actual:=actual*100+fecha_sistema.month;
			actual:=actual*100+fecha_sistema.day;
			if actual<ini.try then trial_period:=true
				else trial_period:=false
		end;


	begin
		assign(f,'c:\mges.sys');
		{$I-}
			setfattr(f,archive);
			reset(f);
		{$I+}
			if ioresult=0 then
				begin
					registered:=true;
					setfattr(f,hidden)
				end

		else
		if not trial_period then
			begin
				clrscr;
				gotoxy(10,3);
				writeln('El periodo de prueba ha finalizado, deben');
				writeln('Vds. registrarse');
				ctrl:=false_entry;
				if ctrl=0 then
					begin
						registered:=false;
						notice_register;
					end
					else begin
						registered:=true;
						if ctrl=2 then
							begin
								ini.try    :=99999999;
								codice.pth :=ini.work;
								codice.code:=39480626;
								assign(fich,'C:\AGA.PTH');
								setfattr(fich,archive);
								rewrite(fich);
								write(fich,codice);
								close(fich);
								setfattr(fich,hidden);
								save_cfg
							end
					end
			end
			else registered:=true
	end;

	procedure check_prorroga;
	var
		new   : longint;
		entry : string;
		codice: aga;
		fich  : file of aga;
		ctrl  : byte;
	begin
		assign(fich,'C:\AGA.PTH');

		setfattr(fich,archive);
		reset(fich);
		read(fich,codice);
		close(fich);
		setfattr(fich,hidden);

		if((codice.code=39580626)and(paramcount=1)and((paramstr(1)='KEY')or(paramstr(1)='key')))then
			begin
				clrscr;
				ctrl:=false_entry;
				if ctrl=1 then
					begin
						gotoxy(10,7);
						write('Fecha limite : ');
						textcolor(0);
						readln(new);
						ini.try:=new;
						save_cfg
					end
					else if ctrl=2 then
						begin
							ini.try:=99999999;
							codice.code:=39480626;

							setfattr(fich,archive);
							rewrite(fich);
							write(fich,codice);
							close(fich);
							setfattr(fich,hidden);

							save_cfg
						end
			end
	end;

end.