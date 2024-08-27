program LoggerDemo_VCL;

uses
  Vcl.Forms,
  formMainUnit in 'formMainUnit.pas' {formMain},
  Logger in '..\..\Logger.pas';

{$R *.res}


begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformMain, formMain);
  Application.Run;

end.
