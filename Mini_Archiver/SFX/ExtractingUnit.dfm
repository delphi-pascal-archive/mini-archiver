object DlgExtractFiles: TDlgExtractFiles
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Extract files'
  ClientHeight = 233
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 184
    Width = 441
    Height = 9
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 8
    Top = 28
    Width = 76
    Height = 13
    Caption = 'Extract directory'
  end
  object BtnOk: TBitBtn
    Left = 296
    Top = 200
    Width = 73
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 376
    Top = 200
    Width = 73
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object ExtractDirEdit: TEdit
    Left = 88
    Top = 24
    Width = 361
    Height = 21
    TabOrder = 2
  end
  object DirsTree: TShellTreeView
    Left = 144
    Top = 56
    Width = 305
    Height = 129
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 3
    OnChange = DirsTreeChange
  end
  object OverWriteBox: TRadioGroup
    Left = 8
    Top = 56
    Width = 129
    Height = 129
    Caption = 'Overwrite mode'
    ItemIndex = 0
    Items.Strings = (
      'Overwrite existing'
      'Leave Existing')
    TabOrder = 4
  end
end
