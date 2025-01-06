(****************************************************************************)
(****************************************************************************)
(*                                                                          *)
(*                                                                          *)
(*                           SOCIOS ACTE 1.0                                *)
(*                       ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ                           *)
(*                                                                          *)
(*    Autor  : Argos (Iv n Gonz lez Angullo)                                *)
(*                                                                          *)
(*    Unidad : "DEFS.PAS"                                                   *)
(*                                                                          *)
(*    Fecha  : 27/3/1997                                                    *)
(*                                                                          *)
(*    Descripcion : Definiciones de Tipos y Variables del Programa.         *)
(*                                                                          *)
(*    Observacion : Creo que ya est  como dios manda ..:-)                  *)
(*                                                                          *)
(****************************************************************************)
(****************************************************************************)

UNIT DEFS;

interface

uses windos;


(* Tipos de Datos *)

TYPE


	{ para las fechas }

	t_date = record
		 Year,Month,Day,Weekday : Word;
	end;


	{ formato del n§ de D.N.I }

	t_dni = longint;


	{ direccion }

	t_direccion = record
		piso                        : byte;
		numero, cpostal             : word;
		letra                       : char;
		calle, localidad, provincia : string[40];
	end;



	{ socios }

	t_socio = record
		nombre		: string[40];
		obs 		: string[80];
		dni         : t_dni;
		tfno_curso	: longint;
		dir_curso   : t_direccion;
		tfno_casa	  : longint;
		dir_casa    : t_direccion;
		saldo       : word;
		bday        : t_date;
		ini_date    : t_date;
	end;



	{ Actividades del socio }

	t_acto = record
		fecha       : t_date;
		descripcion : string[40];
		papel       : string[15];
	end;


	{ Actividades de un Area de ACTE }

	t_actividad = record
		fecha       : t_date;
		descripcion : string[40];
		responsable : string[40];
	end;



	{ Movimiento monetario }

	t_transac = record
		fecha       : t_date;
		ingreso     : boolean;
		cuantia     : word;
		descripcion : string[40];
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



	{ Estructura de t_dni y pos en fichero para hacer b£squedas m s r pidas }

	t_dni_ndx = record
		dni : t_dni;
		pos : word;
	end;


	{ Idem con el Nombre y Apellido }
	t_alfab_ndx = record
		nombre : string[35];
		pos    : word;
	end;


	{ Configuracion del programilla }

	t_ini=record
		key             : array [1..10] of byte; {Para almacenar la clave}
		work            : string[40];
		cuota           : word;
		saldo           : longint;
		last_fact_month : t_date;
	end;



	{ Acceso directo a la VGA }

	videomatrix=array [1..4000] of byte;


	{ tipos de ficheros }

	t_fich_socios = file of t_socio;

	t_fich_actos  = file of t_acto;

	t_fich_area   = file of t_actividad;

	t_fich_money  = file of t_transac;

	t_fich_dni    = file of t_dni_ndx;

	t_fich_alfab  = file of t_alfab_ndx;


(* Variables Globales del programa *)


VAR

fecha_sistema : t_date; { fecha sistema }

socio         : t_socio; { Socio tipo..}

ini           : t_ini; { Configura‡ao }

var_result    : integer; { Para cuando hace falta una int. para una pijada }

max_socios    : word;

fichsocios    : t_fich_socios; { Toooodos los socios estar n aqui.. }
tempsocios    : t_fich_socios; { Idem pero temporalmente (TMP)}

fich_money    : t_fich_money; { Fichero con las t_transac de un socio }
temp_money    : t_fich_money; { Fichero TMP con las t_transac de un socio }

fich_actos    : t_fich_actos; { Fichero con las t_actos de un socio }
temp_actos    : t_fich_actos; { Fichero TMP con las t_actos de un socio }

fich_area     : t_fich_area;  { Otro, este con las actividades de un Area }
temp_area     : t_fich_area;  { Este con las actividades (TMP) de un Area }

dni_ndx       : t_fich_dni;  { Fichero con el ¡ndice por DNI's }
temp_dni      : t_fich_dni;  { Fichero con el ¡ndice por DNI's..  TMP}

alfab_ndx     : t_fich_alfab; { El ¡ndice Alfab‚tico }
temp_alfab    : t_fich_alfab; { El ¡ndice Alfab‚tico.. TMP }


fichero  : string[11];
regs     : tregisters;
contador : byte;
empty    : string;
prnt     : text;

pantalla : videomatrix absolute ($B800):$0000;



implementation
end.