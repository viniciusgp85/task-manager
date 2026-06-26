unit Factory.Repository;
/// <summary>
///   Factory responsável pela criação de repositórios.
///   Aplica o padrão Factory Method para desacoplar a instanciação
///   do repositório concreto da camada de serviço.
///   A camada de Service conhece apenas a interface ITaskRepository,
///   nunca a implementação concreta TTaskRepository.
/// </summary>
interface

uses
  Repository.Interfaces,
  Repository.Task;

type
  TRepositoryFactory = class
  public
    /// <summary>
    ///   Retorna uma instância de ITaskRepository pronta para uso.
    ///   Caso no futuro o repositório mude (ex: de ADO para FireDAC),
    ///   apenas este método precisa ser alterado.
    /// </summary>
    class function GetTaskRepository: ITaskRepository;
  end;

implementation

class function TRepositoryFactory.GetTaskRepository: ITaskRepository;
begin
  Result := TTaskRepository.Create;
end;

end.
