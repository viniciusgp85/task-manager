program TaskManagerServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ActiveX,
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.CORS,
  Controller.Task in 'src\Controller\Controller.Task.pas',
  Factory.Connection in 'src\Factory\Factory.Connection.pas',
  Factory.Repository in 'src\Factory\Factory.Repository.pas',
  Middleware.Auth in 'src\Middleware\Middleware.Auth.pas',
  Model.Task in 'src\Model\Model.Task.pas',
  Repository.Interfaces in 'src\Repository\Repository.Interfaces.pas',
  Repository.Task in 'src\Repository\Repository.Task.pas',
  Service.Task in 'src\Service\Service.Task.pas',
  Factory.Task in 'src\Factory\Factory.Task.pas';

procedure COMMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  CoInitialize(nil);
  try
    Next;
  finally
    CoUninitialize;
  end;
end;

begin
  CoInitialize(nil);
  try
    THorse.Use(Jhonson);
    THorse.Use(HandleException);
    THorse.Use(CORS);
    THorse.Use(COMMiddleware);
    THorse.Use(TAuthMiddleware.Validate);

    TTaskController.RegisterRoutes;

    Writeln('======================================');
    Writeln(' TaskManager Server running on :9000  ');
    Writeln('======================================');

    THorse.Listen(9000);
  finally
    CoUninitialize;
  end;
end.
