program Simplex;

uses
  Forms,
  Principal in 'Principal.pas' {frmPrincipal},
  MetodoSimplex in 'MetodoSimplex.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
