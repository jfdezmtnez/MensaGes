unit gets;

interface

uses crt,defs,common,campstru,graficos,windos;

function get_tarifas_cliente (var ccliente:t_cliente; x,y:byte):byte;
function get_cliente (var ccliente:t_cliente; x,y:byte):byte;
function get_comercial (var ccomercial:t_comercial; x,y:byte):byte;
function get_mensajero (var mmensajero:t_mensajero; x,y:byte):byte;
function get_tarifas_mensajero (x,y:byte):byte;
function get_casillas (var aalbaran:t_albaran; x,y:byte):byte;
function get_albaran (var aalbaran:t_albaran; x,y:byte):byte;
function get_fechas(var fecha_inicio,fecha_fin:str_11):byte;
function get_factura_head(var chead:t_factura_head; x,y:byte):byte;
function get_factura_pie(var cpie:t_factura_head; x,y:byte):byte;

{function get_fichero_fact(var fich:str_11):byte;}


implementation

var
	 salir,salir2:boolean;

function get_tarifas_cliente;
var
	 i,k,op:byte;
	 inicio,p,f:pnodo_dato;

begin
		 i:=0;

		 crea_lista(inicio,5*_max_tfas_cliente);

		 p:=inicio;
		 tarifa2campos_cliente(ccliente,inicio,x,y);
		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=5*_max_tfas_cliente-1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=5*_max_tfas_cliente-1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

		 campos2tarifa_cliente (inicio,ccliente);

		 borra_lista(inicio);

		 get_tarifas_cliente:=op;
end;


function get_cliente;
var
	 i,k,op:byte;
	 inicio,p,f:pnodo_dato;

begin

		 i:=0;
		 crea_lista(inicio,_max_cliente_campos);

		 p:=inicio;
		 cliente2campos(ccliente,inicio,x,y);

		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=_max_cliente_campos-1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=_max_cliente_campos-1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

		 if not(salir) then campos2cliente(inicio,ccliente);

		 borra_lista(inicio);

		 get_cliente:=op;

end;


function get_comercial;
var
	 i,k,op:byte;
	 inicio,p,f:pnodo_dato;
	 temp:t_comercial;

begin

		 i:=0;
		 temp:=ccomercial;
		 crea_lista(inicio,_max_comercial_campos);

		 p:=inicio;
		 comercial2campos(temp,inicio,x,y);

		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=_max_comercial_campos-1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=_max_comercial_campos-1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

		 if not(salir) then campos2comercial(inicio,temp);
		 borra_lista(inicio);

		 ccomercial:=temp;

		 get_comercial:=op;

end;


function get_mensajero;
var
	 i,k,op:byte;
	 inicio,p,f:pnodo_dato;
	 temp:t_mensajero;

begin

		 i:=0;
		 temp:=mmensajero;
		 crea_lista(inicio,_max_mensajero_campos);

		 p:=inicio;
		 mensajero2campos(temp,inicio,x,y);

		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=_max_mensajero_campos-1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=_max_mensajero_campos-1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

		 if not(salir) then campos2mensajero(inicio,temp);
		 borra_lista(inicio);

		 mmensajero:=temp;

		 get_mensajero:=op;

end;


function get_tarifas_mensajero;
var
	 i,k,op:byte;
	 inicio,p,f:pnodo_dato;

begin

		 i:=0;
		 salir:=false;
		 crea_lista(inicio,5*_max_tfas_mensajero);

		 p:=inicio;
		 tarifa2campos_mensajeros(inicio,x,y);

		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=5*_max_tfas_mensajero-1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=5*_max_tfas_mensajero-1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

		 if not(salir) then campos2tarifa_mensajeros(inicio);
		 borra_lista(inicio);

		 get_tarifas_mensajero:=op;

end;


function get_casillas;
var
	 i,k,j,op:byte;
	 inicio,p,f,ini:pnodo_dato;

begin
		 i:=0;

		 crea_lista(inicio,_max_casillas_campos*_max_casillas);
		 casilla2campos(aalbaran,inicio,x,y);

		 ini:=inicio;

		 k:=1;

		 salir:=false;
		 salir2:=false;

		 repeat
					p:=ini;

					for i:=1 to _max_casillas_campos do
					begin
								put_campo(p^,7);
								f:=p;
								p:=p^.sig;
					end;

					p:=ini;
					i:=1;

					textcolor(BLINK+RED);
					highvideo;
					gotoxy(x+10,y+1);
					write(k);
					textcolor(CYAN);
					lowvideo;

					repeat
								op:=get_field(p^);

								{ si se pasa del limite superior }

								if op=0 then if i=_max_casillas_campos then
								begin
										 i:=1;
										 p:=ini;
								end else
								begin
										 inc(i);
										 p:=p^.sig;
								end;

								{ si se pasa del limite inferior }

								if op=1 then if i=1 then
								begin
										 i:=_max_casillas_campos;
										 p:=f;
								end else
								begin
										 dec(i);
										 p:=p^.ant;
								end;

								{ si pulsa ESC }

								if op=3 then salir:=true;

					until (op=2) or (salir);

					{ si pulsa ESC tambien sale del bucle principal }

					if salir then salir2:=true;

					{ si salio con RETURN }

					if not(salir2) then
					begin
							 p:=f;
							 p:=p^.sig;
							 inc(k);

							 { solo que si te pasas de la octava casilla }

							 if k>_max_casillas then salir2:=true;
					end;

					if not(salir2) then ini:=p;

		 until salir2;

		 write_msg('Guardar albaran (S/n)');
		 if si_no('S') then
		 begin
					campos2casilla (inicio,aalbaran);
					get_casillas:=op;
					borra_lista(inicio);
		 end
		 else get_casillas:=5; { codigo de retorno conforme no hay que guardar }

end;


function get_albaran;
var
	 i,k,op:byte;
	 inicio,p,f:pnodo_dato;
	 temp:t_albaran;

begin

		 i:=0;
		 temp:=aalbaran;
		 crea_lista(inicio,_max_albaran_campos);

		 p:=inicio;
		 albaran2campos(temp,inicio,x,y);

		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=_max_albaran_campos-1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=_max_albaran_campos-1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

		 if not(salir) then
		 begin
					campos2albaran(inicio,temp);
					aalbaran:=temp;
					with temp.fecha do

						if day<1 then op:=0
							else if((month in [4,6,9,11])and(day>30)) then op:=0
							 else if ((month in [1,3,5,7,8,10,12])and(day>31)) then op:=0
								 else if month=2 then
									 begin
										 if (year mod 4)=0 then if day>29 then op:=0
											 else if day>28 then op:=0
									 end
									 else if (year<1995) or (year>1999) then op:=0;


					get_albaran:=op;
					borra_lista(inicio);
			 end else get_albaran:=5;

end;




function get_fechas;
var
	i,k,op         : byte;
	inicio,p,f     : pnodo_dato;
	barra,ultimo   : byte;
	ca             : array [1..3] of string;
	cad            : string;
	cdia,cmes,canho: string;
	dia,tmes,anho  : word;
	mal            : boolean;
	semana         : word;
	f1,f2          : longint;

begin

	i:=0;
	crea_lista(inicio,2);
{
	getdate(anho,tmes,dia,semana);
	if tmes=1 then tmes:=12 else dec(tmes);
	str(tmes,cmes);
	str(anho-1900,canho);
}
	anho:=fecha_sistema.year;

	if fecha_sistema.month=1 then
		begin
			tmes:=12;
			dec(anho)
		end
		else tmes:=fecha_sistema.month-1;

	str(tmes,cmes);
	str(anho-1900,canho);

	p:=inicio;

	p^.dato:=empty;
	p^.dato:='1.'+cmes+'.'+canho;
	p^.especifi:='nnxnnxnn';
	p^.ini_x:=24;
	p^.ini_y:=7;
	p^.longitud:=8;
	p^.lineas:=1;

	p:=p^.sig;

	p^.dato:='          '+empty;
	if tmes in [1,3,5,7,8,10,12] then p^.dato:='31.'+cmes+'.'+canho;
	if tmes in [4,6,9,11] then p^.dato:='30.'+cmes+'.'+canho;
	if tmes=2 then
	 if ((anho-1980) mod 4)=0 then p^.dato:='29.'+cmes+'.'+canho
		else p^.dato:='28.'+cmes+'.'+canho;

	p^.especifi:='nnxnnxnn';
	p^.ini_x:=24;
	p^.ini_y:=9;
	p^.longitud:=8;
	p^.lineas:=1;

	p:=inicio;

		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

			 mal:=false;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

			 p:=inicio;
			 fecha_inicio:=p^.dato;

			 {comprobar que fecha_inicio esta bien}

			 cad:='';
			 for i:=1 to 8 do cad:=cad+p^.dato[i];
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
			 if dia<1 then mal:=true
				 else if((tmes in [4,6,9,11])and(dia>30)) then mal:=true
					else if ((tmes in [1,3,5,7,8,10,12])and(dia>31)) then mal:=true
						else if tmes=2 then
							begin
								if (anho mod 4)=0 then if dia>29 then mal:=true
									else if dia>28 then mal:=true
							end
							else if (anho<95) or (anho>99) then mal:=true;

			 if barra<>2 then mal:=true;

			 fecha_inicio:=cad;

			 f1:=anho;
			 f1:=f1*100+tmes;
			 f1:=f1*100+dia;

			 p:=p^.sig;
			 fecha_fin:=p^.dato;

			 {comprobar que fecha_fin esta bien}

			 cad:='';
			 for i:=1 to 8 do cad:=cad+p^.dato[i];
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

			 if dia<1 then mal:=true
				 else if((tmes in [4,6,9,11])and(dia>30)) then mal:=true
					else if ((tmes in [1,3,5,7,8,10,12])and(dia>31)) then mal:=true
						else if tmes=2 then
							begin
								if (anho mod 4)=0 then if dia>29 then mal:=true
									else if dia>28 then mal:=true
							end
							else if (anho<95) or (anho>99) then mal:=true;


			 if barra<>2 then mal:=true;

			 fecha_fin:=cad;

			 f2:=anho;
			 f2:=f2*100+tmes;
			 f2:=f2*100+dia;

			 if f1>=f2 then mal:=true;


			 if (op=2) and mal then get_fechas:=4
			 else
				 if (op=2) and not(mal) then get_fechas:=op
					 else
						 if not(not(salir) and (op=2)) then get_fechas:=5;
			 if op=3 then get_fechas:=3;

		 borra_lista(inicio);

end;




{function get_fichero_fact;
var
	fic   : file of t_albaran;
	path  : str_11;
	campo : t_nodo_dato;
	mes   : str_3;
	op,i  : byte;
	c     : char;
	v     : boolean;
   barra,ultimo:byte;
   ca:array [1..3] of string;
   cad:string;
   cdia,cmes,canho:string;
   dia,tmes,anho:integer;
begin

	v:=true;

	campo.dato:=copy(fich,1,8)+empty;
	campo.especifi:='nnxnnxnn'+empty;
	campo.ini_x:=24;
	campo.ini_y:=7;
	campo.longitud:=8;
	campo.lineas:=1;

	gotoxy(3,7);
	write('Fecha facturacion: ');
	put_campo(campo);


   repeat
      salir:=true;
      campo.dato:='        '+empty;
			repeat
	         op:=get_field(campo);
         until ((op=2)or(op=3));

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

         if (dia<1) or (dia>31) then salir:=false;
         if (tmes<1) or (tmes>12) then salir:=false;
         if (anho<95) or (anho>99) then salir:=false;
         if barra<>2 then salir:=false;

   until salir;

   get_fichero_fact:=op;

   fich:=campo.dato;

end;}

function get_factura_head;
var
	 i,k,op:byte;
	 inicio,p,f:pnodo_dato;

begin

		 i:=0;
		 crea_lista(inicio,_max_factura_head_campos);

		 p:=inicio;
		 factura_general_head2campos(chead,inicio,x,y);

		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=_max_factura_head_campos-1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=_max_factura_head_campos-1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

		 if not(salir) then campos2factura_general_head(inicio,chead);

		 borra_lista(inicio);

		 get_factura_head:=op;

end;

function get_factura_pie;
var
	 i,k,op:byte;
	 inicio,p,f:pnodo_dato;

begin

		 i:=0;
		 crea_lista(inicio,_max_factura_pie_campos);

		 p:=inicio;
		 factura_general_pie2campos(cpie,inicio,x,y);

		 repeat
					put_campo(p^,7);
					f:=p;
					p:=p^.sig;
		 until p=nil;

		 p:=inicio;

		 repeat
					 salir:=false;
					 op:=get_field(p^);
					 if (op=0) then if (i=_max_factura_pie_campos-1) then
					 begin
								i:=0;
								p:=inicio;
					 end else
							 begin
										inc(i);
										p:=p^.sig;
							 end;
					 if (op=1) then if (i=0) then
					 begin
								i:=_max_factura_pie_campos-1;
								p:=f;
					 end else
							 begin
										dec(i);
										p:=p^.ant;
							 end;
					 if (op=3) then salir:=true;
		 until (op=2) or salir;

		 if not(salir) then campos2factura_general_pie(inicio,cpie);

		 borra_lista(inicio);

		 get_factura_pie:=op;

end;


begin
end.
