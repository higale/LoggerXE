object formMain: TformMain
  Left = 100
  Top = 50
  Caption = 'Logger Demo VCL'
  ClientHeight = 481
  ClientWidth = 764
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  DesignSize = (
    764
    481)
  TextHeight = 15
  object btn2: TButton
    Left = 681
    Top = 47
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #36755#20986#26085#24535
    TabOrder = 0
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 681
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #21333#26465#26085#24535
    TabOrder = 1
    OnClick = btn3Click
  end
  object mmoLog: TMemo
    Left = 8
    Top = 8
    Width = 667
    Height = 465
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      'mmoLog')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
