program TaskManagerClient;

uses
  Vcl.Forms,
  View.Main in 'View.Main.pas' {Form1},
  Client.Service.Task in 'src\Service\Client.Service.Task.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
