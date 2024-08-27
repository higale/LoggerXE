unit formMainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Text, FMX.Memo;

type
  TformMain = class(TForm)
    btn1: TButton;
    btn3: TButton;
    mmoLog: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  formMain: TformMain;

implementation

{$R *.fmx}


uses Logger;

procedure TformMain.btn1Click(Sender: TObject);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      for var i := 0 to 5 do
      begin
        g_Logger.Debug('通常在开发中会将其设置为最低的日志级别，用于输出详细的调试信息。(%d)', [i]);
        g_Logger.Info('用于输出常用的信息，使用较为频繁。(%d)', [i]);
        g_Logger.Warn('表明会出现潜在错误的情形，虽然程序不会报错，但仍需注意。(%d)', [i]);
        g_Logger.Error('记录错误和异常信息。(%d)', [i]);
        g_Logger.Fatal('致命错误，一旦发生，程序基本上需要停止。(%d)', [i]);
      end;
    end).Start;
end;

procedure TformMain.btn3Click(Sender: TObject);
begin
  g_Logger.Info('单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!单条日志!');
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
   //g_Logger.Root := '日志'; // 日志目录，缺省为log，可以是相对或绝对路径
  //g_Logger.SubFormat := 'yyyy-mm-dd'; // 子目录格式,缺省为yyyymm(按月分目录)，为空不使用子目录
  //g_Logger.FilenameFormat := 'yyyy-mm-dd_hh'; // 文件名格式，缺省为yyyymmdd(每天一个文件)
  //g_Logger.Encoding := TEncoding.ANSI; // 日志编码格式，缺省UTF8
  //g_Logger.Level := llInfo; // 低于此级别的日志将被忽略，缺省为llAll
  //g_Logger.TimeFormat := 'hh:nn:ss.zzz'; // 日志时间格式，缺省为 'hhnnss'
  //g_Logger.SetTags('[调试]', '[信息]', '[警告]', '[错误]', '[致命]'); // 不同日志级别对应的名称标签，缺省为 '[D]', '[I]', '[W]', '[E]', '[F]'

  // 显示日志
  g_Logger.OnLog := procedure(Sender: TObject; ALevel: TLogLevel; ALevelTag: string; ALog: string; ATime: TDateTime)
    begin
      if mmoLog.Lines.Count > 1000 then
      begin
        mmoLog.Text := 'clear...';
      end;
      mmoLog.Lines.Add(Format('%s%s%s', [FormatDateTime('hh:mm:ss.zzz', ATime), ALevelTag, ALog]));
      mmoLog.GoToTextEnd;
    end;

  mmoLog.Text := '日志目录: ' + g_Logger.Root;
end;

end.
