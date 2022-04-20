object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 99
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 19
    Width = 48
    Height = 13
    Caption = #1048#1097#1077#1084' '#1076#1086':'
  end
  object Label2: TLabel
    Left = 9
    Top = 47
    Width = 47
    Height = 13
    Caption = #1055#1086#1090#1086#1082#1086#1074':'
  end
  object btnGo: TButton
    Left = 152
    Top = 31
    Width = 75
    Height = 25
    Caption = 'GO'
    TabOrder = 0
    OnClick = btnGoClick
  end
  object seCount: TSpinEdit
    Left = 72
    Top = 16
    Width = 65
    Height = 22
    MaxValue = 1000000
    MinValue = 0
    TabOrder = 1
    Value = 20
  end
  object seThread: TSpinEdit
    Left = 72
    Top = 44
    Width = 65
    Height = 22
    MaxValue = 25
    MinValue = 2
    TabOrder = 2
    Value = 2
  end
  object cbPresentation: TCheckBox
    Left = 8
    Top = 74
    Width = 97
    Height = 17
    Caption = #1047#1072#1084#1077#1076#1083#1080#1090#1100'?'
    TabOrder = 3
  end
end
