program prueba;
uses crt,defs,graficos,dos;
begin
	clrscr;
	getdate(fecha_sistema.year,fecha_sistema.month,fecha_sistema.day,fecha_sistema.weekday);
	bars;
	recuadro_socio(15,3);
	error(1);
end.