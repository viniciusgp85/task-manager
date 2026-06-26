program TaskManagerTests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  Mock.Repository.Task in 'Mock\Mock.Repository.Task.pas',
  Model.Task in '..\Server\src\Model\Model.Task.pas',
  Repository.Interfaces in '..\Server\src\Repository\Repository.Interfaces.pas',
  Test.Service.Task in 'Service\Test.Service.Task.pas',
  Service.Task in '..\Server\src\Service\Service.Task.pas',
  Factory.Repository in '..\Server\src\Factory\Factory.Repository.pas',
  Repository.Task in '..\Server\src\Repository\Repository.Task.pas',
  Factory.Connection in '..\Server\src\Factory\Factory.Connection.pas';

{$IFNDEF TESTINSIGHT}
var
  runner     : ITestRunner;
  results    : IRunResults;
  logger     : ITestLogger;
  nunitLogger: ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    TDUnitX.CheckCommandLine;
    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    runner.FailsOnNoAsserts := False;

    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;

    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;

  // Mantém a janela aberta para leitura do resultado
  System.Write('Pressione <Enter> para fechar.');
  System.Readln;
{$ENDIF}
end.
