unit facturas;

interface

	uses crt,defs,common,campstru,graficos,ficheros,puts,gets;


	procedure consultar_factura;
	procedure modif_factura;
	procedure borrar_factura;


implementation

  type

	 t_info=record
		 max_elem:byte; { num. max. de elementos }
		 ancho:byte; { ancho de representacion }
		 elem_actual:byte; { elemento actual de la lista }
		 pos_en_ancho:byte; { pos. relativa dentro del ancho }
		 tipo_desp:byte; { si hay que desplazar en pagina o en unidad }
		 limsup:byte; { limite superior de la lista a presentar }
		 liminf:byte; { limite inferior }
		 paginas:byte; { numero de paginas, resultado de max_elem div ancho }
		 actual_page:byte; { numero actual de pagina }
	 end;


{ Calcula los valores de info en un momento determinado }
	procedure engine(var info:t_info);
	begin
		with info do
		begin
			if tipo_desp=1 then
				if elem_actual>1 then
				begin
					dec(elem_actual);
					if pos_en_ancho>1 then dec(pos_en_ancho)
					else
						begin
							dec(liminf);
							dec(limsup);
						end;
				end;
			if tipo_desp=2 then
				if elem_actual<max_elem then
				begin
					inc(elem_actual);
					if pos_en_ancho<ancho then inc(pos_en_ancho)
					else
						begin
							inc(liminf);
							inc(limsup);
						end;
				end;
		end;
	end;


{ Escribe en pantalla los albaranes de una factura de acuerdo con info }
	procedure disp(var lista:t_lista; var info:t_info);
	var y:byte;
	begin
		gotoxy(3,5);
		y:=3;
		for n:=info.liminf to info.limsup do
		begin
			if n<=info.max_elem then
			begin
				gotoxy(10,y);
				write(lista[n],'      ');
				gotoxy(2,y);
				write(n,'     ');
			end
			else
			begin
				gotoxy(10,y);
				write('         ');
				gotoxy(2,y);
				write('        ');
			end;
			if n=info.liminf+info.pos_en_ancho-1 then
			begin
				textcolor(WHITE);
				textbackground(BLUE);
				gotoxy(10,y);
				write(lista[n],'  ');
				gotoxy(2,y);
				write(n,'     ');
				textcolor(WHITE);
				textbackground(BLACK);
			end;
			inc(y);
		end;


		{ si tal se puede sustituir el for por un while con una condicion
		de salida si ocurre lo de n>max_elem
		}

		with info do
		begin
			gotoxy(40,5);
			write('P ginas: ',paginas);
			gotoxy(40,3);
			write('Elementos: ',max_elem);
			gotoxy(40,7);
			write('Elem. : ',elem_actual,'   ');
			gotoxy(40,9);
			write('Lim Inf:',liminf);
			gotoxy(40,11);
			write('Lim Sup:',limsup);
		end;


	end;


(****************************************************************************)
  { RUTINILLAS ESCRITAS POR ARGOS }
(****************************************************************************)

{ Esta funci¢n se encargar  de coger los datos de un albar n. Solo es llamada
  por add_albaran y edit_albaran }
  function get_albaran_lista(var alb:listalbs;var aalbaran:t_albaran;
										num:t_codigo; c:t_cliente; var i:byte):boolean;
  var
	  op,pos   : word;
	  yes      : boolean;
  begin

  { Casi copia literal de new_albaran }

	  yes:=false;

		lowbar('Modificar factura');
	  recuadro_albaran(3,3);

	  repeat
		  op:=get_albaran(aalbaran,3,3);
		  if op<>0 then yes:=true;
		until yes;

	  pos:=busca_tfno(telefonos,aalbaran.telefono,max_clientes);
	  if pos=0 then
		  begin
			  error(3);
			  aalbaran.telefono:=0;
			  op:=7;
		  end;
	  if op=3 then get_albaran_lista:=false
		  else if op=2 then
			  begin
				  recuadro_casillas(3,10);
				  write_msg(' Pulse Esc para finalizar.');
				  op:=get_casillas(aalbaran,3,10);
				  if op=3 then
					  begin

						  get_albaran_lista:=true;

(****************************************************************************)
							{ Calculando las cantidades de este albar n }
							alb^.temp:=calcular_albaran(aalbaran,c,alb^.se);

							{ Asignar los valores pertinentes al punterini }
							{ ­­Ojo!! nada de tocar alb^.sig ni nada de eso }
							alb^.codigo     :=aalbaran.codigo;
							alb^.fecha      :=fecha_sistema;
							alb^.num_factura:=num;

(****************************************************************************)

							if max_albaranes>1700 then
								begin
									write_msg(' Debe archivar los albaranes antiguos');
									repeat until keypressed
								end;
							if max_albaranes=1750 then ini.permit:=false
						end
				end
	end;


	{ Se carga un albar n de una faTura }
	procedure delete_albaran_fact(var inicial,alb:listalbs;v:boolean);
	var
		i        : byte;
		op,pos   : word;
		yes      : boolean;
		aux      : listalbs;
		buffer   : videomatrix;
		aalbaran : t_albaran;
		fec      : t_index2;
	begin
	{ Desde aqu¡ hasta "nuevo aviso", es casi una copia directa de una parte de
		borra_albaran (ALBARAN.PAS). No merece la pena hacer una mini rutina
		al respecto ya que su uso es muy limitado y no mejorar¡a la estructura
		del c¢digo. }
		write_msg(' Comprobando .....');
		pos:=busca_index_cod(alb^.codigo,i);
		if pos=0 then
			begin
				error(12);  {Hay que tener cuidado con el mensaje}
				if v then write_msg(' Pulsar F1 para quitar ayuda')
					else write_msg('F1 - Ayuda para edici¢n de albaranes')
			end
			else begin
				write_msg(' Buscando......');
				op:=busca_albaran_f(aalbaran,alb^.codigo,i,pos);

			  if op<>0 then
				  begin
					  gettext(1,2,24,80,buffer);
					  blackout(1,2,24,80);
						recuadro_albaran(3,3);
					  put_albaran(aalbaran,3,3);
					  put_casilla(aalbaran,1,3,10);
					  write_msg(' Eliminar albar n (s/N)');
					  yes:=si_no('N');
					  if yes then
						  begin
							  write_msg(' Eliminando ....');
							  if i=0 then
								begin
									{$I-}
									reset(fec_ndx);
									{$I+}
									if ioresult=0 then    { Esto es para cambiar el flag }
										begin
											repeat
												read(fec_index,fec);
											until fec.pos=pos;
											fec.facturado=false;
											seek(fec_ndx,filepos(fec_ndx)-1);
											write(fec_ndx,fec);
											close(fec_ndx)
										end;
								end;
	{"NUEVO AVISO"}

								borra_lin_fact(alb^.codigo); {Borramos esa l¡nea de la faTura}

								if inicial=alb then
									begin
										inicial:=alb^.sig;  {Borrando el puntero de la lista}
										dispose(alb)
									end
									else begin
										aux:=inicial;
										while aux^.sig<>alb do aux:=aux^.sig;
										aux^.sig:=alb^.sig;
										dispose(alb)
									end


	(****************************************************************************)

								{ ¨Cu ndo escribo la faTura en disco? }

								{ ¨Y los ¡ndices? }

							  { ¨A donde vamos? }

							  { ¨De donde venimos? }

							  { Y, sobre todo, ¨Encontrar‚ inquilino alg£n d¡a? }
							  {24-7-96}
  (****************************************************************************)

							end;
					  puttext(1,2,24,80,buffer);
				  end
				  else error(12)
		  end
  end;


{ Devuelve un puntero seg£n una posici¢n relativa en la lista }
  function lugar(var inicio:listalbs,pox:byte;):listalbs;
  begin
		lugar:=inicio;
		while pox>1 do begin	lugar:=lugar^.sig; dec(pox) end;
  end;


  { A¤ade un albar n a la lista de la faTura }
  procedure add_albaran(var inicio:listalbs;var pox:byte;code:t_codigo);
  var
	  i        : byte;
	  c        : t_cliente;
	  op,pos   : word;
	  yes,fin  : boolean;
	  aux,alb  : listalbs;
	  campo    : t_nodo_dato;
		buffer   : videomatrix;
		fecia    : t_index2;
		codigo   : t_codigo;
		aalbaran : t_albaran;
	begin
		pos:=busca_tfno(telefonos,inicio^.telefono,max_clientes);
		if pos<>0 then
			begin
				yes:=true;                { Es muy parecida a new_albaran }
				fin:=false;
				alb:=lugar(inicio,pox);
				ini_albaran(aalbaran);

				busca_cliente_f(c,pos);

				gettext(1,2,80,24,buffer);
				blackout(1,2,80,24);
				textcolor(11);
				gotoxy(3,3);
				write('Codigo:');
				lowvideo;
				while yes do
					begin
						with campo do
							begin
								dato:=empty;
								especifi:=empty;
								ini_x:=12;
								ini_y:=3;
								longitud:=5;
								lineas:=1;
							end;{with}
						op:=get_field(campo);
						val(trim(copy(campo.dato,1,4)),codigo.numero,cod);
						codigo.letra:=upcase(campo.dato[5]);
						if op=3 then
							begin
								yes:=false;
								fin:=true
							end {op}
							else if op=2 then
								begin
									write_msg(' Comprobando......');
									pos:=busca_index_cod(codigo,i);
									if pos=0 then yes:=false
										else begin
											error(11);
											lowbar('Modificar factura')
										end
								end;{op2}
					end; {while}
				if not fin then
					begin
						aalbaran.codigo  :=codigo;
						aalbaran.telefono:=inicio^.telefono;
						lowbar('Modificar factura');
						blackout(3,3,15,3);
						new(aux); { Nuevo nodo}
						aux^.sig:=nil;
						if get_albaran_lista(aux,aalbaran,code,c,i) then
							begin
								write_msg(' A¤adiendo ...');
								albaran_borrado:=true;
								ins_albaran_f(aalbaran,max_albaranes);
								actualiza_cod_index(aalbaran.codigo);
								actualiza_fec_index(aalbaran.fecha);

						{ Esto es para cambiar el estado del flag }
								{$I-}
								reset(fec_ndx);
								{$I+}
								if ioresult=0 then
									begin
										repeat
											read(fec_ndx,fecia);         (*************************)
										until fecia.pos:=max_albaranes; {Comprobar esta condici¢n}
										fecia.facturado:=true;				 (*************************)
										seek(fec_ndx,filepos(fec_ndx)-1);
										write(fec_ndx,fecia);
										close(fec_ndx);
									end;

								alb:=inicio; { Asignaci¢n de punterini }
								while aux^.sig<>nil do alb:=alb^.sig;
								alb^.sig:=aux;
								alb:=aux;

(****************************************************************************)
			{ Ahora hay que actualizar el fichero de l¡neas de la faTura }


			{ Y los eternos problemas : -¨ficheros de fa"T"uras?
												-¨Indices? }
(****************************************************************************)
							end;

						aux:=aux^.sig; { "Suicidamos" a aux }
						dispose(aux)

					end;
				puttext(1,2,80,24,buffer)
			end
			else error(3)
	end;




	{ Modifica un albar n de la faTura }
	procedure edit_albaran(var inicio:listalbs; var pox:byte; code:t_codigo;);
	var
		c        : t_cliente;
		op,pos   : word;
		yes,fin  : boolean;
		aux,alb  : listalbs;
		campo    : t_nodo_dato;
		buffer   : videomatrix;
		codigo   : t_codigo;
		aalbaran : t_albaran;
	begin
		pos:=busca_tfno(inicio^.telefono);
		if pos<>0 then
		begin
			yes:=true;
			fin:=false;

			alb:=lugar(inicio,pox);

			write_msg(' Comprobando......');
			pos:=busca_index_cod(alb^.codigo,i);
			if pos=0 then
				begin
					error(12);
					lowbar('Modificar factura');
					yes:=false
				end;

			if yes then
				begin

					busca_cliente_f(c,pos);

					lowbar('Modificar factura');
					gettext(1,2,80,24,buffer);
					blackout(1,2,80,24);
					if get_albaran_lista(alb,aalbaran,code,c,i) then
						begin
							write_msg(' Actualizando.....');
							write_msg('Un momento...');
							if i=0 then
								begin
									albaran_borrado:=true;
									desactiva_albaran(pos);
									borra_cod_index(codigo);
									borra_fec_index(aalbaran.fecha,pos);
								end
								else borra_cod_dsk(codigo);

							ins_albaran_f(aalbaran,max_albaranes);
							actualiza_cod_index(codigo);
							actualiza_fec_index(aalbaran.fecha);

						end;
					puttext(1,2,80,24,buffer)
				end
				else error(12)
		end
		else error(3)
end;

(****************************************************************************)
  { FIN DE LAS RUTINILLAS ESCRITAS POR ARGOS }
(****************************************************************************)







	procedure consultar_factura;
	var
		ahead:t_factura_head;
		num_pagina:byte;
		paginas:byte;
		v,j,ans:boolean;
		tecla:boolean;
		limsup,liminf:byte;
		campo:t_nodo_dato;
		op,pos:word;
		inic,puntx:listalbs;
		i  : byte;
		c,t:char;
		codigo:t_codigo;
		ofset:byte;
		nalbs:word;
		resto:byte;
		c_ascii:char;
		c_scancode,c_funcion:byte;
		c_estado:t_estado;
		c_teclas:str_3;
	begin
		crea_factura_ndx;
			swap_menu(25,5,26);
			repeat
				ini_factura(ahead);
				v:=true;
				j:=false;
				lowbar('Menu Facturas');
				blackout(1,2,80,24);
				textcolor(11);
				gotoxy(3,3);
				write('Codigo:');
				lowvideo;
				while v do
					begin
						with campo do
							begin
								dato:=empty;
								especifi:=empty;
								ini_x:=12;
								ini_y:=3;
								longitud:=5;
								lineas:=1;
							end;{with}
						op:=get_field(campo);
						val(trim(campo.dato),codigo.numero,cod);
						for i:=1 to 5 do
							if (upcase(campo.dato[i])='A') or (upcase(campo.dato[i])='B') then
								codigo.letra:=upcase(campo.dato[i]);
						if op=3 then
							begin
								v:=false;
								j:=true
							end {op}
							else if op=2 then
								begin
									write_msg(' Buscando......');
									pos:=busca_index_fact(codigo,i);
									if pos=0 then
									 begin
										 error(24);
										 lowbar('Men£ Facturas')
										end
										else v:=false
								end;{op2}
					end; {while}
				if not j then
					begin
						write_msg(' Leyendo datos....');
						inic:=nil;
						op:=busca_factura_f(ahead,inic,pos);
						if op<>0 then
							begin
								lowbar(' Men£ Facturas');
								blackout(3,3,15,3);
								puntx:=inic;
								nalbs:=0;
								while puntx<>nil do
								begin
									inc(nalbs);
									puntx:=puntx^.sig;
								end;
								recuadro_factura_general(3,2);
								put_factura_general_head(ahead,3,2);
								recuadro_pie_factura(3,10);
								put_factura_general_pie(ahead,3,10);
								recuadro_cabecera_albaranes(3,14);
								puntx:=inic;
								write_msg('Cursores Arr./Aba. para ver albaranes. ESC - Salir');
								liminf:=1;
								paginas:=nalbs div 8;
								resto:=nalbs mod 8;
								if (paginas=1) and ( resto=0) then paginas:=0;
								num_pagina:=0;
								if paginas=0 then limsup:=nalbs else
									limsup:=8;
								put_factura_general_albaranes(puntx,liminf,limsup,3,16);
								if paginas<>0 then
								repeat


								(* ver las lineas de albaranes mediante pgup y pgdw,
								pero no funciona del todo bien *)

										{
										dec(paginas);
										repeat until get_key(c_ascii,c_scancode,c_funcion,c_estado,c_teclas);
										if (c_teclas<>'') then
										begin
											ofset:=7;
											if c_teclas='pup' then
												if num_pagina>0 then	dec(num_pagina);
											if c_teclas='pdw' then
											begin
												if num_pagina<=paginas then inc(num_pagina)
												else
												begin
													num_pagina:=paginas;
													ofset:=resto-1;
												end;
												liminf:=num_pagina*8+1;
												limsup:=liminf+ofset;
												blackout(3,16,79,23);
												put_factura_general_albaranes(puntx,liminf,limsup,3,16);
											end;
										end;
										}

(* el trozo de codigo en comentario pertenece a una forma de ver
las lineas de albaran mediante los cursores *)


									repeat until get_key(c_ascii,c_scancode,c_funcion,c_estado,c_teclas);
									if (c_teclas<>'') then
									begin
										if c_teclas='dow' then
										begin
											inc(limsup);
											inc(liminf);
											if limsup>nalbs then
											begin
												dec(limsup);
												dec(liminf);
											end;
											blackout(3,16,79,23);
											put_factura_general_albaranes(puntx,liminf,limsup,3,16);
										end;
										if c_teclas='up' then
										begin
											dec(limsup);
											dec(liminf);
											if liminf<1 then
											begin
												inc(limsup);
												inc(liminf);
											end;
											blackout(3,16,79,23);
											put_factura_general_albaranes(puntx,liminf,limsup,3,16);
										end;
									end;



								until c_teclas='esc'
								else
									put_factura_general_albaranes(puntx,1,nalbs,3,16);



								{put_inverse(3,16,71,16);}
							end
							else error(12);
						write_msg(' Ver otra factura (S/n)');
						ans:=si_no('S')
					end;
			until (j or not ans);
			borra_lista_facturas(inic);

	end;



	procedure modif_factura;
	var
		ahead:t_factura_head;
		num_pagina:byte;
		paginas:byte;
		v,j,ans:boolean;
		tecla:boolean;
		limsup,liminf:byte;
		campo:t_nodo_dato;
		p_alb:listalbs;
		op,pos:word;
		inic,puntx:listalbs;
		i  : byte;
		c,t:char;
		codigo:t_codigo;
		nalbs:word;
		resto:byte;
		c_ascii:char;
		c_scancode,c_funcion:byte;
		num_linea:word;
		kk:byte;
		aux:listalbs;
		auxpos:byte;
		c_estado:t_estado;
		num_albaran:word;
		c_teclas:str_3;
		ypos:byte;
		ya_estaba:boolean;
	begin
		crea_factura_ndx;
			swap_menu(25,5,26);
			repeat
				ini_factura(ahead);
				v:=true;
				j:=false;
				lowbar('Menu Facturas');
				blackout(1,2,80,24);
				textcolor(11);
				gotoxy(3,3);
				write('Codigo:');
				lowvideo;
				while v do
					begin
						with campo do
							begin
								dato:=empty;
								especifi:=empty;
								ini_x:=12;
								ini_y:=3;
								longitud:=5;
								lineas:=1;
							end;{with}
						op:=get_field(campo);
						val(trim(campo.dato),codigo.numero,cod);
						for i:=1 to 5 do
							if (upcase(campo.dato[i])='A') or (upcase(campo.dato[i])='B') then
								codigo.letra:=upcase(campo.dato[i]);
						if op=3 then
							begin
								v:=false;
								j:=true
							end {op}
							else if op=2 then
								begin
									write_msg(' Buscando......');
									pos:=busca_index_fact(codigo,i);
									if pos=0 then
									 begin
										 error(24);
										 lowbar('Men£ Facturas')
										end
										else v:=false
								end;{op2}
					end; {while}
				if not j then
					begin
						write_msg(' Leyendo datos....');
						inic:=nil;
						op:=busca_factura_f(ahead,inic,pos);
						if op<>0 then
							begin
								lowbar(' Modificar lineas de albar n');
								blackout(3,3,15,3);
								puntx:=inic;
								nalbs:=0;
								while puntx<>nil do
								begin
									inc(nalbs);
									puntx:=puntx^.sig;
								end;
								recuadro_factura_general(3,2);
								put_factura_general_head(ahead,3,2);
								recuadro_pie_factura(3,10);
								put_factura_general_pie(ahead,3,10);
								puntx:=inic;
								repeat
									op:=get_factura_head(ahead,3,2);
									if op=2 then op:=get_factura_pie(ahead,3,10);
								until (op=2) or (op=3);
								write_msg('Modificar lineas de albaranes (s/N)');
								ans:=si_no('N');
								if ans then
								begin
									recuadro_cabecera_albaranes(3,14);
									write_msg('F1 - Ayuda para edici¢n de albaranes');
									liminf:=1;
									paginas:=nalbs div 8;
									resto:=nalbs mod 8;
									if (paginas=1) and ( resto=0) then paginas:=0;
									num_pagina:=0;
									if paginas=0 then limsup:=nalbs else
										limsup:=8;
									put_factura_general_albaranes(puntx,liminf,limsup,3,16);
									p_alb:=inic;
									put_linea_albaran(3,16,p_alb,true);
									num_albaran:=1;
									num_linea:=1;
									ypos:=16;
									ya_estaba:=false;
									if paginas<>0 then
									repeat
										 repeat until get_key(c_ascii,c_scancode,c_funcion,c_estado,c_teclas);
										 if (c_teclas<>'') or (c_funcion=1) then
										 begin

											if c_funcion=1 then
												if not(ya_estaba) then
												begin
													ya_estaba:=true;
													write_msg('Pulsar F1 para quitar ayuda');
													gettext(3,3,47,11,pantalla);
													blackout(3,3,46,10);
													textcolor(CYAN);
													textbackground(BLUE);
													highvideo;
													recuadro(3,3,44,8);
													gotoxy(4,4);
													write('INS    - Inserta un nueva albaran, encima ');
													gotoxy(4,5);
													write('         del seleccionado                 ');
													gotoxy(4,6);
													write('DEL    - Borra el albaran seleccionado    ');
													gotoxy(4,7);
													write('RETURN - Permite modificar el albaran     ');
													gotoxy(4,8);
													write('         seleccionado                     ');
													gotoxy(4,9);
													write('ESC    - Salir a menu de Facturas         ');
													textcolor(WHITE);
													textbackground(BLACK);
													lowvideo;
													cursor_off;

												end
												else
												begin
													write_msg('F1 - Ayuda para edici¢n de albaranes');
													ya_estaba:=false;
													puttext(3,3,47,11,pantalla);
												end;


											if c_teclas='ins' then
											begin
												write_msg('Has pulsado INS');
											end;

											if c_teclas='del' then
											begin
												write_msg('Has pulsado DEL');
											end;

											if c_teclas='ret' then
											begin
												write_msg('Has pulsado RETURN');
											end;



											 (* la tecla de abajo *)

											 if c_teclas='dow' then
											 begin
												inc(num_linea);
												if p_alb^.sig<>nil then
												begin
													aux:=p_alb;
													auxpos:=ypos;
													p_alb:=p_alb^.sig;
													inc(num_albaran);
												end;
												if ypos<23 then inc(ypos);
												if num_linea>8 then
												begin
													inc(limsup);
													inc(liminf);
													num_linea:=8;
													ypos:=23;
													blackout(3,16,79,23);
													put_factura_general_albaranes(puntx,liminf,limsup,3,16);
												end;
												if limsup>nalbs then
												begin
													dec(limsup);
													dec(liminf);
													blackout(3,16,79,23);
													put_factura_general_albaranes(puntx,liminf,limsup,3,16);
												end;
												put_linea_albaran(3,auxpos,aux,false);
												put_linea_albaran(3,ypos,p_alb,true);
											end;

											(* la tecla de arriba *)

											if c_teclas='up' then
											begin
												dec(num_linea);
												if p_alb<>inic then
												begin
													aux:=p_alb;
													auxpos:=ypos;
													p_alb:=inic;
													dec(num_albaran);
													if num_albaran>1 then
														for kk:=1 to num_albaran-1 do p_alb:=p_alb^.sig;

												end;
												if ypos>16 then dec(ypos);
												if num_linea<1 then
												begin
													dec(limsup);
													dec(liminf);
													num_linea:=1;
													blackout(3,16,79,23);
													put_factura_general_albaranes(puntx,liminf,limsup,3,16);
													put_linea_albaran(3,ypos,p_alb,true);
												end;
												if liminf<1 then
												begin
													inc(limsup);
													inc(liminf);
													blackout(3,16,79,23);
													put_factura_general_albaranes(puntx,liminf,limsup,3,16);
												end;
												put_linea_albaran(3,auxpos,aux,false);
												put_linea_albaran(3,ypos,p_alb,true);
											 end;
										 end;
									until c_teclas='esc'
									else
									repeat
										 repeat until get_key(c_ascii,c_scancode,c_funcion,c_estado,c_teclas);
										 if (c_teclas<>'') then
										 begin

											if c_funcion=1 then
												if not(ya_estaba) then
												begin
													ya_estaba:=true;
													write_msg('Pulsar F1 para quitar ayuda');
													gettext(3,3,43,10,pantalla);
													recuadro(3,3,43,10);
													gotoxy(4,4);
													write('INS - Inserta un nueva albaran, encima del');
													gotoxy(4,5);
													write('      seleccionado');
													gotoxy(4,6);
													write('DEL - Borra el albaran seleccionado');
													gotoxy(4,7);
													write('RETURN - Permite modificar el albaran');
													gotoxy(4,8);
													write('         seleccionado');
													gotoxy(4,9);
													write('ESC - Salir a menu de Facturas');
												end
												else
												begin
													ya_estaba:=false;
													puttext(3,3,49,10,pantalla);
												end;


											if c_teclas='ins' then
											begin
												write_msg('Has pulsado INS');
											end;

											if c_teclas='del' then
											begin
												write_msg('Has pulsado DEL');
											end;

											if c_teclas='ret' then
											begin
												write_msg('Has pulsado RETURN');
											end;


											  (* la tecla de abajo *)

											  if c_teclas='dow' then
											  begin
												 if num_linea<nalbs then inc(num_linea);
												 if p_alb^.sig<>nil then
												 begin
													 aux:=p_alb;
													 auxpos:=ypos;
													 p_alb:=p_alb^.sig;
													 inc(num_albaran);
												 end;
												 if ypos<15+nalbs then inc(ypos);
												 if num_linea>8 then
												 begin
													 num_linea:=8;
													 ypos:=23;
												 end;
												 put_linea_albaran(3,auxpos,aux,false);
												 put_linea_albaran(3,ypos,p_alb,true);
											 end;

											 (* la tecla de arriba *)

											 if c_teclas='up' then
											 begin
												 if num_linea>1 then dec(num_linea);
												 if p_alb<>inic then
												 begin
													 aux:=p_alb;
													 auxpos:=ypos;
													 p_alb:=inic;
													 dec(num_albaran);
													 if num_albaran>1 then
														 for kk:=1 to num_albaran-1 do p_alb:=p_alb^.sig;

												 end;
												 if ypos>16 then dec(ypos);
												 if num_linea<1 then
												 begin
													 num_linea:=1;
													 put_linea_albaran(3,ypos,p_alb,true);
												 end;
												 put_linea_albaran(3,auxpos,aux,false);
												 put_linea_albaran(3,ypos,p_alb,true);
											  end;
										 end; { del if c_teclas<>'' }
									until c_teclas='esc'; { del else del if del paginas }
								end;
							end
							else error(12);
						write_msg(' Salvar factura modificada (s/N)');
						ans:=si_no('N');
						if ans then
						begin
							borra_fact_index(ahead.num_factura);
							actualiza_fact_index(ahead.num_factura);
							borra_factura_f(pos);
							nalbs:=graba_factura(ahead,inic); { nalbs no significa nalbs }
							if nalbs=1 then error(22);
						end;
						write_msg(' Modificar otra factura (S/n)');
						ans:=si_no('S')
					end;
			until (j or not ans);
			borra_lista_facturas(inic);

	end;



	procedure borrar_factura;
	var
		ahead:t_factura_head;
		num_pagina:byte;
		paginas:byte;
		v,j,ans:boolean;
		tecla:boolean;
		limsup,liminf:byte;
		campo:t_nodo_dato;
		op,pos:word;
		inic,puntx:listalbs;
		i  : byte;
		c,t:char;
		codigo:t_codigo;
		ofset:byte;
		nalbs:word;
		resto:byte;
		c_ascii:char;
		c_scancode,c_funcion:byte;
		c_estado:t_estado;
		c_teclas:str_3;
	begin
		crea_factura_ndx;
			swap_menu(25,5,26);
			repeat
				ini_factura(ahead);
				v:=true;
				j:=false;
				lowbar('Menu Facturas');
				blackout(1,2,80,24);
				textcolor(11);
				gotoxy(3,3);
				write('Codigo:');
				lowvideo;
				while v do
					begin
						with campo do
							begin
								dato:=empty;
								especifi:=empty;
								ini_x:=12;
								ini_y:=3;
								longitud:=5;
								lineas:=1;
							end;{with}
						op:=get_field(campo);
						val(trim(campo.dato),codigo.numero,cod);
						for i:=1 to 5 do
							if (upcase(campo.dato[i])='A') or (upcase(campo.dato[i])='B') then
								codigo.letra:=upcase(campo.dato[i]);
						if op=3 then
							begin
								v:=false;
								j:=true
							end {op}
							else if op=2 then
								begin
									write_msg(' Buscando......');
									pos:=busca_index_fact(codigo,i);
									if pos=0 then
									 begin
										 error(24);
										 lowbar('Men£ Facturas')
										end
										else v:=false
								end;{op2}
					end; {while}
				if not j then
					begin
						write_msg(' Leyendo datos....');
						inic:=nil;
						op:=busca_factura_f(ahead,inic,pos);
						if op<>0 then
							begin
								lowbar(' Men£ Facturas');
								blackout(3,3,15,3);
								recuadro_factura_general(3,2);
								put_factura_general_head(ahead,3,2);
								recuadro_pie_factura(3,10);
								put_factura_general_pie(ahead,3,10);
								write_msg(' Borrar factura (s/N)');
								ans:=si_no('N');
								if ans then
								begin
									borra_factura_f(pos);

									(* ojo! aqui nalbs es una simple variable
									que necesitaba de tipo word , no
									significa una mierda *)

									borra_fact_index(ahead.num_factura);
									borra_lin_fact(ahead.num_factura);
								end;

							end
							else error(12);
						write_msg(' Borrar otra factura (S/n)');
						ans:=si_no('S')
					end;
			until (j or not ans);
			borra_lista_facturas(inic);
	end;


begin
end.
