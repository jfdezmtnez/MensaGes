unit stats;

interface


	procedure make_stats;
	procedure num_stats(option:byte);
	procedure comp_stats(option:byte);



implementation


	uses crt,defs,common,graficos;

	type mat_12 = array [1..12] of longint;




	function recent_client(var c:t_cliente) : boolean;
	var
		fecha : t_date;
	begin
		decrease(fecha_sistema);
		if ((c.ini_date.year=fecha_sistema.year) and
		 (c.ini_date.month=fecha_sistema.month)) then recent_client:=true
			else recent_client:=false;
		increase(fecha_sistema)
	end;



	procedure make_stats;
	var
		sstats   : t_monthly_stats;
		lector   : t_monthly_stats;
		ccliente : t_cliente;
		fich     : file of t_monthly_stats;
		tmp      : file of t_monthly_stats;
		clients  : file of t_cliente;
		i        : word;
	begin
		sstats.fecha.day    := fecha_sistema.day;
		sstats.fecha.month  := fecha_sistema.month;
		sstats.fecha.year   := fecha_sistema.year;
		sstats.fecha.weekday:= fecha_sistema.weekday;

		sstats.client_num   := max_clientes;
		sstats.new_client   := 0;
		sstats.income       := ini.m_income;
		for i:=1 to 10 do sstats.dealers_client[i]:=0;

		Assign(clients,ini.work+'CLIENTES.DAT');
		{$I-}
		Reset(clients);
		{$I+}
		if IOresult=0 then
			begin
				for i:=1 to max_clientes do
					begin
						read(clients,ccliente);
						inc(sstats.dealers_client[ccliente.comercial]);
						if recent_client(ccliente) then inc(sstats.new_client)
					end;
				close(clients)
			end;

		i:=0;

		Assign(fich,ini.work+'STATS.STS');
		{$I-}
		if sstats.fecha.month=1 then rewrite(fich)
		{$I+}
			else begin
				{$I-}
				Reset(fich);
				{$I+}
				if IOresult=0 then
					begin
						Assign(tmp,ini.work+'TEMP.STS');
						Rewrite(tmp);
						while not eof(fich) do
							begin
								read(fich,lector);
								if lector.fecha.month<>sstats.fecha.month then write(tmp,lector)
									else begin
										sstats.income:=sstats.income+lector.income;
										write(tmp,sstats);
										i:=1
									end
							end;

						if i=0 then write(tmp,sstats);
						i:=1;

						close(tmp);
						close(fich);
						erase(fich);
						rename(tmp,ini.work+'STATS.STS')
					end
			end;

		if((i=0)and(ioresult=0))then
			begin
				write(fich,sstats);
				close(fich)
			end;

		ini.m_income:=0;

		save_cfg
	end;




	procedure draw_bar(height:longint;step:longint);
	var
		i : longint;
	begin
		if height<>0 then
			begin
				if ((height div step)=0) then
					begin
						write('Ü');
						gotoxy(wherex,wherey-1)
					end
					else begin
						for i:=1 to (height div step) do
							begin
								write('Û');
								gotoxy(wherex-1,wherey-1);
							end;
						if ((height mod step)>=(step div 2)) then
							begin
								write('Ü');
								gotoxy(wherex,wherey-1)
							end
							else gotoxy(wherex+1,wherey-1)
					end
			end
			else gotoxy(wherex+1,wherey-1);
		gotoxy(wherex,19)
	end;



{  modos 1=clientes,  2=nuevos, 3=ingresos  }
	procedure bar_diagram(totals:mat_12; mode:byte);
	var
		i:byte;
		k:byte;
	begin
		gotoxy(9,20);
		textcolor(CYAN);
		for i:=0 to 11 do
			begin
				textcolor(CYAN);
				write('ÄÄÄÂÄÄ');
				gotoxy(wherex-4,21);
				textcolor(LIGHTGRAY);
				case (1+i) of
					1 : write('ENE');
					2 : write('FEB');
					3 : write('MAR');
					4 : write('ABR');
					5 : write('MAY');
					6 : write('JUN');
					7 : write('JUL');
					8 : write('AGO');
					9 : write('SEP');
					10: write('OCT');
					11: write('NOV');
					12: write('DIC')
				end;
				gotoxy(wherex,20)
			end;
		textcolor(CYAN);
		gotoxy(9,20);
		write('À');
		gotoxy(70,20);
		write('Ù');
		case mode of
			1 : begin
						gotoxy(30,22);
						write('CLIENTES - ');
						write(fecha_sistema.year);
						gotoxy(11,19);
						for i:=1 to 12 do
							begin
								textcolor(YELLOW);
								k:=0;

								while k<3 do
									begin
										draw_bar(totals[i],30);
										inc(k)
									end;

								if totals[i]=0 then gotoxy(wherex-3,19-(totals[i] div 30))
									else if((totals[i] div 30)=0)then gotoxy(wherex-3,18)
										else gotoxy(wherex-3,19-(totals[i] div 30));
								textcolor(cyan);
								write_right(totals[i],wherex+3);
								gotoxy(wherex+2,19)
							end
				 end;

			2 : begin
						gotoxy(30,22);
						write('CLIENTES NUEVOS - ');
						write(fecha_sistema.year);
						gotoxy(11,19);
						for i:=1 to 12 do
							begin
								textcolor(YELLOW);
								k:=0;

								while k<3 do
									begin
										draw_bar(totals[i],5);
										inc(k)
									end;

								if totals[i]=0 then gotoxy(wherex-3,19-(totals[i] div 5))
									else if((totals[i] div 5)=0)then gotoxy(wherex-3,18)
										else gotoxy(wherex-3,19-(totals[i] div 5));
								textcolor(cyan);
								write_right(totals[i],wherex+3);
								gotoxy(wherex+2,19)
							end
					end;

			3 : begin
						gotoxy(27,23);
						write('INGRESOS x 10.000 - ');
						write(fecha_sistema.year);
						gotoxy(11,19);
						for i:=1 to 12 do
							begin
								textcolor(YELLOW);
								k:=0;

								while k<3 do
									begin
										draw_bar(totals[i],400000);
										inc(k)
									end;

								if totals[i]=0 then gotoxy(wherex-3,19-(totals[i] div 400000))
									else if((totals[i] div 400000)=0)then gotoxy(wherex-3,18)
										else gotoxy(wherex-3,19-(totals[i] div 400000));
								textcolor(cyan);
								write_right(totals[i] div 10000,wherex+3);
								gotoxy(wherex+2,19)
							end
					end;


			4 : begin
						gotoxy(30,22);
						write('CLIENTES - ');
						write(fecha_sistema.year);
						gotoxy(11,19);
						for i:=1 to 12 do
							begin
								textcolor(YELLOW);
								k:=0;

								while k<3 do
									begin
										draw_bar(totals[i],15);
										inc(k)
									end;

								if totals[i]=0 then gotoxy(wherex-3,19-(totals[i] div 15))
									else if((totals[i] div 15)=0)then gotoxy(wherex-3,18)
										else gotoxy(wherex-3,19-(totals[i] div 15));
								textcolor(cyan);
								write_right(totals[i],wherex+3);
								gotoxy(wherex+2,19)
							end
				 end

			end;

		cursor_off;
	end;



	procedure num_stats (option : byte);
	var
		nums   : mat_12;
		lector : t_monthly_stats;
		fich   : file of t_monthly_stats;
		feccia : t_date;
		i      : byte;
		c      : char;
	begin
		swap_menu(26,5,24);
		gotoxy(24,5);
		textcolor(LIGHTCYAN);

		case option of
			1 : write('°±²ÛÛ CLIENTES POR MES ÛÛ²±°');
			2 : write('°±²ÛÛ CLIENTES  NUEVOS ÛÛ²±°');
			3 : write('°±²ÛÛ INGRESOS TOTALES ÛÛ²±°')
		end;

		write_msg('Procesando...');
		for i:=12 downto 1 do nums[i]:=0;
		Assign(fich,ini.work+'STATS.STS');
		{$I-}
		Reset(fich);
		{$I+}
		if IOresult=0 then
			begin

				while not eof(fich) do
					begin
						read(fich,lector);
						if lector.fecha.year=fecha_sistema.year then
						case option of
							1 : nums[lector.fecha.month]:=lector.client_num;
							2 : nums[lector.fecha.month]:=lector.new_client;
							3 : nums[lector.fecha.month]:=lector.income
						end
					end;

				close(fich);
				write_msg(' Pulse cualquier tecla para volver');
				bar_diagram(nums,option);
				c:=readkey
			end
			else error(13);

		swap_menu(24,5,28);
		lowbar('Menu Principal')
	end;


{  // modos: 1=clientes por comercial, 2=clientes nuevos por comercial.}
	procedure comp_stats (option : byte);
	var
		i,op  : byte;
		nums  : mat_12;
		code  : t_nodo_dato;
		fich  : file of t_monthly_stats;
		lector: t_monthly_stats;
		temp  : string;
		v,j   : boolean;
		cod   : integer;
		c     : char;
	begin
		swap_menu(26,5,24);
		lowbar('Estadisticas');

		v            :=false;
		j            :=false;

		code.longitud:= 2;
		code.ini_x   :=34;
		code.ini_y   :=10;
		code.lineas  := 1;

		for i:=11 downto 0 do nums[i+1]:=0;
		lector.fecha.year:=0;

		Assign(fich,ini.work+'STATS.STS');
		{$I-}
		Reset(fich);
		{$I+}
		if IOresult=0 then
			begin
				textcolor(LIGHTCYAN);
				gotoxy(26,4);
				write('°±²ÛÛ CLIENTES POR COMERCIAL ÛÛ²±°'); {// 24}
				
				repeat
					blackout(3,6,70,23);
					gotoxy(25,10);
					textcolor(LIGHTGRAY);
					write('C¢digo : ');
					code.dato:=empty;
					repeat
						op:=get_field(code);
						if op=2 then v:=true
							else if op=3 then
								begin
									v:=true;
									j:=true;
								end
					until v;

					if not j then
						begin
							temp:=trim(code.dato);
							val(temp,i,cod);
							if ((i<=max_comerciales)and(i>0)) then
								begin
									while not eof(fich) do
										begin
											read(fich,lector);
											if lector.fecha.year=fecha_sistema.year then
											nums[lector.fecha.month]:=lector.dealers_client[i];
										end;
									blackout(3,6,37,10);
									gotoxy(3,6);
									Lowvideo;
									write('Comercial : ');
									Highvideo;
									write_n_digits(i,2);
									bar_diagram(nums,option+3);
									write_msg(' Ver otro comercial (s/N)');
									j:=not(si_no('N'));
									write_msg('                         ');
								end
								else begin
									error(6);
									lowbar('Estad¡sticas')
								end

						end;

				until j

			end
			else error(13);

	end;


	 {

	 En make_stats tengo que a¤adir la actualizacion, o bien la escritura del 
	 fichero "clientes.sts" dicho fichero va ser un file of byte. En el
	 almacenare consecutivamente
	 
	 }




end.