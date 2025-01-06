unit common;

interface

uses crt,windos,defs;

type

	str_3=string[3]; { este string contiene la tecla pulsada }

	t_estado=record { registro de teclas especiales pulsadas }

	{ bits por orden, 7 6 5 4 1 0 7 3 2 1 0 }

					 insert:boolean;
					 bloqmays:boolean;
					 bloqnum:boolean;
					 bloqdespl:boolean;
					 lshift:boolean;
					 rshift:boolean;
					 petsis:boolean;
					 ralt:boolean;
					 rcontrol:boolean;
					 lalt:boolean;
					 lcontrol:boolean;

				 end;

{	 procedure dar_alta_albaran (fesha:t_date; codigo:t_codigo);
	 function comprueba_albaran (cod:t_codigo; fi:str_11):boolean;
}
	function trim (cad:string):string;
{	function trim_real (cad:string):string;
}

	function get_key (var p_ascii:char; { codigo ascii }
			 var p_scancode:byte; { codigo de exploracion }
			 var p_funcion:byte; { tecla de funcion pulsada }
			 var p_estado:t_estado; { estado bloqmays etc. }
			 var p_teclas:str_3):boolean; {tecla pulsada tab etc. }

	procedure dellete (var str:string; pos,longitud:byte);
	function get_field (VAR campo:t_nodo_dato):byte;
	procedure put_string (campo:t_nodo_dato; modo:byte);
	procedure inserta (var str:string; c:char; pos,longitud:byte);
	function si_no (predefinida:char):boolean;
{	function transform (fecha:t_date):str_11;
}	procedure put_campo (campo:t_nodo_dato; fore:byte);
	procedure put_inverse(inix,iniy,finx,finy:byte);
	procedure cursor_off;
	procedure cursor_solid;
	procedure cursor_line;
	function str_to_long(cad:string):longint;
	procedure increase(var fecha : t_date);
	procedure decrease(var fecha : t_date);
	function fecha_numero(d,m,a:integer):longint;
	procedure cad_fecha(cad:string; var d,m,a:integer);
	procedure save_cfg;
	procedure ordena_alfab_ndx;
	procedure ordena_dni_ndx;


implementation



{ Incrementa una t_date en un mes.. o a¤o si procede..}
procedure increase(var fecha : t_date);
begin
	if fecha.month=12 then
		begin
			fecha.month:=1;
			inc(fecha.year)
		end
		else inc(fecha.month)
end;



{ Decrementa una t_date en un mes.. }
procedure decrease(var fecha : t_date);
begin
	if fecha.month=1 then
		begin
			fecha.month:=12;
			dec(fecha.year)
		end
		else dec(fecha.month)
end;



{ Pone en Inverso el fondo de un recuadro de la pantalla }
procedure put_inverse;
var
	i,j : word;
begin
	while (iniy<=finy) do
		begin
			i:=2*inix+160*iniy-161;
			j:=2*finx+160*iniy-161;
			while (i<=j) do
				begin
					if (i mod 2)=0 then pantalla[i]:=27;
					inc(i);
				end;
			inc(iniy)
		end
end;


{ Convierte un string en longint.. }
function str_to_long;
var
	 total:longint;
	 i,j:word;

function pot_10(pot:byte):longint;
var
	 total:longint;
	 i:word;
begin
		 total:=1;
		 if pot=0 then total:=1 else
				for i:=1 to pot do total:=total*10;
		 pot_10:=total;
end;

begin
		 j:=length(cad);
		 while cad[j]=' ' do dec(j);
		 total:=0;

		 i:=j;
		 while (cad[i] in ['0'..'9']) and (i>=1) do
		 begin
					total:=total+pot_10(j-i)*(ord(cad[i])-48);
					dec(i);
		 end;

		 if (i<>0) and (cad[i]<>#32) then i:=i;
		 str_to_long:=total;
end;




{ Muy compleja (Te alabamos Fran..). Recoje una tecla pulsada por pantalla
Teniendo en cuenta el ESTADO DEL TECLADO (Shifts., Alts., et cetera..}
function get_key;

begin

		 get_key:=false;
		 p_funcion:=13;

		 regs.ax:=0;
		 regs.ah:=$11;
		 intr($16,regs); { int 0x16 serv 0x11 comprobar pulsacion }

		 { si hay alguna tecla en el buffer la recoge }
		 { si no, simplemente devuelve el estado de las teclas especiales }

		 if (regs.flags and 64)=0 then
		 begin
				 { recoge la pulsaci¢n }

				 p_teclas:='';
				 regs.ax:=0;
				 regs.ah:=$10;
				 intr($16,regs); { interrupci¢n 0x16 servicio 0x10 leer tecla }
				 p_ascii:=chr(regs.al);
				 p_scancode:=regs.ah;

				 {comprobacion de teclas}

				 if ((regs.al=224) and (p_scancode=$48)) then p_teclas:='up'; { up }
				 if ((regs.al=224) and (p_scancode=$50)) then p_teclas:='dow'; { down }
				 if ((regs.al=224) and (p_scancode=$4b)) then p_teclas:='lef'; { left }
				 if ((regs.al=224) and (p_scancode=$4d)) then p_teclas:='rig'; { righ }
				 if ((regs.al=$0d) and (p_scancode=$1c)) then p_teclas:='ret'; { retu }
				 if ((regs.al=$0d) and (p_scancode=224)) then p_teclas:='ret'; { retu }
				 if ((regs.al=224) and (p_scancode=$53)) then p_teclas:='del'; { delete }
				 if ((regs.al=$08) and (p_scancode=$0e)) then p_teclas:='bks'; { backspace }
				 if ((regs.al=$09) and (p_scancode=$0f)) then p_teclas:='tab'; { tab }
				 if ((regs.al=$1b) and (p_scancode=$01)) then
				 begin
					 p_teclas:='esc';
					 p_funcion:=0;
				 end; { esc }
				 if ((regs.al=224) and (p_scancode=$52)) then p_teclas:='ins'; { ins        }
				 if ((regs.al=224) and (p_scancode=$47)) then p_teclas:='ini'; { ini        }
				 if ((regs.al=224) and (p_scancode=$4f)) then p_teclas:='end'; { end        }
				 if ((regs.al=0) and (p_scancode=$0f)) then p_teclas:='stb'; { shift+tab}
				 if ((regs.al=224) and (p_scancode=73)) then p_teclas:='pup'; { pgup   }
				 if ((regs.al=224) and (p_scancode=81)) then p_teclas:='pdw'; { pgdown }


				 { function keys }

				 if ((regs.al=0) and (p_scancode=$3b)) then p_funcion:=1;
				 if ((regs.al=0) and (p_scancode=$3c)) then p_funcion:=2;
				 if ((regs.al=0) and (p_scancode=$3d)) then p_funcion:=3;
				 if ((regs.al=0) and (p_scancode=$3e)) then p_funcion:=4;
				 if ((regs.al=0) and (p_scancode=$3f)) then p_funcion:=5;
				 if ((regs.al=0) and (p_scancode=$40)) then p_funcion:=6;
				 if ((regs.al=0) and (p_scancode=$41)) then p_funcion:=7;
				 if ((regs.al=0) and (p_scancode=$42)) then p_funcion:=8;
				 if ((regs.al=0) and (p_scancode=$43)) then p_funcion:=9;
				 if ((regs.al=0) and (p_scancode=$44)) then p_funcion:=10;
				 if ((regs.al=0) and (p_scancode=133)) then p_funcion:=11;
				 if ((regs.al=0) and (p_scancode=134)) then p_funcion:=12;

				 p_ascii:=chr(regs.al);

				 get_key:=true;

		end;


		with p_estado do
		begin
				insert:=false; { pone a 0 los flags }
				bloqnum:=false;
				bloqmays:=false;
				bloqdespl:=false;
				lshift:=false;
				rshift:=false;
				petsis:=false;
				ralt:=false;
				rcontrol:=false;
				lalt:=false;
				lcontrol:=false;
		end;


		regs.ah:=$12;
		intr($16,regs); { int 0x16 serv 0x12 comprobacion teclas especiales }

		{ AL estado del teclado 84, AH 102 teclas }

		with p_estado do
		begin
				if ((regs.al and 128)<>0) then insert:=true; { devuelve los activados }
				if ((regs.al and 32)<>0) then bloqnum:=true;
				if ((regs.al and 64)<>0) then bloqmays:=true;
				if ((regs.al and 16)<>0) then bloqdespl:=true;
				if ((regs.al and 2)<>0) then lshift:=true;
				if ((regs.al and 1)<>0) then rshift:=true;
				if ((regs.ah and 128)<>0) then petsis:=true;
				if ((regs.ah and 8)<>0) then ralt:=true;
				if ((regs.ah and 4)<>0) then rcontrol:=true;
				if ((regs.ah and 2)<>0) then lalt:=true;
				if ((regs.ah and 1)<>0) then lcontrol:=true;
		end;


end;


(* Ya no nos hace falta.. :-((

{ con un mes y un a¤o devuelve el nombre del fichero de albaranes
correspondiente }

function transform;
var
	 year,month:string;

begin
		 str(fecha.year,year);
		 case fecha.month of
					1:month:='ENE';
					2:month:='FEB';
					3:month:='MAR';
					4:month:='ABR';
					5:month:='MAY';
					6:month:='JUN';
					7:month:='JUL';
					8:month:='AGO';
					9:month:='SEP';
					10:month:='OCT';
					11:month:='NOV';
					12:month:='DIC';
		 end;

		 fichero:=month+year+'.ALB';

		 transform:=fichero;
end;

*)



{ Coloca un campo de datos sobre su recuadro en pantalla }
procedure put_campo;
var
	 long_linea:byte;
	 x,y,k:byte;
begin
		 long_linea:=campo.longitud div campo.lineas;
		 textcolor(fore);

		 x:=campo.ini_x;
		 y:=campo.ini_y;

		 for k:=0 to campo.longitud-1 do
		 begin
					gotoxy(x+(k mod long_linea), y+(k div long_linea));
					write(campo.dato[k+1]);
		 end;
end;



{ Quita los caRATEres no num‚ricos de un string..}
function trim;
var
	 res:string;
	 i:byte;
begin

	res:='';
	for i:=1 to length(cad) do
	 begin
		if cad[i] in ['0'..'9'] then res:=res+cad[i];
	 end;

	trim:=res;
end;


(* Creo que nos no va a valer...

{ Lo mismo con n£meros decimales tambi‚n }
function trim_real;
var
	 res:string;
	 i:byte;

begin

		 res:='';
		 for i:=1 to length(cad) do
		 begin
					if cad[i] in ['0'..'9','.'] then res:=res+cad[i];
		 end;

		 trim_real:=res;
end;

*)



{ Borra el cursor de la pantalla. Pro alguna raz¢n no lo deja en ese estado,
As¡ que cuando volvemos a escribir algo el cursor se torna visible otra vez}
procedure cursor_off;
begin
		 regs.ah:=$02;
		 regs.bh:=0;
		 regs.dl:=0;
		 regs.dh:=25;
		 intr($10,regs);
end;


{ Pone el cursor tocho ... }
procedure cursor_solid;
begin
		 regs.ah:=$01;
		 regs.ch:=0;
		 regs.cl:=13;
		 intr($10,regs);
end;


{ Cursor t¡pico de toda la vida..}
procedure cursor_line;
begin
		 regs.ah:=$01;
		 regs.ch:=12;
		 regs.cl:=13;
		 intr($10,regs);
end;


{ Escribe una cadena en un campo con los atributos de color que se le pasan.... }
procedure put_string;
var
	 long_linea:byte;
	 x,y,cont:byte;

begin
		 long_linea:=campo.longitud div campo.lineas;
		 x:=campo.ini_x;
		 y:=campo.ini_y;
		 cont:=1;

		 cursor_off;

		 if modo<>0 then textcolor(CYAN) else textcolor(WHITE);
		 if modo<>0 then textbackground(BLUE) else textbackground(BLACK);
		 if modo<>0 then highvideo else lowvideo;

		 while (cont <=campo.longitud) do
		 begin
					gotoxy(x,y);
					write(campo.dato[cont]);
					inc(x);
					if x-campo.ini_x>=long_linea then
					begin
							 x:=campo.ini_x;
							 inc(y);
					end;
					inc(cont);
		 end;
end;



{ Borra caracteres indeseados..}
procedure dellete;
var
	 tmp1,tmp2:string;
begin

	case longitud of
		1:str:='';
		else
			begin
				tmp1:=copy(str,1,pos-1);
				tmp2:=copy(str,pos+1,longitud-pos);
				str:='';
				str:=tmp1+tmp2+' '
			end
		end
end;



{ Inserta un string dentro de otro..}
procedure inserta;
var
	 tmp1,tmp2:string;
begin

	case longitud of
		1:str:=c;
			else begin
				tmp1:=copy(str,1,pos-1);
				tmp2:=copy(str,pos,longitud-pos);
				str:='';
				str:=tmp1+c+tmp2
			end
	end
end;




{ Coge un campo de pantalla (Te alabamos Fran :-000}
function get_field;
var
	 x,y:byte;
	 p:byte;
	 ins:byte;
	 long_linea:byte;
	 ascii:char;
	 scancode:byte;
	 funcion:byte;
	 estado:t_estado;
	 teclas:str_3;
	 salir:boolean;

begin
		 x:=campo.ini_x;
		 y:=campo.ini_y;
		 p:=1;
		 ins:=1;
		 long_linea:=campo.longitud div campo.lineas;
		 salir:=false;
		 repeat
					 put_string(campo,1);

					 if ins=0 then cursor_solid;
					 if ins=1 then cursor_line;

					 gotoxy(x,y);


					 repeat until (get_key(ascii,scancode,funcion,estado,teclas)) ;

					 if (teclas<>'') then
					 begin
								if teclas='up' then p:=p-long_linea;
								if teclas='dow' then p:=p+long_linea;
								if teclas='lef' then dec(p);
								if teclas='rig' then inc(p);
								if teclas='ret' then
								begin
										 put_string(campo,0);
										 get_field:=2;
										 salir:=true;
								end;
								if teclas='del' then dellete (campo.dato,p,campo.longitud);
								if teclas='bks' then if p>1 then
								begin
										 dellete (campo.dato,p-1,campo.longitud);
										 dec(p);
								end;
								if teclas='tab' then
								begin
										 put_string(campo,0);
										 salir:=true;
										 get_field:=0;
								end;
								if teclas='esc' then
								begin
										 put_string(campo,0);
										 salir:=true;
															 get_field:=3;
												end;
								if teclas='ins' then ins:=abs(1-ins);
								if teclas='ini' then p:=1;
								if teclas='fin' then p:=campo.longitud;
								if teclas='stb' then
								begin
										 put_string(campo,0);
										 salir:=true;
										 get_field:=1;
								end;
					 end
					 else if (ascii<>#0) then
					 begin
								if ins=1 then inserta(campo.dato,ascii,p,campo.longitud) else
								campo.dato[p]:=ascii;
								inc(p);
					 end;

					 if p>campo.longitud then p:=campo.longitud;
					 if p<1 then p:=1;

					 x:=campo.ini_x+((p-1) mod long_linea);
					 y:=campo.ini_y+((p-1) div long_linea);

		 until salir;

		 textcolor(7);
		 textbackground(BLACK);
		 put_string(campo,0);


end;



{  Esta funcioncilla solo es para las decisiones tipo "S/N" }
function si_no;
var
	 c      : char;
	 r,s,p  : byte;
	 estado : t_estado;
	 teclas : str_3;
	 salir  : boolean;
begin
	salir:=false;
	repeat
		gotoxy(wherex,25);
		cursor_off;
		repeat until get_key(c,s,p,estado,teclas);
		if teclas='ret' then
			begin
				salir:=true;
				if predefinida='S' then r:=1
					else r:=0
			end
			else if teclas='' then
				begin
					if c='s' then c:=upcase(c);
					if c='n' then c:=upcase(c);

					if c='S' then
						begin
							r:=1;
							salir:=true;
						end;

					if c='N' then
						begin
							r:=0;
							salir:=true;
						end
				end;
	until salir;
	if r=1 then si_no:=true
		else si_no:=false;
end;

(* NO NOS HACEN FALTA ESTOS:::::
procedure dar_alta_albaran;
var
	valor:byte;
begin
{

		valor:=(fesha.year-1990)*16+fesha.month;
		 codigo.letra:=upcase(codigo.letra);
		 if (codigo.numero<=9999) and (codigo.numero>=0) then
				if ((ord(codigo.letra)-64)<=2) and ((ord(codigo.letra)-64)>=1) then
					ini.albaranes[codigo.numero,ord(codigo.letra)-64]:=valor;}

end;



function comprueba_albaran;
var
	valor:byte;
	alb:t_date;
begin
{
		cod.letra:=upcase(cod.letra);
		valor:=ini.albaranes[cod.numero,ord(cod.letra)-64];
		if valor=0 then
		begin
			 fichero:='';
			 comprueba_albaran:=false;
		end else
		begin
			 alb.year:=((valor and $f0) div 16)+1990;
			 alb.month:=(valor and $0f);
			 fi:=transform(alb);
			 comprueba_albaran:=true;
		end;}
end;
*)



{pasa a longint un fecha expresada en dia mes y a¤o}
function fecha_numero;
var ty:longint;
begin
	 ty:=a;
	 ty:=ty*100000;
	 ty:=ty div 10;
	 m:=m*100;

	 fecha_numero:=ty+m+d;
end;


{ Mete en una t_date un string }
procedure cad_fecha;
var

   i,barra,ultimo:integer;
   ca:array [1..3] of string;
   cdia,cmes,canho:string;
   codig:integer;
begin
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

		 val(cdia,d,codig);
		 val(cmes,m,codig);
		 val(canho,a,codig);
end;


{ Salva la configuraci¢n. Hay que hacerlo a menudo..}
	procedure save_cfg;
	var f:file of t_ini;
	begin
		assign(f,ini.work+'ACTE.CFG');
		{$I-}
		rewrite(f);
		{$I+}
		if ioresult=0 then
			begin
				write(f,ini);
				close(f)
			end
	end;



{ Aqui ordenamos el fichero de DNIïs}
procedure ordena_dni_ndx;
const max=1700;
var
   cont   : word;
   indice : t_dni_ndx;
   indices: array [1..max] of t_dni_ndx;
   tam    : word;
   i,j    : word;
   temp   : t_dni_ndx;
begin
	reset(dni_ndx); {abre para leer codigo.ndx}
	cont:=1;
	while not(eof(dni_ndx)) do
		begin
			read(dni_ndx,indice);
			indices[cont]:=indice; {Pasa todos los ¡ndices a memoria}
			inc(cont);
		end;

	tam:=cont-1;

{ ordena el array en memoria (Bubble) }

	for i:=1 to tam do
		for j:=1 to tam-1 do
			if indices[j].dni>indices[j+1].dni then
				begin
					temp:=indices[j];
					indices[j]:=indices[j+1];
					indices[j+1]:=temp;
				end;

	  { reescribe codigo.ndx con el array }

	  rewrite(dni_ndx); {abre para escribir codigo.ndx}
	  for i:=1 to max_socios do write(dni_ndx,indices[i]);
	  close(dni_ndx); {cierra codigo.ndx}
end;





procedure ordena_alfab_ndx;
const max=1700;
var
   cont     : word;
   indice2  : t_alfab_ndx;
   indices2 : array [1..max] of t_alfab_ndx;
   tam      : word;
   i,j      : word;
   temp2    : t_alfab_ndx;
begin
	cont:=1;
	reset(alfab_ndx); {abre para leer alfa.ndx}

	while not(eof(alfab_ndx)) do
		begin
			read(alfab_ndx,indice2);
			indices2[cont]:=indice2;
		{ indices2[cont].nombre:=indice2.nombre;
		  indices2[cont].pos:=indice2.pos;
}			inc(cont);
		 end;

	tam:=cont-1;

	for i:=1 to tam do
		for j:=1 to tam-1 do
			if indices2[j].nombre>indices2[j+1].nombre then
				begin
					temp2:=indices2[j];
					indices2[j]:=indices2[j+1];
					indices2[j+1]:=temp2;
				end;


	rewrite(alfab_ndx); {abre para escribir ALFA.NDX}
	for i:=1 to tam do write(alfab_ndx,indices2[i]);
	close(alfab_ndx); {cierra ALFA.NDX}
end;



begin
end.