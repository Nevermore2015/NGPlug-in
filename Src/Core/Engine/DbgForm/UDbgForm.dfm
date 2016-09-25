object DbgForm: TDbgForm
  Left = 0
  Top = 0
  Caption = 'DbgForm'
  ClientHeight = 538
  ClientWidth = 728
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 728
    Height = 538
    ActivePage = ts1
    Align = alClient
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'Packet'
      object pnl1: TPanel
        Left = 0
        Top = 344
        Width = 720
        Height = 166
        Align = alBottom
        TabOrder = 0
        object btn1: TButton
          Left = 559
          Top = 29
          Width = 75
          Height = 25
          Caption = 'Clear'
          TabOrder = 0
          OnClick = btn1Click
        end
        object mmo2: TMemo
          Left = 1
          Top = 1
          Width = 552
          Height = 164
          Align = alLeft
          Lines.Strings = (
            'mmo2')
          TabOrder = 1
        end
        object chk1: TCheckBox
          Left = 559
          Top = 6
          Width = 66
          Height = 17
          Caption = 'Send'
          TabOrder = 2
        end
        object chk2: TCheckBox
          Left = 631
          Top = 6
          Width = 66
          Height = 17
          Caption = 'Recv'
          TabOrder = 3
        end
        object btn2: TButton
          Left = 559
          Top = 60
          Width = 75
          Height = 25
          Caption = 'Send'
          TabOrder = 4
        end
      end
      object mmo1: TMemo
        Left = 0
        Top = 0
        Width = 720
        Height = 344
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
end
