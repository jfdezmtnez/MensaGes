unit graficos;

interface

  uses defs;

	procedure gettext (inix,iniy,finx,finy:byte; var buffer:videomatrix);
	procedure puttext (inix,iniy,finx,finy:byte; var buffer:videomatrix);
	procedure blackout (inix,iniy,finx,finy:byte);
	procedure write_msg (msg:string);
	procedure lowbar (back:string);
	procedure bars;
	procedure swap_menu (inicio,y,len:byte);
	procedure write_n_digits (code,n:byte);
	procedure write_right(code:longint;end_x:byte);
	procedure write_left(code:longint; lengt:byte);
	procedure recuadro (x,y,ancho,alto:byte);
	procedure recuadro_cliente (x,y:byte);
	procedure recuadro_tarifas_cliente (x,y:byte);
	procedure recuadro_casillas (x,y:byte);
	procedure recuadro_albaran (x,y:byte);
	procedure recuadro_comercial (x,y:byte);
	procedure recuadro_mensajero (x,y:byte);
	procedure recuadro_tarifas_mensajero (x,y:byte);
	procedure recuadro_facturas (x,y:byte);
	procedure recuadro_factura_mensajero(x,y:byte);
	procedure recuadro_factura_comercial(x,y:byte);
	procedure recuadro_factura_general(x,y:byte);
	procedure recuadro_pie_factura(x,y:byte);
	procedure recuadro_cabecera_albaranes(x,y:byte);
	function hoy:string;
	procedure error (mode:byte);


implementation


  USES Crt,common;


	CONST
		yellow_on_blue =30;
		white_on_blue  =31;
		cyan_on_blue   =19;


(* Almacena en una videomatrix un recuadro de la pantalla *)

  procedure gettext;
	var
		screen_image : videomatrix absolute($B800):$0000;
		i,j : word;
		a : word;
	begin
		 a:=1;
		while (iniy<=finy) do
			begin
				i:=2*inix+160*iniy-161;
				j:=2*finx+160*iniy-161;
				while (i<=j) do
					begin
						buffer[a]:=screen_image[i];
						inc(a);
						inc(i);
					end;
				inc(iniy)
			end
	end;



(* Escribe en un recuadro de la pantalla una videomatrix *)

  procedure puttext;
	var
		screen_output : videomatrix absolute($B800):$0000;
		i,j : word;
		a : word;
	begin
		a:=1;
		while (iniy<finy) do
			begin
				i:=2*inix+160*iniy-161;
				j:=2*finx+160*iniy-161;
				while (i<=j) do
					begin
						screen_output[i]:=buffer[a];
						inc(a);
						inc(i);
					end;
				inc(iniy)
			end
	end;



(* Escribe un string en la �ltima l�nea de la pantalla *)

	procedure escribe (cad : string; color : byte);
	var
		scr_output : videomatrix absolute($B800):$0000;
		i,j        : word;
	begin
		j:=1;
		i:=2*wherex+3839;
		while j<=length(cad) do
			begin
				scr_output[i]:=ord(cad[j]);
				inc(i);
				scr_output[i]:=color;
				inc(i);
				inc(j)
			end;
		gotoxy(wherex+length(cad),25);
	end;



(* Borra un recuadro en pantalla *)

	procedure blackout (inix, iniy, finx, finy : byte);
	VAR
		screen_output:videomatrix absolute($B800):$0000;
		i,j:word;
	begin
		while (iniy<=finy) do
			begin
				i:=2*inix+160*iniy-161;
				j:=2*finx+160*iniy-161;
				while (i<=j) do
					begin
						screen_output[i]:=32;
						inc(i);
						screen_output[i]:=0;
						inc(i)
					end;
				inc(iniy)
			end
	end;



(* Escribe un mensaje en la barra de estado *)

	procedure write_msg ( msg:string );
	begin
		while length(msg)<57 do msg:=msg+' ';
		gotoxy(2,25);
		escribe(msg,yellow_on_blue);
		textcolor(Lightgray);
		textbackground(black);
		cursor_off
	end;



(* Escribe la funci�n que realiza la tecla Esc. *)

	procedure lowbar ( back:string );
	const eskey='  Esc - ';
	begin
		while length(back)<57 do back:=back+' ';
		gotoxy(1,25);
		escribe(eskey,yellow_on_blue);
		escribe(back,white_on_blue);
		gotoxy(60,25);
		escribe('(c) SIGNUM Tech. 1996',cyan_on_blue);
		textcolor(lightgray);
		textbackground(black);
		cursor_off
	end;



(* Escribe las dos barras de estado e inicializa la pantalla *)

	procedure bars;
	var mes : string[11]; i:byte;
	begin
		DirectVideo:=true;
		CheckSnow:=false;
		cursor_off;
		textbackground(blue);
		textcolor(white);
			for i:=1 to 80 do
			begin
					 gotoxy(i,1);
					 write(' ');
			end;
		gotoxy(1,1);
		write('     MENSA-GES  1.0                                   ');
		gotoxy(50,1);
		write(fecha_sistema.day,' de ');
		case fecha_sistema.month of
			1 : mes:='Enero';
			2 : mes:='Febrero';
			3 : mes:='Marzo';
			4 : mes:='Abril';
			5 : mes:='Mayo';
			6 : mes:='Junio';
			7 : mes:='Julio';
			8 : mes:='Agosto';
			9 : mes:='Septiembre';
			10: mes:='Octubre';
			11: mes:='Noviembre';
			12: mes:='Diciembre';
		end;
		write(mes,' de ',fecha_sistema.year);
		lowbar('Salir');
	end;



(* Animacioncilla para cambiar de menu *)

	procedure swap_menu (inicio, y, len : byte);
	var x:byte;
	begin
		blackout(1,6,80,23);
		textcolor(11);
		for x:=0 to 32-inicio do
			begin
				gotoxy(inicio+x,y);
				write(' �����');
				gotoxy(inicio+len-x-6,y);
				write('�۲�� ');
				cursor_off;
				delay(15);
			end;
		gotoxy(33,y);
		write(' ����۲�� ');
		cursor_off;
		delay(15);
		gotoxy(34,y);
		write(' ������ ');
		cursor_off;
		delay(15);
		gotoxy(35,y);
		write(' ���� ');
		cursor_off;
		delay(15);
		gotoxy(36,y);
		write(' �� ');
		cursor_off;
		delay(15);
		gotoxy(37,y);
		write('  ');
		cursor_off;
		delay(15);
		textcolor(lightgray)
	end;




{ comentario: escribe una cifra (thinking) con tantos digitos como mandeeee }
(* Nosotros nos entendemos *)
	procedure write_n_digits (code,n:byte);
	var cad:string;
	begin
		str(code,cad);
		while length(cad)<n do cad:='0'+cad;
		write(cad);
	end;

	
(* Escribe una cifra pegada a la derecha de un recuadro *)
	procedure write_right;
	var cad:string;l:byte;
	begin
		str(code,cad);
		l:=end_x-wherex;
		while length(cad)<l do cad:=' '+cad;
		write(cad)
	end;


	procedure write_left;
	var cad:string;
	begin
		str(code,cad);
		while length(cad)<lengt do cad:=cad+' ';
		write(cad)
	end;


(* Dibuja una ventana normal y corriente, cuadriculada *)

	procedure recuadro (x, y, ancho, alto : byte);
	var k:word;
	begin
		gotoxy(x,y);
		write('�');
		gotoxy(x+ancho-1,y);
		write('�');
		gotoxy(x,y+alto-1);
		write('�');
		gotoxy(x+ancho-1,y+alto-1);
		write('�');
		for k:=x+1 to x+ancho-2 do
			begin
				gotoxy(k,y); write('�');
				gotoxy(k,y+alto-1); write('�');
			end;
		for k:=y+1 to y+alto-2 do
			begin
				gotoxy(x,k); write('�');
				gotoxy(x+ancho-1,k); write('�');
			end
	end;



(* Dibuja el patr�n de inserci�n de clientes, pos 3,2 *)

	procedure recuadro_cliente (x, y : byte);
	begin
		textcolor(11);
		textbackground(black);
		inc(x);
		gotoxy(x,y+1);
		write('Telefono  :');
		gotoxy(x,y+3);
		write('Nombre    :');
		gotoxy(x,y+5);
		write('Calle     :');
		gotoxy(x,y+6);
		write('N�mero    :     Piso:     Letra:   C.Postal:');
		gotoxy(x,y+7);
		write('Localidad :');
		gotoxy(x,y+8);
		write('Provincia :');
		gotoxy(x,y+10);
		write('C.I.F.    :            Comer.:    Desc.:    R.E.: ');
		gotoxy(x,y+11);
		write('F. de Pago:');
		gotoxy(x,y+12);
		write('Cobrar Reembolso:');
		gotoxy(x,y+14);
		write('Obvnes.   :');
		dec(x);
		recuadro(x,y,53,17);
		textcolor(lightgray);
		cursor_off
	end;



(* Dibuja el cuadro de inserci�n de tarifas, pos 15,12 *)

	procedure recuadro_tarifas_cliente (x, y : byte);
	var k:word;
	begin
		gotoxy(x,y);
		textcolor(11);
		textbackground(BLACK);
		write('���������������������������������������������������������Ŀ');
		gotoxy(x,y+1);
		write('�Tipo � Descripci�n � Precio � Ex.Peso � Ex.Tmpo � Ex. Km �');
		gotoxy(x,y+2);
		write('���������������������������������������������������������Ĵ');
		for k:=y+3 to y+11 do
			begin
				gotoxy(x,k);
				write('�     �             �        �         �         �        �');
			end;
		gotoxy(x,y+12);
		write('�����������������������������������������������������������');
		for k:=0 to 8 do
			begin
				gotoxy(x+2,y+3+k);
				write_n_digits(k+1,2);
			end;
		textcolor(lightgray);
		cursor_off
	end;



(* Dibuja el patr�n de inserci�n de las casillas de albaranes, pos 3,8 *)

	procedure recuadro_casillas (x, y : byte);
	begin
		textcolor(11);
		gotoxy(x,y);
		write('�����������Ŀ');
		gotoxy(x,y+1);
		write('�CASILLA    �');
		gotoxy(x,y+2);
		write('���������������������������������������������������������������������Ŀ');
		gotoxy(x,y+3);
		write('�Men.:   �Sv.C.:   �Sv.M.:   �Peso:     �Tiempo:    �Km:     �Fact.:  �');
		gotoxy(x,y+4);
		write('�����������������������������������������������������������������������');
		gotoxy(x,y+5);
		write('�Nombre   :                                         �');
		gotoxy(x,y+6);
		write('��������������������������������������������������������������Ŀ');
		gotoxy(x,y+7);
		write('�Direcci�n:                                         �Hora:     �');
		gotoxy(x,y+8);
		write('����������������������������������������������������������������');
		gotoxy(x,y+9);
		write('�Reembolso:          �');
		gotoxy(x,y+10);
		write('����������������������');
		textcolor(lightgray);
		cursor_off
	end;



(* Dibuja el patr�n de inserci�n de albaranes, pos 3,4 *)

	procedure recuadro_albaran (x, y : byte);
	begin
		textcolor(11);
		gotoxy(x,y);
		write('��������������������������������������������������������������Ŀ');
		gotoxy(x,y+1);
		write('�Tfno.:          �Fecha:    /  /    �Portes:     �Cod:         �');
		gotoxy(x,y+2);
		write('��������������������������������������������������������������Ĵ');
		gotoxy(x+14,y+3);
		write('�Obvnes.:                                        �');
		gotoxy(x+14,y+4);
		write('�                                                �');
		gotoxy(x+14,y+5);
		write('��������������������������������������������������');
		textcolor(lightgray);
		cursor_off
	end;



(* Dibuja el patr�n de inserci�n de comerciales,  pos 3,3 *)

	procedure recuadro_comercial (x, y : byte);
	begin
		textcolor(11);
		inc(x);
		gotoxy(x,y+1);
		write('Telefono  :                Codigo:');
		gotoxy(x,y+3);
		write('Nombre    :');
		gotoxy(x,y+5);
		write('Calle     :');
		gotoxy(x,y+6);
		write('N�mero    :     Piso:     Letra:   C.Postal:');
		gotoxy(x,y+7);
		write('Localidad :');
		gotoxy(x,y+8);
		write('Provincia :');
		gotoxy(x,y+10);
		write('Ex.Laboral:');
		gotoxy(x,y+12);
		write('Estudios  :');
		gotoxy(x,y+14);
		write('C.I.F.    :                      Porcentaje:');
		gotoxy(x,y+16);
		write('Obvnes.   :');
		dec(x);
		recuadro(x,y,53,19);
		textcolor(lightgray);
		cursor_off
	end;



(* Dibuja el patr�n de inserci�n de mensajeros, pos 3,3 *)

	procedure recuadro_mensajero (x, y : byte);
	begin
		textcolor(11);
		inc(x);
		gotoxy(x,y+1);
		write('Telefono  :                Codigo:');
		gotoxy(x,y+3);
		write('Nombre    :');
		gotoxy(x,y+5);
		write('Calle     :');
		gotoxy(x,y+6);
		write('N�mero    :     Piso:     Letra:   C.Postal:');
		gotoxy(x,y+7);
		write('Localidad :');
		gotoxy(x,y+8);
		write('Provincia :');
		gotoxy(x,y+10);
		write('C.I.F.    :            E.Civil:   S.Mil.:   Veh.: ');
		gotoxy(x,y+12);
		write('Obvnes.   :');
		dec(x);
		recuadro(x,y,53,15);
		textcolor(7);
		cursor_off
	end;



(* Dibuja el cuadro de inserci�n de las tarifas de los mensajeros, pos 3,5 *)

	procedure recuadro_tarifas_mensajero (x, y : byte);
	var k : byte;
	begin
		textcolor(11);
		gotoxy(x,y);
		write('���������������������������������������������������������Ŀ');
		gotoxy(x,y+1);
		write('�Tipo � Descripci�n � Precio � Ex.Peso � Ex.Tmpo � Ex. Km �');
		gotoxy(x,y+2);
		write('���������������������������������������������������������Ĵ');
		for k:=y+3 to y+10 do
			begin
				gotoxy(x,k);
				write('�     �             �        �         �         �        �');
			end;
		gotoxy(x,y+11);
		write('�����������������������������������������������������������');
		for k:=0 to 7 do
			begin
				gotoxy(x+2,y+3+k);
				write_n_digits(k+1,2);
			end;
		textcolor(7);
		cursor_off
	end;




(* Dibuja el cuadro para la consulta de facturas, pos 3,2 *)

	procedure recuadro_facturas (x, y : byte);
	var k : byte;
	begin
		textcolor(11);
		gotoxy(x,y);
		write('���������������������������������������������������������������Ŀ');
		gotoxy(x,y+1);
		write('�Cod. �Fecha     �Servicios                            �Subtotal�');
		gotoxy(x,y+2);
		write('���������������������������������������������������������������Ĵ');
		for k:=y+3 to y+18 do
			begin
				gotoxy(x,k);
				write('�     �          �                                     �        �');
			end;
		gotoxy(x,y+18);
		write('���������������������������������������������������������������Ĵ');
		gotoxy(x,y+19);
		write('�Total B.  �00% Desc.  �Base IVA  �00% IVA  �R.E.    �Total N.  �');
		gotoxy(x,y+20);
		write('���������������������������������������������������������������Ĵ');
		gotoxy(x,y+21);
		write('�          �           �          �         �        �          �');
		gotoxy(x,y+22);
		write('�����������������������������������������������������������������');
		textcolor(7);
		cursor_off
	end;



	procedure recuadro_factura_mensajero(x,y:byte);
	var
		k    : byte;
	begin
		textcolor(11);
		gotoxy(x,y);
		write('��������������������������������������������������Ŀ');
		gotoxy(x,y+1);
		write('� Cod. �                  Nombre                   �');
		gotoxy(x,y+2);
		write('��������������������������������������������������Ĵ');
		gotoxy(x,y+3);
		write('�      �                                           �');
		gotoxy(x,y+4);
		write('������Ĵ                                           �');
		gotoxy(x+7,y+5);
		write('���������������������������������������������');
		gotoxy(x,y+6);
		write('��������������������������������������������������Ŀ����������Ŀ');
		gotoxy(x,y+7);
		write('� Tipo � Precio � N�mero � Ex.P. � Tiempo � Ex. km �� Subtotal �');
		gotoxy(x,wherey+1);
		write('��������������������������������������������������Ĵ����������Ĵ');

		for k:=1 to 8 do
			begin
				gotoxy(x,wherey+1);
				write('�  0',k,'  � ');
				write_right(ini.tfas_mensajero[k].precio,wherex+6);
				write(' � x      �       �        �        ��          �');
			end;
		gotoxy(x,wherey+1);
		write('����������������������������������������������������������������');
		gotoxy(x,wherey+1);
		write('                ����������������������������������Ŀ����������ͻ');
		gotoxy(x,wherey+1);
		write('      Importes  �        �       �        �        ��          � Tot.');
		gotoxy(x,wherey+1);
		write('                ����������������������������������������������ͼ');
		textcolor(7);
		cursor_off
	end;


	procedure recuadro_factura_comercial(x,y:byte);
	begin
		textcolor(11);
		gotoxy(x,y);
		write('��������������������������������������������������Ŀ');
		gotoxy(x,y+1);
		write('� Cod. �                  Nombre                   �');
		gotoxy(x,y+2);
		write('��������������������������������������������������Ĵ');
		gotoxy(x,y+3);
		write('�      �                                           �');
		gotoxy(x,y+4);
		write('������Ĵ                                           �');
		gotoxy(x,y+5);
		write('       ���������������������������������������������');
		gotoxy(x,wherey+1);
		write('Albaranes Facturados');
		gotoxy(x+40,wherey);
		write('����������Ŀ');
		gotoxy(x+24,wherey+1);
		write('Total Facturado �          �');
		gotoxy(x+40,wherey+1);
		write('������������');
		gotoxy(x+40,wherey+1);
		write('����������Ŀ');
		gotoxy(x+34,wherey+1);
		write('Total �          � (   %)');
		gotoxy(x+40,wherey+1);
		write('������������');
		textcolor(7);
		cursor_off
	end;


(* Tres procs. para las gr�ficas de facturas *)

	procedure recuadro_factura_general;
	begin
		textcolor(11);
		gotoxy(x,y);
		write('��������������������������������������������������������������Ŀ');
		gotoxy(x,y+1);
		write('�Tfno.:          �Fecha:    /  /    �Pagado:     �N�:          �');
		gotoxy(x,y+2);
		write('��������������������������������������������������������������Ĵ');
		gotoxy(x+14,y+3);
		write('�Obvnes.:                                        �');
		gotoxy(x+14,y+4);
		write('�                                                �');
		gotoxy(x,y+5);
		write('��������������������������������������������������������������Ĵ');
		gotoxy(x,y+6);
		write('�Fecha pago:    /  /     �Tipo de pago:                        �');
		gotoxy(x,y+7);
		write('����������������������������������������������������������������');
		textcolor(lightgray);
		cursor_off;
	end;

	procedure recuadro_pie_factura;
	begin
		textcolor(11);
		gotoxy(x,y);
		textcolor(WHITE);
		highvideo;
		write(' T.bruto   Des.  IVA   B.IVA     B.desc.   R.E.      T.neto');
		gotoxy(x,y+1);
		textcolor(11);
		write('���������������������������������������������������Ŀ����������ͻ');
		gotoxy(x,y+2);
		write('�         �   % �     �         �         �         ��          �');
		gotoxy(x,y+3);
		write('���������������������������������������������������������������ͼ');
		textcolor(7);
		cursor_off
	end;

	procedure recuadro_cabecera_albaranes;
	begin
		textcolor(11);
		gotoxy(x,y);
		writeln('Cod.    Fecha        Servicio/s                             Subtotal');
		gotoxy(x,y+1);
		writeln('��������������������������������������������������������������������');
		textcolor(7);
		cursor_off;
	end;

(* Devuelve un encabezamiento de fecha y lugar *)
	function hoy;
	var
		temp,aux:string;
	begin
		temp:='Vigo ';
		str(fecha_sistema.day,aux);
		if length(aux)<2 then aux:=' '+aux;
		temp:=temp+aux+' de ';
		case fecha_sistema.month of
			1 : aux:='  Enero   de  ';
			2 : aux:=' Febrero  de  ';
			3 : aux:='  Marzo   de  ';
			4 : aux:='  Abril   de  ';
			5 : aux:='   Mayo   de  ';
			6 : aux:='  Junio   de  ';
			7 : aux:='  Julio   de  ';
			8 : aux:='  Agosto  de  ';
			9 : aux:='Septiembre de ';
			10: aux:='  Octubre  de ';
			11: aux:=' Noviembre de ';
			12: aux:=' Diciembre de '
		end;    
		temp:=temp+aux;
		str(fecha_sistema.year,aux);
		temp:=temp+aux;
		hoy:=temp
	end;


(* Saca los distintos mensajes de error que se dan *)

	procedure error (mode : byte);
	var
		buffer : videomatrix;
		ch     : char;

	begin
		gettext(25,10,56,15,buffer);
		gotoxy(25,10);
		textcolor(WHITE);
		textbackground(RED);
		write('������������������������ͻ');             {// 25;;;;;;;_)))))))))}
		gotoxy(25,11);
		write('�                        �');
		gotoxy(25,12);
		write('�                        �');
		gotoxy(25,13);
		write('�                        �');
		gotoxy(25,14);
		write('������������������������ͼ');
{         // 27 espacios escribibles}

		textcolor(YELLOW);
		case mode of

			0 : begin
						gotoxy(30,11);
						write('ACCESO A DISCO');
						gotoxy(33,13);
						write('DENEGADO');
					end;

			1 : begin
						gotoxy(33,11);
						write('CLIENTES');
						gotoxy(31,13);
						write('NO DISPONIBLES');
					end;

			2 : begin
						gotoxy(34,11);
						write('CLIENTE');
						gotoxy(32,13);
						write('YA EXISTENTE');
					end;

			3 : begin
						gotoxy(34,11);
						write('CLIENTE');
						gotoxy(32,13);
						write('INEXISTENTE');
					end;

			4 : begin
						gotoxy(32,11);
						write('COMERCIALES');
						gotoxy(31,13);
						write('NO DISPONIBLES');
					end;

			5 : begin
						gotoxy(34,11);
						write('COMERCIAL');
						gotoxy(32,13);
						write('YA EXISTENTE');
					end;

			6 : begin
						gotoxy(34,11);
						write('COMERCIAL');
						gotoxy(33,13);
						write('INEXISTENTE');
					end;

			7 : begin
						gotoxy(32,11);
						write('MENSAJEROS');
						gotoxy(31,13);
						write('NO DISPONIBLES');
					end;

			8 : begin
						gotoxy(33,11);
						write('MENSAJERO');
						gotoxy(32,13);
						write('YA EXISTENTE');
					end;

			9 : begin
						gotoxy(33,11);
						write('MENSAJERO');
						gotoxy(32,13);
						write('INEXISTENTE');
					end;

			10: begin
						gotoxy(33,11);
						write('ALBARANES');
						gotoxy(31,13);
						write('NO DISPONIBLES');
					end;

			11: begin
						gotoxy(34,11);
						write('ALBARAN');
						gotoxy(32,13);
						write('YA EXISTENTE');
					end;

			12: begin
						gotoxy(34,11);
						write('ALBARAN');
						gotoxy(33,13);
						write('INEXISTENTE');
					end;

			13: begin
						gotoxy(32,11);
						write('ESTADISTICAS');
						gotoxy(31,13);
						write('NO DISPONIBLES');
					end;

			14 : begin
						 gotoxy(35,11);
						 write('PAPEL');
						 gotoxy(31,13);
						 write('NO DISPONIBLE')
					 end;

			15 : begin
						 gotoxy(33,11);
						 write('IMPRESORA');
						 gotoxy(31,13);
						 write('NO DISPONIBLE')
					 end;

			16 : begin
						 gotoxy(33,11);
						 write('IMPRESORA');
						 gotoxy(33,13);
						 write('OCUPADA')
					 end;

			20 : begin
							gotoxy(35,11);
							write('DISCO');
							gotoxy(32,13);
							write('INCORRECTO');
					 end;

			21 : begin
							gotoxy(33,11);
							write('FICHERO');
							gotoxy(33,13);
							write('COMPLETO');
					 end;

			22 : begin
							gotoxy(33,11);
							write('FACTURA');
							gotoxy(33,13);
							write('INVALIDA');
					 end;

			23 : begin
							gotoxy(34,11);
							write('FACTURAS');
							gotoxy(32,13);
							write('NO DISPONIBLES');
					 end;

			24 : begin
							gotoxy(34,11);
							write('FACTURA');
							gotoxy(32,13);
							write('NO DISPONIBLE');
					 end;

		end;

		write_msg('Pulse cualquier tecla');
		ch:=readkey;
		puttext(25,10,56,15,buffer);
		lowbar('Salir')
	end;



end.
