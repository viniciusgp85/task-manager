unit Factory.Task;

interface

uses
  Service.Task;

type
  TTaskFactory = class
  public
    class function CreateService: TTaskService;
  end;

implementation

class function TTaskFactory.CreateService: TTaskService;
begin
  Result := TTaskService.Create;
end;

end.
