unit MetodoSimplex;

interface

uses Classes, SysUtils;

const
 maxVar = 10;
 maxRest = 10;
 maxFila = MaxRest + 1;
 maxCol = MaxVar + 2*MaxRest + 1;
 ValorM = 1E100; // Muy Grande (10^100)
 objMax = 1;
 objMin = -1;

type

 TCelda = Object
  X: Double;
  M: Double;
  function Valor: String;
  procedure PonerCero;
 end;

 TObjetoSimplex = Object
 public
    Basicas: Array[1..MaxRest] of Byte;
    Matriz: Array[1..MaxFila, 1..MaxCol] of TCelda;
    numVariables: Integer;
    numRestricciones: Integer;
    TotalVariables: Integer;
    Artificiales: Set of Byte;
    Objetivo: Integer;
    procedure Reiniciar;
    procedure AjustarFilaPivote(FilaPivote,ColPivote: Byte);
    procedure AjustarFila(Fila, FilaPivote, ColPivote: Byte);
    procedure AjustarTabla;
    function BuscarEntrante: Byte;
    function BuscarSaliente(ColPivote: Byte): Byte;
    function Iterar(var aEntra, aSale: Byte): Boolean;
 end;

var
 ObjetoSimplex: TObjetoSimplex;

implementation

function Multi(A: Double; B: TCelda): TCelda;
begin
 Result.X := B.X * A;
 Result.M := B.M * A;
end;

function TCelda.Valor: String;
var
 signo: char;
 Numero: String;
begin
 Numero:= FloatToStr(X);//  format('%f',[X]);
 if M <> 0 then
 begin
  if X = 0 then
   Numero:= FloatToStr(M) + '(M)'//Format('%f(M)',[M])
  else
  begin
   if M >= 0 then
    Signo:= '+'
   else
    Signo:= '-';
   Numero:= Numero + ' ' + Signo + FloatToStr(Abs(M)) + '(M)';//Format(' %s%f(M)',[Signo,Abs(M)]);
  end;
 end;
 Result:= Numero;
end;

procedure TCelda.PonerCero;
begin
 X:= 0;
 M:= 0;
end;

procedure TObjetoSimplex.Reiniciar;
var
 i,j: Integer;
begin
 Artificiales:= [];
 for i:= 1 to MaxFila do
  for j:= 1 to MaxCol do
   Matriz[i,j].PonerCero;
end;

procedure TObjetoSimplex.AjustarFila(Fila, FilaPivote, ColPivote: Byte);
var
 Multiplicador, Opera: TCelda;
 iCol: Integer;
begin
 Multiplicador:= Multi(1/Matriz[FilaPivote,ColPivote].X,Matriz[Fila,ColPivote]);
 for iCol:= 1 to TotalVariables do
 begin
  Opera:= Multi(Matriz[FilaPivote,iCol].X,Multiplicador);
  Matriz[Fila,iCol].X := Matriz[Fila,iCol].X - Opera.X;
  Matriz[Fila,iCol].M := Matriz[Fila,iCol].M - Opera.M;
 end;
 Opera:= Multi(Matriz[FilaPivote,MaxCol].X,Multiplicador);
 Matriz[Fila,MaxCol].X := Matriz[Fila,MaxCol].X - Opera.X;
 Matriz[Fila,MaxCol].M := Matriz[Fila,MaxCol].M - Opera.M;
end;

procedure TObjetoSimplex.AjustarTabla;
var
 iFila: Integer;
begin
 for iFila:= 1 to NumRestricciones do
 begin
  if Basicas[iFila] in Artificiales then
   AjustarFila(1,iFila + 1,Basicas[iFila]);
 end;
end;

function TObjetoSimplex.BuscarEntrante: Byte;
var
 MaxVal, CompVal: Double;
 MaxCol,iCol: byte;
begin
 MaxCol:= 0;
 MaxVal:= 0;
 for iCol:= 1 to TotalVariables do
 begin
  CompVal:= (-1)*Objetivo*(Matriz[1,iCol].X + Matriz[1,iCol].M * ValorM);
  if CompVal > MaxVal then
  begin
   MaxVal:= CompVal;
   MaxCol:= iCol;
  end;
 end;
 Result:= MaxCol;
end;

function TObjetoSimplex.BuscarSaliente(ColPivote: Byte): Byte;
var
 MinVal, CompVal: Double;
 MinFila,iFila: byte;
begin
 MinFila:= 0;
 MinVal:= ValorM;
 for iFila:= 1 to NumRestricciones do
 begin
  if Matriz[iFila+1,ColPivote].X <> 0 then
  begin
   CompVal:= Matriz[iFila+1,MaxCol].X / Matriz[iFila+1,ColPivote].X;
   if (CompVal >= 0)and(CompVal < MinVal) then
   begin
    MinVal:= CompVal;
    MinFila:= iFila;
   end;
  end;
 end;
 Result:= MinFila;
end;

procedure TObjetoSimplex.AjustarFilaPivote(FilaPivote, ColPivote: Byte);
var
 iCol: Integer;
 ValorPivote: Double;
begin
 ValorPivote:= Matriz[FilaPivote,ColPivote].X;
 for iCol:= 1 to TotalVariables do
  Matriz[FilaPivote,iCol].X := Matriz[FilaPivote,iCol].X / ValorPivote;
 Matriz[FilaPivote,MaxCol].X := Matriz[FilaPivote,MaxCol].X / ValorPivote;
end;

function TObjetoSimplex.Iterar(var aEntra, aSale: Byte): Boolean;
var
 Entra, Sale: Byte;
 iFila: Byte;
begin
 Entra:= BuscarEntrante;
 Sale:= BuscarSaliente(Entra);
 Result:= (Entra > 0)and(Sale > 0);
 if not Result then
  Exit;
 aEntra:= Entra;
 aSale:= Basicas[Sale];
 Basicas[Sale]:= Entra;
 AjustarFilaPivote(Sale+1,Entra);
 for iFila:= 1 to NumRestricciones + 1 do
  if iFila <> Sale + 1 then
    AjustarFila(iFila,Sale+1,Entra);
end;

end.
