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
