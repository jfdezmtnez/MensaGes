unit ficheros;

interface

uses defs,common,crt;

var

	tam:longint;


function scan_socios_f:word;

function busca_socio_f (var ssocio:t_socio;pos:word):word;

procedure ins_socio_f (var ssocio:t_socio; var max_socios:word);

(* No se si nos hara falta este....*)
procedure borra_socio_f (pos:word; var max_socios:word);

procedure create_cod_index;
procedure create_alfa_index;

procedure actualiza_cod_index(num:t_dni);
procedure actualiza_alfa_index(nom:string[35]);

function busca_index_cod(num:t_dni;var i:byte):word;
function busca_index_alfa(nom:string[35]):word;

procedure desactiva_socio(pos:word);
procedure limpia;

procedure borra_cod_index(num:t_dni);
{
procedure borra_cod_dsk(codigo:t_codigo);
}
procedure borra_alfa_index(nom:string[35];pos:longint);
{
procedure archiva_f (lim:longint);

procedure crea_factura_ndx;
procedure actualiza_fact_index(codigo:t_codigo);
procedure borra_fact_index(codigo:t_codigo);
function busca_index_fact(codigo:t_codigo; var i:byte):word;
procedure borra_factura_f (pos:word);
function busca_factura_f(var head:t_factura_head; var punt:listalbs; pos:word):byte;
}

(* Pueden valer para lo de las actividades y las transacs..*)

function graba_factura_head(var j:t_factura_head; var lista:listalbs):byte;
function graba_factura_lines(var j:t_factura_head; var lista:listalbs):byte;

procedure borra_lista_facturas(var ini:listalbs);
procedure borra_lin_fact(codigo:t_codigo);





implementation


	uses campstru,graficos,windos ;


(* Devuelve el n즡ero de socios en el fichero *)

	function scan_socios_f;
	var
		k : word;
	begin
		k:=0;
		{$I-}
		Reset(fichsocios);
		{$I+}
		if IOresult=0 then
			begin
				scan_socios_f:=filesize(fichsocios);
				close(fichsocios);
			end else scan_socios_f:=0;
	end;


(* Las funciones de b즧queda en fichero devuelven 0 si no existe el fichero o
no existe el buscado *)

(* Lee los datos de un socio de un fichero dado *)

	function busca_socio_f;
	begin
		{$I-}
		reset(fichsocios);
		{$I+}
		if ioresult=0 then
			begin
				seek(fichsocios,pos-1);
				read(fichsocios,ssocio);
				close(fichsocios);
				busca_socio_f:=pos
			end
			else
				begin
					error(10)
					busca_socio_f:=0
				end

	end;



(* A쨅dir un socio *)

procedure ins_socio_f;

var
	aux  : t_socio;

begin
	{$I-}
	Reset(fichsocios);
	{$I+}
	if ioresult<>0 then
		begin
			rewrite(fichsocios);
			write(fichsocios,ssocio);
			inc(max_socios)
		end
		else begin
			seek(fichsocios,filesize(fichsocios));
			write(fichsocios,ssocio);
			inc(max_socios);
		end;
	close(fichsocios)
end;



	procedure borra_cliente_f;
	var
		aux  : t_cliente;
		k    : word;
	begin

		{$I-}
		Reset(fichclientes);
		{$I+}
		if ((IOresult<>0)or(max_clientes=0)) then
			begin
				error(1);
				lowbar('Men� Clientes')
			end
			else begin
				Rewrite(tempclientes);
				for k:=1 to pos-1 do
					begin
						read(fichclientes,aux);
						write(tempclientes,aux);
					end;
				read(fichclientes,aux);
				while not eof(fichclientes) do
					begin
						read(fichclientes,aux);
						write(tempclientes,aux);
					end;
				close(fichclientes);
				close(tempclientes);
				erase(fichclientes);
				rename(tempclientes,ini.work+'clientes.dat');
				assign(tempclientes,ini.work+'clientes.tmp');
				assign(fichclientes,ini.work+'clientes.dat')
			end
	end;




(* Eliminar un comercial *)

	procedure borra_comercial_f;
	var
		aux  : t_comercial;
		k    : word;
	begin
		{$I-}
		Reset(fichcomercia);
		{$I+}
		if((IOresult<>0)or(max_comerciales=0))then
			begin
				error(4);
				lowbar('Men� Comerciales')
			end
			else begin
				Rewrite(tempcomercia);
				for k:=1 to pos-1 do
					begin
						read(fichcomercia,aux);
						write(tempcomercia,aux);
					end;
				read(fichcomercia,aux);
				while not eof(fichcomercia) do
					begin
						read(fichcomercia,aux);
						write(tempcomercia,aux);
					end;
				close(fichcomercia);
				close(tempcomercia);
				erase(fichcomercia);
				rename(tempcomercia,ini.work+'dealers.dat');
				assign(tempcomercia,ini.work+'dealers.tmp');
				assign(fichcomercia,ini.work+'dealers.dat');
				dec(max_comerciales)
			end
	end;



(* Borrar un mensajero *)

	procedure borra_mensajero_f;
	var
		aux  : t_mensajero;
		k    : word;
	begin
		{$I-}
		Reset(fichmessager);
		{$I+}
		if((IOresult<>0)or(max_mensajeros=0)) then
			begin
				error(7);
				lowbar('Men� Mensajeros')
			end
			else begin
				Rewrite(tempmessager);
				for k:=1 to pos-1 do
					begin
						read(fichmessager,aux);
						write(tempmessager,aux);
					end;
				read(fichmessager,aux);
				while not eof(fichmessager) do
					begin
						read(fichmessager,aux);
						write(tempmessager,aux);
					end;
				close(fichmessager);
				close(tempmessager);
				erase(fichmessager);
				rename(tempmessager,ini.work+'messager.dat');
				assign(tempmessager,ini.work+'messager.tmp');
				assign(fichmessager,ini.work+'messager.dat');
				dec(max_mensajeros)
			end
	end;



(* Destruir albaran *)

	procedure borra_albaran_f;
	var
		aux  : t_albaran;
		k    : word;
	begin
		{$I-}
		Reset(fichalbs);
		{$I+}
		if ((IOresult<>0)or(max_albaranes=0)) then
			begin
				error(10);
				lowbar('Men� Albaranes')
			end
			else begin
				Rewrite(tempalbs);
				for k:=1 to pos-1 do
					begin
						read(fichalbs,aux);
						write(tempalbs,aux);
					end;
				read(fichalbs,aux);
				while not eof(fichalbs) do
					begin
						read(fichalbs,aux);
						write(tempalbs,aux);
					end;
				close(fichalbs);
				close(tempalbs);
				erase(fichalbs);
				rename(tempalbs,ini.work+'albaran.dat');
				assign(tempalbs,ini.work+'albaran.tmp');
				assign(fichalbs,ini.work+'albaran.dat');
				dec(max_albaranes)
			end
	end;


procedure create_cod_index;
const max=1750;
var
	 albaran : t_albaran;
	 indice  : t_index;
	 cad     : string;
	 indices : array [1..max] of t_index;
	 i,j,n   : longint;
	 temp    : t_index;
	 total   : longint;
	 anho,mes,dia:longint;
	 l,cont  : word;
	 t       : char;
	 validos : word;

begin
	{$I-}
	reset(fichalbs); { abre para leer albaran.dat}
	{$I+}
	if((ioresult=0) and (max_albaranes<>0)) then
		begin
			rewrite(cod_ndx); {abre para escritura albaran.ndx}

			cont   :=1;
			validos:=0;
			while not(eof(fichalbs)) do
				begin
					read(fichalbs,albaran);
					if (albaran.codigo.numero<>0)and
							(albaran.codigo.letra<>' ')and
							(albaran.telefono<>0) then
					begin
							indice.numero:=albaran.codigo.numero;
							indice.letra:=albaran.codigo.letra;
							indice.pos:=cont;
							write(cod_ndx,indice);
							inc(validos);
						end;
					inc(cont);
				end;
			close(fichalbs); {cierra albaran.dat;}

			tam:=filesize(cod_ndx);

			{copia albaran.ndx en memoria }

			reset(cod_ndx); {abre para leer codigo.ndx}
			cont:=1;
			while not(eof(cod_ndx)) do
				begin
					read(cod_ndx,indice);
					indices[cont]:=indice;
					inc(cont);
				end;

		 { ordena el array en memoria }

			 tam:=cont-1;

			for i:=1 to tam do
				for j:=1 to tam-1 do
				if indices[j].numero>indices[j+1].numero then
					begin
						temp:=indices[j];
						indices[j]:=indices[j+1];
						indices[j+1]:=temp;
					end;

				 { reescribe albaran.ndx con el array }

			rewrite(cod_ndx); {abre para escribir codigo.ndx}
			for i:=1 to tam do write(cod_ndx,indices[i]);
			close(cod_ndx) {cierra codigo.ndx}
		end;

	if max_albaranes=0 then rewrite(cod_ndx)

end;


procedure create_fec_index;
const max=1750;
var
	 calbaran : t_albaran;
	 validos : word;
	 i,j,n   : longint;
	 indices2: array [1..max] of t_index2;
	 indice2 : t_index2;
	 total   : longint;
	 anho,mes,dia:longint;
	 l,cont  : word;
	 temp2   : t_index2;
	 t       : char;

begin
	{$I-}
	reset(fichalbs);
	{$I+}
	if ((ioresult=0) and (max_albaranes<>0))  then
		begin
			rewrite(fec_ndx);
			cont   :=1;
			validos:=0;

			while not(eof(fichalbs)) do
				begin
					read(fichalbs,calbaran);
					if (calbaran.codigo.numero<>0)and(calbaran.codigo.letra<>' ')and
					 (calbaran.telefono<>0) then
						begin
							anho:=calbaran.fecha.year-1900;
							anho:=anho*10000;
							mes:=calbaran.fecha.month;
							mes:=mes*100;
							dia:=calbaran.fecha.day;

							indice2.fecha:=anho+mes+dia;
							indice2.pos:=cont;
							indice2.facturado:=false;
							write(fec_ndx,indice2);
							inc(validos);
						end;
					inc(cont);

				end;

			close(fichalbs); {cierra definitivamente albaran.dat}

			tam:=filesize(fec_ndx);

			cont:=1;
			reset(fec_ndx); {abre para leer fecha.ndx}

			while not(eof(fec_ndx)) do
				begin
					read(fec_ndx,indice2);
					indices2[cont].fecha:=indice2.fecha;
					indices2[cont].pos:=indice2.pos;
					indices2[cont].facturado:=indice2.facturado;
					inc(cont);
				end;

			{Sorting FECHA.NDX...}

			tam:=cont-1;

			for i:=1 to tam do
				for j:=1 to tam-1 do
					if indices2[j].fecha>indices2[j+1].fecha then
						begin
							temp2:=indices2[j];
							indices2[j]:=indices2[j+1];
							indices2[j+1]:=temp2;
						end;


			rewrite(fec_ndx); {abre para escribir FECHA.NDX}

			{Rewriting...}

			for i:=1 to tam do write(fec_ndx,indices2[i]);

			close(fec_ndx) {cierra FECHA.NDX}
		end;
	if max_albaranes=0 then rewrite(fec_ndx)
end;




procedure actualiza_cod_index;
var
	ind,indice: t_index;
	condicion:boolean;

begin

	{$I-}
	reset(cod_ndx);
	{$I+}
	if ioresult=0 then
		begin
			rewrite(temp_cod_ndx);

			indice.numero:=codigo.numero;
			indice.letra:=codigo.letra;
			indice.pos:=max_albaranes;


			condicion:=true;

			while not(eof(cod_ndx)) do
				begin

					read(cod_ndx,ind);
					if (condicion)and(indice.numero<=ind.numero) then
						begin
							write(temp_cod_ndx,indice);
							condicion:=false
						end;
					write(temp_cod_ndx,ind);

				end;

			if condicion=true then write(temp_cod_ndx,indice);

			close(cod_ndx);
			close(temp_cod_ndx);

			erase(cod_ndx);
			rename(temp_cod_ndx,ini.work+'codigo.ndx');
			assign(temp_cod_ndx,ini.work+'codigo.tmp');
			assign(cod_ndx,ini.work+'codigo.ndx')
		end
		else create_cod_index;

end;


procedure borra_cod_index;
var
	ind,indice  : t_index;
begin
	reset(cod_ndx);
	rewrite(temp_cod_ndx);

	tam:=filesize(cod_ndx);

	while not(eof(cod_ndx)) do
		begin
			read(cod_ndx,ind);
			if not((ind.letra=codigo.letra)and
				 (ind.numero=codigo.numero)) then write(temp_cod_ndx,ind);
		end;
 {dec(max_albaranes);}
	tam:=filesize(temp_cod_ndx);

	close(cod_ndx);
	close(temp_cod_ndx);

	erase(cod_ndx);
	rename(temp_cod_ndx,ini.work+'codigo.ndx');
	assign(temp_cod_ndx,ini.work+'codigo.tmp');
	assign(cod_ndx,ini.work+'codigo.ndx')

end;



procedure borra_cod_dsk;
var
	ind,indice  : t_cod_dsk;
begin
	reset(cod_dsk);
	rewrite(temp_cod_dsk);

	tam:=filesize(cod_dsk);

	while not(eof(cod_dsk)) do
		begin
			read(cod_dsk,ind);
			if not((ind.letra=codigo.letra)and
				 (ind.numero=codigo.numero)) then write(temp_cod_dsk,ind);
		end;
 {dec(max_albaranes);}
	tam:=filesize(temp_cod_dsk);

	close(cod_dsk);
	close(temp_cod_dsk);

	erase(cod_dsk);;
	rename(temp_cod_dsk,ini.work+'albaran.dsk');
	assign(temp_cod_dsk,ini.work+'albaran.tmp');
	assign(cod_dsk,ini.work+'albaran.dsk')
end;




procedure actualiza_fec_index;
var
	 ind,indice:t_index2;
	 anho,mes,dia:longint;
	 condicion:boolean;

begin
	{$I-}
	reset(fec_ndx);
	{$I+}
	if ioresult=0 then
		begin
			rewrite(temp_fec_ndx);

			anho:=fecha.year-1900;
			anho:=anho*10000;
			mes:=fecha.month;
			mes:=mes*100;
			dia:=fecha.day;

			indice.fecha:=anho+mes+dia;
			indice.pos:=max_albaranes;

			condicion:=true;

			while not(eof(fec_ndx)) do
				begin

					read(fec_ndx,ind);
					if (condicion)and(indice.fecha<=ind.fecha) then
						begin
							write(temp_fec_ndx,indice);
							condicion:=false
						end;
					write(temp_fec_ndx,ind);

				end;

			if condicion then write(temp_fec_ndx,indice);

			close(fec_ndx);
			close(temp_fec_ndx);

			erase(fec_ndx);
			rename(temp_fec_ndx,ini.work+'fecha.ndx');
			assign(temp_fec_ndx,ini.work+'fecha.tmp');
			assign(fec_ndx,ini.work+'fecha.ndx')
		end
		else create_fec_index
end;


procedure borra_fec_index;
var
	 ind,indice:t_index2;
	 anho,mes,dia:longint;
begin
	reset(fec_ndx);
	rewrite(temp_fec_ndx);

	anho:=fecha.year-1900;
	anho:=anho*10000;
{ anho:=anho div 10;}
	mes:=fecha.month;
	mes:=mes*100;
	dia:=fecha.day;

	indice.fecha:=anho+mes+dia;
	indice.pos:=pos;

	while not (eof(fec_ndx)) do
		begin
			read(fec_ndx,ind);
			if ind.pos<>indice.pos then write(temp_fec_ndx,ind)
		end;

	close(fec_ndx);
	close(temp_fec_ndx);

	erase(fec_ndx);
	rename(temp_fec_ndx,ini.work+'fecha.ndx');
	assign(temp_fec_ndx,ini.work+'fecha.tmp');
	assign(fec_ndx,ini.work+'fecha.ndx')
end;



function busca_index_cod(codigo:t_codigo; var i:byte):word;
var
	 ind,indice: t_index;
	 k,q       : t_cod_dsk;
	 salir     : boolean;

begin
	busca_index_cod:=0;

	salir:=false;
	{$I-}
	reset(cod_ndx);
	{$I+}

	if ioresult=0 then
		begin
			indice.numero:= codigo.numero;
			indice.letra := codigo.letra;

			while not((eof(cod_ndx))or salir) do
				begin
					read(cod_ndx,ind);
{         indice.pos:=ind.pos;}
					if (indice.numero=ind.numero) and (indice.letra=ind.letra)
					 then begin
						busca_index_cod:=ind.pos;
						i :=0;
						salir:=true
					 end
				end;
			close(cod_ndx)
		end;

	if not(salir) then
		begin
			{$I-}
			reset(cod_dsk);
			{$I+}
			if ioresult=0 then
				begin
					k.numero:=codigo.numero;
					k.letra :=codigo.letra;
					while not ((eof(cod_dsk))or salir) do
						begin
							read(cod_dsk,q);
							if (k.numero=q.numero) and (k.letra=q.letra)
							 then begin
								busca_index_cod:=q.pos;
								i :=q.disco;
								salir:=true
							 end
						end;
					close(cod_dsk)
				end
		end
		else i:=0

end;




function busca_index_fec(fecha:t_date):word;
var
	 ind,indice:t_index2;
	 salir:boolean;
	 anho,mes,dia:longint;

begin
	busca_index_fec:=0;
	salir:=false;
	{$I-}
	reset(fec_ndx);
	{$I+}
	if ioresult=0 then
		begin
			anho:=fecha.year-1900;
			anho:=anho*10000;
{     anho:=anho div 10; }
			mes:=fecha.month;
			if mes>10 then mes:=mes*1000 else mes:=mes*100;
			dia:=fecha.day;

			indice.fecha:=anho+mes+dia;

			while not(eof(fec_ndx)) and salir do
				begin
					 read(fec_ndx,ind);
					 indice.pos:=ind.pos;
					 if (indice.fecha=ind.fecha) then
						 begin
								busca_index_fec:=ind.pos;
								salir:=true;
						 end
				end;
			close(fec_ndx)
		end
end;




procedure desactiva_albaran;
var
	k  :word;
	alb:t_albaran;
	cuadrado_x,paso:byte;
begin
	reset(fichalbs);
	contador:=1;
	tam:=filesize(fichalbs);
	highvideo;
	cuadrado_x:=20;
	textbackground(BLUE);
	textcolor(YELLOW);
	gotoxy(cuadrado_x,25);
	paso:=max_albaranes div 20;
	k:=1;
	seek(fichalbs,pos-1);
	read(fichalbs,alb);
	seek(fichalbs,pos-1);
	alb.codigo.numero:=0;
	alb.codigo.letra:=' ';
	alb.telefono:=0;
	write(fichalbs,alb);
	tam:=filesize(fichalbs);
	close(fichalbs);
	textcolor(CYAN);
	textbackground(BLACK);
	lowvideo;
end;


procedure limpia;
var
	alb:t_albaran;
	porcentaje,borrados,paso,cuadrado_x,contador:word;
begin
	{$I-}
	reset(fichalbs);
	rewrite(tempalbs);
	{$I+}
	clrscr;
	if ioresult=0 then
		begin
			gotoxy(1,1);
			writeln('Reestructurando base de datos...');

			cuadrado_x:=34;
			gotoxy(cuadrado_x,1);
			write('같같같같같같같같같같같');
			if max_albaranes>20 then
				begin
					paso:=max_albaranes div 20;
					if (max_albaranes mod 20)<>0 then inc(paso);
				end
				else if (max_albaranes<>0) then paso:=20 div max_albaranes;

			borrados:=0;

			while not(eof(fichalbs)) do
				begin
					read(fichalbs,alb);
					if (contador mod paso)=0 then
						begin
							gotoxy(cuadrado_x,1);
							write('�');
							inc(cuadrado_x);
						end;
						if not((alb.codigo.numero=0)and(alb.telefono=0)and(alb.codigo.letra=' '))
						 then write(tempalbs,alb)
							else inc(borrados);
						inc(contador);
				end;

			close(fichalbs);
			close(tempalbs);

			while cuadrado_x<56 do
				begin
					gotoxy(cuadrado_x,1);
					write('�');
					inc(cuadrado_x)
				end;
			writeln;

			porcentaje:=((borrados*100) div max_albaranes);
			if porcentaje<>0 then
				begin
					writeln;
					writeln;
					writeln('La estructura actual es un ',porcentaje,' % menor');
				 end;

			erase(fichalbs);
			rename(tempalbs,ini.work+'albaran.dat');
			assign(tempalbs,ini.work+'albaran.tmp');
			assign(fichalbs,ini.work+'albaran.dat')
		end
end;


	procedure archiva_f(lim:longint);
	var
		alb        : t_albaran;
		cod        : t_cod_dsk;
		fec        : t_index2;
		ctrl       : byte;
		cont       : word;

		procedure check_size;
		var c:char;
		begin
			tam:=diskfree(1);
			if tam<9451 then
				begin
					close(albsdsk);
					write(#7);
					write_msg(' Disco lleno. Retirelo de la disquetera');
					repeat
						repeat until keypressed;
					until diskfree(1)=-1;

					cont:=0;
					inc(ini.last_disk);
					ini.new_disk:=true;
					save_cfg;
					repeat until assign_f_albs(ini.last_disk)=0
				end
		end;

	begin
		{$I-}
		reset(fichalbs);
		{$I+}
		if ioresult=0 then
			begin
				rewrite(tempalbs);
				{$I-}
				reset(fec_ndx);
				if ioresult<>0 then
					begin
						clrscr;
						writeln(' Base de datos no indexada....... programa corrupto!!');
						halt(1)
					end;
				reset(cod_dsk);
				{$I+}

				if ioresult<>0 then
					begin
						rewrite(cod_dsk);
						ini.last_disk:=1;
						ini.new_disk:=true;
						cont:=0
					end
					else begin
						cont:=filesize(cod_dsk);
						seek(cod_dsk,cont)
					end;

				ctrl:=assign_f_albs(ini.last_disk);

				case ctrl of

					0 : begin

								check_size;
								seek(albsdsk,cont);
								inc(cont);
								read(fec_ndx,fec);

								if fec.fecha>=lim then
									begin
										close(fichalbs);
										close(tempalbs);
										close(fec_ndx);
										close(cod_dsk);
										erase(tempalbs);
										write_msg(' Albaranes ya archivados (Pulse una tecla)');
										repeat until keypressed;
										close(albsdsk);
										write_msg(' retire el disco (Pulse una tecla)');
										repeat until keypressed;
									end
									else begin
										while ((not(eof(fec_ndx)) and (fec.fecha<lim))) do
											begin

												check_size;

												write_msg(' Archivando.....');
												seek(fichalbs,fec.pos-1);
												read(fichalbs,alb);
												write(albsdsk,alb);
												dec(max_albaranes);
												cod.numero := alb.codigo.numero;
												cod.letra  := alb.codigo.letra;
												cod.disco  := ini.last_disk;
												cod.pos    := cont;
												write(cod_dsk,cod);
												inc(cont);

												read(fec_ndx,fec)

											end;

										close(albsdsk);

										write(#7);
										write_msg(' Retire el disquete.(Pulse una tecla)');
										repeat until keypressed;
										close(cod_dsk);

										write_msg(' Actualizando base de datos ...');

										if fec.fecha>=lim then
											repeat
												seek(fichalbs,fec.pos-1);
												read(fichalbs,alb);
												write(tempalbs,alb);
												if not(eof(fec_ndx)) then read(fec_ndx,fec);
											until eof(fec_ndx);

										close(fichalbs);
										close(tempalbs);
										close(fec_ndx);
										erase(fichalbs);
										rename(tempalbs,ini.work+'albaran.dat');
										assign(tempalbs,ini.work+'albaran.tmp');
										assign(fichalbs,ini.work+'albaran.dat');

										write_msg(' Indexando la base de datos');
										create_cod_index;
										create_fec_index
									end
							end;


					3 : begin
								close(tempalbs);
								close(fichalbs);
								close(albsdsk);
								close(fec_ndx);
								close(cod_dsk);
								erase(tempalbs)
							end;
				end

			end
			else error(10)

	end;



(* para meter lineas de albaran en mem., funciona *)

procedure add_nodo (var inix:listalbs; var ultx:listalbs; dato:tipo_albs);
var aux:listalbs;
begin
	if inix=nil then
	begin
		new(aux);
		with aux^ do
		begin
			codigo:=dato.codigo;
			fecha:=dato.fecha;
			num_factura:=dato.num_factura;
			se:=dato.se;
			temp:=dato.temp;
		end;
		aux^.sig:=nil;
		inix:=aux;
		ultx:=inix;
	end
	else
	begin
		new(aux);
		with aux^ do
		begin
			codigo:=dato.codigo;
			fecha:=dato.fecha;
			num_factura:=dato.num_factura;
			se:=dato.se;
			temp:=dato.temp;
		end;
		aux^.sig:=nil;
		ultx^.sig:=aux;
		ultx:=aux;
	end;
end;


(* funciona bien *)


procedure borra_lista_facturas;
var
	sig,tmp:listalbs;

begin

	tmp:=ini;
	while not(tmp=nil) do
	begin
		sig:=tmp^.sig;
		dispose(tmp);
		tmp:=sig;
	end;

end;


(* crea un indice de facturas por numero, funciona cojonudo *)

procedure crea_factura_ndx;
const max=1750;
var
	numero:array [1..max] of t_index;
	fact_head:t_factura_head;
	f:file of t_factura_head;
	indice:word;
	z:file of t_index;
	tam:word;
	i,j:word;
	temp:t_index;

begin
	{assign(f,ini.work+'fact_h.dat');}
	{$I-}
	reset(fichfact);
	{$I+}
	if ioresult=0 then
	begin
		indice:=1;

		while not(eof(fichfact)) do
		begin
			read(fichfact,fact_head);
			numero[indice].numero:=fact_head.num_factura.numero;
			numero[indice].letra:=fact_head.num_factura.letra;
			numero[indice].pos:=indice;
			inc(indice);
		end;

		close(fichfact);

		{assign(z,ini.work+'fact.ndx');}
		rewrite(fact_ndx);

		tam:=indice-1;

		for i:=1 to tam do
			for j:=1 to tam-1 do
				if numero[j].numero>numero[j+1].numero then
					begin
						temp:=numero[j];
						numero[j]:=numero[j+1];
						numero[j+1]:=temp;
					end;

		for i:=1 to indice-1 do write(fact_ndx,numero[i]);

		close(fact_ndx);
	end;

end;

(* introduce un numero de factura, funciona cojonudo *)

procedure actualiza_fact_index;
var
	ind,indice: t_index;
	condicion:boolean;

begin

	{$I-}
	reset(fact_ndx);
	{$I+}
	if ioresult=0 then
		begin
			rewrite(temp_fact_ndx);

			indice.numero:=codigo.numero;
			indice.letra:=codigo.letra;
			indice.pos:=max_facturas;

			condicion:=true;

			while not(eof(fact_ndx)) do
				begin

					read(fact_ndx,ind);
					if (condicion)and(indice.numero<=ind.numero) then
						begin
							write(temp_fact_ndx,indice);
							condicion:=false
						end;
					write(temp_fact_ndx,ind);

				end;

			if condicion=true then write(temp_fact_ndx,indice);

			close(fact_ndx);
			close(temp_fact_ndx);

			erase(fact_ndx);
			rename(temp_fact_ndx,ini.work+'fact.ndx');
			assign(temp_fact_ndx,ini.work+'fact.tmp');
			assign(fact_ndx,ini.work+'fact.ndx')
		end
		else crea_factura_ndx;

end;


(* borra un indice, funciona guay *)

procedure borra_fact_index;
var
	ind,indice  : t_index;
begin
	reset(fact_ndx);
	rewrite(temp_fact_ndx);


	while not(eof(fact_ndx)) do
		begin
			read(fact_ndx,ind);
			if not((ind.letra=codigo.letra)and
				 (ind.numero=codigo.numero)) then write(temp_fact_ndx,ind);
		end;

	close(fact_ndx);
	close(temp_fact_ndx);

	erase(fact_ndx);
	rename(temp_fact_ndx,ini.work+'fact.ndx');
	assign(temp_fact_ndx,ini.work+'fact.tmp');
	assign(fact_ndx,ini.work+'fact.ndx')

end;


(* busca un indice, guachy *)

function busca_index_fact;
var
	 ind,indice: t_index;
	 salir     : boolean;

begin
	busca_index_fact:=0;

	salir:=false;
	{$I-}
	reset(fact_ndx);
	{$I+}

	if ioresult=0 then
		begin
			indice.numero:= codigo.numero;
			indice.letra := codigo.letra;

			while not((eof(fact_ndx))or salir) do
				begin
					read(fact_ndx,ind);
					if (indice.numero=ind.numero) and (indice.letra=ind.letra)
					 then begin
						busca_index_fact:=ind.pos;
						i :=0;
						salir:=true
					 end
				end;
			close(fact_ndx)
		end;
end;



{****************************************}

{funcion importante, muy importante, graba una factura en memoria a disco}

{****************************************}

{ tabla de errores:
	0:succes
	1:lista=nil
	2:error en ioresult
}

function graba_factura_head;
var
	i:byte;
	f1:file of t_factura_head;
	normal:tipo_albs;
begin


	if lista<>nil then
	begin
		{$I-}
			reset(fichfact);
		{$I+}
		if IoResult<>0 then rewrite(fichfact);
		if IoResult=0 then seek(fichfact,filesize(fichfact));

		j.ini_line:=max_lineas_alb+1;
		write(fichfact,j);
		inc(max_facturas);
		close(fichfact);
		graba_factura_head:=0;
	end
	else graba_factura_head:=1;

end;



function graba_factura_lines;
var
	i:byte;
	punt:listalbs;
	f2:file of tipo_albs;
	normal:tipo_albs;
begin


	if lista<>nil then
	begin
		{$I-}
			reset(fichlin);
		{$I+}
		if IoResult<>0 then rewrite(fichlin);
		if IoResult=0 then seek(fichlin,filesize(fichlin));

		punt:=lista;
		while not(punt=nil) do
		begin
			with normal do
			begin
				codigo:=punt^.codigo;
				num_factura:=j.num_factura;
				fecha:=punt^.fecha;
				for i:=1 to 9 do se[i]:=punt^.se[i];
				temp:=punt^.temp;
				inc(max_lineas_alb);
			end;
			write(fichlin,normal);
			punt:=punt^.sig;
		end;
		close(fichlin);
		graba_factura_lines:=0;
	end
	else graba_factura_lines:=1;

end;




(* Destruir factura, funciona bien *)

procedure borra_factura_f;
var
	aux  : t_factura_head;
	k    : word;
begin
	{$I-}
	Reset(fichfact);
	{$I+}
	if ((IOresult<>0)or(max_facturas=0)) then
		begin
			error(23);
			lowbar('Men� Facturas')
		end
		else begin
			Rewrite(tempfact);
			for k:=1 to pos-1 do
				begin
					read(fichfact,aux);
					write(tempfact,aux);
				end;
			read(fichfact,aux);
			while not eof(fichfact) do
				begin
					read(fichfact,aux);
					write(tempfact,aux);
				end;
			close(fichfact);
			close(tempfact);
			erase(fichfact);
			rename(tempfact,ini.work+'fact_h.dat');
			assign(tempfact,ini.work+'fact_h.tmp');
			assign(fichfact,ini.work+'fact_h.dat');
			dec(max_facturas)
		end;
end;


(* mete en memoria una cabecera de factura y sus lineas de alb.,
funciona bien *)

function busca_factura_f;
var
	temp:tipo_albs;
	inicio,ultimo:listalbs;
	ini:listalbs;
	lista_empezada:boolean;
	seguir:boolean;

begin


	punt:=nil;
	seguir:=true;
	ultimo:=punt;
	lista_empezada:=false;

	busca_factura_f:=0;

	{$I-}
	reset(fichfact);
	{$I+}
	if ioresult=0 then
		begin
			seek(fichfact,pos-1);
			read(fichfact,head);
			close(fichfact);
			busca_factura_f:=pos
		end
		else error(23);

	{$I-}
	reset(fichlin);
	{$I+}
	if ioresult=0 then
	begin
		seek(fichlin,head.ini_line-1);
		while (not(eof(fichlin)) and seguir) do
		begin
			read(fichlin,temp);
			if (temp.num_factura.numero=head.num_factura.numero) and
				(temp.num_factura.letra=head.num_factura.letra) then
				begin
					add_nodo(punt,ultimo,temp);
					lista_empezada:=true;
				end
			else
				if lista_empezada then seguir:=false;
		end;

		close(fichlin);

	end
	else
		error(23);

end;

procedure borra_lin_fact;
var
  temp:tipo_albs;
begin
	{$I-}
	reset(fichlin);
	{$I+}

	if ioresult=0 then
	begin
		rewrite(templin);

		while not(eof(fichlin)) do
		begin
			read(fichlin,temp);
			if (temp.num_factura.numero=codigo.numero) and
				(temp.num_factura.letra=codigo.letra) then
				begin
					{
					temp.num_factura.numero:=0;
					temp.num_factura.letra:=#0;
					}
					write(templin,temp);
				end
			else
				write(templin,temp);
		end;
		close(fichlin);
		close(templin);

		erase(fichlin);
		rename(templin,ini.work+'fact_alb.dat');
		assign(templin,ini.work+'fact_alb.tmp');
		assign(fichlin,ini.work+'fact_alb.dat');
	end;

end;


begin
	tam:=0
end.
