program princip;
uses
  defs,common,screens,config,protect,graficos,crt,ficheros,windos,errtrap;

var
	 cod, valor:word;
	 a1,a2,a3,a4:word;
	 paco :string;

begin

  albaran_borrado:=false;

	init;

	check_prorroga;

	if registered then
		begin

			textcolor(CYAN);
			textbackground(BLACK);
			highvideo;
			clrscr;

			for contador:=1 to 255 do empty:=empty+' ';
			assign(prnt,'LPT1');
			{$I-}
			rewrite(prnt);
			{$I+}
			if ioresult<>0 then error(15);



			val(paramstr(1),valor,cod);

			if valor<>0 then
				begin
					ini.last_fact_number:=valor;
					save_cfg
				end;


			menus;

			gettime(a1,a2,a3,a4);
			if ((a1>=19) and (a2>=30)) or (albaran_borrado) then
				begin
					limpia;
					writeln;
					writeln('Indexando la base de datos .....');
					create_cod_index;
					create_fec_index;
					clrscr;
				end;

			textcolor(RED);
			highvideo;
			writeln;
			writeln;
			writeln('           (-8       "Gracias por utilizar MENSAGES"       8-)');
			writeln('           (-8   La gesti¢n definitiva para mensajer¡as.   8-)');
			writeln
		end;
	textcolor(lightgray);
	lowvideo
end.
