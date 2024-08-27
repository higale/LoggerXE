# Delphi ��־��(Logger Class for delphi xe)
- v1.0.2
- 2024-08-27 by gale
- https://github.com/higale/LoggerXE

## ����:
- Debug�����ԣ�ͨ���ڿ����лὫ������Ϊ��͵���־�������������ϸ�ĵ�����Ϣ��
- Info����Ϣ������������õ���Ϣ��ʹ�ý�ΪƵ����
- Warn�����棬���������Ǳ�ڴ�������Σ���Ȼ���򲻻ᱨ��������ע�⡣
- Error�����󣬼�¼������쳣��Ϣ��
- Fatal����������һ�������������������Ҫֹͣ��

## ��־�ļ�λ��
  ����ͨ������Root���ı���־�ļ�λ�ã���������ã���־ȱʡ�洢��
- Windows:
*��������Ŀ¼/log/*
- MacOS
*/Users/��ǰ�û�/.������/log/*

## ע��
g_Loggerʵ���Ѿ��Զ�����������ֱ��ʹ��

## ʹ�÷�����
    uses
      Logger;
    ...
    g_Logger.Debug('This is a %s log',['debug'])
    g_Logger.Error('������һЩ����');

    VCL��ʾ��־
    g_Logger.OnLog := procedure(Sender: TObject; ALevel: TLogLevel; ALevelTag: string; ALog: string; ATime: TDateTime)
      begin
        if mmoLog.Lines.Count > 1000 then
          mmoLog.Text := 'clear...';
        mmoLog.Lines.Add(Format('%s%s%s', [FormatDateTime('hh:mm:ss', ATime), ALevelTag, ALog]));
      end;

    FMX��ʾ��־
    g_Logger.OnLog := procedure(Sender: TObject; ALevel: TLogLevel; ALevelTag: string; ALog: string; ATime: TDateTime)
      begin
        if mmoLog.Lines.Count > 1000 then
          mmoLog.Text := 'clear...';
        mmoLog.Lines.Add(Format('%s%s%s', [FormatDateTime('hh:mm:ss', ATime), ALevelTag, ALog]));
        mmoLog.GoToTextEnd;
      end;
