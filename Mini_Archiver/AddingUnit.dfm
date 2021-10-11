object DlgAddFiles: TDlgAddFiles
  Left = 192
  Top = 122
  BorderStyle = bsDialog
  Caption = 'Add files into archive'
  ClientHeight = 233
  ClientWidth = 489
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
    Top = 186
    Width = 473
    Height = 7
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 408
    Top = 148
    Width = 60
    Height = 13
    Caption = 'Compression'
  end
  object FileList: TListView
    Left = 8
    Top = 24
    Width = 393
    Height = 161
    Columns = <
      item
        Caption = 'File name'
        Width = 100
      end
      item
        Caption = 'Size'
        Width = 60
      end
      item
        Caption = 'Path'
        Width = 200
      end>
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object BtnOk: TBitBtn
    Left = 328
    Top = 200
    Width = 73
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = BtnOkClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BtnCancel: TBitBtn
    Left = 408
    Top = 200
    Width = 73
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object BtnAdd: TBitBtn
    Left = 408
    Top = 24
    Width = 73
    Height = 25
    Caption = 'Add'
    TabOrder = 3
    OnClick = BtnAddClick
  end
  object BtnDelete: TBitBtn
    Left = 408
    Top = 56
    Width = 73
    Height = 25
    Caption = 'Delete'
    TabOrder = 4
    OnClick = BtnDeleteClick
  end
  object BtnClear: TBitBtn
    Left = 408
    Top = 88
    Width = 73
    Height = 25
    Caption = 'Clear'
    TabOrder = 5
    OnClick = BtnClearClick
  end
  object cbUsePassword: TCheckBox
    Left = 8
    Top = 204
    Width = 97
    Height = 17
    Caption = 'Use password'
    TabOrder = 7
    OnClick = cbUsePasswordClick
  end
  object PasswordEdit: TEdit
    Left = 112
    Top = 203
    Width = 209
    Height = 21
    Enabled = False
    TabOrder = 8
  end
  object cbCompression: TComboBox
    Left = 408
    Top = 164
    Width = 73
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 2
    TabOrder = 9
    Text = 'Normal'
    Items.Strings = (
      'None'
      'Fastest'
      'Normal'
      'Maximal')
  end
  object BtnComment: TBitBtn
    Left = 408
    Top = 120
    Width = 73
    Height = 25
    Caption = 'Comment'
    TabOrder = 6
    OnClick = BtnCommentClick
  end
  object DlgAddingFiles: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = 'Adding files into archive'
    Left = 16
    Top = 48
  end
end
