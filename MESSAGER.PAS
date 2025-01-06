unit messager;

interface

procedure consulta_mensajero;
procedure new_mensajero;
procedure modif_mensajero;
procedure borrar_mensajero;
procedure fact_mensajero;
procedure listar_mensajeros;

implementation


	uses defs,print,crt,common,graficos,
			 campstru,ficheros,gets,puts,formulas;



(* Rutina para consultar mensajeros *)

	procedure consulta_mensajero;
	var
		mmensajero:t_mensajero;
		codigo   :       byte;
		op,pos   :    integer;
		campo    :    t_nodo_dato;
		i        :    integer;
		v,j,ans  :    boolean;
	begin
		swap_menu(24,5,28);   
		ini_mensajero(mmensajero);
		repeat
			v:=true;
			j:=false;
			lowbar('Men£ Mensajeros');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C¢digo:');
			lowvideo;
			while v do
				begin
					with campo do
						begin
							dato:=empty;
							especifi:=empty;
							ini_x:=12;
							ini_y:=3;
							longitud:=2;
							lineas:=1;
						end;
					op:=get_field(campo);
							 campo.dato:=trim(campo.dato);
					VAL(campo.dato,codigo,cod);
					if op=3 then
						begin
							v:=false;
							j:=true
						end
						else if op=2 then
							begin
								write_msg('Buscando......');
								pos:=busca_mensajero_f(mmensajero,codigo);
								if pos=0 then
									begin
										error(9);
										lowbar('Men£ Mensajeros')
									end
									else v:=false
							end
				end;
			if not j then
				begin
					lowbar('Men£ Mensajeros');
					blackout(3,3,15,3);
					recuadro_mensajero(3,3);
					put_mensajero(mmensajero,3,3);
					write_msg('Consultar otro mensajero (S/n)');
					ans:=si_no('S')
				end;
		until (j or not ans)
	end;



(* Rutina para entrar nuevos mensajeros *)

	procedure new_mensajero;
	var
		mmensajero:t_mensajero;
		codigo   :       byte;
		op,pos   :    integer;
		campo    :    t_nodo_dato;
		i        :    integer;
		v,j,ans  :    boolean;
	begin
		swap_menu(24,5,28);   
		ini_mensajero(mmensajero);
		repeat
			v:=true;
			j:=false;
			lowbar('Men£ Mensajeros');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C¢digo:');
			lowvideo;
			while v do
				begin
					with campo do
						begin
							dato:=empty;
							especifi:=empty;
							ini_x:=12;
							ini_y:=3;
							longitud:=2;
							lineas:=1;
						end;
					op:=get_field(campo);
							 campo.dato:=trim(campo.dato);
					VAL(campo.dato,codigo,cod);
					if op=3 then
						begin
							v:=false;
							j:=true
						end
						else if op=2 then
							begin
								if codigo=0 then
									begin
										error(8);
										lowbar('Men£ Mensajeros');
									end
									else begin
										write_msg('Comprobando......');
										pos:=busca_mensajero_f(mmensajero,codigo);
										if pos<>0 then
											begin
												error(8);
												lowbar('Men£ Mensajeros')
											end
											else v:=false
									end
							end
				end;
			if not j then
				begin
					lowbar('Men£ Mensajeros');
					ini_mensajero(mmensajero);
					mmensajero.codigo:=codigo;
					repeat
						blackout(3,3,15,3);
						recuadro_mensajero(3,3);
						op:=get_mensajero(mmensajero,3,3);
						if op=3 then j:=true;
					until ((op=2)or j);
					if not j then begin
							write_msg('A¤adiendo mensajero.....');
							ins_mensajero_f(mmensajero,max_mensajeros);
							write_msg('Introducir otro mensajero (S/n)');
							ans:=si_no('S')
						end
				end;
		until (j or not ans)
	end;



(* Procedimiento para modificar comerrciales *)

	procedure modif_mensajero;
		var
		mmensajero:t_mensajero;
		codigo   :       byte;
		op,pos   :    integer;
		campo    :    t_nodo_dato;
		i        :    integer;
		v,j,ans  :    boolean;
	begin
		swap_menu(24,5,28);   
		ini_mensajero(mmensajero);
		repeat
			v:=true;
			j:=false;
			lowbar('Men£ Mensajeros');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C¢digo:');
			lowvideo;
			while v do
				begin
					with campo do
						begin
							dato:=empty;
							especifi:=empty;
							ini_x:=12;
							ini_y:=3;
							longitud:=2;
							lineas:=1;
						end;
					op:=get_field(campo);
					campo.dato:=trim(campo.dato);
					VAL(campo.dato,codigo,cod);
					if op=3 then
						begin
							v:=false;
							j:=true
						end
						else if op=2 then
							begin
								if codigo=0 then
									begin
										error(9);
										lowbar('Men£ Mensajeros');
									end
									else begin
										write_msg('Comprobando......');
										pos:=busca_mensajero_f(mmensajero,codigo);
										if pos=0 then
											begin
												error(9);
												lowbar('Men£ Mensajeros')
											end
											else v:=false
									end
							end
				end;
			if not j then
				begin
					lowbar('Men£ Mensajeros');
					repeat
						blackout(3,3,15,3);
						recuadro_mensajero(3,3);
						op:=get_mensajero(mmensajero,3,3);
						if op=3 then j:=true;
					until ((op=2)or j);
					if not j then begin
							write_msg('Actualizando mensajero.....');
							borra_mensajero_f(pos,max_mensajeros);
							ins_mensajero_f(mmensajero,max_mensajeros);
							write_msg('Modificar otro mensajero (S/n)');
							ans:=si_no('S')
						end
				end;
		until (j or not ans)
	end;



(* Deshacerse de un mensajero *)

	procedure borrar_mensajero;
	var
		mmensajero:t_mensajero;
		codigo   :       byte;
		op,pos   :    integer;
		campo    :t_nodo_dato;
		i        :    integer;
		v,j,ans  :    boolean;
	begin
		swap_menu(24,5,28);   
		ini_mensajero(mmensajero);
		repeat
			v:=true;
			j:=false;
			lowbar('Men£ Mensajeros');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C¢digo:');
			lowvideo;
			while v do
				begin
					with campo do
						begin
							dato:=empty;
							especifi:=empty;
							ini_x:=12;
							ini_y:=3;
							longitud:=2;
							lineas:=1;
						end;
					op:=get_field(campo);
							 campo.dato:=trim(campo.dato);
					VAL(campo.dato,codigo,cod);
					if op=3 then
						begin
							v:=false;
							j:=true
						end
						else if op=2 then
							begin
								if codigo=0 then
									begin
										error(9);
										lowbar('Men£ Mensajeros');
									end
									else begin
										write_msg('Comprobando......');
										pos:=busca_mensajero_f(mmensajero,codigo);
										if pos=0 then
											begin
												error(9);
												lowbar('Men£ Mensajeros')
											end
											else v:=false
									end
							end
				end;
			if not j then
				begin
					lowbar('Men£ Mensajeros');
					blackout(3,3,15,3);
					recuadro_mensajero(3,3);
					put_mensajero(mmensajero,3,3);
					write_msg('Borrar mensajero (s/N)');
					ans:=si_no('N');
					if ans=true then
						begin
							write_msg('Borrando mensajero.....');
							borra_mensajero_f(pos,max_mensajeros);
						end;
					write_msg('Borrar otro mensajeros (s/N)');
					ans:=si_no('N')
				end;
		until (j or not ans)
	end;


(* Tambi‚n habr  que facturar, digo yo  }8-)  *)

	procedure fact_mensajero;
	var
		path                    :            string;
		fich1,fich2,fich        :            str_11;
		mmensajero              :       t_mensajero;
		fecia                   :          t_index2;
		fecha_inicio,fecha_fin  :           longint;
		u,m,a                   :           integer;
		cog                     :          t_codigo;
		aalbaran                :         t_albaran;
		codigo                  :              byte;
		op,pos,ind              :           integer;
		campo                   :       t_nodo_dato;
		v,j,ans                 :           boolean;
		servs                   :            t_servs;
		subts                   :           t_subts;
		C                       :              char;
		est                     :          t_status;
	begin
		swap_menu(24,5,28);
		repeat
			ini_mensajero(mmensajero);
			for ind:=1 to 8 do
				begin
					servs[1,ind]:=0;
					servs[2,ind]:=0;
					servs[3,ind]:=0;
					servs[4,ind]:=0;
					subts[ind]:=0
				end;
			path:='';
			v:=true;
			j:=false;
			lowbar('Men£ Mensajeros');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C¢digo:');
			lowvideo;
			while v do
				begin
					with campo do
						begin
							dato:=empty;
							especifi:=empty;
							ini_x:=12;
							ini_y:=3;
							longitud:=2;
							lineas:=1;
						end;
					op:=get_field(campo);
					campo.dato:=trim(campo.dato);
					VAL(campo.dato,codigo,cod);
					if op=3 then
						begin
							v:=false;
							j:=true
						end
						else if op=2 then
							begin
								if codigo=0 then
									begin
										error(9);
										lowbar('Men£ Mensajeros');
									end
									else begin
										write_msg('Comprobando......');
										pos:=busca_mensajero_f(mmensajero,codigo);
										if pos=0 then
											begin
												error(9);
												lowbar('Men£ Mensajeros')
											end
											else v:=false
									end
							end
				end;

			if not j then
				begin
					{fich:=ini.last_fact_month;}
					fich:='           ';
					lowbar('Men£ Mensajeros');
					repeat
						textcolor(CYAN);
						lowvideo;
						gotoxy(2,7);
						write('Fecha de inicio      : ');
						gotoxy(2,9);
						textcolor(CYAN);
						lowvideo;
						write('FEcha de t‚rmino     : ');
						op:=get_fechas(fich1,fich2);
						cad_fecha(fich1,u,m,a);
						fecha_inicio:=fecha_numero(u,m,a);
						cad_fecha(fich2,u,m,a);
						fecha_fin:=fecha_numero(u,m,a);
						blackout(1,2,80,24);
						if op=2 then v:=true
							else if op=0 then
								begin
									error(10);
									lowbar('Men£ Mensajeros')
								end
								else if op=3 then
									begin
										v:=true;
										j:=true
									end;
					until v;
					if not j then
						begin
							write_msg('Procesando.....');
							path:=ini.work+'albaran.dat';
							{$I-}
							Reset(fichalbs);
							{$I+}
							if IOresult<>0 then
								begin
									error(10);
									lowbar('Men£ Mensajeros');
									j:=true
								end
								else begin
									close(fichalbs);
									reset(fec_ndx);
									while not eof(fec_ndx) do
										begin
											read(fec_ndx,fecia);
											if (fecia.fecha>=fecha_inicio)and
											 (fecia.fecha<=fecha_fin) then
												begin
													pos:=busca_albaran_f(aalbaran,cog,0,fecia.pos);
													total_albaran_mensajero(aalbaran,codigo,servs,subts)
												end; {if fechas}
										end; {fec_ndx}
									{close(fichalbs);}
									close(fec_ndx);
									lowbar('Men£ Mensajeros');
									blackout(3,3,40,5);
									recuadro_factura_mensajero(8,3);
									put_fact_mensajero(mmensajero,servs,subts);

									repeat
										write_msg('Imprimir (S/n)');
										ans:=si_no('S');
										write_msg('                        ');
										if ans then
											begin
												get_printer_status(est);
												if est.io_error then error(15)
													else if est.paper_out then error(14)
											end
									until(not(ans) or not((est.paper_out)or(est.io_error)));

									if ans then print_fact_mensajero(mmensajero,servs,subts);

									write_msg('Facturar otro mensajero (S/n)');
									ans:=si_no('S')
								end
						end
				end;
		until (j or not ans)
	end;

procedure listar_mensajeros;

var
	 ans:boolean;
	 est:t_status;
	 n_mensajeros:word;
	 cmensajero:t_mensajero;
	 t:string;
	 C:char;

procedure write_mensajero;
begin
		 with cmensajero do
		 begin
					writeln(prnt);
					writeln(prnt,'Tel‚fono: ',telefono,'     C.I.F.: ',cif,'      C¢digo: ',codigo);
					writeln(prnt,nombre);
					writeln(prnt,'C/ ',direccion.calle);
					if direccion.numero<>0 then writeln(prnt,'N§ ',direccion.numero);
					if direccion.piso<>0 then write(prnt,' ',direccion.piso,' ',direccion.letra);
					writeln(prnt,direccion.localidad);
					writeln(prnt,direccion.provincia);
					t:=upcase(vehiculo);
					if t='M' then writeln(prnt,'Moto') else writeln(prnt,'Coche');
					writeln(prnt,'Obs: ',obs);
					writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
					writeln(prnt);
		 end;
end;



begin

		 swap_menu(24,5,28);   
		 blackout(1,2,80,24);

		 reset(fichmessager);

		 n_mensajeros:=1;

		 repeat
			 write_msg('Pulse una tecla cuando est‚ listo (ESC - Salir)');
			 C:=readkey;
			 if c=#27 then exit;
			 get_printer_status(est);
			 if est.io_error then error(15)
				else if est.paper_out then error(14)
		 until not((est.io_error) or(est.paper_out));

			 if c<>#27 then
			 begin
					write_msg('Imprimiendo...');

					writeln(prnt);
					with fecha_sistema do writeln(prnt,'LISTA DE MENSAJEROS DEL   ',day,'/',month,'/',year);
					writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
					writeln(prnt);
					writeln(prnt);

					while not(eof(fichmessager)) do
					begin
							 read(fichmessager,cmensajero);
							 write_mensajero;
							 inc(n_mensajeros);
							 if n_mensajeros>5 then
								 begin
										write(prnt,#12);
										n_mensajeros:=1;
										repeat
											write_msg('Pulse una tecla cuando est‚ listo');
											C:=readkey;
											get_printer_status(est);
										until not(est.paper_out);
										writeln(prnt);
										with fecha_sistema do writeln(prnt,'LISTA DE MENSAJEROS DEL   ',day,'/',month,'/',year);
										writeln(prnt,'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
										write_msg('Imprimiendo...                       ');
										writeln(prnt);
										writeln(prnt);
								 end;
					end;
					close(fichmessager);
					writeln(prnt,#12);
					write_msg('                                      ');
			 end;

end;


end.