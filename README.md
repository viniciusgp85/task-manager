# Task Manager

API REST e aplicação VCL para gerenciamento de tarefas, desenvolvidos em Delphi como parte da prova técnica para vaga de Desenvolvedor Delphi — BDMG.

## Tecnologias

- Delphi RAD Studio
- Framework Horse — servidor REST
- SQL Server — banco de dados
- ADO — acesso a dados
- DUnitX — testes unitários
- Padrão Factory Method

## Estrutura do Projeto

    TaskManagerGroup/
    │
    ├── Server/
    │   ├── TaskManagerServer.dproj
    │   └── src/
    │       ├── Controller/
    │       │   └── Controller.Task.pas
    │       ├── Service/
    │       │   └── Service.Task.pas
    │       ├── Repository/
    │       │   ├── Repository.Interfaces.pas
    │       │   └── Repository.Task.pas
    │       ├── Factory/
    │       │   ├── Factory.Connection.pas
    │       │   └── Factory.Repository.pas
    │       ├── Model/
    │       │   └── Model.Task.pas
    │       └── Middleware/
    │           └── Middleware.Auth.pas
    │
    ├── Client/
    │   ├── TaskManagerClient.dproj
    │   └── src/
    │       ├── Service/
    │       │   └── Service.Task.Client.pas
    │       └── Forms/
    │           └── Form.Main.pas
    │
    └── TaskManagerTests/
        ├── TaskManagerTests.dproj
        ├── Mock/
        │   └── Mock.Repository.Task.pas
        └── Service/
            └── Test.Service.Task.pas

## Configuração do Banco de Dados

Execute o script no SQL Server:

```sql
CREATE DATABASE TaskManager;
GO

USE TaskManager;
GO

CREATE TABLE Tasks (
  Id          INT IDENTITY(1,1) PRIMARY KEY,
  Title       NVARCHAR(200)  NOT NULL,
  Description NVARCHAR(1000) NULL,
  Status      NVARCHAR(20)   NOT NULL DEFAULT 'Pending',
  Priority    INT            NOT NULL DEFAULT 1,
  CreatedAt   DATETIME       NOT NULL DEFAULT GETDATE(),
  CompletedAt DATETIME       NULL
);
```

## Configuração da Conexão

Abra `Factory.Connection.pas` e ajuste a connection string:

```delphi
const
  CONNECTION_STRING =
    'Provider=SQLOLEDB;'        +
    'Data Source=SEU_SERVIDOR;' +
    'Initial Catalog=TaskManager;' +
    'User ID=SEU_USUARIO;'      +
    'Password=SUA_SENHA;';
```

## Rodando o Servidor

Abra `Server.dproj`, compile e execute. O servidor sobe na porta `9000`.

## Autenticação

Todas as requisições precisam do header:

X-API-Key: your-secret-key

## Endpoints

| Método | Rota        | Descrição                      |
|--------|-------------|--------------------------------|
| GET    | /tasks      | Lista todas as tarefas         |
| GET    | /tasks/:id  | Retorna uma tarefa pelo Id     |
| POST   | /tasks      | Cria uma nova tarefa           |
| PUT    | /tasks/:id  | Atualiza uma tarefa existente  |
| DELETE | /tasks/:id  | Remove uma tarefa              |
| GET    | /stats      | Retorna estatísticas           |

## Payload de Exemplo


json

{
  "title": "Implementar autenticação",
  "description": "Adicionar middleware de API Key",
  "status": "Pending",
  "priority": 3
}




Status aceitos: `Pending`, `InProgress`, `Done`
Prioridade: valor inteiro entre `1` e `5`

## Resposta — GET /stats


json

{
  "totalTasks": "12",
  "avgPriorityPending": "2.5",
  "completedLast7Days": "4"
}




## Rodando o Cliente

Abra `Client.dproj`, compile e execute. A aplicação se conecta ao servidor na porta `9000`.

## Testes Unitários

Abra `TaskManagerTests.dproj`, compile e execute com F9.

Os testes cobrem a camada de Service com repositório mock, sem acesso ao banco de dados. São 16 casos de teste cobrindo inserção, atualização, remoção, busca e estatísticas.

## Arquitetura

O projeto aplica o padrão Factory Method para desacoplar as camadas:

- `TConnectionFactory` — fornece a conexão ADO ao banco
- `TRepositoryFactory` — cria o repositório e retorna via interface `ITaskRepository`
- `TTaskService` — conhece apenas a interface, nunca a implementação concreta

## Autor

Vinicius — Prova Técnica Desenvolvedor Delphi — BDMG