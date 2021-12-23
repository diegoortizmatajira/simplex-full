unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ComCtrls, StdCtrls, ActnList, ExtCtrls, Math;

type
  TfrmPrincipal = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    txtVariables: TEdit;
    udVariables: TUpDown;
    Label2: TLabel;
    txtRestricciones: TEdit;
    udRestricciones: TUpDown;
    grObjetivo: TStringGrid;
    Label3: TLabel;
    Label4: TLabel;
    grRestricciones: TStringGrid;
    ActionList1: TActionList;
    actAplicarCantidades: TAction;
    actGenerarMatriz: TAction;
    Button1: TButton;
    Button2: TButton;
    TabSheet2: TTabSheet;
    grMatriz: TStringGrid;
    actMostrarMatriz: TAction;
    radObjetivo: TRadioGroup;
    Button3: TButton;
    actAjustarTabla: TAction;
    actIterar: TAction;
    Button5: TButton;
    actSolucionar: TAction;
    Button6: TButton;
    Button4: TButton;
    procedure actAplicarCantidadesExecute(Sender: TObject);
    procedure actGenerarMatrizExecute(Sender: TObject);
    procedure actMostrarMatrizExecute(Sender: TObject);
    procedure actAjustarTablaExecute(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actIterarExecute(Sender: TObject);
    procedure actSolucionarExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses MetodoSimplex;

{$R *.DFM}

procedure TfrmPrincipal.actAplicarCantidadesExecute(Sender: TObject);
var
 iCol, iFila: Integer;
begin
 ObjetoSimplex.numVariables:= udVariables.Position;
 ObjetoSimplex.numRestricciones := udRestricciones.Position;
 ObjetoSimplex.Objetivo := trunc(power(-1,radObjetivo.ItemIndex));
 with grObjetivo do
 begin
  ColCount:= ObjetoSimplex.numVariables + 1;
  // Titulos de Columna
  for iCol:= 1 to ObjetoSimplex.numVariables do
   Cells[iCol,0]:= Format('X%2.2d',[iCol]);
  Cells[0,1]:= 'Z =';
 end;
 with grRestricciones do
 begin
  RowCount:= ObjetoSimplex.numRestricciones + 1;
  ColCount:= ObjetoSimplex.numVariables + 3; // + R# + Op + Limite
  for iCol:= 1 to ObjetoSimplex.numVariables do
   Cells[iCol,0]:= Format('X%2.2d',[iCol]);
  Cells[ObjetoSimplex.numVariables+1,0]:= 'Operador';
  Cells[ObjetoSimplex.numVariables+2,0]:= 'Limite';
  for iFila:= 1 to ObjetoSimplex.numRestricciones do
   Cells[0,iFila]:= Format('R%2.2d',[iFila]);
 end;
end;

procedure TfrmPrincipal.actGenerarMatrizExecute(Sender: TObject);
var
 iCol, iFila: Integer;
begin
 With ObjetoSimplex do
 begin
   Reiniciar;
   // Función Objetivo
   TotalVariables:= numVariables;
   for iCol:= 1 to numVariables do
    Matriz[1,iCol].X := -StrToFloat(grObjetivo.Cells[iCol,1]);
   // Restricciones
   for iFila:= 2 to numRestricciones + 1 do
   begin
    for iCol:= 1 to numVariables do
     Matriz[iFila,iCol].X := StrToFloat(grRestricciones.Cells[iCol,iFila-1]);
    Matriz[iFila,MaxCol].X := StrToFloat(grRestricciones.Cells[numVariables+2,iFila-1]);

    case grRestricciones.Cells[NumVariables+1,iFila-1][1] of
     '<':
        begin
         Matriz[iFila,TotalVariables+1].X := 1;
         Basicas[iFila-1]:= TotalVariables + 1;
         inc(TotalVariables,1);
        end;
     '>':
        begin
         Matriz[iFila,TotalVariables+1].X := -1;
         Matriz[iFila,TotalVariables+2].X := 1;
         Matriz[1,TotalVariables+2].M := Objetivo;
         Basicas[iFila-1]:= TotalVariables + 2;
         Include(Artificiales,TotalVariables+2);
         inc(TotalVariables,2);
        end;
     '=':
        begin
         Matriz[iFila,TotalVariables+1].X := 1;
         Matriz[1,TotalVariables+1].M := Objetivo;
         Basicas[iFila-1]:= TotalVariables + 1;
         Include(Artificiales,TotalVariables+1);
         inc(TotalVariables,1);
        end;
     else
        raise Exception.Create('El operador no es valido, debe ser "<", "=" o ">"');
    end;
   end;
 end;
 actMostrarMatriz.Execute;
end;

procedure TfrmPrincipal.actMostrarMatrizExecute(Sender: TObject);
var
 iCol, iFila: Integer;
 Nombre: String;
begin
 with ObjetoSimplex do
 begin
  grMatriz.ColCount := TotalVariables + 2;
  grMatriz.RowCount := numRestricciones + 2;
  // Nombres de las Columnas
  grMatriz.Cells[TotalVariables+1,0]:= 'Sol.';
  for iCol:= 1 to TotalVariables do
  begin
   Nombre:= format('X%2.2d',[iCol]);
   if iCol in Artificiales then
    Nombre:= Nombre + '*';
    grMatriz.Cells[iCol,0]:= Nombre;
  end;
  // Nombres de las filas
  grMatriz.Cells[0,1]:= 'Z';
  for iFila:= 1 to numRestricciones do
  begin
   Nombre:= format('X%2.2d',[Basicas[iFila]]);
   if Basicas[iFila] in Artificiales then
    Nombre:= Nombre + '*';
    grMatriz.Cells[0,iFila+1]:= Nombre;
  end;
  // Contenido de la Matriz
  for iFila:= 1 to numRestricciones + 1 do
  begin
   grMatriz.Cells[TotalVariables+1,iFila]:= Matriz[iFila,MaxCol].Valor;
   for iCol:= 1 to TotalVariables do
    grMatriz.Cells[iCol,iFila]:= Matriz[iFila,iCol].Valor;
  end;
 end;
 PageControl1.ActivePageIndex := 1;
end;

procedure TfrmPrincipal.actAjustarTablaExecute(Sender: TObject);
begin
 ObjetoSimplex.AjustarTabla;
 actMostrarMatriz.Execute;
end;

procedure TfrmPrincipal.Button4Click(Sender: TObject);
begin
 grObjetivo.Cells[1,1]:= '4';
 grObjetivo.Cells[2,1]:= '1';
 grRestricciones.Cells[1,1]:= '3';
 grRestricciones.Cells[2,1]:= '1';
 grRestricciones.Cells[3,1]:= '=';
 grRestricciones.Cells[4,1]:= '3';
 grRestricciones.Cells[1,2]:= '4';
 grRestricciones.Cells[2,2]:= '2';
 grRestricciones.Cells[3,2]:= '>';
 grRestricciones.Cells[4,2]:= '6';
 grRestricciones.Cells[1,3]:= '1';
 grRestricciones.Cells[2,3]:= '2';
 grRestricciones.Cells[3,3]:= '<';
 grRestricciones.Cells[4,3]:= '4';
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
 actAplicarCantidades.Execute;
end;

procedure TfrmPrincipal.actIterarExecute(Sender: TObject);
var
 Entra, Sale: Byte;
begin
 if ObjetoSimplex.Iterar(Entra,Sale) then
 begin
  ShowMessagefmt('Entra la variable X%2.2d /n Sale la variable X%2.2d',[Entra, Sale]);
  actMostrarMatriz.Execute;
 end
 else
  ShowMessage('No se puede iterar más');
end;

procedure TfrmPrincipal.actSolucionarExecute(Sender: TObject);
var
 Entra, Sale: Byte;
begin
 ObjetoSimplex.AjustarTabla;
 repeat
 until not ObjetoSimplex.Iterar(Entra,Sale);
  actMostrarMatriz.Execute;
end;

end.
