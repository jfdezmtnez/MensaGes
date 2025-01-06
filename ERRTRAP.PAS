unit Errtrap;

interface

implementation

uses Crt;

var
	oldexit:pointer;

function wherex:byte; assembler;
asm
	mov ah,3
	mov bh,0
	int 10h
	inc dl
	mov al,dl
end;

procedure RunTimeExitProc;far;
var
	mensaje:string;
begin
	if erroraddr<>nil then
	begin
		case exitcode of
			1:mensaje:='Numero no valido de funcion'; {errores dos}
			2:mensaje:='Archivo no encontrado';
			3:mensaje:='Via de acceso no encontrada';
			4:mensaje:='Demasiados archivos abiertos';
			5:mensaje:='Acceso al archivo denegado';
			6:mensaje:='Manipulacion de archivos no valida';
			8:mensaje:='Memoria insuficiente';
			12:mensaje:='Codigo de acceso al archivo no valido';
			15:mensaje:='Numero de unidad no valido';
			16:mensaje:='No se puede eliminar el directorio actual';
			17:mensaje:='No se puede renombrar entre unidades';
			18:mensaje:='No mas archivos';

			100:mensaje:='Error de lectura de disco'; {errores i/o}
			101:mensaje:='Error de escritura de disco';
			102:mensaje:='Archivo no encontrado';
			103:mensaje:='Archivo no abierto';
			104:mensaje:='Archivo no abierto para entrada';
			105:mensaje:='Archivo no abierto para salida';
			106:mensaje:='Formato numerico no valido';

			150:mensaje:='Disco protegido contra escritura'; {errores criticos}
			151:mensaje:='Unidad desconocida';
			152:mensaje:='Unidad no preparada';
			153:mensaje:='Orden desconocidan';
			154:mensaje:='Error en crc de datos';
			156:mensaje:='Error en busqueda de disco';
			157:mensaje:='Tipo de soporte desconocido';
			158:mensaje:='Sector no encontrado';
			159:mensaje:='Falta papel en la impresora';
			160:mensaje:='Fallo de escritura en dispositivo';
			161:mensaje:='Fallo de lectura en dispo';
			162:mensaje:='Fallo en hardware';

			200:mensaje:='Division por cero'; {errores fatales}
			201:mensaje:='Error de comprobacion de rango';
			202:mensaje:='Error de desbordamiento de pila (stack)';
			203:mensaje:='Error de desbordamiento de pila (heap)';
			204:mensaje:='Operacion de puntero no valida';
			205:mensaje:='Desbordamiento alto de coma flotante';
			206:mensaje:='Desbordamiento bajo de coma flotante';
			207:mensaje:='Operacion de coma flotante invalido';
			208:mensaje:='Manipulador de recubrimientos no instalado';
			209:mensaje:='Error de lectura en archivo overlay';
			210:mensaje:='Objeto no inicializado';
			211:mensaje:='Llamada a metodo abstracto';
			212:mensaje:='Error en regulacion de flujo stream';
			213:mensaje:='Indice de collection fuera de rango';
			214:mensaje:='Error de desbordamiento de collection';
			215:mensaje:='Error aritmetico de desbordamiento';
			216:mensaje:='Error en proteccion general';

		else
			mensaje:='Error sin descripcion';

	end;

	if wherex<>1 then writeln;
	highvideo;
	textcolor(YELLOW);
	textbackground(RED);
	writeln('Error numero:',exitcode);
	writeln('Descripcion :',mensaje);
	erroraddr:=nil;
	lowvideo;;
	textcolor(CYAN);
	textbackground(BLACK);

end;
exitproc:=oldexit;


end;

begin
	oldexit:=exitproc;
	exitproc:=@runtimeexitproc;
end.





