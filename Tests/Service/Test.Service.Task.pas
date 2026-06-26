unit Test.Service.Task;

/// <summary>
///   Testes unitários da camada TTaskService.
///   Utiliza TTaskRepositoryMock para isolar os testes do banco de dados,
///   garantindo que apenas as regras de negócio do Service são validadas.
/// </summary>

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  Model.Task,
  Service.Task,
  Mock.Repository.Task,
  Repository.Interfaces;

type
  [TestFixture]
  TTaskServiceTest = class
  private
    FService: TTaskService;
    FMock   : ITaskRepository;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    // GetAll
    [Test]
    procedure GetAll_DeveRetornarListaComItens;

    // GetById
    [Test]
    procedure GetById_IdValido_DeveRetornarTask;

    [Test]
    procedure GetById_IdInexistente_DeveGerarExcecao;

    // Insert — caminhos de erro
    [Test]
    procedure Insert_TituloVazio_DeveGerarExcecao;

    [Test]
    procedure Insert_StatusInvalido_DeveGerarExcecao;

    [Test]
    procedure Insert_PrioridadeMenorQueUm_DeveGerarExcecao;

    [Test]
    procedure Insert_PrioridadeMaiorQueCinco_DeveGerarExcecao;

    // Insert — caminho feliz
    [Test]
    procedure Insert_DadosValidos_DeveRetornarIdMaiorQueZero;

    // Update — caminhos de erro
    [Test]
    procedure Update_IdZero_DeveGerarExcecao;

    [Test]
    procedure Update_TituloVazio_DeveGerarExcecao;

    [Test]
    procedure Update_StatusInvalido_DeveGerarExcecao;

    [Test]
    procedure Update_PrioridadeInvalida_DeveGerarExcecao;

    // Update — caminho feliz
    [Test]
    procedure Update_DadosValidos_NaoDeveGerarExcecao;

    // Delete
    [Test]
    procedure Delete_IdZero_DeveGerarExcecao;

    [Test]
    procedure Delete_IdValido_NaoDeveGerarExcecao;

    // GetStats
    [Test]
    procedure GetStats_DeveRetornarArrayComTresElementos;
  end;

implementation

procedure TTaskServiceTest.Setup;
begin
  // Injeta o mock diretamente no Service via construtor alternativo
  FMock    := TTaskRepositoryMock.Create;
  FService := TTaskService.CreateWithRepository(FMock);
end;

procedure TTaskServiceTest.TearDown;
begin
  FService.Free;
end;

{ GetAll }

procedure TTaskServiceTest.GetAll_DeveRetornarListaComItens;
var
  LLista: TObject;
begin
  LLista := FService.GetAll;
  try
    Assert.IsNotNull(LLista, 'A lista não deveria ser nil.');
  finally
    LLista.Free;
  end;
end;

{ GetById }

procedure TTaskServiceTest.GetById_IdValido_DeveRetornarTask;
var
  LTask: TTaskModel;
begin
  LTask := FService.GetById(1);
  try
    Assert.IsNotNull(LTask, 'A tarefa não deveria ser nil.');
    Assert.AreEqual(1, LTask.Id);
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.GetById_IdInexistente_DeveGerarExcecao;
begin
  Assert.WillRaise(
    procedure begin FService.GetById(9999); end,
    Exception
  );
end;

{ Insert }

procedure TTaskServiceTest.Insert_TituloVazio_DeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Title    := '';
    LTask.Status   := 'Pending';
    LTask.Priority := 1;
    Assert.WillRaise(
      procedure begin FService.Insert(LTask); end,
      Exception
    );
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.Insert_StatusInvalido_DeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Title    := 'Tarefa válida';
    LTask.Status   := 'StatusInexistente';
    LTask.Priority := 1;
    Assert.WillRaise(
      procedure begin FService.Insert(LTask); end,
      Exception
    );
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.Insert_PrioridadeMenorQueUm_DeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Title    := 'Tarefa válida';
    LTask.Status   := 'Pending';
    LTask.Priority := 0;
    Assert.WillRaise(
      procedure begin FService.Insert(LTask); end,
      Exception
    );
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.Insert_PrioridadeMaiorQueCinco_DeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Title    := 'Tarefa válida';
    LTask.Status   := 'Pending';
    LTask.Priority := 6;
    Assert.WillRaise(
      procedure begin FService.Insert(LTask); end,
      Exception
    );
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.Insert_DadosValidos_DeveRetornarIdMaiorQueZero;
var
  LTask  : TTaskModel;
  LNovoId: Integer;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Title       := 'Nova Tarefa Teste';
    LTask.Description := 'Descrição de teste';
    LTask.Status      := 'Pending';
    LTask.Priority    := 3;
    LNovoId := FService.Insert(LTask);
    Assert.IsTrue(LNovoId > 0, 'O Id retornado deveria ser maior que zero.');
  finally
    LTask.Free;
  end;
end;

{ Update }

procedure TTaskServiceTest.Update_IdZero_DeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Id       := 0;
    LTask.Title    := 'Tarefa válida';
    LTask.Status   := 'Pending';
    LTask.Priority := 1;
    Assert.WillRaise(
      procedure begin FService.Update(LTask); end,
      Exception
    );
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.Update_TituloVazio_DeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Id       := 1;
    LTask.Title    := '';
    LTask.Status   := 'Pending';
    LTask.Priority := 1;
    Assert.WillRaise(
      procedure begin FService.Update(LTask); end,
      Exception
    );
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.Update_StatusInvalido_DeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Id       := 1;
    LTask.Title    := 'Tarefa válida';
    LTask.Status   := 'Invalido';
    LTask.Priority := 1;
    Assert.WillRaise(
      procedure begin FService.Update(LTask); end,
      Exception
    );
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.Update_PrioridadeInvalida_DeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Id       := 1;
    LTask.Title    := 'Tarefa válida';
    LTask.Status   := 'Pending';
    LTask.Priority := 10;
    Assert.WillRaise(
      procedure begin FService.Update(LTask); end,
      Exception
    );
  finally
    LTask.Free;
  end;
end;

procedure TTaskServiceTest.Update_DadosValidos_NaoDeveGerarExcecao;
var
  LTask: TTaskModel;
begin
  LTask := TTaskModel.Create;
  try
    LTask.Id       := 1;
    LTask.Title    := 'Título Atualizado';
    LTask.Status   := 'InProgress';
    LTask.Priority := 2;
    Assert.WillNotRaise(
      procedure begin FService.Update(LTask); end
    );
  finally
    LTask.Free;
  end;
end;

{ Delete }

procedure TTaskServiceTest.Delete_IdZero_DeveGerarExcecao;
begin
  Assert.WillRaise(
    procedure begin FService.Delete(0); end,
    Exception
  );
end;

procedure TTaskServiceTest.Delete_IdValido_NaoDeveGerarExcecao;
begin
  Assert.WillNotRaise(
    procedure begin FService.Delete(1); end
  );
end;

{ GetStats }

procedure TTaskServiceTest.GetStats_DeveRetornarArrayComTresElementos;
var
  LStats: TArray<string>;
begin
  LStats := FService.GetStats;
  Assert.AreEqual(3, Length(LStats), 'GetStats deve retornar exatamente 3 elementos.');
end;

initialization
  TDUnitX.RegisterTestFixture(TTaskServiceTest);

end.
