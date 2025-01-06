unit formulas;

interface

	uses defs,common;

	procedure total_albaran_cliente (var foot:t_foot; var ccliente:t_cliente);
	function calcular_albaran(var alb:t_albaran; var ccliente:t_cliente;
														var s:resumen_serv):longint;

	procedure total_albaran_mensajero (var alb:t_albaran; codigo : byte;
																			var sr:t_servs;
																			var st:t_subts);

	function total_neto_comercial (var comercial:t_comercial; total:longint):longint;

	procedure calcula_factura (bruto:longint;descuento:word;VAR base_iva:word;
																													VAR iva:word;
																													VAR re:word;
																													VAR neto:word);


implementation

var cod:word;

function calcular_albaran;
var
	pts_m_km,pts_c_km:byte;
	i,k:byte;
	subt:longint;
	sub,subkm,subpeso,subtiempo,vkm:word;

begin

	for k:=1 to 9 do s[k]:=0;
	subt:=0;

	for i:=1 to 8 do
		begin

			with alb.casilla[i] do
				begin
					subkm:=0;
					subtiempo:=0;
					subpeso:=0;
					vkm:=0;

					if facturar='s' then
						begin
							if serv_cliente<>0 then
								begin
								 inc(s[serv_cliente]);
								 subt:=subt+ccliente.tarifas[serv_cliente].precio;
								 val(trim(ex_km),vkm,cod);
								 subkm:=vkm*ccliente.tarifas[serv_cliente].ex_km;
								 subpeso:=ex_peso*ccliente.tarifas[serv_cliente].ex_peso;
								 subtiempo:=ex_tiempo*ccliente.tarifas[serv_cliente].ex_tiempo;
								 if ccliente.cobrar_reemb='s' then subt:=subt+round(0.03*reembolso);
								 subt:=subt+subkm+subpeso+subtiempo;
							end
							else begin
								val(trim(ex_km),vkm,cod);
								k:=1;
								while (ex_km[k] in ['0'..'9']) do inc(k);
								if (ex_km[k]='c') or (ex_km[k]='C') then subkm:=vkm*ini.pts_c_km;
								if (ex_km[k]='m') or (ex_km[k]='M') then subkm:=vkm*ini.pts_m_km;
								if ccliente.cobrar_reemb='s' then subt:=subt+round(0.03*reembolso);
								subt:=subt+subkm;
							end;
					end; {if fact}

			 end; {with}
		end; {for}

		calcular_albaran:=subt;
end; {func}


procedure total_albaran_cliente;
var
	temp:real;
	t:real;

begin

	  foot.descuento:=0;
	  foot.iva:=0;
	  foot.recargo_eq:=0;
		t:=ccliente.descuento;
		temp:=foot.total*(t / 100);
		foot.descuento:=round(temp);
		temp:=(foot.total-foot.descuento)*(ini.iva / 100);
		foot.iva:=round(temp);
	  if ccliente.recargo_eq='s' then
	  begin
			 temp:=foot.iva*0.04;
			 foot.recargo_eq:=round(temp);
	  end;
end;




(* Calcula el total de un albar n para un mensajero *)

	procedure total_albaran_mensajero;
		var
			k,tarifa : byte;
			km,tm,wt : longint;
		begin
			for k:=1 to _MAX_CASILLAS do
				begin
					if alb.casilla[k].mensajero=codigo then with alb.casilla[k] do
						begin
							tarifa := serv_mensajero;
							if (tarifa<>0) then
								begin
									inc(sr[1,tarifa]);
									sr[2,tarifa]:=sr[2,tarifa]+ex_peso;
									sr[3,tarifa]:=sr[3,tarifa]+ex_tiempo;

									val(trim(ex_km),km,cod);

									sr[4,tarifa]:=sr[4,tarifa]+km;
									km          := km * ini.tfas_mensajero[tarifa].ex_km;
									tm          := ex_tiempo*ini.tfas_mensajero[tarifa].ex_tiempo;
									wt          := ex_peso*ini.tfas_mensajero[tarifa].ex_peso;
									st[tarifa]  := st[tarifa]+ini.tfas_mensajero[tarifa].precio+km+wt+tm;
								end
						end
				end
		end;



(* Calcula el porcentaje de un albar n par un comercial *)

	function total_neto_comercial(var comercial:t_comercial;total:longint):longint;
		var ttotal : longint;
		begin
			ttotal:=(total*comercial.porcentaje)div 100;
			total_neto_comercial:=ttotal
		end;



(* Calcula una factura *)

	procedure calcula_factura(bruto:longint;descuento:word;VAR base_iva:word;
																												 VAR iva:word;
																												 VAR re:word;
																												 VAR neto:word);
		var
			tmp:real;
		begin
			base_iva:=bruto-((bruto*descuento) div 100);
			tmp     :=    ((base_iva*ini.iva) /  100);
			iva     :=round(tmp);
			re      :=               ((iva*4) div  100);
			neto    :=                 base_iva+iva+re;
		end;


end.
