(****************************************************************************)
(****************************************************************************)
(*                                                                          *)
(*                                                                          *)
(*                           SOCIOS ACTE 1.0                                *)
(*                       ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ                           *)
(*                                                                          *)
(*    Autor  : Argos (Iv n Gonz lez Angullo)                                *)
(*                                                                          *)
(*    Unidad : "GRAFICOS"                                                   *)
(*                                                                          *)
(*    Fecha  : 28/3/1997                                                    *)
(*                                                                          *)
(*    Descripcion : Definiciones de Tipos y Variables del Programa.         *)
(*                                                                          *)
(*    Observacion : Hay que pulirlo mucho a£n....  :-((                     *)
(*                                                                          *)
(****************************************************************************)
(****************************************************************************)



unit graficos;

interface

	uses defs;

	procedure gettext (inix,iniy,finx,finy:byte; var buffer:videomatrix);
	procedure puttext (inix,iniy,finx,finy:byte; var buffer:videomatrix);
	procedure blackout (inix,iniy,finx,finy:byte);
	procedure write_msg (msg:string);
	procedure lowbar (back:string);
	procedure bars;
{	procedure swap_menu (inicio,y,len:byte);
}	procedure write_n_digits (code,n:byte);
	procedure write_right(code:longint;end_x:byte);
	procedure write_left(code:longint; lengt:byte);
	procedure recuadro (x,y,ancho,alto:byte);
	procedure recuadro_socio (x,y:byte);
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
						buffer[a]:=pantalla[i];
						inc(a);
						inc(i);
					end;
				inc(iniy)
			end
	end;



(* Escribe en un recuadro de la pantalla una videomatrix *)

	procedure puttext;
	var
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
						pantalla[i]:=buffer[a];
						inc(a);
						inc(i);
					end;
				inc(iniy)
			end
	end;



(* Escribe un string en la £ltima l¡nea de la pantalla *)

	procedure escribe (cad : string; color : byte);
	var
		i,j        : word;
	begin
		j:=1;
		i:=2*wherex+3839;
		while j<=length(cad) do
			begin
				pantalla[i]:=ord(cad[j]);
				inc(i);
				pantalla[i]:=color;
				inc(i);
				inc(j)
			end;
		gotoxy(wherex+length(cad),25);
	end;



(* Borra un recuadro en pantalla *)

	procedure blackout (inix, iniy, finx, finy : byte);
	var
		i,j:word;
	begin
		while (iniy<=finy) do
			begin
				i:=2*inix+160*iniy-161;
				j:=2*finx+160*iniy-161;
				while (i<=j) do
					begin
						pantalla[i]:=32;
						inc(i);
						pantalla[i]:=0;
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



(* Escribe la funci¢n que realiza la tecla Esc.(La pone en la barra de abajo *)

	procedure lowbar ( back:string );
	const eskey='  Esc - ';
	begin
		while length(back)<57 do back:=back+' ';
		gotoxy(1,25);
		escribe(eskey,yellow_on_blue);
		escribe(back,white_on_blue);
		gotoxy(60,25);
		escribe('(c) SIGNUM Tech. 1997',cyan_on_blue);
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
		write('   GESTIONAcTE  1.0                                   ');
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


(* Escribe una cifra pegada a la izquierda de un recuadro *)
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
		write('Ú');
		gotoxy(x+ancho-1,y);
		write('¿');
		gotoxy(x,y+alto-1);
		write('À');
		gotoxy(x+ancho-1,y+alto-1);
		write('Ù');
		for k:=x+1 to x+ancho-2 do
			begin
				gotoxy(k,y); write('Ä');
				gotoxy(k,y+alto-1); write('Ä');
			end;
		for k:=y+1 to y+alto-2 do
			begin
				gotoxy(x,k); write('³');
				gotoxy(x+ancho-1,k); write('³');
			end
	end;



(* Dibuja el patr¢n de inserci¢n de socios, pos 3,2 *)
	procedure recuadro_socio (x, y : byte);
	begin
		textcolor(11);
		textbackground(black);
		inc(x);
		gotoxy(x,y+1);
		write('Nombre    :');
		gotoxy(x,y+2);
		write('D.N.I.    :          Fecha de Nacimiento:  /  /  ');
		gotoxy(x,y+4);
		write('Direcci¢n ');
		gotoxy(x,y+5);
		write('Calle     :');
		gotoxy(x,y+6);
		write('N£mero    :     Piso:    Letra:   C.Postal:');
		gotoxy(x,y+7);
		write('Localidad :');
		gotoxy(x,y+8);
		write('Provincia :                       Tel‚fono:');
		gotoxy(x,y+10);
		write('Direcci¢n Familiar');
		gotoxy(x,y+11);
		write('Calle     :');
		gotoxy(x,y+12);
		write('N£mero    :     Piso:    Letra:   C.Postal:');
		gotoxy(x,y+13);
		write('Localidad :');
		gotoxy(x,y+14);
		write('Provincia :                       Tel‚fono:');
		gotoxy(x,y+16);
		write('Saldo     :');
		gotoxy(x,y+17);
		write('Obvnes.   :');
		dec(x);
		dec(x);
		recuadro(x,y,53,21);
		textcolor(lightgray);
		cursor_off
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
		write('ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»');             {// 25;;;;;;;_)))))))))}
		gotoxy(25,11);
		write('º                        º');
		gotoxy(25,12);
		write('º                        º');
		gotoxy(25,13);
		write('º                        º');
		gotoxy(25,14);
		write('ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼');
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
						gotoxy(34,11);
						write('SOCIOS');
						gotoxy(31,13);
						write('NO DISPONIBLES');
					end;

			2 : begin
						gotoxy(34,11);
						write('SOCIO');
						gotoxy(32,13);
						write('YA EXISTENTE');
					end;

			3 : begin
						gotoxy(34,11);
						write('SOCIO');
						gotoxy(32,13);
						write('INEXISTENTE');
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


		end; {Case}

		write_msg('Pulse cualquier tecla');
		ch:=readkey;
		puttext(25,10,56,15,buffer);
		lowbar('Salir')
	end;



end.