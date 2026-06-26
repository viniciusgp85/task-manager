unit Client.Service.Task;

interface

uses
  System.SysUtils,
  System.JSON,
  REST.Client,
  REST.Types,
  REST.Response.Adapter;

const
  BASE_URL = 'http://localhost:9000';
  API_KEY  = 'taskmanager-bdmg-2026';

type
  TTaskClientService = class
  private
    class function ExecuteRequest(
      const AResource : string;
      const AMethod   : TRESTRequestMethod;
      const ABody     : string = ''
    ): TJSONValue;
  public
    class function  GetAll  : TJSONArray;
    class function  GetById (const AId: Integer): TJSONObject;
    class function  Insert  (const AJSON: TJSONObject): TJSONObject;
    class function  Update  (const AId: Integer; const AJSON: TJSONObject): TJSONObject;
    class procedure Delete  (const AId: Integer);
    class function  GetStats: TJSONObject;
  end;

implementation

class function TTaskClientService.ExecuteRequest(
  const AResource : string;
  const AMethod   : TRESTRequestMethod;
  const ABody     : string = ''
): TJSONValue;
var
  LClient   : TRESTClient;
  LRequest  : TRESTRequest;
  LResponse : TRESTResponse;
begin
  LClient   := TRESTClient.Create(nil);
  LRequest  := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    LClient.BaseURL     := BASE_URL;
    LRequest.Client     := LClient;
    LRequest.Response   := LResponse;
    LRequest.Resource   := AResource;
    LRequest.Method     := AMethod;
    LRequest.Timeout    := 30000;

    LRequest.Params.AddHeader('X-API-Key', API_KEY);
    LRequest.Params.AddHeader('Accept', 'application/json');

    if ABody <> '' then
    begin
      LRequest.Params.AddHeader('Content-Type', 'application/json');
      LRequest.AddBody(ABody, ctAPPLICATION_JSON);
    end;

    LRequest.Execute;

    if LResponse.StatusCode in [200, 201] then
      Result := TJSONObject.ParseJSONValue(LResponse.Content)
    else
      raise Exception.CreateFmt(
        'Erro na requisição. Código: %d — %s',
        [LResponse.StatusCode, LResponse.Content]
      );
  finally
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

class function TTaskClientService.GetAll: TJSONArray;
begin
  Result := TJSONArray(ExecuteRequest('/tasks', rmGET));
end;

class function TTaskClientService.GetById(const AId: Integer): TJSONObject;
begin
  Result := TJSONObject(ExecuteRequest('/tasks/' + AId.ToString, rmGET));
end;

class function TTaskClientService.Insert(const AJSON: TJSONObject): TJSONObject;
begin
  Result := TJSONObject(ExecuteRequest('/tasks', rmPOST, AJSON.ToString));
end;

class function TTaskClientService.Update(const AId: Integer; const AJSON: TJSONObject): TJSONObject;
begin
  Result := TJSONObject(ExecuteRequest('/tasks/' + AId.ToString, rmPUT, AJSON.ToString));
end;

class procedure TTaskClientService.Delete(const AId: Integer);
begin
  ExecuteRequest('/tasks/' + AId.ToString, rmDELETE).Free;
end;

class function TTaskClientService.GetStats: TJSONObject;
begin
  Result := TJSONObject(ExecuteRequest('/stats', rmGET));
end;

end.
