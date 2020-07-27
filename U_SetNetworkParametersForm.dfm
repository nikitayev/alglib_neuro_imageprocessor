object SetNetworkParametersForm: TSetNetworkParametersForm
  Left = 0
  Top = 0
  Width = 409
  Height = 246
  AutoScroll = True
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1086#1073#1091#1095#1077#1085#1080#1103
  Color = clBtnFace
  Constraints.MinHeight = 246
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
    393
    207)
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
  object Label3: TLabel
    Left = 24
    Top = 62
    Width = 107
    Height = 13
    Caption = #1047#1072#1090#1091#1093#1072#1085#1080#1077' (0.001..1)'
  end
  object Label4: TLabel
    Left = 24
    Top = 89
    Width = 78
    Height = 13
    Caption = #1056#1077#1089#1090#1072#1088#1090#1086#1074' (>0)'
  end
  object Label5: TLabel
    Left = 24
    Top = 116
    Width = 72
    Height = 13
    Caption = #1096#1072#1075' (0.001..1)'
  end
  object Label6: TLabel
    Left = 24
    Top = 143
    Width = 181
    Height = 13
    Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1095#1080#1089#1083#1086' '#1080#1090#1077#1088#1072#1094#1080#1081' (>0)'
  end
  object edNHID1: TEdit
    Left = 256
    Top = 8
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 0
    Text = '30'
  end
  object edNHID2: TEdit
    Left = 256
    Top = 35
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    Text = '30'
  end
  object BitBtn1: TBitBtn
    Left = 310
    Top = 174
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    ExplicitLeft = 309
    ExplicitTop = 76
  end
  object BitBtn2: TBitBtn
    Left = 214
    Top = 174
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 3
    ExplicitLeft = 213
    ExplicitTop = 76
  end
  object edDecay: TEdit
    Left = 256
    Top = 62
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 4
    Text = '0.01'
  end
  object edRestarts: TEdit
    Left = 256
    Top = 89
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 5
    Text = '1'
  end
  object edWStep: TEdit
    Left = 256
    Top = 116
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 6
    Text = '0.01'
  end
  object edIts: TEdit
    Left = 256
    Top = 143
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 7
    Text = '30'
  end
end
