program data_tester;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Payload Simulator';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
