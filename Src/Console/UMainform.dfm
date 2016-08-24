object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 554
  ClientWidth = 805
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object spl1: TSplitter
    Left = 0
    Top = 347
    Width = 805
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 373
  end
  object stat1: TStatusBar
    Left = 0
    Top = 535
    Width = 805
    Height = 19
    Panels = <>
    ExplicitLeft = 408
    ExplicitTop = 288
    ExplicitWidth = 0
  end
  object lv1: TListView
    Left = 0
    Top = 0
    Width = 805
    Height = 299
    Align = alClient
    Columns = <
      item
        Caption = 'PID'
      end
      item
        Caption = #36134#21495
      end
      item
        Caption = #26381#21153#22120
      end
      item
        Caption = #35282#33394#21517
      end
      item
        Caption = #31561#32423
      end
      item
        Caption = #32463#39564#20540
      end
      item
        Caption = #32972#21253
      end
      item
        Caption = #37329#38065
      end
      item
        Caption = #33050#26412
      end
      item
        AutoSize = True
        Caption = #29366#24577
      end>
    GridLines = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    ExplicitHeight = 371
  end
  object pnl1: TPanel
    Left = 0
    Top = 352
    Width = 805
    Height = 183
    Align = alBottom
    TabOrder = 2
    object pgc1: TPageControl
      Left = 1
      Top = 1
      Width = 803
      Height = 181
      ActivePage = ts1
      Align = alClient
      TabOrder = 0
      object ts1: TTabSheet
        Caption = #26085#24535
        ExplicitWidth = 281
        ExplicitHeight = 165
        object mmo1: TMemo
          Left = 0
          Top = 0
          Width = 795
          Height = 153
          Align = alClient
          Color = clMoneyGreen
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitHeight = 129
        end
      end
    end
  end
  object grp1: TGroupBox
    Left = 0
    Top = 299
    Width = 805
    Height = 48
    Align = alBottom
    Caption = #25805#20316
    TabOrder = 3
    object btn1: TButton
      Left = 727
      Top = 15
      Width = 75
      Height = 25
      Caption = #21551#21160#25346#26426
      TabOrder = 0
    end
    object lbledt1: TLabeledEdit
      Left = 50
      Top = 18
      Width = 100
      Height = 20
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #36134#21495':'
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object lbledt2: TLabeledEdit
      Left = 200
      Top = 18
      Width = 100
      Height = 20
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #23494#30721':'
      LabelPosition = lpLeft
      TabOrder = 2
    end
    object btn2: TButton
      Left = 420
      Top = 15
      Width = 75
      Height = 25
      Caption = #24555#36895#21551#21160
      TabOrder = 3
    end
    object lbledt3: TLabeledEdit
      Left = 360
      Top = 18
      Width = 50
      Height = 20
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = #26381#21153#22120':'
      LabelPosition = lpLeft
      TabOrder = 4
    end
    object btn3: TButton
      Left = 501
      Top = 15
      Width = 75
      Height = 25
      Caption = #28165#31354#26085#24535
      TabOrder = 5
      OnClick = btn3Click
    end
  end
  object mm1: TMainMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 640
    Top = 56
    object N1: TMenuItem
      Caption = #25991#20214
      object SetAccountMeumItem: TMenuItem
        Caption = #23548#20837#36134#21495#25991#20214
        OnClick = SetAccountMeumItemClick
      end
      object N2: TMenuItem
        Caption = #20445#23384#36134#21495#20462#25913
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #20851#38381#25346#26426#36719#20214
      end
    end
    object N5: TMenuItem
      Caption = #37197#32622
      object N6: TMenuItem
        Caption = #25346#26426#36134#21495#37197#32622
      end
      object N7: TMenuItem
        Caption = #25346#26426#36719#20214#37197#32622
      end
    end
    object N8: TMenuItem
      Caption = #25480#26435
      object N9: TMenuItem
        Caption = #26597#35810#25480#26435#20449#24687
      end
    end
    object N10: TMenuItem
      Caption = #20851#20110
      object N11: TMenuItem
        Caption = #26816#26597#26356#26032
      end
      object N12: TMenuItem
        Caption = #36719#20214#29256#26412#21495
      end
    end
  end
end
