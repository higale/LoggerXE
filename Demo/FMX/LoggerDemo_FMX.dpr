program LoggerDemo_FMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  formMainUnit in 'formMainUnit.pas' {formMain},
  Logger in '..\..\Logger.pas';

{$R *.res}


begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;

end.
