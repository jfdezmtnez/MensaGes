unit puts;

interface

uses crt,defs,common,campstru,graficos,formulas;

procedure put_cliente (var ccliente:t_cliente; x,y:byte);
procedure put_comercial (var ccomercial:t_comercial; x,y:byte);
procedure put_mensajero (var mmensajero:t_mensajero; x,y:byte);
procedure put_tarifas_cliente (var ccliente:t_cliente; x,y:byte);
procedure put_tarifas_mensajero (x,y:byte);
procedure put_casilla (var aalbaran:t_albaran; casilla,x,y:byte);
procedure put_albaran (var aalbaran:t_albaran; x,y:byte);
procedure put_fact_comercial(var ccomercial:t_comercial; albaranes:word; submonto:longint);
procedure put_fact_mensajero(var mmensajero:t_mensajero; servs:t_servs; sub:t_subts);
procedure put_factura_general_head(var head:t_factura_head; x,y:byte);
procedure put_factura_general_pie(var head:t_factura_head; x,y:byte);
procedure put_factura_general_albaranes(var lista:listalbs; lim_inf,lim_sup:word; x,y:byte);
procedure put_linea_albaran(x,y:byte; var linea:listalbs; inv:boolean);


implementation




procedure put_cliente;
var
	inicio,p:pnodo_dato;
begin

		recuadro_cliente(3,3);
	  crea_lista(inicio,_max_cliente_campos);

		p:=inicio;
	  cliente2campos(ccliente,inicio,x,y);

		repeat
	  put_campo(p^,7);
		p:=p^.sig;
	  until p=nil;

	  borra_lista(inicio);
end;



procedure put_comercial;
var
	inicio,p:pnodo_dato;
begin
		recuadro_comercial(3,3);
	  crea_lista(inicio,_max_comercial_campos);

	  p:=inicio;
		comercial2campos(ccomercial,inicio,x,y);

	  repeat
				put_campo(p^,7);
			  p:=p^.sig;
	  until p=nil;

	  borra_lista(inicio);
end;



procedure put_mensajero;
var
	inicio,p:pnodo_dato;
begin
		recuadro_mensajero(3,3);
	  crea_lista(inicio,_max_mensajero_campos);

	  p:=inicio;
	  mensajero2campos(mmensajero,inicio,x,y);

	  repeat
	  put_campo(p^,7);
		p:=p^.sig;
	  until p=nil;

	  borra_lista(inicio);

end;



procedure put_tarifas_cliente;
var
	inicio,p:pnodo_dato;
begin
	  recuadro_tarifas_cliente(15,12);
	  crea_lista(inicio,5*_max_tfas_cliente);

	  p:=inicio;
	  tarifa2campos_cliente(ccliente,inicio,x,y);
		repeat
	  put_campo(p^,7);
	  p:=p^.sig;
		until p=nil;

	  borra_lista(inicio);

end;



procedure put_tarifas_mensajero;
var
	inicio,p:pnodo_dato;
begin
	  recuadro_tarifas_mensajero(3,3);
	  crea_lista(inicio,5*_max_tfas_mensajero);

	  p:=inicio;
		tarifa2campos_mensajeros(inicio,x,y);

		repeat
	  put_campo(p^,7);
	  p:=p^.sig;
		until p=nil;

	  borra_lista(inicio);
end;



procedure put_casilla;
var
	inicio,aux_dato:pnodo_dato;
begin
	  recuadro_casillas(x,y);

	  crea_lista(inicio,_max_casillas_campos);
	  aux_dato:=inicio;

	  gotoxy(x+10,y+1);
	  textcolor(BLINK+RED);
		textbackground(BLACK);
	  highvideo;
	  write(casilla);

	  textcolor(CYAN);

	  if aalbaran.casilla[casilla].mensajero=0 then aux_dato^.dato:='  ' else
	  str(aalbaran.casilla[casilla].mensajero,aux_dato^.dato);
	  aux_dato^.especifi:='nn';
     aux_dato^.dato:=aux_dato^.dato+empty;
	  rellena(aux_dato,x+6,y+3,2,1);
	  aux_dato:=aux_dato^.sig;

	  if aalbaran.casilla[casilla].serv_cliente=0 then aux_dato^.dato:='  ' else
	  str(aalbaran.casilla[casilla].serv_cliente,aux_dato^.dato);
     aux_dato^.dato:=aux_dato^.dato+empty;
		aux_dato^.especifi:='nn';
	  rellena(aux_dato,x+16,y+3,2,1);
	  aux_dato:=aux_dato^.sig;

	  if aalbaran.casilla[casilla].serv_mensajero=0 then aux_dato^.dato:='  ' else
		str(aalbaran.casilla[casilla].serv_mensajero,aux_dato^.dato);
		 aux_dato^.dato:=aux_dato^.dato+empty;
	  aux_dato^.especifi:='nn';
		rellena(aux_dato,x+26,y+3,2,1);
	  aux_dato:=aux_dato^.sig;

		if aalbaran.casilla[casilla].ex_peso=0 then aux_dato^.dato:='   ' else
		str(aalbaran.casilla[casilla].ex_peso,aux_dato^.dato);
		 aux_dato^.dato:=aux_dato^.dato+empty;
		aux_dato^.especifi:='nnn';
		rellena(aux_dato,x+35,y+3,3,1);
		aux_dato:=aux_dato^.sig;

		if aalbaran.casilla[casilla].ex_tiempo=0 then aux_dato^.dato:='  ' else
		str(aalbaran.casilla[casilla].ex_tiempo,aux_dato^.dato);
		 aux_dato^.dato:=aux_dato^.dato+empty;
		aux_dato^.especifi:='nn';
		rellena(aux_dato,x+48,y+3,2,1);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=aalbaran.casilla[casilla].ex_km+empty;
		aux_dato^.especifi:='nnnx';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		rellena(aux_dato,x+56,y+3,4,1);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=aalbaran.casilla[casilla].facturar+empty;
		aux_dato^.especifi:='x';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		rellena(aux_dato,x+68,y+3,1,1);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=aalbaran.casilla[casilla].nombre+empty;
		aux_dato^.especifi:=XEX40;
		 aux_dato^.dato:=aux_dato^.dato+empty;
		rellena(aux_dato,x+11,y+5,40,1);
		aux_dato:=aux_dato^.sig;

	  aux_dato^.dato:=aalbaran.casilla[casilla].direccion+empty;
	  aux_dato^.especifi:=XEX40;
		 aux_dato^.dato:=aux_dato^.dato+empty;
	  rellena(aux_dato,x+11,y+7,40,1);
		aux_dato:=aux_dato^.sig;

	  aux_dato^.dato:=aalbaran.casilla[casilla].hora+empty;
		aux_dato^.especifi:='xxxxx';
		 aux_dato^.dato:=aux_dato^.dato+empty;
	  rellena(aux_dato,x+57,y+7,5,1);
	  aux_dato:=aux_dato^.sig;

	  if aalbaran.casilla[casilla].reembolso=0 then aux_dato^.dato:='        ' else
     str(aalbaran.casilla[casilla].reembolso,aux_dato^.dato);
	  aux_dato^.especifi:='nnnnnnnnnn';
     aux_dato^.dato:=aux_dato^.dato+empty;
		rellena(aux_dato,x+11,y+9,10,1);
	  aux_dato:=aux_dato^.sig;

	  aux_dato:=inicio;

	  repeat
		put_campo(aux_dato^,7);
		aux_dato:=aux_dato^.sig;
	  until aux_dato=nil;

     borra_lista(inicio);

end;



procedure put_albaran;
var
	inicio,p:pnodo_dato;
begin
	  crea_lista(inicio,_max_albaran_campos);

	  p:=inicio;
	  albaran2campos(aalbaran,inicio,x,y);

	  repeat
	  put_campo(p^,7);
	  p:=p^.sig;
	  until p=nil;

		borra_lista(inicio);
end;



procedure put_fact_comercial;
var monto:longint;
begin
	monto:=total_neto_comercial(ccomercial,submonto);
	gotoxy(8,8);
	write_n_digits(ccomercial.codigo,2);
	for i:=1 to 40 do
		begin
			gotoxy(13+i,8);
			write(ccomercial.nombre[i]);
			gotoxy(13+i,9);
			write(ccomercial.nombre[i+40])
		end;
	gotoxy(14,13);
	write(albaranes);
	gotoxy(46,12);
	write_right(submonto,55);
	gotoxy(46,15);
	write_right(monto,55);
	gotoxy(59,15);
	write_right(ccomercial.porcentaje,61);
	cursor_off
end;



procedure put_fact_mensajero;
var
	monto,b,k,t,p : longint;
	i             : byte;
begin
	b:=0;
	k:=0;
	t:=0;
	p:=0;
	monto:=0;
	gotoxy(11,6);
	write_n_digits(mmensajero.codigo,2);
	for i:=1 to 40 do
		begin
			gotoxy(16+i,6);
			write(mmensajero.nombre[i]);
			gotoxy(16+i,7);
			write(mmensajero.nombre[i+40])
		end;
	for i:=1 to 8 do
		begin
			gotoxy(28,11+i);
			write_right(servs[1,i],32);
			b:=b+servs[1,i]*ini.tfas_mensajero[i].precio;
			gotoxy(35,11+i);
			write_right(servs[2,i],40);
			p:=p+servs[2,i]*ini.tfas_mensajero[i].ex_peso;
			gotoxy(43,11+i);
			write_right(servs[3,i],49);
			t:=t+servs[3,i]*ini.tfas_mensajero[i].ex_tiempo;
			gotoxy(52,11+i);
			write_right(servs[4,i],58);
			k:=k+servs[4,i]*ini.tfas_mensajero[i].ex_km;
			gotoxy(62,11+i);
			write_right(sub[i],70);
			monto:=monto+sub[i]
		end;

	gotoxy(28,14+i);
	write_right(b,32);
	gotoxy(35,14+i);
	write_right(p,40);
	gotoxy(43,14+i);
	write_right(t,49);
	gotoxy(52,14+i);
	write_right(k,58);
	gotoxy(62,14+i);
	write_right(monto,70)
end;


procedure put_factura_general_head;
var
	inicio,p:pnodo_dato;
begin
	  crea_lista(inicio,_max_factura_head_campos);
	  p:=inicio;
	  factura_general_head2campos(head,inicio,x,y);

	  repeat
			put_campo(p^,7);
			p:=p^.sig;
	  until p=nil;

	  borra_lista(inicio);
end;


procedure put_factura_general_pie;
var
	inicio,p:pnodo_dato;
begin
	  crea_lista(inicio,_max_factura_pie_campos);
	  p:=inicio;
	  factura_general_pie2campos(head,inicio,x,y);

	  repeat
			put_campo(p^,7);
			p:=p^.sig;
	  until p=nil;

	  borra_lista(inicio);
end;


(* coloca una linea de alb en pantalla, en video inv o normal *)


procedure put_linea_albaran;
var
	z,resto:byte;

begin
	if inv then
	begin
		textbackground(BLUE);
		textcolor(CYAN);
		highvideo;
	end;

	with linea^ do
	begin
		gotoxy(x,y);
		write(codigo.numero,codigo.letra);
		gotoxy(x+9,y);
		write(fecha.day,'/',fecha.month,'/',fecha.year);
		gotoxy(x+22,y);
		if se[1]<>0 then write('01x',se[1],' ');
		if se[2]<>0 then write('02x',se[2],' ');
		if se[3]<>0 then write('03x',se[3],' ');
		if se[4]<>0 then write('04x',se[4],' ');
		if se[5]<>0 then write('05x',se[5],' ');
		if se[6]<>0 then write('06x',se[6],' ');
		if se[7]<>0 then write('07x',se[7],' ');
		if se[8]<>0 then write('08x',se[8],' ');
		if se[9]<>0 then write('09x',se[9],' ');
		resto:=63-wherex;
		for z:=1 to resto-2 do write('.');
		gotoxy(x+62,y);
		write_right(temp,x+67);
	end;
	if inv then
	begin
		textbackground(BLACK);
		textcolor(WHITE);
		lowvideo;
	end;


end;

(* coloca en pantalla las lineas de albaranes desde lim_inf hasta lim_sup
a partir de x,y *)


procedure put_factura_general_albaranes;
var
	cont:word;
	y_temp:byte;
	p:listalbs;

begin
	y_temp:=y;
	cont:=1;
	p:=lista;
	while p<>nil do
	begin
		if (cont>=lim_inf) and (cont<=lim_sup) then
		begin
			put_linea_albaran(x,y_temp,p,false);
			inc(y_temp);
		end;
		inc(cont);
		p:=p^.sig;
	end;


end;



end.