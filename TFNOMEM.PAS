unit tfnomem;

interface

	uses defs;

	procedure ini_tfnos (var telefonos:t_telefonos);
	function busca_tfno (var telefonos:t_telefonos; telefono:longint; max_clientes:word):word;
	function ins_tfno (var telefonos:t_telefonos; telefono:longint; var max_clientes:word):word;
	procedure borra_tfno (var telefonos:t_telefonos; pos:word; var max_clientes:word);
	procedure ordena (var telefonos:t_telefonos; max_clientes:word);

implementation


(* Inicializa la lista de tel‚fonos *)

	procedure ini_tfnos (var telefonos:t_telefonos);
	var
		k : word;
	begin
		for k:=1 to _MAX_CLIENTES do telefonos[k]:=99999999
	end;



(* Buscar un tel‚fono en memoria *)

	function busca_tfno (var telefonos:t_telefonos; telefono:longint; max_clientes:word):word;
	var
		k : word;
		v : boolean;
	begin
		k:=1;
		v:=true;
		if max_clientes=0 then busca_tfno:=0
			else begin
				while v do
					begin
						if telefono=telefonos[k] then v:=false
							else if telefonos[k]<telefono then inc(k)
								else v:=false;
						if k>max_clientes then v:=false
					end;
				if telefonos[k]=telefono then busca_tfno:=k
					else busca_tfno:=0
			end
	end;



(* Inserta un tel‚fono en el array de memoria *)

	function ins_tfno (var telefonos:t_telefonos; telefono:longint; var max_clientes:word):word;
	var
		n,k : word;
		v   : boolean;
	begin
		k:=1;
		n:=1;
		v:=false;
		if max_clientes=_MAX_CLIENTES then ins_tfno:=0
			else begin
				if max_clientes=0 then telefonos[1]:=telefono
				else begin
					repeat
						if telefonos[k]<telefono then inc(k)
							else begin
								if telefonos[k]=99999999 then k:=max_clientes+1;
								v:=true
							end;
					until v;
				if max_clientes=1 then case k of
						1 : begin
									telefonos[2]:=telefonos[1];
									telefonos[1]:=telefono
								end;
						2 : telefonos[2]:=telefono
				end
					else if k<=max_clientes then for n:=max_clientes downto k do telefonos[n+1]:=telefonos[n]
						else telefonos[max_clientes+1]:=telefono
				end;
				telefonos[k]:=telefono;
				inc(max_clientes);
				ins_tfno:=k;
			end
	end;



(* elimina un tfno de la matriz en memoria *)

	procedure borra_tfno (var telefonos:t_telefonos; pos:word; var max_clientes:word);
	var
		k : word;
	begin
		for k:=pos to max_clientes do telefonos[k]:=telefonos[k+1];
		dec(max_clientes)
	end;



(* Ordena la lista en memooria seg£n el bubble-method. S¢lo es £til la 1¦ vez *)

	procedure ordena (var telefonos:t_telefonos; max_clientes:word);
	var i,j : word;
			temp: longint;
	begin
		for i:=1 to max_clientes do
			for j:=0 to max_clientes do if (telefonos[j]>telefonos[j+1]) then
				begin
					temp:=telefonos[j];
					telefonos[j]:=telefonos[j+1];
					telefonos[j+1]:=temp
				end;
	end;



end.
