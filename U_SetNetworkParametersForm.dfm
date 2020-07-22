object SetNetworkParametersForm: TSetNetworkParametersForm
  Left = 0
  Top = 0
  Width = 408
  Height = 148
  AutoScroll = True
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1086#1073#1091#1095#1077#1085#1080#1103
  Color = clBtnFace
  Constraints.MinHeight = 148
  Constraints.MinWidth = 408
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Left = 10
  GlassFrame.Top = 10
  GlassFrame.Right = 10
  GlassFrame.Bottom = 50
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    392
    109)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 212
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1085#1077#1081#1088#1086#1085#1086#1074' 1-'#1075#1086' '#1089#1082#1088#1099#1090#1086#1075#1086' '#1089#1083#1086#1103
  end
  object Label2: TLabel
    Left = 24
    Top = 35
    Width = 212
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1085#1077#1081#1088#1086#1085#1086#1074' 2-'#1075#1086' '#1089#1082#1088#1099#1090#1086#1075#1086' '#1089#1083#1086#1103
  end
  object edNHID1: TEdit
    Left = 256
    Top = 8
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 0
    Text = '10'
  end
  object edNHID2: TEdit
    Left = 256
    Top = 35
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    Text = '10'
  end
  object BitBtn1: TBitBtn
    Left = 309
    Top = 76
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    ExplicitLeft = 552
    ExplicitTop = 266
  end
  object BitBtn2: TBitBtn
    Left = 213
    Top = 76
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 3
    ExplicitLeft = 456
    ExplicitTop = 266
  end
end
