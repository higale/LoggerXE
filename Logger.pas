{
# Delphi 日志类(Logger Class for delphi xe)
- v1.0.2
- 2024-08-27 by gale
- https://github.com/higale/LoggerXE

## 方法:
- Debug：调试，通常在开发中会将其设置为最低的日志级别，用于输出详细的调试信息。
- Info：信息，用于输出常用的信息，使用较为频繁。
- Warn：警告，表明会出现潜在错误的情形，虽然程序不会报错，但仍需注意。
- Error：错误，记录错误和异常信息。
- Fatal：致命错误，一旦发生，程序基本上需要停止。

## 日志文件位置
  可以通过设置Root来改变日志文件位置，如果不设置，日志缺省存储在
- Windows:
*程序所在目录/log/*
- MacOS
*/Users/当前用户/.程序名/log/*

## 注意
g_Logger实例已经自动创建，可以直接使用

## 使用方法：
    uses
      Logger;
    ...
    g_Logger.Debug('This is a %s log',['debug'])
    g_Logger.Error('发生了一些错误！');

    VCL显示日志
    g_Logger.OnLog := procedure(Sender: TObject; ALevel: TLogLevel; ALevelTag: string; ALog: string; ATime: TDateTime)
      begin
        if mmoLog.Lines.Count > 1000 then
          mmoLog.Text := 'clear...';
        mmoLog.Lines.Add(Format('%s%s%s', [FormatDateTime('hh:mm:ss', ATime), ALevelTag, ALog]));
      end;

    FMX显示日志
    g_Logger.OnLog := procedure(Sender: TObject; ALevel: TLogLevel; ALevelTag: string; ALog: string; ATime: TDateTime)
      begin
        if mmoLog.Lines.Count > 1000 then
          mmoLog.Text := 'clear...';
        mmoLog.Lines.Add(Format('%s%s%s', [FormatDateTime('hh:mm:ss', ATime), ALevelTag, ALog]));
        mmoLog.GoToTextEnd;
      end;
}
unit Logger;

// 兼容旧版日志类，可以使用WriteLog函数输出日志
{$DEFINE Compatible_Old_Version}

interface

uses
  System.IOUtils, System.Classes, System.SysUtils, System.SyncObjs;

type
  /// <summary>日志级别</summary>
  TLogLevel = (llAll, llDebug, llInfo, llWarn, llError, llFatal, llOff);
  /// <summary>日志回调事件</summary>
  TOnLogerLog = reference to procedure(Sender: TObject; ALevel: TLogLevel; ALevelTag: string; ALog: string; ATime: TDateTime);

  /// <summary>日志类</summary>
  TLogger = class
  private
    FCSLock: TCriticalSection;
    FRoot: string;
    FSubFormat: string;
    FFilenameFormat: string;
    FEncoding: TEncoding;
    FLevel: TLogLevel;
    FTimeFormat: string;
    FTags: array [TLogLevel] of string;
    FOnLog: TOnLogerLog;
    procedure SetRoot(AValue: string);
    procedure Log(ALog: string; const ALogLevel: TLogLevel); overload;
    procedure Log(ALog: string; const Args: array of const; const LogLevel: TLogLevel); overload;
  public
    /// <summary>日志目录，缺省为log，可以是相对或绝对路径</summary>
    property Root: string read FRoot write SetRoot;
    /// <summary>子目录格式,缺省为yyyymm(每月一个子目录)，为空不使用子目录</summary>
    property SubFormat: string read FSubFormat write FSubFormat;
    /// <summary>日志文件名格式，缺省为yyyymmdd(每天一个文件)</summary>
    property FilenameFormat: string read FFilenameFormat write FFilenameFormat;
    /// <summary>日志编码格式，缺省UTF8</summary>
    property Encoding: TEncoding read FEncoding write FEncoding;
    /// <summary>低于此级别的日志将被忽略，缺省为llAll, llOff为全部忽略</summary>
    property Level: TLogLevel read FLevel write FLevel;
    /// <summary>保存日志时间格式，缺省为 'hhnnss'</summary>
    property TimeFormat: string read FTimeFormat write FTimeFormat;
    /// <summary>日志触发事件，线程安全</summary>
    property OnLog: TOnLogerLog read FOnLog write FOnLog;
    /// <summary>不同日志级别对应的名称标签，缺省为 '[D]', '[I]', '[W]', '[E]', '[F]'</summary>
    /// <param name="ADebugTag">调试日志标签</param>
    /// <param name="AInfoTag">信息日志标签</param>
    /// <param name="AWarnTag">警告日志标签</param>
    /// <param name="AErrorTag">错误日志标签</param>
    /// <param name="AFatalTag">致命错误日志标签</param>
    procedure SetTags(ADebugTag, AInfoTag, AWarnTag, AErrorTag, AFatalTag: string);
  public
    /// <summary>构造函数，如无特殊需求，可以直接使用g_Logger，它已经自动初始化，不需要手动创建</summary>
    constructor Create;
    /// <summary>析构函数</summary>
    destructor Destroy; override;
    /// <summary>输出调试日志</summary>
    /// <param name="ALog">日志内容</param>
    procedure Debug(ALog: string); overload;
    /// <summary>输出调试日志</summary>
    /// <param name="ALog">包含格式化格式信息的日志数据</param>
    /// <param name="Args">用于格式化的参数</param>
    procedure Debug(ALog: string; const Args: array of const); overload;
    /// <summary>输出信息日志</summary>
    /// <param name="ALog">日志内容</param>
    procedure Info(ALog: string); overload;
    /// <summary>输出信息日志</summary>
    /// <param name="ALog">包含格式化格式信息的日志数据</param>
    /// <param name="Args">用于格式化的参数</param>
    procedure Info(ALog: string; const Args: array of const); overload;
    /// <summary>输出警告日志</summary>
    /// <param name="ALog">日志内容</param>
    procedure Warn(ALog: string); overload;
    /// <summary>输出警告日志</summary>
    /// <param name="ALog">包含格式化格式信息的日志数据</param>
    /// <param name="Args">用于格式化的参数</param>
    procedure Warn(ALog: string; const Args: array of const); overload;
    /// <summary>输出错误日志</summary>
    /// <param name="ALog">日志内容</param>
    procedure Error(ALog: string); overload;
    /// <summary>输出错误日志</summary>
    /// <param name="ALog">包含格式化格式信息的日志数据</param>
    /// <param name="Args">用于格式化的参数</param>
    procedure Error(ALog: string; const Args: array of const); overload;
    /// <summary>输出致命错误日志</summary>
    /// <param name="ALog">日志内容</param>
    procedure Fatal(ALog: string); overload;
    /// <summary>输出致命错误日志</summary>
    /// <param name="ALog">包含格式化格式信息的日志数据</param>
    /// <param name="Args">用于格式化的参数</param>
    procedure Fatal(ALog: string; const Args: array of const); overload;
{$IFDEF Compatible_Old_Version}
    /// <summary>输出日志 【警告】不建议使用此函数! 此函数仅为兼容旧版本程序</summary>
    /// <param name="ALog">日志内容</param>
    /// <param name="ALogLevel">日志级别 0:信息 1,2:警告 other:错误</param>
    procedure WriteLog(ALog: String; const ALogLevel: integer = 0); overload;
      deprecated '函数 WriteLog 已不建议使用，请直接使用语义更清晰的 Debug、Info、Warn、Error或Fatal 函数输出日志';
    /// <summary>输出日志 【警告】不建议使用此函数! 此函数仅为兼容旧版本程序</summary>
    /// <param name="ALog">包含格式化格式信息的日志数据</param>
    /// <param name="Args">用于格式化的参数</param>
    /// <param name="ALogLevel">日志级别 0:信息 1,2:警告 other:错误</param>
    procedure WriteLog(ALog: String; const Args: array of const; const ALogLevel: integer = 0); overload;
      deprecated '函数 WriteLog 已不建议使用，请直接使用语义更清晰的 Debug、Info、Warn、Error或Fatal 函数输出日志';
{$ENDIF}
  end;

var
  g_Logger: TLogger;

implementation

{ ------------------------------------------------------------------------------
  名称: TLogger.Create
  说明: 构造函数
------------------------------------------------------------------------------ } constructor TLogger.Create;
begin
  inherited Create;
  FCSLock := TCriticalSection.Create;
{$IFDEF MACOS}
  FRootDir := ExtractFilePath(TPath.GetDocumentsPath) + '.' + ExtractFileName(ParamStr(0)) + PathDelim + 'log' + PathDelim;
{$ELSE}
  FRoot := ExtractFilePath(ParamStr(0)) + 'log' + PathDelim;
{$ENDIF}
  FSubFormat := 'yyyymm';
  FFilenameFormat := 'yyyymmdd';
  FEncoding := TEncoding.UTF8;
  FLevel := llAll;
  FTimeFormat := 'hhnnss';
  SetTags('[D]', '[I]', '[W]', '[E]', '[F]');
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Destroy
  说明: 析构函数
------------------------------------------------------------------------------ }
destructor TLogger.Destroy;
begin
  FCSLock.Free;
  inherited;
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.SetRoot
  说明: LogDir属性设置函数
  参数: AValue
------------------------------------------------------------------------------ }
procedure TLogger.SetRoot(AValue: string);
begin
  FRoot := ExpandFileName(AValue);
  if FRoot[FRoot.Length] <> PathDelim then
  begin
    FRoot := FRoot + PathDelim;
  end;
  if not ForceDirectories(FRoot) then
  begin
    raise Exception.Create('The log file directory cannot be created: ' + FRoot);
  end;
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.SetLevelTags
  说明: LevelTags属性设置函数
  参数: ADebugTag 调试
        AInfoTag 信息
        AWarnTag 警告
        AErrorTag 错误
------------------------------------------------------------------------------ }
procedure TLogger.SetTags(ADebugTag, AInfoTag, AWarnTag, AErrorTag, AFatalTag: string);
begin
  FTags[llDebug] := ADebugTag;
  FTags[llInfo] := AInfoTag;
  FTags[llWarn] := AWarnTag;
  FTags[llError] := AErrorTag;
  FTags[llFatal] := AFatalTag;
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Log
  说明: Log输出函数
  参数: ALog 包含格式化格式信息的日志数据
        Args 用于格式化的参数
        LogLevel 日志级别
------------------------------------------------------------------------------ }
procedure TLogger.Log(ALog: string; const Args: array of const; const LogLevel: TLogLevel);
begin
  Log(Format(ALog, Args), LogLevel);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Log
  说明: Log输出函数
  参数: ALog 日志数据
        ALogLevel 日志级别
------------------------------------------------------------------------------ }
procedure TLogger.Log(ALog: string; const ALogLevel: TLogLevel);
var
  FullDir, SubDir: string;
  logFileName: string;
  strLogAll: string;
  LogLevelTag: string;
  LogTime: TDateTime;
begin
  if ALogLevel >= FLevel then
  begin
    LogTime := Now;
    LogLevelTag := FTags[ALogLevel];
    logFileName := FormatDateTime(FFilenameFormat, LogTime) + '.log';
    FullDir := FRoot;
    if FSubFormat <> '' then
    begin
      SubDir := FormatDateTime(FSubFormat, LogTime);
      FullDir := FRoot + SubDir + PathDelim;
    end;
    strLogAll := Format('%s%s%s' + sLineBreak, [FormatDateTime(FTimeFormat, LogTime), LogLevelTag, ALog]);
    FCSLock.Enter;
    try
      if not DirectoryExists(FullDir) then
      begin
        ForceDirectories(FullDir);
      end;
      try
        TFile.AppendAllText(FullDir + logFileName, strLogAll, FEncoding);
      except
      end;
    finally
      FCSLock.Leave;
    end;

    if Assigned(FOnLog) then
    begin
      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          FOnLog(self, ALogLevel, FTags[ALogLevel], ALog, LogTime);
        end);
    end;
  end;
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Debug
  说明: 调试日志
  参数: ALog 日志数据
------------------------------------------------------------------------------ }
procedure TLogger.Debug(ALog: string);
begin
  Log(ALog, llDebug);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Debug
  说明: 调试日志
  参数: ALog 包含格式化格式信息的日志数据
        Args 用于格式化的参数
------------------------------------------------------------------------------ }
procedure TLogger.Debug(ALog: string; const Args: array of const);
begin
  Log(ALog, Args, llDebug);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Info
  说明: 信息日志
  参数: ALog 日志数据
------------------------------------------------------------------------------ }
procedure TLogger.Info(ALog: string);
begin
  Log(ALog, llInfo);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Info
  说明: 信息日志
  参数: ALog 包含格式化格式信息的日志数据
        Args 用于格式化的参数
------------------------------------------------------------------------------ }
procedure TLogger.Info(ALog: string; const Args: array of const);
begin
  Log(ALog, Args, llInfo);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Warn
  说明: 警告日志
  参数: ALog 日志数据
------------------------------------------------------------------------------ }
procedure TLogger.Warn(ALog: string);
begin
  Log(ALog, llWarn);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Warn
  说明: 警告日志
  参数: ALog 包含格式化格式信息的日志数据
        Args 用于格式化的参数
------------------------------------------------------------------------------ }
procedure TLogger.Warn(ALog: string; const Args: array of const);
begin
  Log(ALog, Args, llWarn);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Error
  说明: 错误日志
  参数: ALog 日志数据
------------------------------------------------------------------------------ }
procedure TLogger.Error(ALog: string);
begin
  Log(ALog, llError);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Error
  说明: 错误日志
  参数: ALog 包含格式化格式信息的日志数据
        Args 用于格式化的参数
------------------------------------------------------------------------------ }
procedure TLogger.Error(ALog: string; const Args: array of const);
begin
  Log(ALog, Args, llError);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Fatal
  说明: 致命错误日志
  参数: ALog 日志数据
------------------------------------------------------------------------------ }
procedure TLogger.Fatal(ALog: string);
begin
  Log(ALog, llFatal);
end;

{ ------------------------------------------------------------------------------
  名称: TLogger.Fatal
  说明: 致命错误日志
  参数: ALog 包含格式化格式信息的日志数据
        Args 用于格式化的参数
------------------------------------------------------------------------------ }
procedure TLogger.Fatal(ALog: string; const Args: array of const);
begin
  Log(ALog, Args, llFatal);
end;
{$IFDEF Compatible_Old_Version}


{ -------------------------------------------------------------------------------
  名称: TLogger.WriteLog
  说明: 旧版本日志输出函数，为兼容保留，不建议使用
  参数: ALog 日志数据
        ALogLevel 日志级别
------------------------------------------------------------------------------- }
procedure TLogger.WriteLog(ALog: String; const ALogLevel: integer);
var
  ALvl: TLogLevel;
begin
  case ALogLevel of
    0:
      ALvl := llInfo;
    1, 2:
      ALvl := llWarn;
  else
    ALvl := llError;
  end;
  Log(ALog, ALvl);
end;

{ -------------------------------------------------------------------------------
  名称: TLogger.WriteLog
  说明: 旧版本日志输出函数，为兼容保留，不建议使用
  参数: ALog 包含格式化格式信息的日志数据
        Args 用于格式化的参数
        ALogLevel 日志级别
------------------------------------------------------------------------------- }
procedure TLogger.WriteLog(ALog: String; const Args: array of const; const ALogLevel: integer);
var
  ALvl: TLogLevel;
begin
  case ALogLevel of
    0:
      ALvl := llInfo;
    1, 2:
      ALvl := llWarn;
  else
    ALvl := llError;
  end;
  Log(ALog, Args, ALvl);
end;
{$ENDIF}

initialization

g_Logger := TLogger.Create;

finalization

FreeAndNil(g_Logger);

end.
