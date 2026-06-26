unit Model.Task;

interface

type
  TTaskModel = class
  private
    FId          : Integer;
    FTitle       : string;
    FDescription : string;
    FStatus      : string;
    FPriority    : Integer;
    FCreatedAt   : TDateTime;
    FCompletedAt : TDateTime;
  public
    property Id          : Integer   read FId          write FId;
    property Title       : string    read FTitle       write FTitle;
    property Description : string    read FDescription write FDescription;
    property Status      : string    read FStatus      write FStatus;
    property Priority    : Integer   read FPriority    write FPriority;
    property CreatedAt   : TDateTime read FCreatedAt   write FCreatedAt;
    property CompletedAt : TDateTime read FCompletedAt write FCompletedAt;
  end;

implementation

end.
