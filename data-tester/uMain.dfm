object frmMain: TfrmMain
  Left = 372
  Top = 238
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Payload Simulator by EX4'
  ClientHeight = 434
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Consolas'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ScreenSnap = True
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object grpPort: TGroupBox
    Left = 0
    Top = 0
    Width = 153
    Height = 105
    Caption = ' Port '
    TabOrder = 0
    object lbl1: TLabel
      Left = 8
      Top = 24
      Width = 28
      Height = 15
      Caption = 'Port'
    end
    object lbl2: TLabel
      Left = 8
      Top = 48
      Width = 56
      Height = 15
      Caption = 'Baudrate'
    end
    object lbl3: TLabel
      Left = 8
      Top = 80
      Width = 14
      Height = 15
      Caption = 'ID'
    end
    object cbbPortCOM: TComboBox
      Left = 72
      Top = 20
      Width = 73
      Height = 23
      Hint = 'Set communication port'
      Style = csDropDownList
      ItemHeight = 15
      ItemIndex = 0
      TabOrder = 0
      Text = 'COM1'
      Items.Strings = (
        'COM1'
        'COM2'
        'COM3'
        'COM4'
        'COM5'
        'COM6'
        'COM7'
        'COM8'
        'COM9'
        'COM10'
        'COM11'
        'COM12'
        'COM13'
        'COM14'
        'COM15'
        'COM16'
        'COM17'
        'COM18'
        'COM19'
        'COM20'
        'COM21'
        'COM22'
        'COM23'
        'COM24'
        'COM25'
        'COM26'
        'COM27'
        'COM28'
        'COM29'
        'COM30'
        'COM31'
        'COM32'
        'COM33'
        'COM34'
        'COM35'
        'COM36'
        'COM37'
        'COM38'
        'COM39'
        'COM40'
        'COM41'
        'COM42'
        'COM43'
        'COM44'
        'COM45'
        'COM46'
        'COM47'
        'COM48'
        'COM49'
        'COM50')
    end
    object cbbPortSpeed: TComboBox
      Left = 72
      Top = 44
      Width = 73
      Height = 23
      Hint = 'Communication speed'
      Style = csDropDownList
      ItemHeight = 15
      ItemIndex = 5
      TabOrder = 1
      Text = '57600'
      Items.Strings = (
        '9600'
        '14400'
        '19200'
        '38400'
        '56000'
        '57600'
        '115200')
    end
    object edtPortID: TEdit
      Left = 72
      Top = 72
      Width = 33
      Height = 23
      Hint = 'Payload ID'
      MaxLength = 3
      TabOrder = 2
      Text = '000'
    end
  end
  object grpAccelerometer: TGroupBox
    Left = 160
    Top = 0
    Width = 137
    Height = 105
    Caption = ' Accelerometer '
    TabOrder = 1
    object lbl4: TLabel
      Left = 8
      Top = 24
      Width = 21
      Height = 15
      Caption = 'Min'
    end
    object lbl5: TLabel
      Left = 8
      Top = 48
      Width = 21
      Height = 15
      Caption = 'Max'
    end
    object lbl20: TLabel
      Left = 8
      Top = 72
      Width = 10
      Height = 22
      Hint = 
        'Value sent is calculated according to the formula below :'#13#10'Valu_' +
        'sent = ((Real_value - Value_min)/(Value_max - Value_min)) * 999'#13 +
        #10'0 <= Value_sent <= 999'
      Caption = '?'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -19
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object seAccMinValue: TSpinEdit
      Left = 40
      Top = 19
      Width = 81
      Height = 24
      Hint = 'Accelerometer minimal value'
      MaxValue = 999
      MinValue = -99
      TabOrder = 0
      Value = -16
    end
    object seAccMaxValue: TSpinEdit
      Left = 40
      Top = 43
      Width = 81
      Height = 24
      Hint = 'Accelerometer maximal value'
      MaxValue = 999
      MinValue = -99
      TabOrder = 1
      Value = 16
    end
  end
  object grpGyrometer: TGroupBox
    Left = 304
    Top = 0
    Width = 137
    Height = 105
    Caption = ' Gyrometer '
    TabOrder = 2
    object lbl6: TLabel
      Left = 8
      Top = 24
      Width = 21
      Height = 15
      Caption = 'Min'
    end
    object lbl7: TLabel
      Left = 8
      Top = 48
      Width = 21
      Height = 15
      Caption = 'Max'
    end
    object lbl21: TLabel
      Left = 8
      Top = 72
      Width = 10
      Height = 22
      Hint = 
        'Value sent is calculated according to the formula below :'#13#10'Valu_' +
        'sent = ((Real_value - Value_min)/(Value_max - Value_min)) * 999'#13 +
        #10'0 <= Value_sent <= 999'
      Caption = '?'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -19
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object seGyroMinValue: TSpinEdit
      Left = 40
      Top = 19
      Width = 81
      Height = 24
      Hint = 'Gyrometer minimal value'
      MaxValue = 16000
      MinValue = -16000
      TabOrder = 0
      Value = -2000
    end
    object seGyroMaxValue: TSpinEdit
      Left = 40
      Top = 43
      Width = 81
      Height = 24
      Hint = 'Gyrometer maximal value'
      MaxValue = 16000
      MinValue = -16000
      TabOrder = 1
      Value = 2000
    end
  end
  object grpGPS: TGroupBox
    Left = 0
    Top = 104
    Width = 441
    Height = 105
    Caption = ' GPS '
    TabOrder = 4
    object lbl8: TLabel
      Left = 8
      Top = 24
      Width = 56
      Height = 15
      Caption = 'Latitude'
    end
    object lbl9: TLabel
      Left = 8
      Top = 48
      Width = 63
      Height = 15
      Caption = 'Longitude'
    end
    object lbl10: TLabel
      Left = 8
      Top = 72
      Width = 56
      Height = 15
      Caption = 'Altitude'
    end
    object lbl22: TLabel
      Left = 272
      Top = 16
      Width = 10
      Height = 22
      Hint = 
        'Value sent is calculated according to the formula below :'#13#10'Valu_' +
        'sent = ((Real_value - Value_min)/(Value_max - Value_min)) * 999'#13 +
        #10'0 <= Value_sent <= 999'
      Caption = '?'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -19
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object rxspedtGPSLatFrom: TRxSpinEdit
      Left = 80
      Top = 20
      Width = 89
      Height = 23
      Hint = 'GPS latitude start from'
      Decimal = 6
      MaxValue = 90.000000000000000000
      MinValue = -90.000000000000000000
      ValueType = vtFloat
      TabOrder = 0
    end
    object rxspedtGPSLatTo: TRxSpinEdit
      Left = 176
      Top = 20
      Width = 89
      Height = 23
      Hint = 'GPS latitude to'
      Decimal = 6
      MaxValue = 90.000000000000000000
      MinValue = -90.000000000000000000
      ValueType = vtFloat
      Value = 90.000000000000000000
      TabOrder = 1
    end
    object rxspedtGPSLongFrom: TRxSpinEdit
      Left = 80
      Top = 44
      Width = 89
      Height = 23
      Hint = 'GPS longitude start from'
      Decimal = 6
      MaxValue = 90.000000000000000000
      MinValue = -90.000000000000000000
      ValueType = vtFloat
      TabOrder = 2
    end
    object rxspedtGPSLongTo: TRxSpinEdit
      Left = 176
      Top = 44
      Width = 89
      Height = 23
      Hint = 'GPS longitude to'
      Decimal = 6
      MaxValue = 90.000000000000000000
      MinValue = -90.000000000000000000
      ValueType = vtFloat
      Value = 90.000000000000000000
      TabOrder = 3
    end
    object rxspedtGPSAltitudeFrom: TRxSpinEdit
      Left = 80
      Top = 68
      Width = 89
      Height = 23
      Hint = 'GPS altitude start from'
      Decimal = 3
      MaxValue = 10000.000000000000000000
      MinValue = -90.000000000000000000
      ValueType = vtFloat
      TabOrder = 4
    end
    object rxspedtGPSAltitudeTo: TRxSpinEdit
      Left = 176
      Top = 68
      Width = 89
      Height = 23
      Hint = 'GPS altitude to'
      Decimal = 3
      MaxValue = 10000.000000000000000000
      ValueType = vtFloat
      Value = 3000.000000000000000000
      TabOrder = 5
    end
  end
  object btnStartStopDataTransmit: TBitBtn
    Left = 8
    Top = 384
    Width = 75
    Height = 25
    Caption = '&Start'
    TabOrder = 8
    OnClick = btnStartStopDataTransmitClick
  end
  object statMain: TStatusBar
    Left = 0
    Top = 415
    Width = 724
    Height = 19
    Panels = <
      item
        Width = 120
      end
      item
        Width = 75
      end
      item
        Width = 50
      end>
  end
  object grpDelay: TGroupBox
    Left = 0
    Top = 208
    Width = 217
    Height = 81
    Caption = ' Payload Timing '
    TabOrder = 5
    object lbl13: TLabel
      Left = 8
      Top = 24
      Width = 28
      Height = 15
      Caption = 'Freq'
    end
    object lbl14: TLabel
      Left = 98
      Top = 24
      Width = 14
      Height = 15
      Caption = 'Hz'
    end
    object lbl15: TLabel
      Left = 8
      Top = 56
      Width = 119
      Height = 15
      Caption = 'Image frame delay'
    end
    object lbl16: TLabel
      Left = 197
      Top = 56
      Width = 14
      Height = 15
      Caption = 'ms'
    end
    object sePayloadTimingFreq: TSpinEdit
      Left = 40
      Top = 19
      Width = 57
      Height = 24
      Hint = 'Payload sensor transmission frequency in Hz'
      MaxValue = 200
      MinValue = 1
      TabOrder = 0
      Value = 50
    end
    object sePayloadTimingImageDelay: TSpinEdit
      Left = 128
      Top = 51
      Width = 65
      Height = 24
      Hint = 'Payload image frame delay transmission in ms'
      MaxValue = 1000
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
  end
  object grpPayloadCommand: TGroupBox
    Left = 224
    Top = 208
    Width = 217
    Height = 81
    Caption = ' Payload Command '
    TabOrder = 6
    object lbl11: TLabel
      Left = 8
      Top = 24
      Width = 42
      Height = 15
      Caption = 'Sensor'
    end
    object lbl12: TLabel
      Left = 8
      Top = 48
      Width = 35
      Height = 15
      Caption = 'Image'
    end
    object edtPayloadCommandGetSensor: TEdit
      Left = 56
      Top = 20
      Width = 33
      Height = 23
      Hint = 'Sensor acquired command'
      MaxLength = 1
      TabOrder = 0
      Text = 's'
    end
    object edtPayloadCommandGetImage: TEdit
      Left = 56
      Top = 44
      Width = 33
      Height = 23
      Hint = 'Image acquire command'
      MaxLength = 1
      TabOrder = 1
      Text = 'c'
    end
  end
  object grpImage: TGroupBox
    Left = 448
    Top = 0
    Width = 275
    Height = 289
    Caption = ' Image '
    TabOrder = 3
    object imgPayloadImage: TImage
      Left = 38
      Top = 45
      Width = 200
      Height = 200
      Hint = 'Double click here to change payload image'
      Stretch = True
      OnDblClick = imgPayloadImageDblClick
    end
  end
  object grpValue: TGroupBox
    Left = 0
    Top = 288
    Width = 723
    Height = 89
    Caption = ' Value Monitor '
    TabOrder = 7
    object lbl17: TLabel
      Left = 8
      Top = 16
      Width = 91
      Height = 15
      Caption = 'Accelerometer'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object lblAccValue: TLabel
      Left = 8
      Top = 32
      Width = 105
      Height = 15
      Caption = 'X = 0.000 m/s^2'
    end
    object lbl18: TLabel
      Left = 152
      Top = 16
      Width = 63
      Height = 15
      Caption = 'Gyrometer'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object lblGyroValue: TLabel
      Left = 152
      Top = 32
      Width = 91
      Height = 15
      Caption = 'X = 0.000 '#39'/s'
    end
    object lbl19: TLabel
      Left = 296
      Top = 16
      Width = 21
      Height = 15
      Caption = 'GPS'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object lblGPSValue: TLabel
      Left = 296
      Top = 32
      Width = 112
      Height = 15
      Caption = 'Lat = 0.000000 '#39
    end
  end
  object comportMain: TComPort
    BaudRate = br57600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    Buffer.InputSize = 256000
    Buffer.OutputSize = 256000
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    OnAfterOpen = comportMainAfterOpen
    OnAfterClose = comportMainAfterClose
    OnBeforeClose = comportMainBeforeClose
    OnRxChar = comportMainRxChar
    Left = 348
    Top = 187
  end
  object tmr1: TTimer
    OnTimer = tmr1Timer
    Left = 412
    Top = 187
  end
  object bmdthrdMain: TBMDThread
    RefreshInterval = 50
    UpdateEnabled = False
    OnExecute = bmdthrdMainExecute
    OnStart = bmdthrdMainStart
    OnTerminate = bmdthrdMainTerminate
    Left = 284
    Top = 187
  end
  object dlgOpenPicMain: TOpenPictureDialog
    Filter = 'All(*.jpg,*.jpeg,*.bmp)|*.jpg;*.jpeg;*.bmp'
    Title = 'Open Image File'
    Left = 380
    Top = 187
  end
  object cnhnt1: TCnHint
    BackColor = clYellow
    BorderColor = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    HintStyle = hsBalloonHint
    Left = 316
    Top = 187
  end
end
