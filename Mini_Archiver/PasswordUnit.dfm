object DlgPassword: TDlgPassword
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Password'
  ClientHeight = 137
  ClientWidth = 353
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
    Top = 88
    Width = 337
    Height = 9
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 108
    Height = 13
    Caption = 'Please insert password'
  end
  object BtnOk: TBitBtn
    Left = 192
    Top = 104
    Width = 73
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 272
    Top = 104
    Width = 73
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object PassWordEdit: TEdit
    Left = 8
    Top = 40
    Width = 337
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 2
  end
  object cbShowChar: TCheckBox
    Left = 8
    Top = 72
    Width = 337
    Height = 17
    Caption = 'Show char'
    TabOrder = 3
    OnClick = cbShowCharClick
  end
end
