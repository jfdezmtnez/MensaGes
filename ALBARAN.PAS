unit albaran;

interface

procedure consulta_albaran;
procedure new_albaran;
procedure modif_albaran;
procedure borrar_albaran;
procedure archivar;

implementation

uses crt,defs,common,campstru,graficos,ficheros,puts,gets,tfnomem;



procedure consulta_albaran;
var
	aalbaran:t_albaran;
	v,j,ans:boolean;
	campo:t_nodo_dato;
	op,pos:word;
	i  : byte;
	c,t:char;
	codigo:t_codigo;
begin
		swap_menu(25,5,26);
		repeat
			ini_albaran(aalbaran);
			v:=true;
			j:=false;
			lowbar('Menu Albaranes');
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
					codigo.letra:=upcase(campo.dato[5]);
					if op=3 then
						begin
							v:=false;
							j:=true
						end {op}
						else if op=2 then
							begin
								write_msg(' Buscando......');
								pos:=busca_index_cod(codigo,i);
								if pos=0 then
								 begin
									 error(12);
									 lowbar('Men£ Albaranes')
									end
									else v:=false
							end;{op2}
				end; {while}
			if not j then
				begin
					write_msg(' Leyendo datos....');
					op:=busca_albaran_f(aalbaran,codigo,i,pos);
					if op<>0 then
						begin
							lowbar(' Men£ Albaranes');
							blackout(3,3,15,3);
		{         aalbaran.codigo.numero:=codigo.numero;
							aalbaran.codigo.letra:=codigo.letra;
		}         recuadro_albaran(3,3);
							put_albaran(aalbaran,3,3);
							ans:=true;
							i:=1;
							while (ans) and (i<=_max_casillas)do
								begin
									put_casilla(aalbaran,i,3,10);
									write_msg(' Pulse una tecla para ver casillas. ESC Salir');
									t:=readkey;
									if t=#27 then ans:=false;
									inc(i);
								end
						end
						else error(12);
					write_msg(' Ver otro albar n (S/n)');
					ans:=si_no('S')
				end;
		until (j or not ans)

end;



procedure new_albaran;
var
	aalbaran:t_albaran;
	v,j,ans:boolean;
	campo:t_nodo_dato;
	i : byte;
	op,pos:word;
	dat:byte;
	c,t:char;
	cad:string;
	codigo:t_codigo;
begin
	swap_menu(25,5,26);
	repeat
		ini_albaran(aalbaran);
		v:=true;
		j:=false;
		lowbar('Menu Albaranes');
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
				val(trim(copy(campo.dato,1,4)),codigo.numero,cod);
				codigo.letra:=upcase(campo.dato[5]);
				if op=3 then
					begin
						v:=false;
						j:=true
					end {op}
					else if op=2 then
						begin
							write_msg(' Comprobando......');
							pos:=busca_index_cod(codigo,i);
							if pos=0 then v:=false
								else begin
									error(11);
									lowbar('Men£ Albaranes')
								end
						end;{op2}
			end; {while}
		if not j then
			begin
				aalbaran.codigo:=codigo;
				lowbar('Men£ Albaranes');
				blackout(3,3,15,3);
				recuadro_albaran(3,3);

				repeat
					op:=get_albaran(aalbaran,3,3);
					if op<>0 then v:=true;
				until v;

				pos:=busca_tfno(telefonos,aalbaran.telefono,max_clientes);
				if pos=0 then
					begin
						error(3);
						aalbaran.telefono:=0;
						op:=7;
					end;
				if op=3 then j:=true
					else if op=2 then
						begin
							recuadro_casillas(3,10);
							write_msg(' Pulse Esc para finalizar.');
							op:=get_casillas(aalbaran,3,10);
							if op=3 then
								begin
									write_msg(' A¤adiendo...');

									ins_albaran_f(aalbaran,max_albaranes);
									albaran_borrado:=true;

									actualiza_cod_index(codigo);
									actualiza_fec_index(aalbaran.fecha);
												{ordena_fecha_ndx;}
									blackout(1,2,80,24);
									write_msg(' Introducir otro albar n (S/n)');
									ans:=si_no('S');
									if max_albaranes>1700 then
										begin
											write_msg(' Debe archivar los albaranes antiguos');
											repeat until keypressed
										end;
									if max_albaranes=1750 then
										begin
											ini.permit:=false;
											j:=true
										end
								end
						end
				end;
		until (j or not ans)
end;



procedure modif_albaran;
var
	aalbaran:t_albaran;
	v,j,ans:boolean;
	campo:t_nodo_dato;
	op,pos:word;
	i : byte;
	c,t:char;
	codigo:t_codigo;
begin
		swap_menu(25,5,26);
		repeat
			ini_albaran(aalbaran);
			v:=true;
			j:=false;
			lowbar('Menu Albaranes');
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
					val(trim(copy(campo.dato,1,4)),codigo.numero,cod);
					codigo.letra:=upcase(campo.dato[5]);
					if op=3 then
						begin
							v:=false;
							j:=true
						end {op}
						else if op=2 then
							begin
								write_msg(' Comprobando......');
								pos:=busca_index_cod(codigo,i);
								if pos=0 then
									begin
										error(12);
										lowbar('Men£ Albaranes')
									end
									else v:=false
							end;{op2}
				end; {while}
			if not j then
				begin
					write_msg(' Buscando....');
					op:=busca_albaran_f(aalbaran,codigo,i,pos);
					if op<>0 then
						begin
							lowbar('Men£ Albaranes');
							blackout(3,3,15,3);
							recuadro_albaran(3,3);

							repeat
								op:=get_albaran(aalbaran,3,3);
								if op<>0 then v:=true;
							until v;

							if op=3 then j:=true
								else if op=2 then
									begin
										recuadro_casillas(3,10);
										write_msg(' Pulse Esc para finalizar.');
										op:=get_casillas(aalbaran,3,10);
										if (op=3) or (op=2) then
											begin
												write_msg(' Actualizando.....');
												{borra_albaran_f(pos,max_albaranes);}
												write_msg('Un momento...');
												if i=0 then
													begin
														if albaran_borrado=false then albaran_borrado:=true;
														desactiva_albaran(pos);
														borra_cod_index(codigo);
														borra_fec_index(aalbaran.fecha,pos);
													end
													else borra_cod_dsk(codigo);
												ins_albaran_f(aalbaran,max_albaranes);
												actualiza_cod_index(codigo);
												actualiza_fec_index(aalbaran.fecha);
												{ordena_cod_ndx;}
												{ordena_fecha_ndx;}
												{write_msg(' Modificar otro albar n (S/n)');
												ans:=si_no('S')}
											end
								 end
						end
						else error(12);
					write_msg(' Modificar otro albar n (S/n)');
					ans:=si_no('S')
				end;
		until (j or not ans)
end;



procedure borrar_albaran;
var
	aalbaran:t_albaran;
	v,j,ans:boolean;
	campo:t_nodo_dato;
	i : byte;
	op,pos:word;
	c,t:char;
	codigo:t_codigo;
begin
		swap_menu(25,5,26);
		repeat
			ini_albaran(aalbaran);
			v:=true;
			j:=false;
			lowbar('Menu Albaranes');
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
					val(trim(copy(campo.dato,1,4)),codigo.numero,cod);
					codigo.letra:=upcase(campo.dato[5]);
					if op=3 then
						begin
							v:=false;
							j:=true
						end {op}
						else if op=2 then
							begin
								write_msg(' Buscando......');
								pos:=busca_index_cod(codigo,i);
								if pos=0 then
									begin
										error(12);
										lowbar('Men£ Albaranes')
									end
									else v:=false
							end;{op2}
				end; {while}
			if not j then
				begin
					write_msg(' Buscando....');
					op:=busca_albaran_f(aalbaran,codigo,i,pos);
					if op<>0 then
						begin
							lowbar('Men£ Albaranes');
							blackout(3,3,15,3);
							recuadro_albaran(3,3);
							put_albaran(aalbaran,3,3);
							put_casilla(aalbaran,1,3,10);
							write_msg(' Borrar albar n (s/N)');
							ans:=si_no('N');
							if ans then
								begin
									{borra_albaran_f(pos,max_albaranes);}
									write_msg('Borrando...');
									if i=0 then
										begin
											if albaran_borrado=false then albaran_borrado:=true;
											desactiva_albaran(pos);
											borra_cod_index(codigo);
											borra_fec_index(aalbaran.fecha,pos)
										end
										else borra_cod_dsk(codigo);
									{ordena_fecha_ndx;}
								end;
						end
						else error(12);

					write_msg(' Borrar otro albar n (s/N)');
					ans:=si_no('N')
				end;
		until (j or not(ans));
end;


procedure archivar;
var
	campo : t_nodo_dato;
	op,i  : byte;
	barra : byte;
	ultimo: byte;
	dia,tmes,anho:longint;
	cdia,cmes,canho:string;
	cad   : string;
	ca    : array[1..3]of string;
	mal   : boolean;
	f_lim : longint;
begin
	swap_menu(25,5,26);
	lowbar(' Men£ albaranes');

	decrease(fecha_sistema);
	decrease(fecha_sistema);
	dia:=1;
	tmes:=fecha_sistema.month;
	anho:=fecha_sistema.year;
	mal:=false;
	increase(fecha_sistema);
	increase(fecha_sistema);
	str(dia,ca[1]);
	str(tmes,ca[2]);
	str(anho-1900,ca[3]);

	with campo do
		begin
			especifi:='nnxnnxnn';
			dato:=ca[1]+'.'+ca[2]+'.'+ca[3]+empty;
			ini_x:=22;
			ini_y:=5;
			lineas:=1;
			longitud:=8;
		end;

{ cad_fecha(campo.dato,dia,tmes,anho);
}
	gotoxy(5,5);
	textcolor(3);
	write('Archivar hasta : ');
	put_campo(campo,7);
	op:=get_field(campo);
	if op<>3 then
		begin
			cad:='';
			for i:=1 to 8 do cad:=cad+campo.dato[i];
			barra:=0;
			ultimo:=1;
			for i:=1 to length(cad) do
			begin
				if cad[i]='.' then
					begin
						ca[barra+1]:=copy(cad,ultimo,i-ultimo);
						ultimo:=i+1;
						inc(barra);
					end;
			end;
			ca[barra+1]:=copy(cad,ultimo,(length(cad)+1)-ultimo);
			cdia:=ca[1];
			cmes:=ca[2];
			canho:=trim(ca[3]);
			val(cdia,dia,cod);
			val(cmes,tmes,cod);
			val(canho,anho,cod);
			if (dia<1) or (dia>31) then mal:=true;
			if (tmes<1) or (tmes>12) then mal:=true;
			if (anho<95) or (anho>99) then mal:=true;
			if barra<>2 then mal:=true;

			if not mal then
				begin
					anho := anho*10000;
{         anho := anho div 10;}
					tmes := tmes*100;
					f_lim:= anho+tmes+dia;
					archiva_f(f_lim)
				end
		end;
	if max_albaranes<1750 then ini.permit:=true;
	save_cfg;
	blackout(5,5,45,15)

end;


begin
end.