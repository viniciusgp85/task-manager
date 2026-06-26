unit Controller.Task;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  Model.Task,
  Service.Task;

type
  TTaskController = class
  private
    class function  TaskToJSON(const ATask: TTaskModel): TJSONObject;
    class function  JSONToTask(const AJSON: TJSONObject): TTaskModel;
  public
    class procedure GetAll  (Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetById (Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Post    (Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Put     (Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete  (Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetStats(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure RegisterRoutes;
  end;

implementation

class function TTaskController.TaskToJSON(const ATask: TTaskModel): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('id',          TJSONNumber.Create(ATask.Id));
  Result.AddPair('title',       ATask.Title);
  Result.AddPair('description', ATask.Description);
  Result.AddPair('status',      ATask.Status);
  Result.AddPair('priority',    TJSONNumber.Create(ATask.Priority));
  Result.AddPair('createdAt',   DateTimeToStr(ATask.CreatedAt));
  if ATask.CompletedAt > 0 then
    Result.AddPair('completedAt', DateTimeToStr(ATask.CompletedAt))
  else
    Result.AddPair('completedAt', TJSONNull.Create);
end;

class function TTaskController.JSONToTask(const AJSON: TJSONObject): TTaskModel;
begin
  Result             := TTaskModel.Create;
  Result.Title       := AJSON.GetValue<string>('title', '');
  Result.Description := AJSON.GetValue<string>('description', '');
  Result.Status      := AJSON.GetValue<string>('status', 'Pending');
  Result.Priority    := AJSON.GetValue<Integer>('priority', 1);
end;

class procedure TTaskController.GetAll(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService  : TTaskService;
  LTasks    : TObjectList<TTaskModel>;
  LArray    : TJSONArray;
  LTask     : TTaskModel;
begin
  LService := TTaskService.Create;
  try
    LTasks := LService.GetAll;
    try
      LArray := TJSONArray.Create;
      for LTask in LTasks do
        LArray.AddElement(TaskToJSON(LTask));
      Res.Send<TJSONArray>(LArray).Status(200);
    finally
      LTasks.Free;
    end;
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('error', E.Message)).Status(500);
  end;
  LService.Free;
end;

class procedure TTaskController.GetById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TTaskService;
  LTask    : TTaskModel;
  LId      : Integer;
begin
  LService := TTaskService.Create;
  try
    LId   := StrToIntDef(Req.Params['id'], 0);
    LTask := LService.GetById(LId);
    try
      Res.Send<TJSONObject>(TaskToJSON(LTask)).Status(200);
    finally
      LTask.Free;
    end;
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('error', E.Message)).Status(404);
  end;
  LService.Free;
end;

class procedure TTaskController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TTaskService;
  LTask    : TTaskModel;
  LJSON    : TJSONObject;
  LNewId   : Integer;
  LBody    : string;
begin
  LService := TTaskService.Create;
  try
    LBody := Req.Body;
    if LBody = '' then
      raise Exception.Create('Corpo da requisição está vazio.');

    LJSON := TJSONObject.ParseJSONValue(LBody) as TJSONObject;
    if not Assigned(LJSON) then
      raise Exception.Create('JSON inválido no corpo da requisição.');

    try
      LTask := JSONToTask(LJSON);
      try
        LNewId   := LService.Insert(LTask);
        LTask.Id := LNewId;
        Res.Send<TJSONObject>(TaskToJSON(LTask)).Status(201);
      finally
        LTask.Free;
      end;
    finally
      LJSON.Free;
    end;
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('error', E.Message)).Status(400);
  end;
  LService.Free;
end;

class procedure TTaskController.Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TTaskService;
  LTask    : TTaskModel;
  LJSON    : TJSONObject;
  LId      : Integer;
  LBody    : string;
begin
  LService := TTaskService.Create;
  try
    LId   := StrToIntDef(Req.Params['id'], 0);
    LBody := Req.Body;

    if LBody = '' then
      raise Exception.Create('Corpo da requisição está vazio.');

    LJSON := TJSONObject.ParseJSONValue(LBody) as TJSONObject;
    if not Assigned(LJSON) then
      raise Exception.Create('JSON inválido no corpo da requisição.');

    try
      LTask    := JSONToTask(LJSON);
      try
        LTask.Id := LId;
        LService.Update(LTask);
        Res.Send<TJSONObject>(TaskToJSON(LTask)).Status(200);
      finally
        LTask.Free;
      end;
    finally
      LJSON.Free;
    end;
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('error', E.Message)).Status(400);
  end;
  LService.Free;
end;

class procedure TTaskController.Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TTaskService;
  LId      : Integer;
begin
  LService := TTaskService.Create;
  try
    LId := StrToIntDef(Req.Params['id'], 0);
    LService.Delete(LId);
    Res.Send(TJSONObject.Create.AddPair('message', 'Task deleted successfully')).Status(200);
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('error', E.Message)).Status(400);
  end;
  LService.Free;
end;

class procedure TTaskController.GetStats(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TTaskService;
  LStats   : TArray<string>;
  LJSON    : TJSONObject;
begin
  LService := TTaskService.Create;
  try
    LStats := LService.GetStats;
    LJSON  := TJSONObject.Create;
    LJSON.AddPair('totalTasks',          LStats[0]);
    LJSON.AddPair('avgPriorityPending',  LStats[1]);
    LJSON.AddPair('completedLast7Days',  LStats[2]);
    Res.Send<TJSONObject>(LJSON).Status(200);
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('error', E.Message)).Status(500);
  end;
  LService.Free;
end;

class procedure TTaskController.RegisterRoutes;
begin
  THorse.Get   ('/tasks',       GetAll);
  THorse.Get   ('/tasks/:id',   GetById);
  THorse.Post  ('/tasks',       Post);
  THorse.Put   ('/tasks/:id',   Put);
  THorse.Delete('/tasks/:id',   Delete);
  THorse.Get   ('/stats',       GetStats);
end;

end.
