unit Service.Task;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Model.Task,
  Repository.Interfaces,
  Factory.Repository;

type
  TTaskService = class
  private
    FRepository: ITaskRepository;
  public
    constructor Create;
    constructor CreateWithRepository(const ARepository: ITaskRepository);

    function  GetAll  : TObjectList<TTaskModel>;
    function  GetById (const AId: Integer): TTaskModel;
    function  Insert  (const ATask: TTaskModel): Integer;
    procedure Update  (const ATask: TTaskModel);
    procedure Delete  (const AId: Integer);
    function  GetStats: TArray<string>;
  end;

implementation

constructor TTaskService.Create;
begin
  // Obtém o repositório via Factory, garantindo o desacoplamento
  // entre a camada de serviço e a implementação concreta do repositório.
  FRepository := TRepositoryFactory.GetTaskRepository;
end;

function TTaskService.GetAll: TObjectList<TTaskModel>;
begin
  Result := FRepository.GetAll;
end;

function TTaskService.GetById(const AId: Integer): TTaskModel;
begin
  Result := FRepository.GetById(AId);
  if not Assigned(Result) then
    raise Exception.CreateFmt('Task com Id %d não encontrada.', [AId]);
end;

function TTaskService.Insert(const ATask: TTaskModel): Integer;
begin
  if ATask.Title.Trim.IsEmpty then
    raise Exception.Create('O Título é obrigatório.');

  if not (ATask.Status = 'Pending')   and
     not (ATask.Status = 'InProgress') and
     not (ATask.Status = 'Done') then
    raise Exception.Create('O status deve estar entre Pending, InProgress ou Done.');

  if (ATask.Priority < 1) or (ATask.Priority > 5) then
    raise Exception.Create('A Prioridade deve estar entre 1 e 5.');

  Result := FRepository.Insert(ATask);
end;

procedure TTaskService.Update(const ATask: TTaskModel);
begin
  if ATask.Id <= 0 then
    raise Exception.Create('Task Id Inválido.');

  if ATask.Title.Trim.IsEmpty then
    raise Exception.Create('O Título é obrigatório.');

  if not (ATask.Status = 'Pending')    and
     not (ATask.Status = 'InProgress') and
     not (ATask.Status = 'Done') then
    raise Exception.Create('O status deve estar entre Pending, InProgress ou Done.');

  if (ATask.Priority < 1) or (ATask.Priority > 5) then
    raise Exception.Create('A Prioridade deve estar entre 1 e 5.');

  FRepository.Update(ATask);
end;

constructor TTaskService.CreateWithRepository(
  const ARepository: ITaskRepository);
begin
  // Construtor usado nos testes unitários para injeção do repositório mock,
  // evitando qualquer acesso ao banco de dados durante os testes.
  FRepository := ARepository;
end;

procedure TTaskService.Delete(const AId: Integer);
begin
  if AId <= 0 then
    raise Exception.Create('Task Id Inválido.');

  FRepository.Delete(AId);
end;

function TTaskService.GetStats: TArray<string>;
begin
  Result := FRepository.GetStats;
end;

end.
