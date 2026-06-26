unit Repository.Task;

interface

uses
  System.SysUtils,
  Data.DB,
  System.Generics.Collections,
  Data.Win.ADODB,
  Model.Task,
  Repository.Interfaces,
  Factory.Connection;

type
  TTaskRepository = class(TInterfacedObject, ITaskRepository)
  private
    FConnection: TADOConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function  GetAll  : TObjectList<TTaskModel>;
    function  GetById (const AId: Integer): TTaskModel;
    function  Insert  (const ATask: TTaskModel): Integer;
    procedure Update  (const ATask: TTaskModel);
    procedure Delete  (const AId: Integer);
    function  GetStats: TArray<string>;
  end;

implementation

constructor TTaskRepository.Create;
begin
  FConnection := TConnectionFactory.GetConnection;
end;

function TTaskRepository.GetAll: TObjectList<TTaskModel>;
var
  LQuery : TADOQuery;
  LTask  : TTaskModel;
begin
  Result := TObjectList<TTaskModel>.Create(True);
  LQuery := TADOQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text   :=
      'SELECT Id, Title, Description, Status, Priority, CreatedAt, CompletedAt ' +
      'FROM Tasks ORDER BY CreatedAt DESC';
    LQuery.Open;
    while not LQuery.Eof do
    begin
      LTask              := TTaskModel.Create;
      LTask.Id           := LQuery.FieldByName('Id').AsInteger;
      LTask.Title        := LQuery.FieldByName('Title').AsString;
      LTask.Description  := LQuery.FieldByName('Description').AsString;
      LTask.Status       := LQuery.FieldByName('Status').AsString;
      LTask.Priority     := LQuery.FieldByName('Priority').AsInteger;
      LTask.CreatedAt    := LQuery.FieldByName('CreatedAt').AsDateTime;
      LTask.CompletedAt  := LQuery.FieldByName('CompletedAt').AsDateTime;
      Result.Add(LTask);
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

function TTaskRepository.GetById(const AId: Integer): TTaskModel;
var
  LQuery: TADOQuery;
begin
  Result := nil;
  LQuery := TADOQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text   :=
      'SELECT Id, Title, Description, Status, Priority, CreatedAt, CompletedAt ' +
      'FROM Tasks WHERE Id = :Id';
    LQuery.Parameters.ParamByName('Id').Value := AId;
    LQuery.Open;
    if not LQuery.IsEmpty then
    begin
      Result             := TTaskModel.Create;
      Result.Id          := LQuery.FieldByName('Id').AsInteger;
      Result.Title       := LQuery.FieldByName('Title').AsString;
      Result.Description := LQuery.FieldByName('Description').AsString;
      Result.Status      := LQuery.FieldByName('Status').AsString;
      Result.Priority    := LQuery.FieldByName('Priority').AsInteger;
      Result.CreatedAt   := LQuery.FieldByName('CreatedAt').AsDateTime;
      Result.CompletedAt := LQuery.FieldByName('CompletedAt').AsDateTime;
    end;
  finally
    LQuery.Free;
  end;
end;

function TTaskRepository.Insert(const ATask: TTaskModel): Integer;
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text   :=
      'INSERT INTO Tasks (Title, Description, Status, Priority, CreatedAt) ' +
      'OUTPUT INSERTED.Id ' +
      'VALUES (:Title, :Description, :Status, :Priority, GETDATE())';
    LQuery.Parameters.ParamByName('Title').Value       := ATask.Title;
    LQuery.Parameters.ParamByName('Description').Value := ATask.Description;
    LQuery.Parameters.ParamByName('Status').Value      := ATask.Status;
    LQuery.Parameters.ParamByName('Priority').Value    := ATask.Priority;
    LQuery.Open;
    Result := LQuery.Fields[0].AsInteger;
  finally
    LQuery.Free;
  end;
end;

procedure TTaskRepository.Update(const ATask: TTaskModel);
var
  LQuery: TADOQuery;
  LSQL  : string;
begin
  LQuery := TADOQuery.Create(nil);
  try
    LQuery.Connection := FConnection;

    if ATask.Status = 'Done' then
      LSQL :=
        'UPDATE Tasks SET ' +
        '  Title       = :Title, ' +
        '  Description = :Description, ' +
        '  Status      = :Status, ' +
        '  Priority    = :Priority, ' +
        '  CompletedAt = GETDATE() ' +
        'WHERE Id = :Id'
    else
      LSQL :=
        'UPDATE Tasks SET ' +
        '  Title       = :Title, ' +
        '  Description = :Description, ' +
        '  Status      = :Status, ' +
        '  Priority    = :Priority, ' +
        '  CompletedAt = NULL ' +
        'WHERE Id = :Id';

    LQuery.SQL.Text := LSQL;
    LQuery.Parameters.ParamByName('Title').Value       := ATask.Title;
    LQuery.Parameters.ParamByName('Description').Value := ATask.Description;
    LQuery.Parameters.ParamByName('Status').Value      := ATask.Status;
    LQuery.Parameters.ParamByName('Priority').Value    := ATask.Priority;
    LQuery.Parameters.ParamByName('Id').Value          := ATask.Id;
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

procedure TTaskRepository.Delete(const AId: Integer);
var
  LQuery: TADOQuery;
begin
  LQuery := TADOQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text   := 'DELETE FROM Tasks WHERE Id = :Id';
    LQuery.Parameters.ParamByName('Id').Value := AId;
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

destructor TTaskRepository.Destroy;
begin
   if Assigned(FConnection) then
    FreeAndNil(FConnection);
  inherited;
end;

function TTaskRepository.GetStats: TArray<string>;
var
  LQuery: TADOQuery;
begin
  SetLength(Result, 3);
  LQuery := TADOQuery.Create(nil);
  try
    LQuery.Connection := FConnection;

    LQuery.SQL.Text := 'SELECT COUNT(*) AS Total FROM Tasks';
    LQuery.Open;
    Result[0] := LQuery.FieldByName('Total').AsString;
    LQuery.Close;

    LQuery.SQL.Text :=
      'SELECT AVG(CAST(Priority AS FLOAT)) AS AvgPriority ' +
      'FROM Tasks WHERE Status = ''Pending''';
    LQuery.Open;
    Result[1] := FormatFloat('0.##', LQuery.FieldByName('AvgPriority').AsFloat);
    LQuery.Close;

    LQuery.SQL.Text :=
      'SELECT COUNT(*) AS Completed FROM Tasks ' +
      'WHERE Status = ''Done'' AND CompletedAt >= DATEADD(DAY, -7, GETDATE())';
    LQuery.Open;
    Result[2] := LQuery.FieldByName('Completed').AsString;
    LQuery.Close;
  finally
    LQuery.Free;
  end;
end;

end.
