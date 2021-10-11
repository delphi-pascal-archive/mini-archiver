object DlgEditComment: TDlgEditComment
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Edit comment'
  ClientHeight = 209
  ClientWidth = 393
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
    Top = 162
    Width = 377
    Height = 7
    Shape = bsBottomLine
  end
  object Comment: TMemo
    Left = 8
    Top = 16
    Width = 377
    Height = 145
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object BtnOk: TBitBtn
    Left = 232
    Top = 176
    Width = 73
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 312
    Top = 176
    Width = 73
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
end
