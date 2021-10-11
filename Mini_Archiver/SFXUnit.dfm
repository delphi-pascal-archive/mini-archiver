object DlgCreateSFX: TDlgCreateSFX
  Left = 193
  Top = 122
  BorderStyle = bsDialog
  Caption = 'Create SFX'
  ClientHeight = 145
  ClientWidth = 433
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
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 65
    Height = 13
    Caption = 'Archive name'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 67
    Height = 13
    Caption = 'PE EXE name'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 96
    Width = 417
    Height = 9
    Shape = bsBottomLine
  end
  object BtnOk: TBitBtn
    Left = 272
    Top = 112
    Width = 73
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 352
    Top = 112
    Width = 73
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object ArchiveEdit: TEdit
    Left = 8
    Top = 32
    Width = 385
    Height = 21
    TabOrder = 2
  end
  object BtnOpenArch: TBitBtn
    Left = 400
    Top = 32
    Width = 25
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = BtnOpenArchClick
  end
  object PEEdit: TEdit
    Left = 8
    Top = 72
    Width = 385
    Height = 21
    TabOrder = 4
  end
  object BtnSavePE: TBitBtn
    Left = 400
    Top = 72
    Width = 25
    Height = 21
    Caption = '...'
    TabOrder = 5
    OnClick = BtnSavePEClick
  end
  object DlgSaveMAF: TSaveDialog
    Filter = 'PE Executable (*.exe)|*.EXE|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save PE'
    Left = 40
  end
  object DlgOpenArch: TOpenDialog
    Filter = 'MAF files (*.maf)|*.MAF|All files (*.*)|*.*'
    Left = 8
  end
end
