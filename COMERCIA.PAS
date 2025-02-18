unit comercial;

interface

	procedure consulta_comercial;
	procedure new_comercial;
	procedure modif_comercial;
	procedure borrar_comercial;
	procedure fact_comercial;
	procedure listar_comerciales;

implementation

	uses defs,formulas,crt,common,graficos,campstru,
			 tfnomem,ficheros,gets,puts,print;



(* Rutina para consultar comerciales *)

	procedure consulta_comercial;
	var
		ccomercial:t_comercial;
		codigo   :       byte;
		op,pos   :    integer;
		campo    :    t_nodo_dato;
		i        :    integer;
		v,j,ans  :    boolean;
	begin
		ini_comercial(ccomercial);
		swap_menu(24,5,28);   
		repeat
			v:=true;
			j:=false;
			lowbar('Men� Comerciales');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C�digo:');
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
								pos:=busca_comercial_f(ccomercial,codigo);
								if pos=0 then
									begin
										error(6);
										lowbar('Men� Comerciales')
									end
									else v:=false
							end
				end;
			if not j then
				begin
					lowbar('Men� Comerciales');
					blackout(3,3,15,3);
					recuadro_comercial(3,3);
					put_comercial(ccomercial,3,3);
					write_msg('Consultar otro comercial (S/n)');
					ans:=si_no('S')
				end;
		until (j or not ans)
	end;



(* Rutina para entrar nuevos comerciales *)

	procedure new_comercial;
	var
		ccomercial:t_comercial;
		num      :       byte;
		op,pos   :    integer;
		campo    :    t_nodo_dato;
		i        :    integer;
		v,j,ans  :    boolean;
	begin
		swap_menu(24,5,28);   
		ini_comercial(ccomercial);
		num:=0;
		repeat
			v:=true;
			j:=false;
			lowbar('Men� Comerciales');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C�digo:');
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
					val(campo.dato,num,cod);
					if op=3 then
						begin
							v:=false;
							j:=true
						end
						else if((op=2)and(num<>0))then
							begin
								write_msg('Comprobando......');
								pos:=busca_comercial_f(ccomercial,num);
								if pos<>0 then
									begin
										error(5);
										lowbar('Men� Comerciales')
									end
									else v:=false
							end
				end;
			if not j then
				begin
					lowbar('Men� Comerciales');
					ini_comercial(ccomercial);
					ccomercial.codigo:=num;
					repeat
						blackout(3,3,15,3);
						recuadro_comercial(3,3);
						op:=get_comercial(ccomercial,3,3);
						if op=3 then j:=true;
					until ((op=2)or j);
					if not j then begin
							write_msg('A�adiendo comercial.....');
							ins_comercial_f(ccomercial,max_comerciales);
							write_msg('Introducir otro comercial (S/n)');
							ans:=si_no('S')
						end
				end;
		until (j or not ans)
	end;



(* Procedimiento para modificar comerciales *)

	procedure modif_comercial;
		var
		ccomercial:t_comercial;
		codigo   :       byte;
		op,pos   :    integer;
		campo    :    t_nodo_dato;
		i        :    integer;
		v,j,ans  :    boolean;
	begin
		swap_menu(24,5,28);   
		ini_comercial(ccomercial);
		repeat
			v:=true;
			j:=false;
			lowbar('Men� Comerciales');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C�digo:');
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
						else if((op=2)and(codigo<>0))then
							begin
								write_msg('Comprobando......');
								pos:=busca_comercial_f(ccomercial,codigo);
								if pos=0 then
									begin
										error(6);
										lowbar('Men� Comerciales')
									end
									else v:=false
							end
				end;
			if not j then
				begin
					lowbar('Men� Comerciales');
					repeat
						blackout(3,3,15,3);
						recuadro_comercial(3,3);
						op:=get_comercial(ccomercial,3,3);
						if op=3 then j:=true;
					until ((op=2)or j);
					if not j then begin
							write_msg('Actualizando comercial.....');
							borra_comercial_f(pos,max_comerciales);
							ins_comercial_f(ccomercial,max_comerciales);
							write_msg('Modificar otro comercial (S/n)');
							ans:=si_no('S')
						end
				end;
		until (j or not ans)
	end;



(* Deshacerse de un comercial *)

	procedure borrar_comercial;
	var
		ccomercial:t_comercial;
		codigo   :       byte;
		op,pos   :    integer;
		campo    :    t_nodo_dato;
		i        :    integer;
		v,j,ans  :    boolean;
	begin
		swap_menu(24,5,28);   
		ini_comercial(ccomercial);
		repeat
			v:=true;
			j:=false;
			lowbar('Men� Comerciales');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C�digo:');
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
						else if((op=2)and(codigo<>0))then
							begin
								write_msg('Comprobando......');
								pos:=busca_comercial_f(ccomercial,codigo);
								if pos=0 then
									begin
										error(6);
										lowbar('Men� Comerciales')
									end
									else v:=false
							end
				end;
			if not j then
				begin
					lowbar('Men� Comerciales');
					blackout(3,3,15,3);
					recuadro_comercial(3,3);
					put_comercial(ccomercial,3,3);
					write_msg('Borrar comercial (s/N)');
					ans:=si_no('N');
					if ans=true then
						begin
							write_msg('Borrando comercial.....');
							borra_comercial_f(pos,max_comerciales);
						end;
					write_msg('Borrar otro comercial (s/N)');
					ans:=si_no('N')
				end;
		until (j or not ans)
	end;



(* Tambi�n habr� que facturar, digo yo  }8-)  *)


	procedure fact_comercial;
	var
		path                  :            string;
		fich1,fich2,fich      :            str_11;
		fecia                 :          t_index2;
		fecha_inicio,fecha_fin:           longint;
		ccomercial            :       t_comercial;
		cog                   :          t_codigo;
		aalbaran              :         t_albaran;
		ccliente              :         t_cliente;
		codigo                :              byte;
		ind,ind2              :              word;
		sub                   :           longint;
		op,pos                :           integer;
		campo                 :       t_nodo_dato;
		i                     :           integer;
		v,j,ans               :           boolean;
		serv                  :      resumen_serv;
		u,m,a                 :           integer;
		est                   :          t_status;
	begin
		swap_menu(24,5,28);
		ini_comercial(ccomercial);
		repeat
			path:='';
			fich:=ini.last_fact_month;
			v:=true;
			j:=false;
			sub:=0;
			lowbar('Men� Comerciales');
			blackout(1,2,80,24);
			textcolor(11);
			gotoxy(3,3);
			write('C�digo:');
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
										error(6);
										lowbar('Men� Comerciales');
									end
									else begin
										write_msg('Comprobando......');
										pos:=busca_comercial_f(ccomercial,codigo);
										if pos=0 then
											begin
												error(6);
												lowbar('Men� Comerciales')
											end
											else v:=false
									end
							end
				end;
			if not j then
				begin
					lowbar('Men� Comerciales');
					repeat
						textcolor(CYAN);
						lowvideo;
						gotoxy(2,7);
						write('Fecha de inicio      : ');
						gotoxy(2,9);
						textcolor(CYAN);
						lowvideo;
						write('FEcha de t�rmino     : ');
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
									 lowbar('Men� Comerciales')
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
									lowbar('Men� Comerciales');
									j:=true
								end
								else begin
									{$I-}
									Reset(fichclientes);
									{$I+}
									if IOresult<>0 then
										begin
											error(1);
											lowbar('Men� Comerciales');
											j:=true
										end
								end;
							close(fichalbs);
							if not j then
								begin
									ind:=0;
									reset(fec_ndx);
									while not(eof(fec_ndx)) do
										begin
											read(fec_ndx,fecia);
											if (fecia.fecha>=fecha_inicio)and
											 (fecia.fecha<=fecha_fin) then
												begin
													pos:=busca_albaran_f(aalbaran,cog,0,fecia.pos);
													pos:=busca_tfno(telefonos,aalbaran.telefono,max_clientes);
													Reset(fichclientes);
													ind2:=0;
													if pos<>0 then
														repeat
															read(fichclientes,ccliente);
															inc(ind2)
														until ind2=pos;
													if ccliente.comercial=ccomercial.codigo then
														begin
															sub:=sub+calcular_albaran(aalbaran,ccliente,serv);
															inc(ind)
														end
												end; {if fechas}
										end; {eof(f_fechas)}

									close(fec_ndx);
									close(fichclientes);

									lowbar('Men� Comerciales');
									blackout(3,3,40,5);
									recuadro_factura_comercial(5,5);
									put_fact_comercial(ccomercial,ind,sub);

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

									if ans then print_fact_comercial(ccomercial,sub);

									write_msg('Facturar otro comercial (S/n)');
									ans:=si_no('S')
								end
						end
				end;
		until (j or not ans)
	end;



procedure listar_comerciales;

var
	 ans:boolean;
	 est:t_status;
	 n_comerciales:word;
	 ccomercial:t_comercial;
	 C:char;

procedure write_comercial;
begin
		 with ccomercial do
		 begin
					writeln(prnt);
					writeln(prnt,'Tel�fono: ',telefono,'     C.I.F.: ',cif,'      C�digo: ',codigo);
					writeln(prnt,nombre);
					writeln(prnt,'C/ ',direccion.calle);
					if direccion.numero<>0 then writeln(prnt,'N� ',direccion.numero);
					if direccion.piso<>0 then write(prnt,' ',direccion.piso,' ',direccion.letra);
					writeln(prnt,direccion.localidad);
					writeln(prnt,direccion.provincia);
					if porcentaje<>0 then writeln(prnt,'    Descuento: ',porcentaje,' %') else writeln(prnt);
					writeln(prnt,'Obs: ',obs);
					writeln(prnt,'���������������������������������������������������������������������������');
					writeln(prnt);
		 end;
end;



begin

		 swap_menu(24,5,28);   
		 blackout(1,2,80,24);

		 reset(fichcomercia);

		 n_comerciales:=1;

		 repeat
			 write_msg('Pulse una tecla cuando est� listo (ESC - Salir)');
			 C:=readkey;
			 if c=#27 then exit;
			 get_printer_status(est);
			 if est.io_error then error(15)
				else if est.paper_out then error(14);
		 until not((est.io_error) or (est.paper_out));

			 if c<>#27 then
			 begin
					write_msg('Imprimiendo...');

					writeln(prnt);
					with fecha_sistema do writeln(prnt,'LISTA DE COMERCIALES DEL   ',day,'/',month,'/',year);
					writeln(prnt,'��������������������������������������');
					writeln(prnt);
					writeln(prnt);

					while not(eof(fichcomercia)) do
					begin
							 read(fichcomercia,ccomercial);
							 write_comercial;
							 inc(n_comerciales);
							 if n_comerciales>5 then
							 begin
										write(prnt,#12);
										n_comerciales:=1;
										repeat
											write_msg('Pulse una tecla cuando est� listo');
											C:=readkey;
											get_printer_status(est);
										until not(est.paper_out);
										writeln(prnt);
										with fecha_sistema do writeln(prnt,'LISTA DE COMERCIALES DEL   ',day,'/',month,'/',year);
										writeln(prnt,'������������������������������������');
										write_msg('Imprimiendo...                       ');
										writeln(prnt);
										writeln(prnt);
							 end;
					end;
					close(fichcomercia);
					writeln(prnt,#12);
					write_msg('                                      ');
			 end;

end;






end.