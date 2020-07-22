object TrainProgressForm: TTrainProgressForm
  Left = 0
  Top = 0
  Caption = 'Train progress form'
  ClientHeight = 296
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  ScreenSnap = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 255
    Width = 648
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      648
      41)
    object btStopTrainer: TButton
      Left = 565
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight, akBottom]
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btStopTrainerClick
    end
  end
  object sgTrainProgressGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 648
    Height = 255
    Align = alClient
    DefaultColWidth = 120
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
    TabOrder = 1
  end
end
