object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 571
  ClientWidth = 971
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 417
    Top = 33
    Height = 538
    ExplicitLeft = 656
    ExplicitTop = 272
    ExplicitHeight = 100
  end
  object ScrollBoxSrc: TScrollBox
    Left = 0
    Top = 33
    Width = 417
    Height = 538
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alLeft
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    object ImageSrc: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 971
    Height = 33
    Align = alTop
    TabOrder = 1
    object JvFilenameEdit: TJvFilenameEdit
      Left = 1
      Top = 1
      Width = 969
      Height = 31
      OnAfterDialog = JvFilenameEditAfterDialog
      Align = alClient
      Filter = 'JPEG|*.jpg;*.jpeg|All files (*.*)|*.*'
      TabOrder = 0
      Text = ''
      ExplicitHeight = 21
    end
  end
  object ScrollBoxAfterEffect: TScrollBox
    Left = 420
    Top = 33
    Width = 551
    Height = 538
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    object ImageAfterEffect: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
    end
  end
  object DXDIBSrc: TDXDIB
    Left = 176
    Top = 64
  end
  object DXDIBAfterEffect: TDXDIB
    Left = 576
    Top = 72
  end
  object MainMenu: TMainMenu
    Left = 652
    Top = 353
    object N1: TMenuItem
      Caption = #1069#1092#1092#1077#1082#1090#1099
      object N2: TMenuItem
        Caption = #1056#1072#1079#1084#1099#1090#1080#1077
        object N1x1: TMenuItem
          Caption = '1x'
          OnClick = N1x1Click
        end
        object N2x1: TMenuItem
          Caption = '2x'
          OnClick = N2x1Click
        end
        object N3x1: TMenuItem
          Caption = '3x'
          OnClick = N3x1Click
        end
        object N4x1: TMenuItem
          Caption = '4x'
          OnClick = N4x1Click
        end
      end
      object miApplyNetwork: TMenuItem
        Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1085#1077#1081#1088#1086#1089#1077#1090#1100
        object N21: TMenuItem
          Caption = #1088#1072#1076#1080#1091#1089' 2'
          OnClick = miApplyNetworkClick
        end
        object N31: TMenuItem
          Caption = #1088#1072#1076#1080#1091#1089' 3'
          OnClick = N31Click
        end
        object N41: TMenuItem
          Caption = #1056#1072#1076#1080#1091#1089' 4'
          OnClick = N41Click
        end
      end
    end
    object miProduct: TMenuItem
      Caption = #1043#1077#1085#1077#1088#1072#1094#1080#1103
      object miGenerateVariant1: TMenuItem
        Caption = #1042#1072#1088#1080#1072#1085#1090' 1 8x4'
        OnClick = miGenerateVariant1Click
      end
      object miGenerateVariant2: TMenuItem
        Caption = #1042#1072#1088#1080#1072#1085#1090' 2 16x6'
        OnClick = miGenerateVariant2Click
      end
      object miGenerateVariant3: TMenuItem
        Caption = #1042#1072#1088#1080#1072#1085#1090' 2 32x8'
        OnClick = miGenerateVariant3Click
      end
    end
    object N3: TMenuItem
      Caption = #1054#1073#1091#1095#1077#1085#1080#1077
      object miStartNeuroTrain: TMenuItem
        Caption = #1057#1090#1072#1088#1090' '#1086#1073#1091#1095#1077#1085#1080#1103
        object miStartNeuroTrainRadius2: TMenuItem
          Caption = #1056#1072#1076#1080#1091#1089' 2'
          OnClick = miStartNeuroTrainRadius2Click
        end
        object miStartNeuroTrainRadius3: TMenuItem
          Caption = #1056#1072#1076#1080#1091#1089' 3'
          OnClick = miStartNeuroTrainRadius3Click
        end
        object miStartNeuroTrainRadius4: TMenuItem
          Caption = #1056#1072#1076#1080#1091#1089' 4'
          OnClick = miStartNeuroTrainRadius4Click
        end
      end
      object miSaveNetworkToFile: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1074' '#1092#1072#1081#1083'...'
        OnClick = miSaveNetworkToFileClick
      end
      object miLoadNetwork: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1085#1077#1081#1088#1086#1089#1077#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072'...'
        OnClick = miLoadNetworkClick
      end
    end
    object N4: TMenuItem
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
      object miLoadFromFileLeft: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1083#1077#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        OnClick = miLoadFromFileLeftClick
      end
      object miLoadFromFileRight: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1072#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        OnClick = miLoadFromFileRightClick
      end
      object miCopyLeftImage: TMenuItem
        Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1083#1077#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        OnClick = miCopyLeftImageClick
      end
      object miCopyRightImage: TMenuItem
        Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1072#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        OnClick = miCopyRightImageClick
      end
      object miSaveLeftImageAsBMP: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1083#1077#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1074' BMP'
        OnClick = miSaveLeftImageAsBMPClick
      end
      object miSaveRightImageAsBMP: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1088#1072#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1074' BMP'
        OnClick = miSaveRightImageAsBMPClick
      end
      object miSaveLeftImageAsJPEG: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1083#1077#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1074' JPEG'
        OnClick = miSaveLeftImageAsJPEGClick
      end
      object miSaveRightImageAsJPEG: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1088#1072#1074#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1074' JPEG'
        OnClick = miSaveRightImageAsJPEGClick
      end
    end
  end
  object OpenDialogNetwork: TOpenDialog
    DefaultExt = '*.network'
    Options = [ofReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 328
    Top = 153
  end
  object OpenPictureDialogImage1: TOpenPictureDialog
    DefaultExt = 'jpg'
    Options = [ofReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 160
    Top = 313
  end
  object OpenPictureDialogImage2: TOpenPictureDialog
    DefaultExt = 'jpg'
    Options = [ofReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 464
    Top = 305
  end
  object SavePictureDialogImage1: TSavePictureDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 144
    Top = 385
  end
  object SavePictureDialogImage2: TSavePictureDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 464
    Top = 369
  end
end
