CREATE DATABASE TaskManager;


USE TaskManager;


CREATE TABLE Tasks (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Title       NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Status      NVARCHAR(20)  NOT NULL DEFAULT 'Pending',
    Priority    INT           NOT NULL DEFAULT 1,
    CreatedAt   DATETIME      NOT NULL DEFAULT GETDATE(),
    CompletedAt DATETIME      NULL,

    CONSTRAINT CHK_Status   CHECK (Status IN ('Pending', 'InProgress', 'Done')),
    CONSTRAINT CHK_Priority CHECK (Priority BETWEEN 1 AND 5)
);

INSERT INTO Tasks (Title, Description, Status, Priority, CreatedAt, CompletedAt)
VALUES
('Configurar ambiente',  'Instalar Delphi e dependências', 'Done',       3, DATEADD(DAY,-10,GETDATE()), DATEADD(DAY,-8,GETDATE())),
('Criar banco de dados', 'Modelar tabela de tarefas',      'Done',       4, DATEADD(DAY,-6,GETDATE()),  DATEADD(DAY,-5,GETDATE())),
('Desenvolver API REST', 'Endpoints CRUD com Horse',       'InProgress', 5, DATEADD(DAY,-3,GETDATE()),  NULL),
('Criar tela VCL',       'Interface cliente da API',       'Pending',    4, DATEADD(DAY,-2,GETDATE()),  NULL),
('Escrever README',      'Documentar o projeto',           'Pending',    2, DATEADD(DAY,-1,GETDATE()),  NULL),
('Publicar no GitHub',   'Push do repositório final',      'Pending',    5, GETDATE(),                  NULL);


/*Queries*/

-- 1. Total de tarefas
SELECT COUNT(*) AS TotalTasks 
FROM Tasks;

-- 2. Média de prioridade das tarefas pendentes
SELECT AVG(CAST(Priority AS FLOAT)) AS AvgPriorityPending
FROM Tasks
WHERE Status = 'Pending';

-- 3. Tarefas concluídas nos últimos 7 dias
SELECT COUNT(*) AS CompletedLast7Days
FROM Tasks
WHERE Status = 'Done'
  AND CompletedAt >= DATEADD(DAY, -7, GETDATE());
