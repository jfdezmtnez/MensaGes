program instalar;

uses crt,dos,defs,common,campstru,gets,graficos,strings,ficheros,config;

var
	op    : byte;
	pth   : file of aga;
	chain : string;
	work  : t_nodo_dato;
	codice: aga;
	answer: boolean;
	c     : char;


procedure swap(orig,dest:string);
var
	fich1: file;
	fich2: file;
	c    : char;
	info : Searchrec;
	j    : byte;
	r,w  : word;
	Buf  : array[1..2048] of Char;

	{ Descarta los directorios '.' y '..'}
	function valid(name:string):byte;
	begin
		if((name='.')or(name='..'))then valid:=0
			else if (name[length(name)-3]<>'.') then valid:=0
				else if name='USA.EXE' then valid:=2
					else valid:=1
	end;

begin

	findfirst(orig+'*.*',anyfile,info);

	while doserror=0 do
		begin
			j:=valid(info.name);
			if j<>0 then
				begin
					assign(fich1,orig+info.name);
					write('.');
					if j=1 then
						begin
							{$I-}
							Reset(fich1,1);  { Record size = 1 }
							{$I+}
							if IOresult=0 then
								begin
									assign(fich2,dest+info.name);
									rewrite(fich2,1);
									repeat
										BlockRead(fich1,Buf,SizeOf(Buf),r);
										BlockWrite(fich2,Buf,r,w);
									until((r=0)or(w<>r));
									close(fich1);
									close(fich2)
								end;
								erase(fich1)
						end
						else erase(fich1)
				end;

			findnext(info)
		end
end;



procedure assignar;
var
	i,k : byte;
	f   : file of t_ini;
begin

	for k:=0 to 15 do increase(fecha_sistema);
	if codice.code=39480626 then ini.try:=99999999
		else if codice.code=0 then begin
			codice.code:=39580626;
			ini.try:=fecha_sistema.year;
			ini.try:=ini.try*100+fecha_sistema.month;
			ini.try:=ini.try*100+fecha_sistema.day;
		end
		else if codice.code<>39580626 then
			begin
				clrscr;
				decrease(fecha_sistema);
				textcolor(7);
				write(' Sistema corrupto. Instalaci¢n abortada !');
				halt(1)
			end
			else begin
				assign(f,codice.pth+'MENSAGES.CFG');
				{$I-}
				reset(f);
				{$I+}
				if ioresult=0 then
					begin
						read(f,ini);
						close(f)
					end
					else begin
						clrscr;
						decrease(fecha_sistema);
						textcolor(7);
						write(' Sistema corrupto. Instalaci¢n abortada !');
						halt(1)
					end
			end;

	for k:=15 downto 0 do decrease(fecha_sistema);

	k:=length(work.dato);
	i:=k;
	while work.dato[k]=' ' do dec(k);
	if k<i then delete(work.dato,k+1,i-k);
	if work.dato[length(work.dato)]<>'\' then work.dato:=work.dato+'\';
	codice.pth:=work.dato;
	ini.work:=work.dato;

	ini.pts_c_km:=45;
	ini.pts_m_km:=40;

	ini.tfas_defecto[1].descripcion:='Moto         '+empty;
	ini.tfas_defecto[1].precio:=200;
	ini.tfas_defecto[1].ex_peso:=0;
	ini.tfas_defecto[1].ex_tiempo:=18;
	ini.tfas_defecto[1].ex_km:=40;

	ini.tfas_defecto[2].descripcion:='Coche        '+empty;
	ini.tfas_defecto[2].precio:=425;
	ini.tfas_defecto[2].ex_peso:=20;
	ini.tfas_defecto[2].ex_tiempo:=20;
	ini.tfas_defecto[2].ex_km:=45;

	ini.tfas_defecto[3].descripcion:='Po-Express   '+empty;
	ini.tfas_defecto[3].precio:=450;
	ini.tfas_defecto[3].ex_peso:=30;
	ini.tfas_defecto[3].ex_tiempo:=0;
	ini.tfas_defecto[3].ex_km:=0;

	ini.tfas_defecto[4].descripcion:='S. Regular   '+empty;
	ini.tfas_defecto[4].precio:=400;
	ini.tfas_defecto[4].ex_peso:=30;
	ini.tfas_defecto[4].ex_tiempo:=0;
	ini.tfas_defecto[4].ex_km:=0;

	ini.tfas_defecto[5].descripcion:='Reg. Cap.    '+empty;
	ini.tfas_defecto[5].precio:=1000;
	ini.tfas_defecto[5].ex_peso:=40;
	ini.tfas_defecto[5].ex_tiempo:=0;
	ini.tfas_defecto[5].ex_km:=0;

	ini.tfas_defecto[6].descripcion:='Reg. Pob.    '+empty;
	ini.tfas_defecto[6].precio:=1300;
	ini.tfas_defecto[6].ex_peso:=40;
	ini.tfas_defecto[6].ex_tiempo:=0;
	ini.tfas_defecto[6].ex_km:=0;

	ini.tfas_defecto[7].descripcion:='Nac. Cap.    '+empty;
	ini.tfas_defecto[7].precio:=1350;
	ini.tfas_defecto[7].ex_peso:=975;
	ini.tfas_defecto[7].ex_tiempo:=0;
	ini.tfas_defecto[7].ex_km:=0;

	ini.tfas_defecto[8].descripcion:='Nac. Pob.    '+empty;
	ini.tfas_defecto[8].precio:=1800;
	ini.tfas_defecto[8].ex_peso:=975;
	ini.tfas_defecto[8].ex_tiempo:=0;
	ini.tfas_defecto[8].ex_km:=0;

	ini.tfas_defecto[9].descripcion:='S. Especial  '+empty;
	ini.tfas_defecto[9].precio:=0;
	ini.tfas_defecto[9].ex_peso:=0;
	ini.tfas_defecto[9].ex_tiempo:=0;
	ini.tfas_defecto[9].ex_km:=0;

	ini.tfas_mensajero[1].descripcion:='Moto         '+empty;
	ini.tfas_mensajero[1].precio:=100;
	ini.tfas_mensajero[1].ex_peso:=0;
	ini.tfas_mensajero[1].ex_tiempo:=9;
	ini.tfas_mensajero[1].ex_km:=20;

	ini.tfas_mensajero[2].descripcion:='Coche        '+empty;
	ini.tfas_mensajero[2].precio:=225;
	ini.tfas_mensajero[2].ex_peso:=10;
	ini.tfas_mensajero[2].ex_tiempo:=10;
	ini.tfas_mensajero[2].ex_km:=22;

	ini.tfas_mensajero[3].descripcion:='Serv. "75"   '+empty;
	ini.tfas_mensajero[3].precio:=75;
	ini.tfas_mensajero[3].ex_peso:=0;
	ini.tfas_mensajero[3].ex_tiempo:=0;
	ini.tfas_mensajero[3].ex_km:=0;

	ini.tfas_mensajero[4].descripcion:='             '+empty;
	ini.tfas_mensajero[4].precio:=0;
	ini.tfas_mensajero[4].ex_peso:=0;
	ini.tfas_mensajero[4].ex_tiempo:=0;
	ini.tfas_mensajero[4].ex_km:=0;

	ini.tfas_mensajero[5].descripcion:='             '+empty;
	ini.tfas_mensajero[5].precio:=0;
	ini.tfas_mensajero[5].ex_peso:=0;
	ini.tfas_mensajero[5].ex_tiempo:=0;
	ini.tfas_mensajero[5].ex_km:=0;

	ini.tfas_mensajero[6].descripcion:='             '+empty;
	ini.tfas_mensajero[6].precio:=0;
	ini.tfas_mensajero[6].ex_peso:=0;
	ini.tfas_mensajero[6].ex_tiempo:=0;
	ini.tfas_mensajero[6].ex_km:=0;

	ini.tfas_mensajero[7].descripcion:='             '+empty;
	ini.tfas_mensajero[7].precio:=0;
	ini.tfas_mensajero[7].ex_peso:=0;
	ini.tfas_mensajero[7].ex_tiempo:=0;
	ini.tfas_mensajero[7].ex_km:=0;

	ini.tfas_mensajero[8].descripcion:='             '+empty;
	ini.tfas_mensajero[8].precio:=0;
	ini.tfas_mensajero[8].ex_peso:=0;
	ini.tfas_mensajero[8].ex_tiempo:=0;
	ini.tfas_mensajero[8].ex_km:=0;

	ini.key[1] := 172;
	ini.key[2] := 169;
	ini.key[3] := 176;
	ini.key[4] := 176;
	ini.key[5] := 173;
	ini.key[6] := 167;
	ini.key[7] := 179;
	ini.key[8] := 178;
	ini.key[9] := 173;
	ini.key[10]:= 165;

	ini.new_disk:=true;
	ini.last_disk:=1;
	ini.permit:=true;
	ini.iva:=16
end;


procedure preparar_work;
var c:longint;s,t:string;
begin
	{$I-}
	getdir(0,s);
	t:=copy(s,1,3);
	chdir(t);
	t:=copy(ini.work,1,length(ini.work)-1);
	chdir(t);
	if ioresult<>0 then mkdir(t)
		else chdir(s)
	{$I+}
end;

procedure configure;
var
p,f,i   : pnodo_dato;
cliente : t_cliente;
op,k    : byte;
v,j     : boolean;
c       : char;
begin
	v:=false;
	j:=false;
	blackout(3,9,63,9);
	gotoxy(3,9);
	write('Porcentaje IVA : ');
	gotoxy(3,12);
	write('Pts. por Km. (Coche) : ');
	gotoxy(3,15);
	write('Pts. por Km. (Moto) : ');
	crea_lista(i,3);
	p:=i;
	with p^ do
		begin
			str(ini.iva:2:2,dato);
			dato:=dato+empty;
			especifi:=XEX80;
			ini_x:=20;
			ini_y:=9;
			longitud:=5;
			lineas:=1
		end;
	put_campo(p^,7);
	p:=p^.sig;
	with p^ do
		begin
			str(ini.pts_c_km,dato);
			dato:=dato+empty;
			especifi:=XEX80;
			ini_x:=26;
			ini_y:=12;
			longitud:=3;
			lineas:=1
		end;
	put_campo(p^,7);
	p:=p^.sig;
	with p^ do
		begin
			str(ini.pts_m_km,dato);
			dato:=dato+empty;
			especifi:=XEX80;
			ini_x:=25;
			ini_y:=15;
			longitud:=3;
			lineas:=1
		end;
	put_campo(p^,7);
	f:=p;
	p:=i;
	k:=1;
	write_msg(' Pulse Enter para continuar');
	repeat
		op:=get_field(p^);
		case op of
			0 : begin
						if k=3 then
							begin
								p:=i;
								k:=1
							end
							else begin
								p:=p^.sig;
								inc(k)
							end
					end;

			1 : begin
						if k=1 then
							begin
								p:=f;
								k:=3 { fallo, de 4 a 3}
							end
							else begin
								p:=p^.ant;
								dec(k)
							end
					end;

			2 : v:=true;

			3 : begin
						v:=true;
						j:=true
					end
		end;
	until v;
	if not j then
		begin
			p:=i;
			val(trim_real(p^.dato),ini.iva,cod);
			p:=p^.sig;
			val(trim_real(p^.dato),ini.pts_c_km,cod);
			p:=p^.sig;
			val(trim_real(p^.dato),ini.pts_m_km,cod);
			blackout(3,9,44,18);
			lowbar('Men£ Principal');
			gotoxy(15,8);
			textcolor(3);
			write('Tarifas por Defecto');
			gotoxy(13,9);
			write('ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ');
			ini_cliente(cliente);
			recuadro_tarifas_cliente(10,11);
			write_msg(' Pulse Enter para seguir');
			op:=get_tarifas_cliente(cliente,10,11);
			if op<>3 then
				begin
					for k:=1 to 9 do
						begin
							ini.tfas_defecto[k].descripcion:=cliente.tarifas[k].descripcion;
							ini.tfas_defecto[k].precio:=cliente.tarifas[k].precio;
							ini.tfas_defecto[k].ex_peso:=cliente.tarifas[k].ex_peso;
							ini.tfas_defecto[k].ex_tiempo:=cliente.tarifas[k].ex_tiempo;
							ini.tfas_defecto[k].ex_km:=cliente.tarifas[k].ex_km;
						end;
					blackout(3,8,80,24);
					gotoxy(15,8);
					textcolor(3);
					write('Tarifas de los Mensajeros');
					gotoxy(13,9);
					write('ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ');
					recuadro_tarifas_mensajero(10,11);
					write_msg(' Pulse Enter para salvar');
					op:=get_tarifas_mensajero(10,11);
					if op<>3 then
						begin
							write_msg('Actualizando...');
							save_cfg;
						end;
					setfattr(pth,archive);
					Rewrite(pth);
					codice.pth:=ini.work;
					write(pth,codice);
					close(pth);
					setfattr(pth,hidden)
				end
		end;
	swap_menu(25,5,26);
	write_msg(' Pulse cualquier tecla para seguir')
end;


procedure mueve_exe;

type matrix=array[1..1048] of byte;

var
	f,g   : file;
	bat   :  text;
	buf   : matrix;
	s     : string[3];
	r,w   : word;
	tam   : longint;
	k,step: longint;
	i,x   : byte;

	procedure cavity;
	begin
		tam:=filesize(g) div 1048;
		if tam<50 then {Si hay mas cuadritos que items es muy sencillo}
			begin
				i   :=0; {Indicador}
				step:=50 div tam; {numero de cuadrados por item}
			end
			else begin  { Si hay mas items es un poco mas complicado}
				i:=1; {Indicador}
				step:= tam div 50;  { numero de items por cuadrado}
			{ Si el resto es no nulo (aun sobran items)}
				if((tam mod 50)<>0)then inc(step); {Incrementamos }
			end;

		textbackground(9);
		gotoxy(15,20);
		write('                                                  ');
		gotoxy(33,22);
		textcolor(11);
		textbackground(0);
		write('0 ');
		lowvideo;
		write('% completo');
		cursor_off
	end;

	procedure actualiza;
	begin
		textcolor(14);
		gotoxy(x,20);
		write('Û');
		inc(x);
		textcolor(11);
		if x>19 then gotoxy(32,22)
			else gotoxy(33,22);
		write((x-15)*2);
		cursor_off
	end;


begin
	k:=0;
	x:=15;
	write_msg(' Copiando datos....');
	assign(g,'a:\mensages.dat');
	{$I-}
	reset(g,1);
	{$I+}
	if IOresult=0 then
		begin
			cavity;
			assign(f,ini.work+'MENSAGES.EXE');
			rewrite(f,1);
			repeat
				blockread(g,Buf,sizeof(buf),r);
				blockwrite(f,Buf,r,w);
				inc(k);
				if((k mod step)=0) then actualiza;
			until((r=0)or(w<>r));

			gotoxy(x,22);
			textcolor(14);
			while x<65 do actualiza;
			gotoxy(31,22);
			textcolor(11);
			write(100,' ');
			close(g);
			close(f);
			write_msg(' Escribiendo Cargador....');
			delay(200);
			s:=copy(ini.work,1,3);
			assign(bat,s+'MGES.BAT');
			rewrite(bat);
			writeln(bat,'@ECHO OFF');
			writeln(bat,ini.work,'CLOCK.EXE /P');
			writeln(bat,ini.work,'FNT1.COM');
			writeln(bat,ini.work,'MENSAGES.EXE');
			writeln(bat,ini.work,'CLOCK.EXE /U');
			writeln(bat,ini.work,'SYSFNT.COM');
			close(bat);
			textcolor(7);
			textbackground(0)
		end

end;


begin


	for op:=1 to 255 do empty:=' '+empty;
	chain:='';
	assign(pth,'c:\aga.pth');
	{$I-}
	Reset(pth);
	{$I+}
	if ioresult=0 then
		begin
			read(pth,codice);
			for op:=1 to length(codice.pth) do chain:=chain+upcase(codice.pth[op]);
			close(pth)
		end
		else begin
			chain:='C:\MENSAGES\';
			codice.pth:=chain;
			codice.code:=0;
			rewrite(pth);
			write(pth,codice);
			close(pth)
		end;

	init;

	work.dato    :=chain;
	work.ini_x   :=27;
	work.ini_y   :=9;
	work.lineas  :=1;
	work.longitud:=40;

	getdate(fecha_sistema.year,fecha_sistema.month,fecha_sistema.day,fecha_sistema.weekday);

	clrscr;
	bars;
	GOTOXY(1,2);
	CLREOL;
	textcolor(11);
	gotoxy(28,5);
	write('°±²ÛÛ INSTALAR ÛÛ²±°'); {// Len=20}
	gotoxy(3,9);
	write('Directorio de trabajo : ');
	repeat
		op:=get_field(work);
	until op>1;
	if op=2 then
		begin
			assignar;
			preparar_work;

			save_cfg;

			setfattr(pth,archive);
			rewrite(pth);
			write(pth,codice);
			close(pth);
			setfattr(pth,hidden);

			for op:=1 to length(ini.work) do ini.work[op]:=upcase(ini.work[op]);
			if ini.work<>chain then
				begin
					write_msg(' Moviendo datos.....');
					gotoxy(5,12);
					textcolor(3);
					write(' Trabajando ');
					textcolor(lightgreen);
					swap(chain,ini.work);
					gotoxy(5,12);
					clreol
				end;

			write_msg(' Desea configurar los parametros ? (S/n)');
			answer:=si_no('S');
			if answer then configure
				else write_msg(' Pulse cualquier tecla para seguir (Esc.-Salir)');
			C:=readkey;
			if C<>#27 then
				begin
					mueve_exe;
					write_msg(' Indexando la base de datos ....');
					assign(cod_ndx,ini.work+'codigo.ndx');
					create_cod_index;
					assign(fec_ndx,ini.work+'fecha.ndx');
					create_fec_index;
					assign(cod_ndx,ini.work+'facturas.ndx');
					crea_factura_ndx;
					clrscr;
					writeln(' Instalaci¢n completa');
					writeln;
					chain:='';
					for op:=1 to 2 do chain:=chain+ini.work[op];
					chdir(chain+'\');
				end
				else clrscr
		end
		else begin
			clrscr;
			writeln;
			write(' Signum instalador v1.0');
			textcolor(7);
			write('..........Instalaci¢n abortada!!');
			textcolor(7);
			writeln('.')
		end
end.
