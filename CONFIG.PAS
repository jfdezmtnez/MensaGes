unit config;

interface

	procedure init;
	procedure configure;


implementation

	uses windos,crt,defs,common,campstru,tfnomem,ficheros,graficos,gets ;

	function read_cfg:boolean;
	var f:file of t_ini;
	begin
		assign(f,ini.work+'MENSAGES.CFG');
		{$I-}
		reset(f);
		{$I+}
		if ioresult=0 then
			begin
				read_cfg:=true;
				read(f,ini);
				close(f)
			end
			else read_cfg:=false
	end;

	procedure errorcillo;
	begin
		textcolor(7);
		clrscr;
		writeln('  Debe reinstalar el programa...');
		halt(1);
	end;

	procedure init;
	var
		llave : file of aga;
		lector: aga;
	begin
		getdate(fecha_sistema.year,fecha_sistema.month,fecha_sistema.day,fecha_sistema.weekday);
		assign(llave,'C:\AGA.PTH');
		{$I-}
		reset(llave);
		{$I+}
		if ioresult<>0 then errorcillo;
		read(llave,lector);
		ini.work:=lector.pth;
		close(llave);
		if read_cfg then
			begin
				{$I-}
				ini_tfnos(telefonos);
				assign(fichfact,ini.work+'fact_h.dat');
				assign(tempfact,ini.work+'fact_h.tmp');

				assign(fichlin,ini.work+'fact_alb.dat');
				assign(templin,ini.work+'fact_alb.tmp');

				assign(fichalbs,ini.work+'albaran.dat');
				assign(tempalbs,ini.work+'albaran.tmp');

				assign(fichalbs,ini.work+'albaran.dat');
				assign(tempalbs,ini.work+'albaran.tmp');

				assign(fichclientes,ini.work+'clientes.dat');
				assign(tempclientes,ini.work+'clientes.tmp');

				assign(fichcomercia,ini.work+'dealers.dat');
				assign(tempcomercia,ini.work+'dealers.tmp');

				assign(fichmessager,ini.work+'messager.dat');
				assign(tempmessager,ini.work+'messager.tmp');

				assign(cod_ndx,ini.work+'codigo.ndx');
				assign(temp_cod_ndx,ini.work+'codigo.tmp');

				assign(fec_ndx,ini.work+'fecha.ndx');
				assign(temp_fec_ndx,ini.work+'fecha.tmp');

				assign(fact_ndx,ini.work+'fact.ndx');
				assign(temp_fact_ndx,ini.work+'fact.tmp');

				assign(cod_dsk,ini.work+'albaran.dsk');
				assign(temp_cod_dsk,ini.work+'dsk.tmp');

				{$I+}


				max_clientes:=scan_client_f(telefonos);
				max_comerciales:=scan_dealer_f;
				max_mensajeros:=scan_messager_f;
				max_albaranes:=scan_dispatch_f;
				max_facturas:=scan_facturas_f;
				max_lineas_alb:=scan_lineas_alb_f;
			end;
		decrease(fecha_sistema);
		ini.last_fact_month:=transform(fecha_sistema);
		increase(fecha_sistema);
		save_cfg;
		textcolor(7)
	end;


	procedure configure;
	var
		p,f,i   : pnodo_dato;
		cliente : t_cliente;
		fich    : FILE of t_ini;
		lector  : aga;
		faga    : file of aga;
		bat     : text;
		op,k,cte: byte;
		v,j     : boolean;
		c       : char;
		
	begin
		v:=false;
		j:=false;
		lowbar('Menฃ Principal');
		swap_menu(25,5,26);
		gotoxy(25,5);
		Textcolor(11);
		write('ฐฑฒÛÛ CONFIGURACION  ÛÛฒฑฐ');
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
									k:=3
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
				p^.dato:=trim_real(p^.dato);
				val(p^.dato,ini.iva,cod);
				p:=p^.sig;
				val(trim_real(p^.dato),ini.pts_c_km,cod);
				p:=p^.sig;
				val(trim_real(p^.dato),ini.pts_m_km,cod);
				blackout(3,9,44,18);
				lowbar('Menฃ Principal');
				gotoxy(15,8);
				textcolor(3);
				write('Tarifas por Defecto');
				gotoxy(13,9);
				write('อออออออออออออออออออออออ');
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
						write('อออออออออออออออออออออออออออออ');
						recuadro_tarifas_mensajero(10,11);
						write_msg(' Pulse Enter para salvar');
						op:=get_tarifas_mensajero(10,11);
						if op<>3 then
							begin
								write_msg('Actualizando...');
								save_cfg;
								assign(faga,'C:\AGA.PTH');
								setfattr(faga,faarchive);
								reset(faga);
								read(faga,lector);
								close(faga);
								lector.pth:=ini.work;
								rewrite(faga);
								write(faga,lector);
								close(faga);
								setfattr(faga,fahidden);
								assign(bat,'C:\MGES.BAT');
								rewrite(bat);
								writeln(bat,'@ ',ini.work,'MYFONT.COM');
								writeln(bat,'@ ',ini.work,'MENSAGES.EXE');
								writeln(bat,'@ ',ini.work,'FNT1.COM');
								close(bat)
							end
					end
			end;
		swap_menu(25,5,26)
	end;


end.
