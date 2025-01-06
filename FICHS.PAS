program prueba;

uses defs,crt,windos;

var

f:file;
fich:tfilerec;
t:char;
i,k:integer;
numero:t_codigo;
fecha:t_date;
telefono:longint;
n:array [1..9] of t_codigo;
iva:real;
desc:byte;
total:longint;
tot:longint;
result:word;

final:t_codigo;



begin

	clrscr;
	assign(f,'c:\prueba.dat');
	rewrite(f,6);


	tot:=0;

	numero.numero:=3555;
	numero.letra:='A';
	tot:=tot+sizeof(numero);
	fecha.day:=5;
	fecha.month:=5;
	fecha.year:=1996;
	tot:=tot+sizeof(fecha);
	telefono:=417707;
	tot:=tot+sizeof(telefono);
	for i:=1 to 9 do
	begin
		n[i].numero:=1000*i;
		n[i].letra:='A';
	end;
	tot:=tot+sizeof(n);
	iva:=16.0;
	writeln('real:',sizeof(iva));
	tot:=tot+sizeof(iva);
	desc:=10;
	tot:=tot+sizeof(desc);
	total:=256789;
	tot:=tot+sizeof(total);

	final.numero:=0;
	final.letra:='X';

	tot:=tot+sizeof(final);

		blockwrite(f,numero,1,result);
		blockwrite(f,fecha,1);
		blockwrite(f,telefono,1);
		for k:=1 to 9 do blockwrite(f,n[k],1);
		blockwrite(f,final,1);
		blockwrite(f,iva,1);
		blockwrite(f,desc,1);
		blockwrite(f,total,1);

	close(f);
	writeln('total:',tot);

	reset(f,6);

	numero.numero:=0;
	numero.letra:=' ';
	fecha.day:=0;
	fecha.month:=0;
	fecha.year:=0;
	telefono:=0;
	for i:=1 to 9 do
	begin
		n[i].numero:=0;
		n[i].letra:=' ';
	end;
	iva:=0;
	desc:=0;
	total:=0;

	final.numero:=0;
	final.letra:=' ';


		blockread(f,numero,1);

		writeln(numero.numero,numero.letra);

		blockread(f,fecha,1);
		writeln(fecha.day,'-',fecha.month,'-',fecha.year);


		blockread(f,telefono,1);
		writeln(telefono);
		for k:=1 to 9 do begin blockread(f,n[1],1); writeln(n[1].numero,n[1].letra); end;
		blockread(f,numero,1);
		writeln(numero.numero,numero.letra);
		blockread(f,iva,1);
		writeln(iva);
		blockread(f,desc,1);
		writeln(desc);
		blockread(f,total,1);
		writeln(total);

	close(f);

end.






