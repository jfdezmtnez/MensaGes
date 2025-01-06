unit print;

interface

	uses defs;

	procedure print_fact_mensajero(var mensajero:t_mensajero; serv:t_servs; sub:t_subts);
	procedure print_fact_comercial(var comercial:t_comercial;sub:longint);
	procedure print_fact_cliente(var ccliente:t_cliente; lista:listalbs;
																sub:longint;
																cad:string;
																number:string;
																var lim:byte;
																var pie :t_foot;
																var ju :string);
	procedure get_printer_status(var estado:t_status);
	procedure ini_printer(var estado:t_status);
	procedure heading;
	procedure right_justify (code:longint;lengt:byte);
	procedure print_n_digits (code:word;n:byte);




implementation

	uses formulas,graficos,windos,crt;



	const

		StartPage= '';
		EndPage  = #12;
		Postamble= '';

	{var Prnt : TEXT;}

	var t:char;


	 procedure get_printer_status;
	 var
			status:byte;


	 begin
				regs.ah:=$02;
				regs.dx:=0;
				intr($17,regs);
				status:=regs.ah;

				with estado do
				begin
						 timeout:=false;
						 io_error:=false;
						 printer_selected:=false;
						 paper_out:=false;
						 acknow:=false;
						 busy:=false;
				end;

				with estado do
				begin
						 if (status and 1)<>0 then timeout:=true;
						 if (status and 8)<>0 then io_error:=true;
						 if (status and 16)<>0 then printer_selected:=true;
						 if (status and 32)<>0 then paper_out:=true;
						 if (status and 64)<>0 then acknow:=true;
						 if (status and 128)<>0 then busy:=false;
				end;

	 end;

	 procedure ini_printer;
	 var
			status:byte;
	 begin
				regs.ah:=$01;
				regs.dx:=0;
				intr($17,regs);
				status:=regs.ah;

				with estado do
				begin
						 timeout:=false;
						 io_error:=false;
						 printer_selected:=false;
						 paper_out:=false;
						 acknow:=false;
						 busy:=false;
				end;

				with estado do
				begin
						 if (status and 1)<>0 then timeout:=true;
						 if (status and 8)<>0 then io_error:=true;
						 if (status and 16)<>0 then printer_selected:=true;
						 if (status and 32)<>0 then paper_out:=true;
						 if (status and 64)<>0 then acknow:=true;
						 if (status and 128)<>0 then busy:=false;
				end;

	 end;



	procedure heading;
	var mes : string[10];
	begin
		write(Prnt,StartPage);
		write(Prnt,'                                                ');
		writeln(prnt,hoy);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt)
	end;

	procedure print_n_digits (code:word;n:byte);
	var cad:string;
	begin
		str(code,cad);
		while length(cad)<n do cad:='0'+cad;
		write(Prnt,cad);
	end;

	procedure right_justify (code:longint;lengt:byte);
	var cad:string;
	begin
		str(code,cad);
		while length(cad)<lengt do cad:=' '+cad;
		write(Prnt,cad)
	end;

	procedure left_justify (cad:string;lengt:byte);
	begin
		while length(cad)<lengt do cad:=cad+' ';
			write(Prnt,cad)
	end;

	procedure print_left(code:longint; lengt:byte);
	var cad:string;
	begin
		str(code,cad);
		left_justify(cad,lengt)
	end;


	procedure print_fact_mensajero;
	var
		I               : byte;
		monto,s,k,w,t,b : longint;
	begin
		k:=0;
		w:=0;
		t:=0;
		b:=0;
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		heading;
		monto:=0;
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt,'                             FACTURACION DE MENSAJERO');
		writeln(Prnt,'                          ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		write(Prnt,'        C¢digo: ');
		print_n_digits(mensajero.codigo,2);
		writeln(Prnt);
		writeln(Prnt,'        ',mensajero.nombre);
		writeln(Prnt,'        C/ ',mensajero.direccion.calle);
		write(Prnt,'          N§ ',mensajero.direccion.numero);
		write(Prnt,' Piso ');
		write(Prnt,mensajero.direccion.piso);
		writeln(Prnt,' ',mensajero.direccion.letra);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt,'       ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿ÚÄÄÄÄÄÄÄÄÄÄ¿');
		writeln(Prnt,'       ³ Tipo ³ Precio ³ N£mero ³ Ex.P. ³ Tiempo ³ Ex. km ³³ Subtotal ³');
		writeln(Prnt,'       ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´ÃÄÄÄÄÄÄÄÄÄÄ´');
		for i:=1 to 8 do
		begin
			s:=serv[1,i];
			b:=b+serv[1,i]*ini.tfas_mensajero[i].precio;
			w:=w+serv[2,i]*ini.tfas_mensajero[i].ex_peso;
			t:=t+serv[3,i]*ini.tfas_mensajero[i].ex_tiempo;
			k:=k+serv[4,i]*ini.tfas_mensajero[i].ex_km;
			monto:=monto+sub[i];
			write(Prnt,'       ³  ');
			print_n_digits(i,2);
			write(Prnt,'  ³ ');
			right_justify(ini.tfas_mensajero[i].precio,6);
			write(Prnt,' ³ x ');
			right_justify(s,4);
			write(Prnt,' ³ ');
			s:=serv[2,i];
			right_justify(s,5);
			write(Prnt,' ³ ');
			s:=serv[3,i];
			right_justify(s,6);
			write(Prnt,' ³ ');
			s:=serv[4,i];
			right_justify(s,6);
			write(Prnt,' ³³ ');
			right_justify(sub[i],8);
			writeln(Prnt,' ³')
		end;
		writeln(Prnt,'       ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙÀÄÄÄÄÄÄÄÄÄÄÙ');
		writeln(Prnt,'                       ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿ÉÍÍÍÍÍÍÍÍÍÍ»');
		write(Prnt,'             Importes  ³ ');
		right_justify(b,6);
		write(Prnt,' ³ ');
		right_justify(w,5);
		write(Prnt,' ³ ');
		right_justify(t,6);
		write(Prnt,' ³ ');
		right_justify(k,6);
		write(Prnt,' ³º ');
		right_justify(monto,8);
		writeln(Prnt,' º');
		writeln(Prnt,'                       ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙÈÍÍÍÍÍÍÍÍÍÍ¼');
		write(Prnt,#12)
	end;



	procedure print_fact_comercial;
	var neto:longint;
	begin
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		heading;
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt,'                          FACTURACION DE COMERCIAL');
		writeln(Prnt,'                       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		write(Prnt,'        C¢digo: ');
		print_n_digits(comercial.codigo,2);
		writeln(Prnt);
		writeln(Prnt,'        ',comercial.nombre);
		write(Prnt,'        C/ ',comercial.direccion.calle);
			write(Prnt,'        N§ ',comercial.direccion.numero);
		write(Prnt,' Piso ');
		write(Prnt,comercial.direccion.piso);
		writeln(Prnt,' ',comercial.direccion.letra);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt);
		writeln(Prnt,'                                  ÚÄÄÄÄÄÄÄÄÄÄ¿');
		write(Prnt,'                      Total bruto ³ ');
		right_justify(sub,8);
		writeln(Prnt,' ³');
		writeln(Prnt,'                                  ÀÄÄÄÄÄÄÄÄÄÄÙ');
		neto:=total_neto_comercial(comercial,sub);
		writeln(Prnt,'                                  ÚÄÄÄÄÄÄÄÄÄÄ¿');
		write(Prnt,'                      Total neto  ³ ');
		right_justify(neto,8);
		write(Prnt,' ³ ');
		writeln(Prnt,comercial.porcentaje,' %');
		writeln(Prnt,'                                  ÀÄÄÄÄÄÄÄÄÄÄÙ');
		write(Prnt,#12);
	end;



	procedure print_fact_cliente;
	var
		y_imp   : byte;
		est     : t_status;
		auxiliar: listalbs;

		procedure print_line(cod:t_codigo;fe:t_date;o:resumen_serv;g:longint);
		var z,resto,espacio:byte;
		begin
				write(prnt,cod.numero,cod.letra);
				str(cod.numero,cad);
				cad:=cad+cod.letra;
				espacio:=7-length(cad);
				for z:=1 to espacio do write(prnt,' ');
				print_n_digits(fe.day,2);
				write(prnt,'/');
				print_n_digits(fe.month,2);
				write(prnt,'/');
				write(prnt,fe.year);
				write(prnt,'  ');
				espacio:=1;
				for z:=1 to 9 do
					begin
							if o[z]<>0 then if o[z]>9 then
							begin
								 inc(espacio,4);
								 write(prnt,'0',z:1,'x',o[z],' ');
							end
							else
							begin
								 inc(espacio,5);
								 write(prnt,'0',z:1,'x',o[z],' ');
							end;
					end;
				if o[z]<>0 then if o[z]>9 then
				begin
					 inc(espacio,4);
					 write(prnt,'0',z:1,'x',o[z],' ');
				end
				else
				begin
					 inc(espacio,5);
					 write(prnt,'0',z:1,'x',o[z],' ');
				end;
				for z:=1 to 46-espacio do write(prnt,'.');
				write(prnt,' ');

				right_justify(g,6);
				writeln(prnt);
		end;


	 procedure print_head;
	 var i:byte;
	 begin
				writeln(prnt,'                                         ',hoy);
				writeln(prnt);

				with ccliente do
				begin
						 for i:=1 to 53 do write(prnt,' ');
						 writeln(prnt,'Factura N§: ',number);
						 writeln(prnt);
						 writeln(prnt,'Tel‚fono: ',telefono,'     C.I.F.: ',cif);
						 writeln(prnt,nombre);
						 writeln(prnt,'C/ ',direccion.calle);
						 if direccion.numero<>0 then writeln(prnt,'N§ ',direccion.numero);
						 if direccion.piso<>0 then write(prnt,' ',direccion.piso,' ',direccion.letra);
						 writeln(prnt,direccion.localidad);
						 writeln(prnt,direccion.provincia);
						 if descuento<>0 then writeln(prnt,'Descuento: ',descuento,' %') else writeln(prnt);
						 writeln(prnt,'Pago : ',ccliente.forma_pago)
				end;
	 end;


	 procedure print_head_line;
	 begin
			writeln(prnt,'Cod.   Fecha       Servicio/s                                   Subtotal');
			writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
	 end;


	 procedure checkline;
	 begin
		 if y_imp>30 then
			 begin

				 write(prnt,#12);
				 write_msg('Introduzca una hoja y pulse una tecla');
				 t:=readkey;
				 write_msg('                                                     ');

				 get_printer_status(est);
				 while ((est.paper_out)or(est.io_error)) do
					 begin
						 write_msg(' Pulse una tecla cuando est‚ listo');
						 repeat until keypressed;
						 if est.io_error then error(15)
							 else if est.paper_out then error(14);
						 get_printer_status(est)
					 end;

				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 print_head_line;
				 y_imp:=1
			 end
			 else inc(y_imp)
	 end;



	 procedure print_tarifas;
	 var
			i:byte;
	 begin
			if y_imp+16>30 then
				begin

					write(prnt,#12);
					write_msg('Introduzca una hoja y pulse una tecla');
					t:=readkey;
					write_msg('                                                     ');

					get_printer_status(est);
					while ((est.paper_out)or(est.io_error)) do
						begin
							write_msg(' Pulse una tecla cuando est‚ listo');
							repeat until keypressed;
							if est.io_error then error(15)
								else if est.paper_out then error(14);
							get_printer_status(est)
						end;

					writeln(prnt);
					writeln(prnt);
					writeln(prnt);
					writeln(prnt);
					writeln(prnt);
					writeln(prnt);
					writeln(prnt);
					y_imp:=1
				end;

			writeln(prnt);
			writeln(prnt);
			writeln(prnt);
			writeln(prnt,'TARIFAS');
			writeln(prnt);
			writeln(prnt,'Cod.  Descripci¢n   Precio  ');
			writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
			for i:=1 to _max_tfas_cliente do
				begin
					with ccliente.tarifas[i] do
						begin
							write(prnt,' ',i,'    ');
							write(prnt,descripcion,'  ');
							right_justify(precio,5);
							writeln(prnt);
						end
				end;
			y_imp:=y_imp+13
	 end;


	 procedure print_foot;
	 var cd:integer;
	 begin
		 if y_imp>30 then
			 begin

				 write(prnt,#12);
				write_msg('Introduzca una hoja y pulse una tecla');
				t:=readkey;
				 write_msg('                                                   ');

				 get_printer_status(est);
				 while ((est.paper_out)or(est.io_error)) do
					 begin
						 write_msg(' Pulse una tecla cuando est‚ listo');
						 repeat until keypressed;
						 if est.io_error then error(15)
							 else if est.paper_out then error(14);
						 get_printer_status(est)
					 end;

				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 writeln(prnt);
				 y_imp:=1
			 end
			 else begin
				 writeln(prnt);
				 writeln(prnt)
			 end;
		 write_msg(' Imprimiendo....');
		 writeln(prnt,' T.Bruto     Dto.      Base       I.V.A.     Importe     R.E.    T.NETO');
		 writeln(prnt,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄ¿');
		 write(prnt,'³');
		 
		 print_left(pie.total,12);

		 print_left(pie.descuento,10);

		 print_left(pie.total-pie.descuento,11);

		 write(prnt,ini.iva:2:1);
		 write(prnt,' %     ');

		 print_left(pie.iva,12);

		 print_left(pie.recargo_eq,7);

		 write(prnt,'³');
		 right_justify(pie.total-pie.descuento+pie.iva+pie.recargo_eq,6);
		 write(prnt,'³');
		 writeln(prnt,' Pts.');
		 writeln(prnt,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÙ');
		 writeln(prnt)
	 end;


	begin
		write_msg(' Imprimiendo....');
		auxiliar:=lista;
		y_imp:=0;
		writeln(prnt);
		writeln(prnt);
		writeln(prnt);
		writeln(prnt);
		writeln(prnt);
		writeln(prnt);
		writeln(prnt);
		writeln(prnt);
		writeln(prnt);

		print_head;

		writeln(prnt);
		print_head_line;
		while lista<>nil do
			begin
				write_msg('Imprimiendo linea: ');
				textcolor(YELLOW);
				textbackground(BLUE);
				gotoxy(21,25);
				write(y_imp);
				textcolor(CYAN);
				textbackground(BLACK);
				print_line(lista^.codigo,lista^.fecha,lista^.se,lista^.temp);
				checkline;

				lista:=lista^.sig

			end;

		print_foot;
		print_tarifas;
		lista:=auxiliar;
		write(prnt,#12);
		write_msg('Espere a finalizar la impresi¢n y pulse una tecla');
		t:=readkey;
		write_msg('                                                 ');
	end;


begin
end.