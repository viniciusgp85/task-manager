unit Middleware.Auth;

interface

uses
  Horse,
  System.SysUtils;

const
  API_KEY = 'taskmanager-bdmg-2026';

type
  TAuthMiddleware = class
  public
    class procedure Validate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

class procedure TAuthMiddleware.Validate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LApiKey: string;
begin
  LApiKey := Req.Headers['X-API-Key'];

  if LApiKey <> API_KEY then
  begin
    Res.Send('{"error":"Não autorizado. Chave de API inválida ou ausente."}').Status(401);
    Exit;
  end;

  Next;
end;

end.
