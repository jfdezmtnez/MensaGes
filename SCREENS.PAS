unit screens;

interface

	function main_menu:byte;
	function dispatch_menu:byte;
	function client_menu:byte;
	function dealer_menu:byte;
	function messager_menu:byte;
	function stats_menu:byte;
	procedure menus;


implementation

	uses crt,defs,common,graficos,cliente,messager,albaran,
				comercial,stats,config,facturas;



	function main_menu:byte;
	var
		s,func :    byte;
		estado :t_estado;
		teclas :   str_3;
		a      :    char;
		v      : boolean;
	begin
		textcolor(11);
		gotoxy(25,5);
		write('∞±≤€€ MENU PRINCIPAL €€≤±∞'); {//Len=26}
		gotoxy(26,8);
		write('F1 - ');
		lowvideo;
		write('Servicio al Cliente');
		highvideo;
		gotoxy(26,10);
		write('F2 - ');
		lowvideo;
		write('Gesti¢n de Clientes');
		highvideo;
		gotoxy(26,12);
		write('F3 - ');
		lowvideo;
		write('Gesti¢n de Albaranes');
		highvideo;
		gotoxy(26,14);
		write('F4 - ');
		lowvideo;
		write('Gesti¢n de Mensajeros');
		highvideo;
		gotoxy(26,16);
		write('F5 - ');
		lowvideo;
		write('Gesti¢n de Comerciales');
		highvideo;
		gotoxy(26,18);
		write('F6 - ');
		lowvideo;
		write('Gesti¢n de Facturas');
		highvideo;
		gotoxy(26,20);
		write('F7 - ');
		lowvideo;
		write('Estad°sticas');
		highvideo;
		gotoxy(26,22);
		write('F8 - ');
		lowvideo;
		write('Configurar Datos');
		lowbar('Salir');
		v   :=true;
		repeat
			repeat until(get_key(a,s,func,estado,teclas));
			if func=0 then v:=false
				else if ((func<9)and(func>0)) then v:=false;
		until not v;
		main_menu:=func;
	end;


	function dispatch_menu:byte;
	var
		s,func :    byte;
		estado :t_estado;
		teclas :   str_3;
		a      :    char;
		v,temp : boolean;
	begin
		textcolor(11);
		gotoxy(25,5);
		write('∞±≤€€ MENU ALBARANES €€≤±∞'); {//Len=26}
		gotoxy(27,8);
		write('F1 - ');
		lowvideo;
		writeln('Consultar albar†n');
		highvideo;
		gotoxy(27,wherey+1);
		write('F2 - ');
		lowvideo;
		writeln('Nuevo albar†n');
		highvideo;
		gotoxy(27,wherey+1);
		write('F3 - ');
		lowvideo;
		writeln('Modificar albar†n');
		highvideo;
		gotoxy(27,wherey+1);
		write('F4 - ');
		lowvideo;
		writeln('Borrar albar†n');
		highvideo;
		gotoxy(27,wherey+1);
		write('F5 - ');
		lowvideo;
		writeln('Archivar albaranes');
		writeln;
		lowbar('Men£ Principal');
		repeat
			repeat until(get_key(a,s,func,estado,teclas));
			if func=0 then v:=false
				else if ((func<6)and(func>0)) then v:=false;
		until not v;
		dispatch_menu:=func;
	end;



	function client_menu:byte;
	var
		s,func :    byte;
		estado :t_estado;
		teclas :   str_3;
		a      :    char;
		v      : boolean;
	begin
		textcolor(11);
		gotoxy(25,5);
		write('∞±≤€€ MENU  CLIENTES €€≤±∞'); {//Len=26}
		gotoxy(27,8);
		write('F1 - ');
		lowvideo;
		write('Nuevo Cliente');
		highvideo;
		gotoxy(27,10);
		write('F2 - ');
		lowvideo;
		write('Modificar Cliente');
		highvideo;
		gotoxy(27,12);
		write('F3 - ');
		lowvideo;
		write('Borrar Cliente');
		highvideo;
		gotoxy(27,14);
		write('F4 - ');
		lowvideo;
		write('Facturar Cliente');
		highvideo;
		gotoxy(27,16);
		write('F5 - ');
		lowvideo;
		write('Listar Clientes');

		lowbar('Men£ Principal');
		v   :=true;
		repeat
			repeat until(get_key(a,s,func,estado,teclas));
			if func=0 then v:=false
				else if ((func<6)and(func>0)) then v:=false;
		until not v;
		client_menu:=func;
	end;


	function fact_menu:byte;
	var
		s,func :    byte;
		estado :t_estado;
		teclas :   str_3;
		a      :    char;
		v      : boolean;
	begin
		textcolor(11);
		gotoxy(25,5);
		write('∞±≤€€ MENU  FACTURAS €€≤±∞'); {//Len=26}
		gotoxy(27,8);
		write('F1 - ');
		lowvideo;
		write('Consultar Factura');
		highvideo;
		gotoxy(27,10);
		write('F2 - ');
{		lowvideo;
		write('Modificar Factura');
		highvideo;
		gotoxy(27,12);
		write('F3 - ');
}		lowvideo;
		write('Borrar Factura');
		highvideo;

		lowbar('Men£ Principal');
		v   :=true;
		repeat
			repeat until(get_key(a,s,func,estado,teclas));
			if func=0 then v:=false
				else if ((func<4)and(func>0)) then v:=false;
		until not v;
		fact_menu:=func;
	end;



	function dealer_menu:byte;
	var
		s,func :    byte;
		estado :t_estado;
		teclas :   str_3;
		a      :    char;
		v      : boolean;
	begin
		textcolor(11);
		gotoxy(24,5);
		write('∞±≤€€ MENU COMERCIALES €€≤±∞'); {//Len=28}
		gotoxy(26,8);
		write('F1 - ');
		lowvideo;
		write('Consultar comercial');
		highvideo;
		gotoxy(26,10);
		write('F2 - ');
		lowvideo;
		write('Nuevo comercial');
		highvideo;
		gotoxy(26,12);
		write('F3 - ');
		lowvideo;
		write('Modificar comercial');
		highvideo;
		gotoxy(26,14);
		write('F4 - ');
		lowvideo;
		write('Borrar comercial');
		highvideo;
		gotoxy(26,16);
		write('F5 - ');
		lowvideo;
		write('Facturar comercial');
		highvideo;
		gotoxy(26,18);
		write('F6 - ');
		lowvideo;
		write('Listar Comerciales');
		lowbar('Men£ Principal');
		v   :=true;
		repeat
			repeat until(get_key(a,s,func,estado,teclas));
			if func=0 then v:=false
				else if ((func<7)and(func>0)) then v:=false;
		until not v;
		dealer_menu:=func;
	end;



	function messager_menu:byte;
	var
		s,func :    byte;
		estado :t_estado;
		teclas :   str_3;
		a      :    char;
		v      : boolean;
	begin
		textcolor(11);
		gotoxy(24,5);
		write('∞±≤€€ MENU  MENSAJEROS €€≤±∞'); {/ Len=28}
		gotoxy(26,8);
		write('F1 - ');
		lowvideo;
		write('Consultar mensajero');
		highvideo;
		gotoxy(26,10);
		write('F2 - ');
		lowvideo;
		write('Nuevo mensajero');
		highvideo;
		gotoxy(26,12);
		write('F3 - ');
		lowvideo;
		write('Modificar mensajero');
		highvideo;
		gotoxy(26,14);
		write('F4 - ');
		lowvideo;
		write('Borrar mensajero');
		highvideo;
		gotoxy(26,16);
		write('F5 - ');
		lowvideo;
		write('Facturar mensajero');
		highvideo;
		gotoxy(26,18);
		write('F6 - ');
		lowvideo;
		write('Listar Mensajeros');
		lowbar('Men£ Principal');
		v   :=true;
		repeat
			repeat until(get_key(a,s,func,estado,teclas));
			if func=0 then v:=false
				else if ((func<7)and(func>0)) then v:=false;
		until not v;
		messager_menu:=func;
	end;



	function stats_menu:byte;
	var
		s,func :    byte;
		estado :t_estado;
		teclas :   str_3;
		a      :    char;
		v      : boolean;
	begin
		textcolor(11);
		gotoxy(26,5);
		write('∞±≤€€ ESTADISTICAS €€≤±∞'); {// Len=24}
		gotoxy(26,8);
		write('F1 - ');
		lowvideo;
		write('N£mero de clientes');
		highvideo;
		gotoxy(26,10);
		write('F2 - ');
		lowvideo;
		write('Clientes nuevos');
		highvideo;
		gotoxy(26,12);
		write('F3 - ');
		lowvideo;
		write('Clientes por comercial');
		highvideo;
		gotoxy(26,14);
{
		write('F4 - ');
		lowvideo;
		write('Clientes nuevos por comercial');
		highvideo;
		gotoxy(26,16);
}
		write('F4 - ');
		lowvideo;
		write('Ingresos por mes');
		lowbar('Men£ Principal');
		v   :=true;
		repeat
			repeat until(get_key(a,s,func,estado,teclas));
			if func=0 then v:=false
				else if ((func<6)and(func>0)) then v:=false;
		until not v;
		stats_menu:=func;
	end;



	procedure menus;
	var opcion : byte;
	begin
		opcion:=1;
		bars;
		while (opcion<>0) do
			begin
				blackout(1,2,80,24);
				lowbar('Salir');
				opcion:=main_menu;
				case opcion of

					0 : begin
								write_msg(' ® Seguro que desea salir (s/N) ?');
								if not(si_no('N')) then opcion:=9;
							end;

					1 : begin
{                swap_menu(25,5,26);}
								consultar_client
							end;


					2 : begin
								swap_menu(25,5,26);
								repeat
									blackout(1,2,80,24);
									opcion:=client_menu;
									case opcion of
										1 : new_cliente;
										2 : modif_client;
										3 : borrar_cliente;
										4 : facturar_client;
										5 : listar_client;
										0 : swap_menu(25,5,26)
									end;
								until (opcion=0);
								opcion:=1
							end;


					3 : begin
								swap_menu(25,5,26);
								repeat
									blackout(1,2,80,24);
									opcion:=dispatch_menu;
									case opcion of
										1 : consulta_albaran;
										2 : if (ini.permit) then new_albaran
													else error(21);
										3 : modif_albaran;
										4 : borrar_albaran;
										5 : archivar;
										0 : swap_menu(25,5,26)
									end;
								until (opcion=0);
								opcion:=1
							end;


					4 : begin
								swap_menu(25,5,26);
								repeat
									blackout(1,2,80,24);
									opcion:=messager_menu;
									case opcion of
										1 : consulta_mensajero;
										2 : new_mensajero;
										3 : modif_mensajero;
										4 : borrar_mensajero;
										5 : fact_mensajero;
										6 : listar_mensajeros;
										0 : swap_menu(24,5,28)
									end;
								until (opcion=0);
								opcion:=1
							end;


					5 : begin
								swap_menu(25,5,26);
								repeat
									blackout(1,2,80,24);
									opcion:=dealer_menu;
									case opcion of
										1 : consulta_comercial;
										2 : new_comercial;
										3 : modif_comercial;
										4 : borrar_comercial;
										5 : fact_comercial;
										6 : listar_comerciales;
										0 : swap_menu(24,5,28)
									end;
								until (opcion=0);
								opcion:=1
							end;


					7 : begin
								swap_menu(25,5,26);
								repeat
									blackout(1,2,80,24);
									opcion:=stats_menu;
									case opcion of
										1 : num_stats(1);
										2 : num_stats(2);
										3 : comp_stats(1);
										(*4 : comp_stats(2);*)
										4 : num_stats(3);
										0 : swap_menu(26,5,24)
									end;
								until (opcion=0);
								opcion:=1
							end;


					8 : configure;


					6 : begin
								swap_menu(25,5,26);
								repeat
									blackout(1,2,80,24);
									opcion:=fact_menu;
									case opcion of
										1 : consultar_factura;
										2 :{ modif_factura;
										3 :} borrar_factura;
										0 : swap_menu(24,5,27)
									end;
								until (opcion=0);
								opcion:=1
							end;

				end
			end;

		textcolor(7);
		clrscr
	end;

end.