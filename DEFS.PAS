unit defs;

interface

uses windos;

const

XEX80='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
XEX40='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

_MAX_CLIENTE_CAMPOS=16;
_MAX_MENSAJERO_CAMPOS=15;
_MAX_COMERCIAL_CAMPOS=15;
_MAX_ALBARAN_CAMPOS=7;
_MAX_CASILLAS_CAMPOS=11;
_MAX_TFAS_CLIENTE=9;
_MAX_TFAS_MENSAJERO=8;
_MAX_CASILLAS=8;
_MAX_CLIENTES=1000;
_MAX_FACTURA_HEAD_CAMPOS=11;
_MAX_FACTURA_PIE_CAMPOS=7;

type


{
// ***********************************************************************
// ***********************************************************************
//
// Definiciones de tipos y variables
//
// ***********************************************************************
// ***********************************************************************
}


		t_index=record
								numero:word;
								letra:char;
								pos:longint;
								end;

		t_index2=record
						 fecha     : longint;
						 pos       : longint;
						 facturado : boolean;


							end;


		t_cod_dsk=record
								numero:word;
								letra :char;
								disco :word;
								pos   :longint;
							end;



t_s=record
	cantidad:word;
	peso,tiempo,km:word;
end;

t_resul=record
	codigo:string;
	fecha:string;
	s:array [1..8] of t_s;
	subtotal:longint;
end;



{ para las fechas }

t_date = record
	 Year,Month,Day,Weekday : Word;
	 end;


{ estructuras para la matriz din mica de datos }

pnodo_dato=^t_nodo_dato;
t_nodo_dato=record
		dato:string;
		especifi:string;
		ini_x,ini_y,lineas,longitud:byte;
		sig:pnodo_dato;
		ant:pnodo_dato;
end;


{ tarifa en general }

t_tarifas=record
	descripcion : string[13];
	ex_peso,ex_tiempo,precio: word;
	ex_km : word;
	 end;


{ direccion }

t_direccion=record
	piso : byte;
	 numero, cpostal : word;
	letra : char;
	calle, localidad, provincia : string[40];
	 end;


{ cliente }

t_cliente=record
			nombre, obs : string[80];
			cif : string[10];
			forma_pago : string[40];
			comercial, descuento : byte;
			recargo_eq : char;
			telefono : longint;
			direccion : t_direccion;
			tarifas : array [1..9] of t_tarifas;
			ini_date : t_date;
			cobrar_reemb : char;
				 end;


{ datos de un comercial }

t_comercial=record
				 nombre, estudios, exp_laboral, obs : string[80];
				 cif : string[10];
				 direccion : t_direccion;
				 codigo,porcentaje:byte;
				 telefono : longint;
						end;



{datos de un mensajero }

t_mensajero=record
				 nombre, obs : string[80];
				 cif : string[10];
				 estado_civil, servicio_militar, vehiculo : char;
				 codigo : byte;
				 telefono : longint;
				 direccion : t_direccion;
						 end;


{ estructura para los albaranes }

t_servicio=record
					mensajero, serv_cliente, serv_mensajero : byte;
					ex_peso, ex_tiempo : word;
					ex_km : string[5];
					nombre, direccion : string[40];
					hora : string[5];
					facturar : char;
					reembolso : longint;
					 end;

t_codigo=record
						numero : word;
						letra  : char;
				 end;

t_albaran=record
			telefono : longint;
			codigo : t_codigo;
			casilla : array [1..8] of t_servicio;
			portes : char; { Pagados o Debidos }
			fecha : t_date;
			obs : string[80];
	end;


resumen_serv=array [1..9] of word;


listalbs = ^tipo_albs;

tipo_albs=record
	codigo : t_codigo;
	fecha  : t_date;
	num_factura:t_codigo;
	se     : resumen_serv;
	temp   : longint;
	sig    : listalbs
end;


t_fichalbs = file of t_albaran;

t_foot=record
				 total,descuento,iva,recargo_eq:longint;
			 end;


t_factura_serv=record
										 servicio:byte;
										 cantidad:byte;
										 end;
{
t_factura_servs=record
								codigo:t_codigo;
								fecha:t_date;
								num_factura:t_codigo;
								servicios:resumen_serv;
								subtotal:longint;
							 end;
} (* tipo invalidado en favor de tipo_albs, que es calcado gracias
a la toposidad de Ivan *)

t_factura_head=record
								telefono : longint;
								fecha : t_date;
								num_factura : t_codigo;
								pagado:char;
								tipo_pago:string[20];
								totales:t_foot;
								fecha_pago:t_date;
								iva:real;
								descuento:byte;
								obs:string[80];
								total_neto:longint;
								ini_line:longint; (* pos de la 1¦ linea de
														albaranes en fact_alb.dat *)
						end;


t_telefonos = array [1.._MAX_CLIENTES] of longint;


t_monthly_stats=record
	fecha          : t_date;
	client_num     : word;
	new_client     : word;
	dealers_client : array [1..10] of word;
	income         : longint
end;


t_status=record
							 timeout:boolean;
							 io_error:boolean;
							 printer_selected:boolean;
							 paper_out:boolean;
							 acknow:boolean;
							 busy:boolean;
							 end;


t_serv=array [1..8] of word;

t_servs=array [1..4,1..8] of word; {Para facturar los mensajeros}

t_subts=array [1..8] of longint;

str_11=string[11];

str_40=string[40];



t_ini=record
				tfas_defecto:array [1..9] of t_tarifas;
				tfas_mensajero:array [1..8] of t_tarifas;
				pts_c_km : word;
				pts_m_km : word;
				key      : array [1..10] of byte; {Para almacenar la clave}
				last_disk: word;
				new_disk : boolean;
				try      : longint;        {Para el periodo de prueba}
				iva      : real;
				work     : str_40;
				permit   : boolean;
				last_fact_month : str_11;
				m_income : longint;
				last_fact_number:longint;
			end;


aga=record
	pth:string;
	code:longint;
end;

videomatrix=array [1..4000] of byte;

var

fecha_sistema : t_date; {// fecha sistema}

ini:t_ini;

telefonos:t_telefonos; {telefonos globalmente hablando}

var_result:integer;

max_clientes:word;
max_mensajeros:word;
max_comerciales:word;
max_albaranes:word;
max_facturas:word;
max_lineas_alb:longint;


fichalbs    : t_fichalbs;
tempalbs    : t_fichalbs;
fichfact    : file of t_factura_head;
tempfact    : file of t_factura_head;
fichlin     : file of tipo_albs;
templin     : file of tipo_albs;
albsdsk     : file of t_albaran;
fichclientes: file of t_cliente;
tempclientes: file of t_cliente;
fichcomercia: file of t_comercial;
tempcomercia: file of t_comercial;
fichmessager: file of t_mensajero;
tempmessager: file of t_mensajero;
cod_ndx     : file of t_index;
temp_cod_ndx: file of t_index;
fec_ndx     : file of t_index2;
temp_fec_ndx: file of t_index2;
fact_ndx    : file of t_index;
temp_fact_ndx: file of t_index;
cod_dsk     : file of t_cod_dsk;
temp_cod_dsk: file of t_cod_dsk;


f_albaran: str_11;
tpath    : str_40;
tfile    : str_11;
fichero  : str_11;
regs     : tregisters;
contador : byte;
empty    : string;
prnt     : text;

albaran_borrado:boolean;
pantalla:videomatrix;


implementation

begin
end.
