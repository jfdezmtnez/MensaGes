unit cliente;

interface

procedure consultar_client;
procedure new_cliente;
procedure modif_client;
procedure borrar_cliente;
procedure facturar_client;
procedure listar_client;


implementation

	uses crt,defs,common,graficos,tfnomem,campstru,ficheros,gets,puts,
	 print,formulas,stats,facturas;


(* Rutina para comprobar el telefono del cliente y su existencia *)

	procedure check_telefono(mode:byte;var j:boolean;var tfno:longint;var k:word);
	var
		v       : boolean;
		campo   : t_nodo_dato;
		op      : integer;
	begin
		v:=true;
		j:=false;
		lowbar('Menu Clientes');
		blackout(1,2,80,24);
		textcolor(11);
		gotoxy(3,3);
		write('Tel‚fono:');
		lowvideo;
		while v do
			begin
				with campo do
					begin
						dato:=empty;
						especifi:=empty;
						ini_x:=12;
						ini_y:=3;
						longitud:=7;
						lineas:=1;
					end;
				op:=get_field(campo);
				tfno:=str_to_long(trim(campo.dato));
				if op=3 then
					begin
						v:=false;
						j:=true
					end
					else if op=2 then
						begin
							write_msg('Comprobando.....');
							k:=busca_tfno(telefonos,tfno,max_clientes);
							if mode=0 then
								begin
									if k=0 then
										begin
											error(3);
											lowbar('Men£ Clientes')
										end
										else v:=false
								end
								else begin
									if k<>0 then begin
										error(2);
										lowbar('Men£ Clientes')
									end
									else v:=false
								end
						end
			end;
	end;


(* Rutina para consultar los datos de un cliente *)

	procedure consultar_client;
	var
		ccliente: t_cliente;
		telefono:   longint;
		pos     :      word;
		i       :   integer;
		c       :      char;
		j,ans   :   boolean;
	begin

		repeat

			check_telefono(0,j,telefono,pos);


			if not j then
				begin
					write_msg('Buscando.....');
					busca_cliente_f(ccliente,pos);
					blackout(12,3,20,3);
					recuadro_cliente(3,3);
					put_cliente(ccliente,3,3);
					write_msg('Pulse una tecla para ver tarifas. (Esc-Salir)');
					c:=readkey;
					if c<>#27 then
						begin
							write_msg('Consultar otro cliente (S/n)');
							put_tarifas_cliente(ccliente,15,12);
							ans:=si_no('S')
						end
				end;
		until (j or not ans)
	end;



(* Rutina para dar de alta un cliente *)

	procedure new_cliente;
	var
		ccliente:  t_cliente;
		op,pos  :       word;
		telefono:    longint;
		i       :    integer;
		v,j,ans :    boolean;
	begin

		repeat
			check_telefono(1,j,telefono,pos);

			v:=false;

			if not j then
				begin
					lowbar('Men£ Clientes');
					ini_cliente(ccliente);
					ccliente.telefono:=telefono;
					repeat
						blackout(12,3,54,19);
						recuadro_cliente(3,3);
						op:=get_cliente(ccliente,3,3);
						if op=3 then
							begin
								j:=true;
								v:=true
							end
							else begin
								recuadro_tarifas_cliente(15,12);
								op:=get_tarifas_cliente(ccliente,15,12);
								if op=2 then v:=true
							end;
					until v;
					if not j then
						begin
							write_msg('A¤adiendo cliente....');
							pos:=ins_tfno(telefonos,ccliente.telefono,max_clientes);
							ins_cliente_f(ccliente,pos,max_clientes);
							write_msg('Introducir otro cliente (s/N)');
							ans:=si_no('N');
						end
				end;
		until (j or not ans)
	end;



(* Modificar clientes, hay que fozar con el fichero de marras *)

	procedure modif_client;
	var
		ccliente : t_cliente;
		telefono:   longint;
		op,pos  :      word;
		v,j,ans :   boolean;
		i       :   integer;
	begin

		repeat
			check_telefono(0,j,telefono,pos);

			v:=false;

			if not j then
				begin
					ini_cliente(ccliente);
					ccliente.telefono:=telefono;
					write_msg('Buscando.....');
					busca_cliente_f(ccliente,pos);
					lowbar('Men£ Clientes');
					repeat
						blackout(12,3,54,19);
						recuadro_cliente(3,3);
						op:=get_cliente(ccliente,3,3);
						if op=3 then
							begin
								v:=true;
								j:=true;
							end
							else begin
								recuadro_tarifas_cliente(15,12);
								op:=get_tarifas_cliente(ccliente,15,12);
								if op=2 then v:=true
							end;
					until v;

					if not j then
						begin
							write_msg('Modificar cliente (s/N)');
							ans:=si_no('N');
							if ans then
							begin
								write_msg('Actualizando cliente.....');
								borra_tfno(telefonos,pos,max_clientes);
								borra_cliente_f(pos,max_clientes+1);
								pos:=ins_tfno(telefonos,ccliente.telefono,max_clientes);
								ins_cliente_f(ccliente,pos,max_clientes);
							end
						end;
					write_msg('Modificar otro cliente (s/N)');
					ans:=si_no('N')
				end;
		until (j or not ans)
	end;



(* Dar de baja a un cliente *)

	procedure borrar_cliente;
	var
		ccliente : t_cliente;
		telefono :   longint;
		pos      :      word;
		j,ans    :   boolean;
		i        :   integer;
	begin
		repeat
			check_telefono(0,j,telefono,pos);

			if not j then
				begin
					write_msg('Buscando.....');
					busca_cliente_f(ccliente,pos);
					lowbar('Men£ Clientes');
					recuadro_cliente(3,3);
					put_cliente(ccliente,3,3);
					write_msg('Borrar cliente (s/N)');
					ans:=si_no('N');
					if ans then
						begin
							write_msg('Borrando cliente.....');
							borra_tfno(telefonos,pos,max_clientes);
							borra_cliente_f(pos,max_clientes-1)
						end;
					write_msg('Borrar otro cliente (s/N)');
					ans:=si_no('N')
				end;
		until (j or not ans)
	end;




procedure facturar_client;

var
	ccliente                               : t_cliente;
	fecha_ini,fecha_fin,d,sub,telefono,temp: longint;
	fact_number                            : longint;
	number                                 : string[7];
	j_number,contador,num_alb,op,pos,i     : word;
	total_albaranes                        : word;
	imp,todos,bien,v,j,ans                 : boolean;
	dato,campo                             : t_nodo_dato;
	cad,cadf,ju                            : string;
	se                                     : resumen_serv;
	est                                    : t_status;
	fecia                                  : t_index2;
	codigo                                 : t_codigo;
	pie                                    : t_foot;
	cuadrado_x,u,m,a,paso                  : integer;
	alb                                    : t_albaran;
	blb,clb                                : listalbs;
	x,y,lim,copias                         : byte;
	fiche1,fiche2,fiche                    : str_11;
	tefnos                                 : t_telefonos;
	C                                      : char;
	factura_head                           : t_factura_head;
	factura_lista                          : listalbs;
	res                                    : word;
	numero_factura                         : t_codigo;
	tecla                                  : char;



	procedure facturar_uno(t:longint);


	procedure write_line(cod:t_codigo;fe:t_date;o:resumen_serv;g:longint;a,b:byte);
	var z,resto:byte;
	begin
		 gotoxy(a+1,b);
		 write(cod.numero,cod.letra);
		 gotoxy(a+9,b);
		 write(fe.day,'/',fe.month,'/',fe.year);
		 gotoxy(a+22,b);
		 if o[1]<>0 then write('01x',o[1],' ');
		 if o[2]<>0 then write('02x',o[2],' ');
		 if o[3]<>0 then write('03x',o[3],' ');
		 if o[4]<>0 then write('04x',o[4],' ');
		 if o[5]<>0 then write('05x',o[5],' ');
		 if o[6]<>0 then write('06x',o[6],' ');
		 if o[7]<>0 then write('07x',o[7],' ');
		 if o[8]<>0 then write('08x',o[8],' ');
		 if o[9]<>0 then write('09x',o[9]);
		 resto:=63-wherex;
		 for z:=1 to resto-2 do write('.');
		 gotoxy(a+61,b);
		 write_right(g,a+67);
	end;



	procedure write_head;
	var b:byte;
	begin
		 blackout(1,2,80,22);
		 textcolor(WHITE+BLINK);
		 highvideo;
		 gotoxy(1,3);
		 for b:=1 to 78 do write(ccliente.nombre[b]);
		 textcolor(BLUE);
		 highvideo;
		 gotoxy(60,4);
		 write('Factura N§: ',number);
		 gotoxy(1,4);
		 writeln('Telefono: ',ccliente.telefono);
		 writeln;
		 writeln(' Cod.    Fecha        Servicio/s                             Subtotal');
		 writeln(' ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
		 writeln;
		 textcolor(CYAN);
		 lowvideo;
	end;


	procedure write_foot;
	begin
		 textcolor(BLUE);
		 highvideo;
		 gotoxy(1,20);
		 writeln('T.Bruto     Dto.      Base       I.V.A.     Importe     R.E.     T.NETO');
		 writeln('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
		 textcolor(11);
		 write_left(pie.total,12);
		 write_left(pie.descuento,10);
		 write_left(pie.total-pie.descuento,11);
		 write(ini.iva:2:1,' %     ');
		 write_left(pie.iva,12);
		 write_left(pie.recargo_eq,9);
		 textcolor(WHITE+BLINK);
		 gotoxy(65,22);
		 write_left(pie.total-pie.descuento+pie.iva+pie.recargo_eq,6);
		 write(' Pts.');
		 textcolor(YELLOW);
		 gotoxy(2,18);
		 write('N§ Total de Albaranes: ',total_albaranes);
		 textcolor(CYAN)

	end;

	procedure new_list(var n:listalbs; a:t_albaran);
	var index:byte;
	begin
		new(n);
		n^.sig      := nil;
		n^.codigo   := a.codigo;
		n^.fecha    := a.fecha;
		n^.temp     := temp;
		for index:=1 to 9 do n^.se[index]:=se[index];
	end;

	procedure add_node (var n:listalbs; a:t_albaran);
	var aux1,aux2:listalbs;
	begin
		aux1:=n;
		while aux1^.sig<>nil do aux1:=aux1^.sig;
		new_list(aux2,a);
		aux1^.sig:=aux2
	end;

	begin
		{$I-}
		reset(fichalbs);
		reset(fec_ndx);
		{$I+}
		if ioresult<>0 then
			begin
				error(10);
				lowbar('Men£ Clientes');
			end
		else begin

			close(fec_ndx);
			close(fichalbs);
			blb:=nil;

			repeat
				gotoxy(2,7);
				write('Numero de Factura:                                     ');
				dato.dato:='             ';
				dato.especifi:='xxxxxxxxxxxxx';
				dato.ini_x:=21;
				dato.ini_y:=7;
				dato.longitud:=7;
				dato.lineas:=1;
				str(ini.last_fact_number,number);
				dato.dato:=number+'A';
				op:=get_field(dato);
				number:=dato.dato;
				val(trim(number),j_number,cod);
				numero_factura.numero:=j_number;
				numero_factura.letra:='A';
				if op=2 then v:=true
						else begin v:=false; campo.dato:=''; end;
			until v;

			y:=8;
			write_msg(' Facturando ....              ');
			sub:=0;
			x:=1;
			lim:=20;
			total_albaranes:=0;
			write_head;
			contador:=1;
			textcolor(YELLOW);
			textbackground(BLUE);
			highvideo;
			cuadrado_x:=20;
			gotoxy(cuadrado_x,25);
			write('°°°°°°°°°°°°°°°°°°°°');
			cursor_off;
			textcolor(CYAN);
			textbackground(BLACK);
			lowvideo;
			reset(fec_ndx);
			rewrite(temp_fec_ndx);
			while not(eof(fec_ndx)) do
			begin
				read(fec_ndx,fecia);
				write(temp_fec_ndx,fecia);
			end;
			close(temp_fec_ndx);
			close(fec_ndx);
			reset(fec_ndx);
			while not(eof(fec_ndx)) do
				begin
					gotoxy(80,25);
					read(fec_ndx,fecia);
					if ((fecia.fecha>=fecha_ini)and(fecia.fecha<=fecha_fin)) then
						begin
							textcolor(YELLOW);
							textbackground(BLUE);
							highvideo;
							if (contador mod paso)=0 then
								begin
									gotoxy(cuadrado_x,25);
									write('²');
									inc(cuadrado_x);
								end;
							textcolor(CYAN);
							textbackground(BLACK);
							lowvideo;
							inc(contador);
{ A¤ado aqu¡ la comprobaci¢n de si el albar n ha sido facturado }
							if not(fecia.facturado) then
								begin
									pos:=busca_albaran_f(alb,codigo,0,fecia.pos);
									if alb.telefono=t then
										begin
											inc(total_albaranes);
											temp:=calcular_albaran(alb,ccliente,se);

											if blb=nil then new_list(blb,alb)
												else add_node(blb,alb);

											sub:=sub+temp;
											write_line(alb.codigo,alb.fecha,se,temp,x,y);
											if y>16 then
												begin
													gettext(1,9,80,17,pantalla);
													if (fecia.fecha<fecha_fin) then
														puttext(1,8,80,17,pantalla);
													{blackout(1,8,80,17);}
													{y:=8;}
												end
												else inc(y);

				{ Modificamos y escribimos el nuevo estado de fecia }

				{ el cambiar a facturado:=true esta desactivado por que
				si no no se puede realizar la factura cuantas veces se desee,
				lo pongo a true si se decide emitir la factura}


											fecia.facturado:=true;
											seek(fec_ndx,filepos(fec_ndx)-1);
											write(fec_ndx,fecia);

										end {albaran.t=t}
								end { del fecia.facturado }
						end {del fecia.fecha}
				end; {while}

			pie.total:=sub;
			ini.m_income:=ini.m_income+sub;
			save_cfg;
			total_albaran_cliente(pie,ccliente);
			write_foot;

			textcolor(YELLOW);
			textbackground(BLUE);
			gotoxy(cuadrado_x,25);
			while cuadrado_x<40 do
				begin
					write('²');
					inc(cuadrado_x)
				end;
			cursor_off;

			textcolor(cyan);
			textbackground(Black);
		end;


	end;



begin

		swap_menu(25,5,26);

		repeat
			copias:=0;
			ini_cliente(ccliente);
			fiche:='              ';
			v:=true;
			todos:=false;
			j:=false;
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('Tel‚fono:');
			lowvideo;
			while v do
				begin
					with campo do
						begin
							dato:=empty;
							especifi:=empty;
							ini_x:=12;
							ini_y:=3;
							longitud:=7;
							lineas:=1;
						end;
					op:=get_field(campo);
					telefono:=str_to_long(trim(campo.dato));
					if op=3 then
						begin
							v:=false;
							j:=true
						end;
					if op=2 then
						if not(todos) then
							begin
								write_msg('Comprobando.....');
								pos:=busca_tfno(telefonos,telefono,max_clientes);
								write_msg('                       ');
								if pos=0 then
									begin
										error(3);
										lowbar('Menu Clientes')
									end
									else
									begin
											busca_cliente_f(ccliente,pos);
											j:=false;
											v:=false;
									end;
								end {todos}
								else begin j:=false; v:=false; end;
			end; {while}
			if not j then
				begin
					v:=false;
					repeat
						repeat
							textcolor(CYAN);
							lowvideo;
							gotoxy(2,7);
							write('Fecha de inicio      : ');
							gotoxy(2,9);
							textcolor(CYAN);
							lowvideo;
							write('Fecha de t‚rmino     : ');
							op:=get_fechas(fiche1,fiche2);
							blackout(1,4,80,10);
						until (op=2) or (op=3);
						cad_fecha(fiche1,u,m,a);
						fecha_ini:=fecha_numero(u,m,a);
						cad_fecha(fiche2,u,m,a);
						fecha_fin:=fecha_numero(u,m,a);

						if op=2 then v:=true
							else if op=0 then
								begin
									error(10);
									lowbar('Men£ Clientes')
								end
								else if op=3 then
									begin
										v:=true;
										j:=true
									end;

					until v;

					reset(fec_ndx);
					if ioresult=0 then
					num_alb:=0;
					while not(eof(fec_ndx)) do
						begin
							read(fec_ndx,fecia);
							if (fecia.fecha>=fecha_ini) and (fecia.fecha<=fecha_fin) then inc(num_alb);
						end;
					close(fec_ndx);


(*          paso:=num_alb div 20; {numero de albs. por cuadrado}
					if ((paso>1)and((num_alb mod 20)<>0)) then dec(paso);
*)
					if num_alb<20 then {Si hay mas cuadritos que albs es muy sencillo}
						begin
							i    := 0;
							if num_alb<>0 then
							paso :=20 div num_alb; {numero de cuadrados por item}
						end
						else begin  { Si hay mas items es un poco mas complicado}

							paso:=num_alb div 20;  {numero de items por cuadrado}

	{Si el resto es no nulo (aun sobran items) :.Incrementamos el numero de
	items por cuadrado}
							if((num_alb mod 20)<>0)then inc(paso)

						end;

{					if not(todos) then
						begin
}

					facturar_uno(telefono);
					factura_lista:=blb;

					if factura_lista=nil then error(22)
					else
					begin

						write_msg(' ¨Emitir factura? (s/N)');
						ans:=si_no('N');

						if ans then
						begin

							{escribe la factura almacenada en memoria a disco
							blb:comienzo de la lista en memoria con los albaranes
							pie:record con el bruto, desc, base_iva, base_rec_eq
							ccliente:datos del cliente
							number:numero de factura
							}

							ini_factura(factura_head);

							with factura_head do
							begin
								telefono:=ccliente.telefono;
								num_factura:=numero_factura;
								totales:=pie;
								fecha:=fecha_sistema;
								total_neto:=pie.total-pie.descuento+pie.iva+pie.recargo_eq;
								{
								pagado:='n';
								tipo_pago:=' ';
								fecha_pago.day:=0;
								fecha_pago.month:=0;
								fecha_pago.year:=0;
								}
								totales.recargo_eq:=pie.recargo_eq;
								iva:=ini.iva;
								descuento:=ccliente.descuento;
							end;


							res:=graba_factura_head(factura_head,factura_lista);
							res:=graba_factura_lines(factura_head,factura_lista);
							inc(ini.last_fact_number);
							save_cfg;
							actualiza_fact_index(factura_head.num_factura);

							{el make_stats esta castigado por fallar}

							{make_stats;}

							repeat
								write_msg('Imprimir (S/n)');
								ans:=si_no('S');
								write_msg('                        ');
								if ans then
									begin
										imp:=true;
										get_printer_status(est);
										if est.io_error then error(15)
											else if est.paper_out then error(14)
												else begin
													gotoxy(3,3);
													textcolor(3);
													blackout(1,2,80,24);
													write('N£mero de copias : ');
													with campo do
														begin
															dato:=' 2';
															especifi:='nn';
															ini_x:=22;
															ini_y:=3;
															longitud:=2;
															lineas:=1
														end;
													op:=get_field(campo);
													val(trim(campo.dato),copias,cod)
												end
									end
									else imp:=false;

							until (not(ans)or not((est.paper_out)or(est.io_error)));



							if imp then begin
								i:=0;
								repeat
									write_msg(' Pulse cualquier tecla para imprimir copia');
									C:=readkey;
									if C<>#27 then
										begin
											repeat
												get_printer_status(est);
											until not (est.paper_out);
											print_fact_cliente(ccliente,blb,sub,cad,number,lim,pie,ju);
											inc(i);
										end
										else i:=copias;
										write_msg('Espere a que finalice la impresion y pulse una tecla');
										C:=readkey;
										write_msg('                                                    ');
								until i=copias;
							end; { del if imp}

						end { del if ans }
						else
						begin
							erase(fec_ndx);
							rename(temp_fec_ndx,ini.work+'fecha.ndx');
							assign(temp_fec_ndx,ini.work+'fecha.tmp');
							assign(fec_ndx,ini.work+'fecha.ndx');
						end;

					factura_lista:=blb;
			end;{ del if factura_lista:=nil}




					while blb<>nil do {Borramos la lista de albaranes}
						begin
							clb:=blb;
							blb:=blb^.sig;
							dispose(clb)
						end;

				end;

			write_msg('Facturar otro cliente (S/n)');
			ans:=si_no('S');
			if ans then j:=false
				else j:=true;
			write_msg('                            ');
		until j;


end;



{***********************************}


procedure listar_client;
var
	 ans:boolean;
	 est:t_status;
	 n_clientes:word;
	 ccliente:t_cliente;
	 C:char;

procedure write_cliente;
begin

		swap_menu(25,5,26);

		 with ccliente do
		 begin
					writeln(prnt);
					writeln(prnt,'Tel‚fono: ',telefono,'     C.I.F.: ',cif);
					writeln(prnt,nombre);
					writeln(prnt,'C/ ',direccion.calle);
					if direccion.numero<>0 then write(prnt,'N§ ',direccion.numero,'; ')
						else write(prnt,'s/n');
					if direccion.piso<>0 then
					 writeln(prnt,' ',direccion.piso,'§ ',direccion.letra)
						else writeln(prnt);

					writeln(prnt,direccion.localidad);
					writeln(prnt,direccion.provincia);
					write(prnt,'Fecha de entrada: ');
					print_n_digits(ini_date.day,2);
					write(prnt,'/');
					print_n_digits(ini_date.month,2);
					write(prnt,'/',ini_date.year,'   Comercial: ',comercial);
					if descuento<>0 then writeln(prnt,'    Descuento: ',descuento,' %') else writeln(prnt);
					if cobrar_reemb='s' then writeln(prnt,'Cobrar 3% de reembolso');
					writeln(prnt,'Obs: ',obs);
		 end;
end;

procedure listar_tarifas;
var
	 i:byte;
begin
		 writeln(prnt,'TARIFAS');
		 writeln(prnt);
		 writeln(prnt,'Cod.  Descripci¢n   Precio  ');
		 writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
		 for i:=1 to _max_tfas_cliente do
		 begin
					with ccliente.tarifas[i] do
					begin
							 write(prnt,' ',i,'     ');
							 write(prnt,descripcion,' ');
							 right_justify(precio,5);
							 writeln(prnt);
					end;
		 end;
		 writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
		 writeln(prnt);
end;



begin

	{$I-}
	reset(fichclientes);
	{$I+}
	if ioresult=0 then
		begin
			swap_menu(25,5,26);
			blackout(1,2,80,24);
			write_msg('Clientes del mes (S/n)');
			n_clientes:=1;


			ans:=si_no('S');

			repeat
				write_msg('Pulse una tecla cuando est‚ listo');
				C:=readkey;
				if C=#27 then exit;
				get_printer_status(est);
				if est.io_error then error(15)
				 else if est.paper_out then error(14)
			until not((est.paper_out)or(est.io_error));

			if C<>#27 then
			 begin
				 write_msg('Imprimiendo...');

				 writeln(prnt);
				 with fecha_sistema do writeln(prnt,'LISTA DE CLIENTES DEL   ',day,'/',month,'/',year);
				 writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
				 writeln(prnt);
				 writeln(prnt);

				 while not(eof(fichclientes)) do
					 begin
							read(fichclientes,ccliente);
							with ccliente.ini_date do
								begin
									 if ans then
											if (month=fecha_sistema.month) and (year=fecha_sistema.year) then
												begin
													 write_cliente;
													 listar_tarifas;
													 inc(n_clientes);
												end;
									 if not(ans) then
										 begin
												write_cliente;
												listar_tarifas;
												inc(n_clientes);
										 end;
								end;
							if n_clientes>2 then
								begin
									 write(prnt,#12);
									 n_clientes:=1;
									 repeat
										 write_msg('Pulse una tecla cuando est‚ listo');
										 repeat until keypressed;
										 get_printer_status(est);
									 until not(est.paper_out);
									 writeln(prnt);
									 with fecha_sistema do writeln(prnt,'LISTA DE CLIENTES DEL   ',day,'/',month,'/',year);
									 writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
									 write_msg('Imprimiendo...                       ');
									 writeln(prnt);
									 writeln(prnt);
								end;
					 end;
				 close(fichclientes);
				 writeln(prnt,#12);
				 write_msg('                        ')
			 end
		end
		else error(1)
end;



end.