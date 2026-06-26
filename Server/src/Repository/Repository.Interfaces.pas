unit Repository.Interfaces;

interface

uses
  System.Generics.Collections,
  Model.Task;

type
  ITaskRepository = interface
    ['{F7BACF7C-1886-4590-BA38-51D97E142DD6}']
    function  GetAll    : TObjectList<TTaskModel>;
    function  GetById   (const AId: Integer): TTaskModel;
    function  Insert    (const ATask: TTaskModel): Integer;
    procedure Update    (const ATask: TTaskModel);
    procedure Delete    (const AId: Integer);
    function  GetStats  : TArray<string>;
  end;

implementation

end.
