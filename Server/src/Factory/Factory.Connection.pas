unit Factory.Connection;

interface

uses
  System.SysUtils,
  Data.Win.ADODB;

const
  CONN_STRING = 'Provider=SQLOLEDB;Data Source=localhost\SQLEXPRESS;' +
                'Initial Catalog=TaskManager;' +
                'User ID=taskuser;Password=Task@1234;';

type
  TConnectionFactory = class
  public
    class function GetConnection: TADOConnection;
  end;

implementation

class function TConnectionFactory.GetConnection: TADOConnection;
begin
  Result := TADOConnection.Create(nil);
  Result.ConnectionString := CONN_STRING;
  Result.LoginPrompt      := False;
  Result.Connected        := True;
end;

end.
