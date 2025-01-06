UNIT campstru;

INTERFACE

USES crt,windos,defs,common;

VAR
	 cod:integer;
	 i:byte;

procedure crea_lista(var ini:pnodo_dato; nodos:byte);
procedure borra_lista(var ini_dato:pnodo_dato);

procedure ini_cliente (var ccliente:t_cliente);
procedure ini_mensajero (var mensajero:t_mensajero);
procedure ini_comercial (var comercial:t_comercial);
procedure ini_albaran (var albaran:t_albaran);
procedure ini_factura (var chead:t_factura_head);

procedure rellena (var campo:pnodo_dato; x,y,longitud,lineas:byte);

procedure tarifa2campos_cliente (var ccliente:t_cliente; var ini_dato:pnodo_dato; x,y:byte);
procedure campos2tarifa_cliente (var ini_dato:pnodo_dato; var ccliente:t_cliente);

procedure cliente2campos (var ccliente:t_cliente; var ini_dato:pnodo_dato; x,y:byte);
procedure campos2cliente (var ini_dato:pnodo_dato; var ccliente:t_cliente);

procedure comercial2campos (var ccomercial:t_comercial; var ini_dato:pnodo_dato; x,y:byte);
procedure campos2comercial (var ini_dato:pnodo_dato; var ccomercial:t_comercial);

procedure tarifa2campos_mensajeros (var ini_dato:pnodo_dato; x,y:byte);
procedure campos2tarifa_mensajeros (var ini_dato:pnodo_dato);

procedure mensajero2campos (var mmensajero:t_mensajero; var ini_dato:pnodo_dato; x,y:byte);
procedure campos2mensajero (var ini_dato:pnodo_dato; var mmensajero:t_mensajero);

procedure casilla2campos (var aalbaran:t_albaran; var ini_dato:pnodo_dato; x,y:byte);
procedure campos2casilla (var ini_dato:pnodo_dato; var aalbaran:t_albaran);

procedure albaran2campos (var aalbaran:t_albaran; var ini_dato:pnodo_dato; x,y:byte);
procedure campos2albaran (var ini_dato:pnodo_dato; var aalbaran:t_albaran);

procedure factura_general_head2campos(var head:t_factura_head; var ini_dato:pnodo_dato; x,y:byte);
procedure campos2factura_general_head(var ini_dato:pnodo_dato; var head:t_factura_head);

procedure factura_general_pie2campos(var head:t_factura_head; var ini_dato:pnodo_dato; x,y:byte);
procedure campos2factura_general_pie(var ini_dato:pnodo_dato; var head:t_factura_head);


IMPLEMENTATION


procedure crea_nodo(var ini_dato:pnodo_dato; var ant_dato:pnodo_dato);
var
	 aux_dato:pnodo_dato;
begin
		 if ini_dato=nil then
		 begin
					new(ini_dato);
					ini_dato^.sig:=nil;
					ini_dato^.ant:=nil;
					ant_dato:=ini_dato;
		 end
		 else
		 begin
					new(aux_dato);
					ant_dato^.sig:=aux_dato;
					aux_dato^.sig:=nil;
					aux_dato^.ant:=ant_dato;
					ant_dato:=aux_dato;
		 end;
end;



procedure crea_lista;
var
	 aux:pnodo_dato;
	 ant:pnodo_dato;
	 i:word;
begin

		 ini:=nil;
		 ant:=nil;

		 for i:=1 to nodos do crea_nodo(ini,ant);

end;




procedure borra_lista;
var
	 aux_dato:pnodo_dato;
	 ant_dato:pnodo_dato;
	 i:word;
begin
		 aux_dato:=ini_dato;

		 while not(aux_dato=nil) do
		 begin
					ant_dato:=aux_dato;
					aux_dato:=aux_dato^.sig;
					dispose(ant_dato);
		 end;
end;


procedure ini_cliente;
var
	 year,month,day,weekday:word;
	 k:byte;
begin

	ccliente.telefono:=0;
	ccliente.cif:='';
	ccliente.nombre:='';
	ccliente.forma_pago:='';
	ccliente.obs:='';
	getdate(year,month,day,weekday);
	ccliente.ini_date.year:=year;
	ccliente.ini_date.month:=month;
	ccliente.ini_date.day:=day;
	ccliente.ini_date.weekday:=weekday;
	ccliente.comercial:=0;
	ccliente.descuento:=0;
	ccliente.recargo_eq:='n';
	ccliente.direccion.numero:=0;
	ccliente.direccion.piso:=0;
	ccliente.direccion.cpostal:=0;
	ccliente.direccion.letra:=#0;
	ccliente.direccion.calle:='';
	ccliente.direccion.localidad:='Vigo';
	ccliente.direccion.provincia:='Pontevedra';
	ccliente.cobrar_reemb:='n';
	 for k:=1 to _max_tfas_cliente do
	 begin
		ccliente.tarifas[k].descripcion:=ini.tfas_defecto[k].descripcion;
		ccliente.tarifas[k].precio:=ini.tfas_defecto[k].precio;
		ccliente.tarifas[k].ex_peso:=ini.tfas_defecto[k].ex_peso;
		ccliente.tarifas[k].ex_tiempo:=ini.tfas_defecto[k].ex_tiempo;
		ccliente.tarifas[k].ex_km:=ini.tfas_defecto[k].ex_km;
	 end;

end;

procedure ini_comercial;
begin
	comercial.telefono:=0;
	comercial.codigo:=0;
	comercial.porcentaje:=0;
	comercial.cif:='';
	comercial.estudios:='';
	comercial.exp_laboral:='';
	comercial.nombre:='';
	comercial.obs:='';
	comercial.direccion.numero:=0;
	comercial.direccion.piso:=0;
	comercial.direccion.cpostal:=0;
	comercial.direccion.letra:=#0;
	comercial.direccion.calle:='';
	comercial.direccion.localidad:='Vigo';
	comercial.direccion.provincia:='Pontevedra';
end;

procedure ini_mensajero;
begin
	mensajero.telefono:=0;
	mensajero.codigo:=0;
	mensajero.cif:='';
	mensajero.nombre:='';
	mensajero.obs:='';
	mensajero.estado_civil:='n';
	mensajero.servicio_militar:='s';
	mensajero.vehiculo:='m';
	mensajero.direccion.numero:=0;
	mensajero.direccion.piso:=0;
	mensajero.direccion.cpostal:=0;
	mensajero.direccion.letra:=#0;
	mensajero.direccion.calle:='';
	mensajero.direccion.localidad:='Vigo';
	mensajero.direccion.provincia:='Pontevedra';
end;

procedure ini_albaran;
var
	 k:word;
	 year,month,day,weekday:word;
begin

	albaran.telefono:=0;
	albaran.codigo.numero:=0;
	albaran.codigo.letra:=#0;
	albaran.portes:=#0;
	albaran.obs:='';
	getdate(year,month,day,weekday);
	albaran.fecha.year:=year;
	albaran.fecha.month:=month;
	albaran.fecha.day:=day;
	albaran.fecha.weekday:=weekday;
	for k:=1 to _MAX_CASILLAS do
	 begin
		albaran.casilla[k].mensajero:=0;
		albaran.casilla[k].serv_cliente:=0;
		albaran.casilla[k].serv_mensajero:=0;
		albaran.casilla[k].ex_peso:=0;
		albaran.casilla[k].ex_tiempo:=0;
		albaran.casilla[k].ex_km:='    ';
		albaran.casilla[k].nombre:='';
		albaran.casilla[k].direccion:='';
		albaran.casilla[k].facturar:='s';
		albaran.casilla[k].hora:='     ';
		albaran.casilla[k].reembolso:=0;
	end;
end;

procedure ini_factura;
begin
	with chead do
	begin
		telefono:=0;
		fecha.day:=0;
		fecha.month:=0;
		fecha.year:=0;
		num_factura.numero:=0;
		num_factura.letra:=#0;
		pagado:='n';
		tipo_pago:='';
		with totales do
		begin
			total:=0;
			descuento:=0;
			iva:=0;
			recargo_eq:=0;
		end;
		fecha_pago.day:=0;
		fecha_pago.month:=0;
		fecha_pago.year:=0;
		iva:=0;
		descuento:=0;
		obs:='';
		total_neto:=0;
	end;
end;



procedure rellena;
begin
		 campo^.ini_x:=x;
		 campo^.ini_y:=y;
		 campo^.longitud:=longitud;
		 campo^.lineas:=lineas;
end;


procedure tarifa2campos_cliente;
var
	 aux_dato:pnodo_dato;
	 i:word;
begin
		 aux_dato:=ini_dato;

		 for i:=1 to _max_tfas_cliente do
		 begin
					aux_dato^.dato:=ccliente.tarifas[i].descripcion+empty;
					aux_dato^.especifi:='xxxxxxxxxxxxx';
					rellena(aux_dato,x+7,y+3+i-1,13,1);
					aux_dato:=aux_dato^.sig;

					if ccliente.tarifas[i].precio=0 then aux_dato^.dato:='     ' else
					str(ccliente.tarifas[i].precio,aux_dato^.dato);
               aux_dato^.dato:=aux_dato^.dato+empty;
					aux_dato^.especifi:='nnnnn';
					rellena(aux_dato,x+24,y+3+i-1,5,1);
					aux_dato:=aux_dato^.sig;

					if ccliente.tarifas[i].ex_peso=0 then aux_dato^.dato:='     ' else
					str(ccliente.tarifas[i].ex_peso,aux_dato^.dato);
					aux_dato^.especifi:='nnnnn';
               aux_dato^.dato:=aux_dato^.dato+empty;
					rellena(aux_dato,x+34,y+3+i-1,5,1);
					aux_dato:=aux_dato^.sig;

					if ccliente.tarifas[i].ex_tiempo=0 then aux_dato^.dato:='     ' else
					str(ccliente.tarifas[i].ex_tiempo,aux_dato^.dato);
					aux_dato^.especifi:='nnnnn';
               aux_dato^.dato:=aux_dato^.dato+empty;
					rellena(aux_dato,x+44,y+3+i-1,5,1);
					aux_dato:=aux_dato^.sig;

					if ccliente.tarifas[i].ex_km=0 then aux_dato^.dato:='     ' else
					str(ccliente.tarifas[i].ex_km,aux_dato^.dato);
					aux_dato^.especifi:='nnnnn';
               aux_dato^.dato:=aux_dato^.dato+empty;
					rellena(aux_dato,x+53,y+3+i-1,5,1);
					aux_dato:=aux_dato^.sig;


		 end;
end;


procedure campos2tarifa_cliente;
var
	 aux_dato:pnodo_dato;
	 i:word;
begin
		 aux_dato:=ini_dato;
		 for i:=1 to _max_tfas_cliente do
		 begin
					ccliente.tarifas[i].descripcion:=aux_dato^.dato;
					aux_dato:=aux_dato^.sig;
               aux_dato^.dato:=trim(aux_dato^.dato);
					val(aux_dato^.dato,ccliente.tarifas[i].precio,cod);
					aux_dato:=aux_dato^.sig;
               aux_dato^.dato:=trim(aux_dato^.dato);
					val(aux_dato^.dato,ccliente.tarifas[i].ex_peso,cod);
					aux_dato:=aux_dato^.sig;
               aux_dato^.dato:=trim(aux_dato^.dato);
					val(aux_dato^.dato,ccliente.tarifas[i].ex_tiempo,cod);
					aux_dato:=aux_dato^.sig;
               aux_dato^.dato:=trim(aux_dato^.dato);
					val(aux_dato^.dato,ccliente.tarifas[i].ex_km,cod);
					aux_dato:=aux_dato^.sig;
		 end;
end;



procedure cliente2campos;
var
	 aux_dato:pnodo_dato;
	 i:word;
begin
		 aux_dato:=ini_dato;


		 if ccliente.telefono=0 then aux_dato^.dato:='       ' else
		 str(ccliente.telefono,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+12,y+1,7,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.nombre+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+12,y+3,80,2);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.direccion.calle+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+5,40,1);
		 aux_dato:=aux_dato^.sig;

		 if ccliente.direccion.numero=0 then aux_dato^.dato:='    ' else
		 str(ccliente.direccion.numero,aux_dato^.dato);
		 aux_dato^.especifi:='nnnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+12,y+6,4,1);
		 aux_dato:=aux_dato^.sig;

		 if ccliente.direccion.piso=0 then aux_dato^.dato:='   ' else
		 str(ccliente.direccion.piso,aux_dato^.dato);
		 aux_dato^.especifi:='nnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+22,y+6,3,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.direccion.letra+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+33,y+6,1,1);
		 aux_dato:=aux_dato^.sig;

		 if ccliente.direccion.cpostal=0 then aux_dato^.dato:='     ' else
		 str(ccliente.direccion.cpostal,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnn';
			 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+45,y+6,5,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.direccion.localidad+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+7,40,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.direccion.provincia+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+8,40,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.cif+empty;
		 aux_dato^.especifi:='xxxxxxxxxxx';
		 rellena(aux_dato,x+12,y+10,10,1);
		 aux_dato:=aux_dato^.sig;

		 if ccliente.comercial=0 then aux_dato^.dato:='  ' else
		 str(ccliente.comercial,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+31,y+10,2,1);
		 aux_dato:=aux_dato^.sig;

		 if ccliente.descuento=0 then aux_dato^.dato:='  ' else
		 str(ccliente.descuento,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
			 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+41,y+10,2,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.recargo_eq+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+50,y+10,1,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.forma_pago+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+11,40,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.cobrar_reemb+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+18,y+12,1,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccliente.obs+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+12,y+14,80,2);
end;


procedure campos2cliente;
var
	 aux_dato:pnodo_dato;
begin
		 aux_dato:=ini_dato;


		ccliente.telefono:=str_to_long(aux_dato^.dato);
		 aux_dato:=aux_dato^.sig;
		ccliente.nombre:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccliente.direccion.calle:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccliente.direccion.numero,cod);
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccliente.direccion.piso,cod);
		 aux_dato:=aux_dato^.sig;
		ccliente.direccion.letra:=aux_dato^.dato[1];
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccliente.direccion.cpostal,cod);
		 aux_dato:=aux_dato^.sig;
		ccliente.direccion.localidad:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccliente.direccion.provincia:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccliente.cif:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccliente.comercial,cod);
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccliente.descuento,cod);
		 aux_dato:=aux_dato^.sig;
		ccliente.recargo_eq:=aux_dato^.dato[1];
		 aux_dato:=aux_dato^.sig;
		ccliente.forma_pago:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccliente.recargo_eq:=aux_dato^.dato[1];
		 aux_dato:=aux_dato^.sig;
		ccliente.obs:=aux_dato^.dato;
end;


procedure comercial2campos;
var
	 aux_dato:pnodo_dato;
begin
		 aux_dato:=ini_dato;

		 if ccomercial.telefono=0 then aux_dato^.dato:='       ' else
		 str(ccomercial.telefono,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+12,y+1,7,1);
		 aux_dato:=aux_dato^.sig;

		 if ccomercial.codigo=0 then aux_dato^.dato:='  ' else
		 str(ccomercial.codigo,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+35,y+1,2,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.nombre+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+12,y+3,80,2);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.direccion.calle+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+5,40,1);
		 aux_dato:=aux_dato^.sig;

		 if ccomercial.direccion.numero=0 then aux_dato^.dato:='    ' else
		 str(ccomercial.direccion.numero,aux_dato^.dato);
		 aux_dato^.especifi:='nnnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+12,y+6,4,1);
		 aux_dato:=aux_dato^.sig;

		 if ccomercial.direccion.piso=0 then aux_dato^.dato:='   ' else
		 str(ccomercial.direccion.piso,aux_dato^.dato);
		 aux_dato^.especifi:='nnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+22,y+6,3,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.direccion.letra;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+33,y+6,1,1);
		 aux_dato:=aux_dato^.sig;

		 if ccomercial.direccion.cpostal=0 then aux_dato^.dato:='     ' else
		 str(ccomercial.direccion.cpostal,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+45,y+6,5,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.direccion.localidad+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+7,40,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.direccion.provincia+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+8,40,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.exp_laboral+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+12,y+10,80,2);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.estudios+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+12,y+12,80,2);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.cif+empty;
		 aux_dato^.especifi:='xxxxxxxxxx';
		 rellena(aux_dato,x+12,y+14,10,1);
		 aux_dato:=aux_dato^.sig;

		 if ccomercial.porcentaje=0 then aux_dato^.dato:='  ' else
		 str(ccomercial.porcentaje,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+45,y+14,2,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=ccomercial.obs+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+12,y+16,80,2);
end;


procedure campos2comercial;
var
	 aux_dato:pnodo_dato;
begin
		 aux_dato:=ini_dato;

		ccomercial.telefono:=str_to_long(aux_dato^.dato);
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccomercial.codigo,cod);
		 aux_dato:=aux_dato^.sig;
		ccomercial.nombre:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccomercial.direccion.calle:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccomercial.direccion.numero,cod);
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccomercial.direccion.piso,cod);
		 aux_dato:=aux_dato^.sig;
		ccomercial.direccion.letra:=aux_dato^.dato[1];
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccomercial.direccion.cpostal,cod);
		 aux_dato:=aux_dato^.sig;
		ccomercial.direccion.localidad:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccomercial.direccion.provincia:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccomercial.exp_laboral:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccomercial.estudios:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		ccomercial.cif:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,ccomercial.porcentaje,cod);
		 aux_dato:=aux_dato^.sig;
		ccomercial.obs:=aux_dato^.dato;
end;


procedure mensajero2campos;
var
	 aux_dato:pnodo_dato;
begin
     aux_dato:=ini_dato;

		 if mmensajero.telefono=0 then aux_dato^.dato:='       ' else
		 str(mmensajero.telefono,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+12,y+1,7,1);
		 aux_dato:=aux_dato^.sig;

		 if mmensajero.codigo=0 then aux_dato^.dato:='  ' else
		 str(mmensajero.codigo,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+35,y+1,2,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.nombre+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+12,y+3,80,2);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.direccion.calle+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+5,40,1);
		 aux_dato:=aux_dato^.sig;

		 if mmensajero.direccion.numero=0 then aux_dato^.dato:='    ' else
		 str(mmensajero.direccion.numero,aux_dato^.dato);
		 aux_dato^.especifi:='nnnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+12,y+6,4,1);
		 aux_dato:=aux_dato^.sig;

		 if mmensajero.direccion.piso=0 then aux_dato^.dato:='   ' else
		 str(mmensajero.direccion.piso,aux_dato^.dato);
		 aux_dato^.especifi:='nnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+22,y+6,3,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.direccion.letra+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+33,y+6,1,1);
		 aux_dato:=aux_dato^.sig;

		 if mmensajero.direccion.cpostal=0 then aux_dato^.dato:='     ' else
		 str(mmensajero.direccion.cpostal,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+45,y+6,5,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.direccion.localidad+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+7,40,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.direccion.provincia+empty;
		 aux_dato^.especifi:=XEX40;
		 rellena(aux_dato,x+12,y+8,40,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.cif+empty;
		 aux_dato^.especifi:='xxxxxxxxxxx';
		 rellena(aux_dato,x+12,y+10,10,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.estado_civil+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+32,y+10,1,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.servicio_militar+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+42,y+10,1,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.vehiculo+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+49,y+10,1,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=mmensajero.obs+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+12,y+12,80,2);
end;


procedure campos2mensajero;
var
	 aux_dato:pnodo_dato;
begin
		 aux_dato:=ini_dato;

		mmensajero.telefono:=str_to_long(aux_dato^.dato);
		 aux_dato:=aux_dato^.sig;
			 aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,mmensajero.codigo,cod);
		 aux_dato:=aux_dato^.sig;
		mmensajero.nombre:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		mmensajero.direccion.calle:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,mmensajero.direccion.numero,cod);
		 aux_dato:=aux_dato^.sig;
       aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,mmensajero.direccion.piso,cod);
		 aux_dato:=aux_dato^.sig;
		mmensajero.direccion.letra:=aux_dato^.dato[1];
		 aux_dato:=aux_dato^.sig;
			 aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,mmensajero.direccion.cpostal,cod);
		 aux_dato:=aux_dato^.sig;
		mmensajero.direccion.localidad:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		mmensajero.direccion.provincia:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		mmensajero.cif:=aux_dato^.dato;
		 aux_dato:=aux_dato^.sig;
		mmensajero.estado_civil:=aux_dato^.dato[1];
		 aux_dato:=aux_dato^.sig;
		mmensajero.servicio_militar:=aux_dato^.dato[1];
		 aux_dato:=aux_dato^.sig;
		mmensajero.vehiculo:=aux_dato^.dato[1];
		 aux_dato:=aux_dato^.sig;
		mmensajero.obs:=aux_dato^.dato;
end;


procedure tarifa2campos_mensajeros;
var
	 aux_dato:pnodo_dato;
	 i:word;
begin
     aux_dato:=ini_dato;

		 for i:=1 to 8 do
		 begin
					aux_dato^.dato:=ini.tfas_mensajero[i].descripcion+empty;
					aux_dato^.especifi:='xxxxxxxxxxxxx';
					rellena(aux_dato,x+7,y+3+i-1,13,1);
					aux_dato:=aux_dato^.sig;

					if ini.tfas_mensajero[i].precio=0 then aux_dato^.dato:='     ' else
					str(ini.tfas_mensajero[i].precio,aux_dato^.dato);
					rellena(aux_dato,x+24,y+3+i-1,5,1);
               aux_dato^.dato:=aux_dato^.dato+empty;
					aux_dato:=aux_dato^.sig;

					if ini.tfas_mensajero[i].ex_peso=0 then aux_dato^.dato:='     ' else
					str(ini.tfas_mensajero[i].ex_peso,aux_dato^.dato);
               aux_dato^.dato:=aux_dato^.dato+empty;
					rellena(aux_dato,x+34,y+3+i-1,5,1);
					aux_dato:=aux_dato^.sig;

					if ini.tfas_mensajero[i].ex_tiempo=0 then aux_dato^.dato:='     ' else
					str(ini.tfas_mensajero[i].ex_tiempo,aux_dato^.dato);
               aux_dato^.dato:=aux_dato^.dato+empty;
					rellena(aux_dato,x+44,y+3+i-1,5,1);
					aux_dato:=aux_dato^.sig;

					if ini.tfas_mensajero[i].ex_km=0 then aux_dato^.dato:='     ' else
					str(ini.tfas_mensajero[i].ex_km,aux_dato^.dato);
               aux_dato^.dato:=aux_dato^.dato+empty;
					rellena(aux_dato,x+53,y+3+i-1,5,1);
					aux_dato:=aux_dato^.sig;

		 end;
end;


procedure campos2tarifa_mensajeros;
var
	 aux_dato:pnodo_dato;
	 i:word;
begin
		 aux_dato:=ini_dato;

		 for i:=1 to 8 do
		 begin
					ini.tfas_mensajero[i].descripcion:=aux_dato^.dato;
					aux_dato:=aux_dato^.sig;
					aux_dato^.dato:=trim(aux_dato^.dato);
					val(aux_dato^.dato,ini.tfas_mensajero[i].precio,cod);
					aux_dato:=aux_dato^.sig;
               aux_dato^.dato:=trim(aux_dato^.dato);
					val(aux_dato^.dato,ini.tfas_mensajero[i].ex_peso,cod);
					aux_dato:=aux_dato^.sig;
               aux_dato^.dato:=trim(aux_dato^.dato);
					val(aux_dato^.dato,ini.tfas_mensajero[i].ex_tiempo,cod);
					aux_dato:=aux_dato^.sig;
               aux_dato^.dato:=trim(aux_dato^.dato);
					val(aux_dato^.dato,ini.tfas_mensajero[i].ex_km,cod);
					aux_dato:=aux_dato^.sig;
		 end;
end;




procedure albaran2campos;
var
	 aux_dato:pnodo_dato;
	 temp:string;
begin

	  aux_dato:=ini_dato;

		 if aalbaran.telefono=0 then aux_dato^.dato:='       ' else
		 str(aalbaran.telefono,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+7,y+1,7,1);
		 aux_dato:=aux_dato^.sig;

		 if aalbaran.fecha.day=0 then aux_dato^.dato:='  ' else
		 str(aalbaran.fecha.day,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
       aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+26,y+1,2,1);
		 aux_dato:=aux_dato^.sig;

		 if aalbaran.fecha.month=0 then aux_dato^.dato:='  ' else
		 str(aalbaran.fecha.month,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+29,y+1,2,1);
		 aux_dato:=aux_dato^.sig;

		 if aalbaran.fecha.year=0 then aux_dato^.dato:='    ' else
		 str(aalbaran.fecha.year,aux_dato^.dato);
		 aux_dato^.especifi:='nnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+32,y+1,4,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=aalbaran.portes+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+44,y+1,1,1);
		 aux_dato:=aux_dato^.sig;


		 str(aalbaran.codigo.numero,temp);
		 aux_dato^.dato:=temp+aalbaran.codigo.letra+empty;
		 aux_dato^.especifi:='nnnnx';
		 rellena(aux_dato,x+54,y+1,5,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=aalbaran.obs+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+23,y+3,80,2);
end;


procedure campos2albaran;
var
	 aux_dato:pnodo_dato;
	 temp:string;
begin
		aux_dato:=ini_dato;

		aalbaran.telefono:=str_to_long(aux_dato^.dato);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,aalbaran.fecha.day,cod);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,aalbaran.fecha.month,cod);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,aalbaran.fecha.year,cod);
		aux_dato:=aux_dato^.sig;

		aalbaran.portes:=aux_dato^.dato[1];
		aux_dato:=aux_dato^.sig;

		val(trim(aux_dato^.dato),aalbaran.codigo.numero,cod);
		aalbaran.codigo.letra:=upcase(aux_dato^.dato[5]);
		aux_dato:=aux_dato^.sig;

		aalbaran.obs:=aux_dato^.dato;
end;


procedure casilla2campos;
var
	 aux_dato:pnodo_dato;
	 i:word;
begin

     aux_dato:=ini_dato;
		 for i:=1 to _max_casillas do
		 begin

						{ mensajero, 1 }

				if aalbaran.casilla[i].mensajero=0 then aux_dato^.dato:='  ' else
				str(aalbaran.casilla[i].mensajero,aux_dato^.dato);
				aux_dato^.especifi:='nn';
            aux_dato^.dato:=aux_dato^.dato+empty;
				rellena(aux_dato,x+6,y+3,2,1);
				aux_dato:=aux_dato^.sig;

            { serv_cliente, 2}

				if aalbaran.casilla[i].serv_cliente=0 then aux_dato^.dato:='  ' else
				str(aalbaran.casilla[i].serv_cliente,aux_dato^.dato);
				aux_dato^.especifi:='nn';
						aux_dato^.dato:=aux_dato^.dato+empty;
				rellena(aux_dato,x+16,y+3,2,1);
				aux_dato:=aux_dato^.sig;

						{ serv_mensajero, 3}

				if aalbaran.casilla[i].serv_mensajero=0 then aux_dato^.dato:='  ' else
				str(aalbaran.casilla[i].serv_mensajero,aux_dato^.dato);
				aux_dato^.especifi:='nn';
						aux_dato^.dato:=aux_dato^.dato+empty;
				rellena(aux_dato,x+26,y+3,2,1);
				aux_dato:=aux_dato^.sig;

						{ ex_peso, 4}

				if aalbaran.casilla[i].ex_peso=0 then aux_dato^.dato:='   ' else
				str(aalbaran.casilla[i].ex_peso,aux_dato^.dato);
				aux_dato^.especifi:='nnn';
						aux_dato^.dato:=aux_dato^.dato+empty;
				rellena(aux_dato,x+35,y+3,3,1);
				aux_dato:=aux_dato^.sig;

						{ ex_tiempo, 5 }

				if aalbaran.casilla[i].ex_tiempo=0 then aux_dato^.dato:='  ' else
				str(aalbaran.casilla[i].ex_tiempo,aux_dato^.dato);
				aux_dato^.especifi:='nn';
						aux_dato^.dato:=aux_dato^.dato+empty;
				rellena(aux_dato,x+48,y+3,2,1);
				aux_dato:=aux_dato^.sig;

						{ ex_km, 6}

				aux_dato^.dato:=aalbaran.casilla[i].ex_km+empty;
				aux_dato^.especifi:='nnnx';
				rellena(aux_dato,x+56,y+3,4,1);
				aux_dato:=aux_dato^.sig;

						{ facturar, 7}

				aux_dato^.dato:=aalbaran.casilla[i].facturar+empty;
				aux_dato^.especifi:='x';
				rellena(aux_dato,x+68,y+3,1,1);
				aux_dato:=aux_dato^.sig;

						{ nombre, 8}

				aux_dato^.dato:=aalbaran.casilla[i].nombre+empty;
				aux_dato^.especifi:=XEX40;
				rellena(aux_dato,x+11,y+5,40,1);
				aux_dato:=aux_dato^.sig;

						{ direccion, 9}

				aux_dato^.dato:=aalbaran.casilla[i].direccion+empty;
				aux_dato^.especifi:=XEX40;
				rellena(aux_dato,x+11,y+7,40,1);
				aux_dato:=aux_dato^.sig;

            { hora, 10 }

				aux_dato^.dato:=aalbaran.casilla[i].hora+empty;
				aux_dato^.especifi:='xxxxx';
				rellena(aux_dato,x+57,y+7,5,1);
				aux_dato:=aux_dato^.sig;

            { reembolso, 11}

				if aalbaran.casilla[i].reembolso=0 then aux_dato^.dato:='        ' else
            str(aalbaran.casilla[i].reembolso,aux_dato^.dato);
				aux_dato^.especifi:='nnnnnnnnnn';
				rellena(aux_dato,x+11,y+9,10,1);

				aux_dato^.dato:=aux_dato^.dato+empty;
				aux_dato:=aux_dato^.sig;
		 end;
end;


procedure campos2casilla;
var
	 aux_dato:pnodo_dato;
	 i:word;
begin
		 aux_dato:=ini_dato;

		 for i:=1 to _max_casillas do
		 begin
						aux_dato^.dato:=trim(aux_dato^.dato);
				val(aux_dato^.dato,aalbaran.casilla[i].mensajero,cod);
				aux_dato:=aux_dato^.sig;

            aux_dato^.dato:=trim(aux_dato^.dato);
				val(aux_dato^.dato,aalbaran.casilla[i].serv_cliente,cod);
				aux_dato:=aux_dato^.sig;

				aux_dato^.dato:=trim(aux_dato^.dato);
				val(aux_dato^.dato,aalbaran.casilla[i].serv_mensajero,cod);
				aux_dato:=aux_dato^.sig;

						aux_dato^.dato:=trim(aux_dato^.dato);
				val(aux_dato^.dato,aalbaran.casilla[i].ex_peso,cod);
				aux_dato:=aux_dato^.sig;

						aux_dato^.dato:=trim(aux_dato^.dato);
				val(aux_dato^.dato,aalbaran.casilla[i].ex_tiempo,cod);
				aux_dato:=aux_dato^.sig;

				aalbaran.casilla[i].ex_km:=aux_dato^.dato;
				aux_dato:=aux_dato^.sig;

				aalbaran.casilla[i].facturar:=aux_dato^.dato[1];
				aux_dato:=aux_dato^.sig;

				aalbaran.casilla[i].nombre:=aux_dato^.dato;
				aux_dato:=aux_dato^.sig;

				aalbaran.casilla[i].direccion:=aux_dato^.dato;
				aux_dato:=aux_dato^.sig;

				aalbaran.casilla[i].hora:=aux_dato^.dato;
				aux_dato:=aux_dato^.sig;

				aux_dato^.dato:=trim(aux_dato^.dato);
				aalbaran.casilla[i].reembolso:=str_to_long(aux_dato^.dato);
				aux_dato:=aux_dato^.sig;
		 end;
end;


procedure factura_general_head2campos;
var
	 aux_dato:pnodo_dato;
	 temp:string;
begin
	  aux_dato:=ini_dato;

		 if head.telefono=0 then aux_dato^.dato:='       ' else
		 str(head.telefono,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+7,y+1,7,1);
		 aux_dato:=aux_dato^.sig;

		 if head.fecha.day=0 then aux_dato^.dato:='  ' else
		 str(head.fecha.day,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+26,y+1,2,1);
		 aux_dato:=aux_dato^.sig;

		 if head.fecha.month=0 then aux_dato^.dato:='  ' else
		 str(head.fecha.month,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+29,y+1,2,1);
		 aux_dato:=aux_dato^.sig;

		 if head.fecha.year=0 then aux_dato^.dato:='    ' else
		 str(head.fecha.year,aux_dato^.dato);
		 aux_dato^.especifi:='nnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+32,y+1,4,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=head.pagado+empty;
		 aux_dato^.especifi:='x';
		 rellena(aux_dato,x+44,y+1,1,1);
		 aux_dato:=aux_dato^.sig;


		 str(head.num_factura.numero,temp);
		 aux_dato^.dato:=temp+head.num_factura.letra+empty;
		 aux_dato^.especifi:='nnnnx';
		 rellena(aux_dato,x+54,y+1,5,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=head.obs+empty;
		 aux_dato^.especifi:=XEX80;
		 rellena(aux_dato,x+23,y+3,80,2);
		 aux_dato:=aux_dato^.sig;

		 if head.fecha_pago.day=0 then aux_dato^.dato:='  ' else
		 str(head.fecha_pago.day,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+14,y+6,2,1);
		 aux_dato:=aux_dato^.sig;

		 if head.fecha_pago.month=0 then aux_dato^.dato:='  ' else
		 str(head.fecha.month,aux_dato^.dato);
		 aux_dato^.especifi:='nn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+17,y+6,2,1);
		 aux_dato:=aux_dato^.sig;

		 if head.fecha_pago.year=0 then aux_dato^.dato:='    ' else
		 str(head.fecha.year,aux_dato^.dato);
		 aux_dato^.especifi:='nnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+20,y+6,4,1);
		 aux_dato:=aux_dato^.sig;

		 aux_dato^.dato:=head.tipo_pago+empty;
		 aux_dato^.especifi:='xxxxxxxxxxxxxxxxxxxx';
		 rellena(aux_dato,x+39,y+6,20,1);

end;

procedure campos2factura_general_head;
var
	 aux_dato:pnodo_dato;
	 temp:string;
begin

		aux_dato:=ini_dato;

		head.telefono:=str_to_long(aux_dato^.dato);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,head.fecha.day,cod);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,head.fecha.month,cod);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,head.fecha.year,cod);
		aux_dato:=aux_dato^.sig;

		head.pagado:=aux_dato^.dato[1];
		aux_dato:=aux_dato^.sig;

		val(trim(aux_dato^.dato),head.num_factura.numero,cod);
		head.num_factura.letra:=upcase(aux_dato^.dato[5]);
		aux_dato:=aux_dato^.sig;

		head.obs:=aux_dato^.dato;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,head.fecha_pago.day,cod);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,head.fecha_pago.month,cod);
		aux_dato:=aux_dato^.sig;

		aux_dato^.dato:=trim(aux_dato^.dato);
		val(aux_dato^.dato,head.fecha_pago.year,cod);
		aux_dato:=aux_dato^.sig;

		head.tipo_pago:=aux_dato^.dato;

end;

procedure factura_general_pie2campos;
var
	 aux_dato:pnodo_dato;
	 temp:string;
begin
		 aux_dato:=ini_dato;

		 if head.totales.total=0 then aux_dato^.dato:='        ' else
		 str(head.totales.total,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+1,y+2,9,1);
		 aux_dato:=aux_dato^.sig;

		 if head.descuento=0 then aux_dato^.dato:='   ' else
		 str(head.descuento,aux_dato^.dato);
		 aux_dato^.especifi:='nnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+11,y+2,3,1);
		 aux_dato:=aux_dato^.sig;

		 if head.iva=0 then aux_dato^.dato:='    ' else
		 str(head.iva:2:2,aux_dato^.dato);
		 aux_dato^.especifi:='nn.n';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+17,y+2,4,1);
		 aux_dato:=aux_dato^.sig;

		 if head.totales.iva=0 then aux_dato^.dato:='         ' else
		 str(head.totales.iva,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+23,y+2,9,1);
		 aux_dato:=aux_dato^.sig;

		 if head.totales.descuento=0 then aux_dato^.dato:='         ' else
		 str(head.totales.descuento,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+33,y+2,9,1);
		 aux_dato:=aux_dato^.sig;

		 if head.totales.recargo_eq=0 then aux_dato^.dato:='         ' else
		 str(head.totales.recargo_eq,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+43,y+2,9,1);
		 aux_dato:=aux_dato^.sig;

		 if head.total_neto=0 then aux_dato^.dato:='         ' else
		 str(head.total_neto,aux_dato^.dato);
		 aux_dato^.especifi:='nnnnnnnnn';
		 aux_dato^.dato:=aux_dato^.dato+empty;
		 rellena(aux_dato,x+54,y+2,9,1);
end;



procedure campos2factura_general_pie;
var
	 aux_dato:pnodo_dato;
	 temp:string;
begin

		aux_dato:=ini_dato;

		head.totales.total:=str_to_long(aux_dato^.dato);
		aux_dato:=aux_dato^.sig;

		val(trim(aux_dato^.dato),head.descuento,cod);
		aux_dato:=aux_dato^.sig;

		val(trim_real(aux_dato^.dato),head.iva,cod);
		aux_dato:=aux_dato^.sig;

		head.totales.descuento:=str_to_long(aux_dato^.dato);
		aux_dato:=aux_dato^.sig;

		head.totales.iva:=str_to_long(aux_dato^.dato);
		aux_dato:=aux_dato^.sig;

		head.totales.recargo_eq:=str_to_long(aux_dato^.dato);
		aux_dato:=aux_dato^.sig;

		head.total_neto:=str_to_long(aux_dato^.dato);

end;

begin
end.


