unit Mock.Repository.Task;

/// <summary>
///   Implementação fake de ITaskRepository utilizada exclusivamente
///   nos testes unitários. Simula o comportamento do repositório real
///   sem realizar nenhum acesso ao banco de dados.
/// </summary>

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Model.Task,
  Repository.Interfaces;

type
  TTaskRepositoryMock = class(TInterfacedObject, ITaskRepository)
  private
    FTasks  : TObjectList<TTaskModel>;
    FNextId : Integer;
  public
    constructor Create;
    destructor  Destroy; override;

    function  GetAll  : TObjectList<TTaskModel>;
    function  GetById (const AId: Integer): TTaskModel;
    function  Insert  (const ATask: TTaskModel): Integer;
    procedure Update  (const ATask: TTaskModel);
    procedure Delete  (const AId: Integer);
    function  GetStats: TArray<string>;
  end;

implementation

constructor TTaskRepositoryMock.Create;
var
  LTask: TTaskModel;
begin
  FNextId := 1;
  FTasks  := TObjectList<TTaskModel>.Create(True);

  // Popula com dados iniciais para os testes
  LTask             := TTaskModel.Create;
  LTask.Id          := FNextId;
  LTask.Title       := 'Tarefa Mock 1';
  LTask.Description := 'Descrição mock 1';
  LTask.Status      := 'Pending';
  LTask.Priority    := 2;
  LTask.CreatedAt   := Now;
  FTasks.Add(LTask);
  Inc(FNextId);

  LTask             := TTaskModel.Create;
  LTask.Id          := FNextId;
  LTask.Title       := 'Tarefa Mock 2';
  LTask.Description := 'Descrição mock 2';
  LTask.Status      := 'Done';
  LTask.Priority    := 3;
  LTask.CreatedAt   := Now;
  LTask.CompletedAt := Now;
  FTasks.Add(LTask);
  Inc(FNextId);
end;

destructor TTaskRepositoryMock.Destroy;
begin
  FTasks.Free;
  inherited;
end;

function TTaskRepositoryMock.GetAll: TObjectList<TTaskModel>;
var
  LResult : TObjectList<TTaskModel>;
  LTask   : TTaskModel;
  LCopy   : TTaskModel;
begin
  LResult := TObjectList<TTaskModel>.Create(True);
  for LTask in FTasks do
  begin
    LCopy             := TTaskModel.Create;
    LCopy.Id          := LTask.Id;
    LCopy.Title       := LTask.Title;
    LCopy.Description := LTask.Description;
    LCopy.Status      := LTask.Status;
    LCopy.Priority    := LTask.Priority;
    LCopy.CreatedAt   := LTask.CreatedAt;
    LCopy.CompletedAt := LTask.CompletedAt;
    LResult.Add(LCopy);
  end;
  Result := LResult;
end;

function TTaskRepositoryMock.GetById(const AId: Integer): TTaskModel;
var
  LTask : TTaskModel;
  LCopy : TTaskModel;
begin
  Result := nil;
  for LTask in FTasks do
  begin
    if LTask.Id = AId then
    begin
      LCopy             := TTaskModel.Create;
      LCopy.Id          := LTask.Id;
      LCopy.Title       := LTask.Title;
      LCopy.Description := LTask.Description;
      LCopy.Status      := LTask.Status;
      LCopy.Priority    := LTask.Priority;
      LCopy.CreatedAt   := LTask.CreatedAt;
      LCopy.CompletedAt := LTask.CompletedAt;
      Result := LCopy;
      Exit;
    end;
  end;
end;

function TTaskRepositoryMock.Insert(const ATask: TTaskModel): Integer;
var
  LCopy: TTaskModel;
begin
  LCopy             := TTaskModel.Create;
  LCopy.Id          := FNextId;
  LCopy.Title       := ATask.Title;
  LCopy.Description := ATask.Description;
  LCopy.Status      := ATask.Status;
  LCopy.Priority    := ATask.Priority;
  LCopy.CreatedAt   := Now;
  FTasks.Add(LCopy);
  Result := FNextId;
  Inc(FNextId);
end;

procedure TTaskRepositoryMock.Update(const ATask: TTaskModel);
var
  LTask: TTaskModel;
begin
  for LTask in FTasks do
  begin
    if LTask.Id = ATask.Id then
    begin
      LTask.Title       := ATask.Title;
      LTask.Description := ATask.Description;
      LTask.Status      := ATask.Status;
      LTask.Priority    := ATask.Priority;
      if ATask.Status = 'Done' then
        LTask.CompletedAt := Now
      else
        LTask.CompletedAt := 0;
      Exit;
    end;
  end;
end;

procedure TTaskRepositoryMock.Delete(const AId: Integer);
var
  I: Integer;
begin
  for I := 0 to FTasks.Count - 1 do
  begin
    if FTasks[I].Id = AId then
    begin
      FTasks.Delete(I);
      Exit;
    end;
  end;
end;

function TTaskRepositoryMock.GetStats: TArray<string>;
begin
  SetLength(Result, 3);
  Result[0] := IntToStr(FTasks.Count);
  Result[1] := '2';
  Result[2] := '1';
end;

end.
