unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, CPort, ExtCtrls, Mask, RXSpin, Buttons, BMDThread,
  ComCtrls, jpeg, ExtDlgs, CnHint;

type
  TfrmMain = class(TForm)
    comportMain: TComPort;
    tmr1: TTimer;
    grpPort: TGroupBox;
    lbl1: TLabel;
    cbbPortCOM: TComboBox;
    lbl2: TLabel;
    cbbPortSpeed: TComboBox;
    lbl3: TLabel;
    edtPortID: TEdit;
    grpAccelerometer: TGroupBox;
    seAccMinValue: TSpinEdit;
    lbl4: TLabel;
    lbl5: TLabel;
    seAccMaxValue: TSpinEdit;
    grpGyrometer: TGroupBox;
    lbl6: TLabel;
    lbl7: TLabel;
    seGyroMinValue: TSpinEdit;
    seGyroMaxValue: TSpinEdit;
    grpGPS: TGroupBox;
    lbl8: TLabel;
    rxspedtGPSLatFrom: TRxSpinEdit;
    rxspedtGPSLatTo: TRxSpinEdit;
    lbl9: TLabel;
    rxspedtGPSLongFrom: TRxSpinEdit;
    rxspedtGPSLongTo: TRxSpinEdit;
    lbl10: TLabel;
    rxspedtGPSAltitudeFrom: TRxSpinEdit;
    rxspedtGPSAltitudeTo: TRxSpinEdit;
    btnStartStopDataTransmit: TBitBtn;
    bmdthrdMain: TBMDThread;
    statMain: TStatusBar;
    grpDelay: TGroupBox;
    lbl13: TLabel;
    sePayloadTimingFreq: TSpinEdit;
    lbl14: TLabel;
    lbl15: TLabel;
    sePayloadTimingImageDelay: TSpinEdit;
    lbl16: TLabel;
    grpPayloadCommand: TGroupBox;
    lbl11: TLabel;
    edtPayloadCommandGetSensor: TEdit;
    lbl12: TLabel;
    edtPayloadCommandGetImage: TEdit;
    grpImage: TGroupBox;
    imgPayloadImage: TImage;
    dlgOpenPicMain: TOpenPictureDialog;
    grpValue: TGroupBox;
    lbl17: TLabel;
    lblAccValue: TLabel;
    lbl18: TLabel;
    lblGyroValue: TLabel;
    lbl19: TLabel;
    lblGPSValue: TLabel;
    lbl20: TLabel;
    lbl21: TLabel;
    lbl22: TLabel;
    cnhnt1: TCnHint;
    procedure comportMainAfterOpen(Sender: TObject);
    procedure comportMainAfterClose(Sender: TObject);
    procedure btnStartStopDataTransmitClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure comportMainBeforeClose(Sender: TObject);
    procedure SimulationProcess(Sender: TObject);
    procedure bmdthrdMainExecute(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure bmdthrdMainTerminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure comportMainRxChar(Sender: TObject; Count: Integer);
    procedure bmdthrdMainStart(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure FormCreate(Sender: TObject);
    procedure imgPayloadImageDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  simMode: Integer = -1;
  cntFrameImage: Integer = 1;

implementation

{$R *.dfm}

//enable disable controll vcl

procedure EnableDisableControlSimulator(const isEnable: Boolean = False);
begin
  with frmMain do
  begin
    grpPort.Enabled := isEnable;
    grpAccelerometer.Enabled := isEnable;
    grpGyrometer.Enabled := isEnable;
    grpGPS.Enabled := isEnable;
    grpDelay.Enabled := isEnable;
    grpPayloadCommand.Enabled := isEnable;
  end;
end;

//calculate linear value prediction

function CalcLinearValue(aInputMin, aInputMax, aResultMin, aResultMax,
  aInputValue: Real):
  Real;
begin
  try
    Result := (((aInputValue - aInputMin) / (aInputMax - aInputMin)) *
      (aResultMax -
      aResultMin)) + aResultMin;
  except
    Result := 0;
  end;
end;

//calculate random float value

function CalcFloatRandomValueRange(aResultMin, aResultMax: Real): Real;
begin
  try
    Result := (Random * (aResultMax - aResultMin)) + aResultMin;
  except
    Result := 0;
  end;
end;

//set black image

function SetBlackImage(aTimage: TImage): Boolean;
var
  abmpx: TBitmap;
begin
  try
    abmpx := TBitmap.Create;
    with abmpx do
    begin
      Width := 200;
      Height := 200;
      PixelFormat := pf24bit;
      Canvas.Brush.Color := clRed;
      Canvas.FillRect(Rect(0, 0, 200, 100));
    end;
    aTimage.Picture.Assign(abmpx);
    abmpx.Free;
    Result := True;
  except
    begin
      abmpx.Free;
      Result := False;
    end;

  end;
end;

//resize image

procedure ResizeImage(aJPEGFname: string; aWidth, aHeight: Integer; const
  aTImage: TImage = nil
  );
var
  Jpg: TJPEGImage;
  Bmp, Bmpx: TBitmap;
  isJPG: Boolean;
begin
  try
    isJPG := (LowerCase(ExtractFileExt(aJPEGFname)) = '.jpg') or
      (LowerCase(ExtractFileExt(aJPEGFname))
      = '.jpeg');

    Jpg := TJPEGImage.Create;
    Bmp := TBitmap.Create;
    Bmpx := TBitmap.Create;

    if isJPG then
      Jpg.LoadFromFile(aJPEGFname)
    else
      Bmpx.LoadFromFile(aJPEGFname);

    // Copy JPEG to bitmap and resize it in one go
    Bmp.PixelFormat := pf24bit;
    Bmp.Width := aWidth;
    Bmp.Height := aHeight;

    Bmpx.PixelFormat := pf24bit;

    if isJPG then
      Bmp.Canvas.StretchDraw(Rect(0, 0, aWidth, aHeight), Jpg)
    else
      Bmp.Canvas.StretchDraw(Rect(0, 0, aWidth, aHeight), Bmpx);

    //assign to timage
    if aTImage <> nil then
      aTImage.Picture.Assign(Bmp);

    // Copy BMP back to JPG
    Jpg.Assign(Bmp);
    Jpg.Free;
    Bmp.Free;
    Bmpx.Free;
  except
    Jpg.Free;
    Bmp.Free;
    Bmpx.Free;
  end;
end;

//get and send frame image

function GetAndSendImageFrameData(aBitmap: TBitmap; aCOM: TComPort;
  aGPSLatValue, aGPSLongValue, aGPSAltitudeValue: Integer; const
  aFrame: Integer = 1): Boolean;
var
  lineData: PByteArray;
  idFrame: Integer;
  //  rr, rg, rb: Byte;
  abuff: array[0..32] of Byte;
begin
  try
    lineData := aBitmap.ScanLine[aFrame - 1];
    //    idFrame := 0;
    if aCOM.Connected then
      aCOM.WriteStr(Format(#255'%.03d', [aFrame]));
    //    for idFrame := 0 to ((aBitmap.Width - 1) * 3) do
    for idFrame := 0 to (aBitmap.Width - 1) do
    begin

      if aCOM.Connected then
      begin
        abuff[0] := lineData[idFrame * 3 + 2] - Ord(lineData[idFrame * 3 + 2] =
          $FF);
        abuff[1] := lineData[idFrame * 3 + 1] - Ord(lineData[idFrame * 3 + 1] =
          $FF);
        abuff[2] := lineData[idFrame * 3 + 0] - Ord(lineData[idFrame * 3 + 0] =
          $FF);
        aCOM.Write(abuff, 3);

        //        aCOM.WriteStr(
        //          chr(lineData[idFrame * 3 + 2] - Ord(lineData[idFrame * 3 + 2] = $FF))
        //          +
        //          //r
        //          chr(lineData[idFrame * 3 + 1] - Ord(lineData[idFrame * 3 + 1] = $FF))
        //          +
        //          //g
        //          chr(lineData[idFrame * 3 + 0] - Ord(lineData[idFrame * 3 + 0] = $FF))
        //          //b
        //          );

      end;
    end;
    if aCOM.Connected then
      aCOM.WriteStr(Format(' %.03d %.03d %.03d INA', [aGPSLatValue,
        aGPSLongValue,
          aGPSAltitudeValue]));
  except
    Result := False;
  end;
end;

//update monitoring value

procedure UpdateMonitorValue(
  gx, gy, gz,
  grx, gry, grz,
  gps_lat, gps_long, gps_altitude: Real
  );
begin
  try
    with frmMain do
    begin
      lblAccValue.Caption :=
        Format('X = %7.3f m/s'#178#13 +
        'Y = %7.3f m/s'#178#13 +
        'Z = %7.3f m/s'#178, [gx, gy, gz]);

      lblGyroValue.Caption :=
        Format('X = %10.3f '#176 + '/s'#13 +
        'Y = %10.3f '#176 + '/s'#13 +
        'Z = %10.3f '#176 + '/s', [grx, gry, grz]);

      lblGPSValue.Caption :=
        Format('Lat'#9 + '= %10.6f '#176#13 +
        'Long'#9 + '= %10.6f '#176#13 +
        'Alt'#9 + '= %10.3f m', [gps_lat, gps_long, gps_altitude]);
    end;
  except

  end;
end;

procedure TfrmMain.comportMainAfterOpen(Sender: TObject);
begin
  try
    btnStartStopDataTransmit.Caption := '&Stop';
    statMain.Panels[1].Text := 'START';
    statMain.Panels[2].Text := FormatDateTime('hh:mm:ss.zzz', Now) + ' : ' +
      'Starting';
    EnableDisableControlSimulator(False);
    bmdthrdMain.Start;
  except
  end;
end;

procedure TfrmMain.comportMainAfterClose(Sender: TObject);
begin
  try
    btnStartStopDataTransmit.Caption := '&Start';
    statMain.Panels[1].Text := 'STOP';
    statMain.Panels[2].Text := FormatDateTime('hh:mm:ss.zzz', Now) + ' : ' +
      'Stopped';
    EnableDisableControlSimulator(True);

    cntFrameImage := 1;
    simMode := -1;
  except
  end;
end;

procedure TfrmMain.btnStartStopDataTransmitClick(Sender: TObject);
begin
  try
    if btnStartStopDataTransmit.Caption = '&Start' then
    begin
      if not comportMain.Connected then
      begin
        comportMain.Port := cbbPortCOM.Text;
        comportMain.BaudRate := TBaudRate(cbbPortSpeed.ItemIndex + 7);
        comportMain.Open;
      end;
    end
    else
    begin
      comportMain.Close;
    end;
  except
    on e: Exception do
    begin
      MessageDlg('Cannot start simulator : '#13 + e.Message, mtError, [mbOK],
        MB_ICONERROR);
    end;
  end;
end;

procedure TfrmMain.tmr1Timer(Sender: TObject);
begin
  try
    statMain.Panels[0].Text := FormatDateTime('dd-mm-yyyy hh:mm:ss', Now);
  except

  end;
end;

procedure TfrmMain.comportMainBeforeClose(Sender: TObject);
begin
  bmdthrdMain.Stop;
end;

procedure TfrmMain.SimulationProcess(Sender: TObject);
var
  dtx: string;
  accx, accy, accz,
    gyrox, gyroy, gyroz,
    gps_lat, gps_long, gps_altitude: Integer;
  accxf, accyf, acczf,
    gyroxf, gyroyf, gyrozf,
    gps_latf, gps_longf, gps_altitudef: Real;
begin
  try
    //random
    if simMode = 0 then
    begin
      if comportMain.Connected then
      begin
        accxf := CalcFloatRandomValueRange(seAccMinValue.Value,
          seAccMaxValue.Value);
        accyf := CalcFloatRandomValueRange(seAccMinValue.Value,
          seAccMaxValue.Value);
        acczf := CalcFloatRandomValueRange(seAccMinValue.Value,
          seAccMaxValue.Value);

        accx := Trunc(CalcLinearValue(
          seAccMinValue.Value,
          seAccMaxValue.Value,
          0, 999,
          accxf));
        accy := Trunc(CalcLinearValue(
          seAccMinValue.Value,
          seAccMaxValue.Value,
          0, 999, accyf));
        accz := Trunc(CalcLinearValue(
          seAccMinValue.Value,
          seAccMaxValue.Value,
          0, 999, acczf));

        gyroxf := CalcFloatRandomValueRange(seGyroMinValue.Value,
          seGyroMaxValue.Value);
        gyroyf := CalcFloatRandomValueRange(seGyroMinValue.Value,
          seGyroMaxValue.Value);
        gyrozf := CalcFloatRandomValueRange(seGyroMinValue.Value,
          seGyroMaxValue.Value);

        gyrox := Trunc(CalcLinearValue(
          seGyroMinValue.Value,
          seGyroMaxValue.Value,
          0, 999, gyroxf));
        gyroy := Trunc(CalcLinearValue(
          seGyroMinValue.Value,
          seGyroMaxValue.Value,
          0, 999, gyroyf));
        gyroz := Trunc(CalcLinearValue(
          seGyroMinValue.Value,
          seGyroMaxValue.Value,
          0, 999, gyrozf));

        gps_latf := CalcFloatRandomValueRange(rxspedtGPSLatFrom.Value,
          rxspedtGPSLatTo.Value);
        gps_longf := CalcFloatRandomValueRange(rxspedtGPSLongFrom.Value,
          rxspedtGPSLongTo.Value);
        gps_altitudef := CalcFloatRandomValueRange(rxspedtGPSAltitudeFrom.Value,
          rxspedtGPSAltitudeTo.Value);

        gps_lat := Trunc(CalcLinearValue(rxspedtGPSLatFrom.Value,
          rxspedtGPSLatTo.Value, 0, 999,
          gps_latf));
        gps_long := Trunc(CalcLinearValue(rxspedtGPSLongFrom.Value,
          rxspedtGPSLongTo.Value, 0, 999,
          gps_longf));
        gps_altitude := Trunc(CalcLinearValue(rxspedtGPSAltitudeFrom.Value,
          rxspedtGPSAltitudeTo.Value, 0, 999,
          gps_altitudef));

        dtx :=
          Format(#13'%.03d %.03d %.03d %.03d %.03d %.03d %.03d %.03d %.03d %.03d %.03d',
          [
          StrToIntDef(edtPortID.Text, 0),
            accx, accy, accz,
            gyrox, gyroy, gyroz,
            gps_lat, gps_long, gps_altitude,
            StrToIntDef(edtPortID.Text, 0)
            ]);
        comportMain.WriteStr(dtx);

        statMain.Panels[2].Text := FormatDateTime('hh:mm:ss.zzz', Now) + ' : ' +
          dtx;

        UpdateMonitorValue(accxf, accyf, acczf, gyroxf, gyroyf, gyrozf,
          gps_latf, gps_longf, gps_altitudef);
      end;
    end

    else if simMode = 1 then
    begin
      accxf := CalcFloatRandomValueRange(seAccMinValue.Value,
        seAccMaxValue.Value);
      accyf := CalcFloatRandomValueRange(seAccMinValue.Value,
        seAccMaxValue.Value);
      acczf := CalcFloatRandomValueRange(seAccMinValue.Value,
        seAccMaxValue.Value);

      accx := Trunc(CalcLinearValue(
        seAccMinValue.Value,
        seAccMaxValue.Value,
        0, 999,
        accxf));
      accy := Trunc(CalcLinearValue(
        seAccMinValue.Value,
        seAccMaxValue.Value,
        0, 999, accyf));
      accz := Trunc(CalcLinearValue(
        seAccMinValue.Value,
        seAccMaxValue.Value,
        0, 999, acczf));

      gyroxf := CalcFloatRandomValueRange(seGyroMinValue.Value,
        seGyroMaxValue.Value);
      gyroyf := CalcFloatRandomValueRange(seGyroMinValue.Value,
        seGyroMaxValue.Value);
      gyrozf := CalcFloatRandomValueRange(seGyroMinValue.Value,
        seGyroMaxValue.Value);

      gyrox := Trunc(CalcLinearValue(
        seGyroMinValue.Value,
        seGyroMaxValue.Value,
        0, 999, gyroxf));
      gyroy := Trunc(CalcLinearValue(
        seGyroMinValue.Value,
        seGyroMaxValue.Value,
        0, 999, gyroyf));
      gyroz := Trunc(CalcLinearValue(
        seGyroMinValue.Value,
        seGyroMaxValue.Value,
        0, 999, gyrozf));

      gps_latf := CalcFloatRandomValueRange(rxspedtGPSLatFrom.Value,
        rxspedtGPSLatTo.Value);
      gps_longf := CalcFloatRandomValueRange(rxspedtGPSLongFrom.Value,
        rxspedtGPSLongTo.Value);
      gps_altitudef := CalcFloatRandomValueRange(rxspedtGPSAltitudeFrom.Value,
        rxspedtGPSAltitudeTo.Value);

      gps_lat := Trunc(CalcLinearValue(rxspedtGPSLatFrom.Value,
        rxspedtGPSLatTo.Value, 0, 999,
        gps_latf));
      gps_long := Trunc(CalcLinearValue(rxspedtGPSLongFrom.Value,
        rxspedtGPSLongTo.Value, 0, 999,
        gps_longf));
      gps_altitude := Trunc(CalcLinearValue(rxspedtGPSAltitudeFrom.Value,
        rxspedtGPSAltitudeTo.Value, 0, 999,
        gps_altitudef));

      UpdateMonitorValue(accxf, accyf, acczf, gyroxf, gyroyf, gyrozf,
        gps_latf, gps_longf, gps_altitudef);

      if cntFrameImage <= 200 then
      begin
        statMain.Panels[2].Text := FormatDateTime('hh:mm:ss.zzz', Now) + ' : ' +
          'Sending frame image #' + IntToStr(cntFrameImage);

        if cntFrameImage = 1 then //1st frame
        begin
          if comportMain.Connected then
          begin
            comportMain.ClearBuffer(True, True);
            comportMain.WriteStr(#13 + Format('%.03d',
              [StrToIntDef(edtPortID.Text, 0)]) + #$FF#13);
            SleepEx(500, True);
          end;
        end;

        GetAndSendImageFrameData(imgPayloadImage.Picture.Bitmap, comportMain,
          gps_lat, gps_long, gps_altitude,
          cntFrameImage);

        if cntFrameImage = 200 then
        begin
          comportMain.WriteStr('INA');
        end;

        Inc(cntFrameImage);

        if cntFrameImage = 201 then
          simMode := -1;
      end
      else
      begin
        cntFrameImage := 1;
        simMode := -1;
      end;
    end
    else
    begin

    end;

  except

  end;
end;

procedure TfrmMain.bmdthrdMainExecute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
  try
    while (not Thread.Terminated) do
    begin
      Thread.Synchronize(SimulationProcess);
      if simMode = 0 then
        SleepEx(Trunc(1000 / sePayloadTimingFreq.Value), False)
      else
        SleepEx(sePayloadTimingImageDelay.Value, False);
    end;
  except
    try
      bmdthrdMain.Stop;
    except
    end;
  end;
end;

procedure TfrmMain.bmdthrdMainTerminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
  try
    btnStartStopDataTransmit.Caption := '&Start';
    statMain.Panels[1].Text := 'STOP';
    statMain.Panels[2].Text := FormatDateTime('hh:mm:ss.zzz', Now) + ' : ' +
      'Stopped';
    EnableDisableControlSimulator(True);
  except
  end;
end;

procedure TfrmMain.comportMainRxChar(Sender: TObject; Count: Integer);
var
  dtcmd: string;
begin
  try
    comportMain.ReadStr(dtcmd, Count);
    if Pos(edtPayloadCommandGetSensor.Text, dtcmd) <> 0 then
    begin
      if (simMode <> 0) and (simMode <> 1) then
      begin
        simMode := 0;
        edtPayloadCommandGetSensor.Color := clLime;
      end
      else
      begin
        simMode := -1;
        edtPayloadCommandGetSensor.Color := clWhite;
        edtPayloadCommandGetImage.Color := clWhite;
      end;
    end
    else if Pos(edtPayloadCommandGetImage.Text, dtcmd) <> 0 then
    begin
      if simMode <> 1 then
      begin
        simMode := 1;
        edtPayloadCommandGetImage.Color := clLime;
      end
      else
      begin
        simMode := -1;
        edtPayloadCommandGetSensor.Color := clWhite;
        edtPayloadCommandGetImage.Color := clWhite;
      end;
    end;
  except

  end;
end;

procedure TfrmMain.bmdthrdMainStart(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
  simMode := -1; //start from stop condition
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SetBlackImage(imgPayloadImage);
  UpdateMonitorValue(0, 0, 0, 0, 0, 0, 0, 0, 0);
end;

procedure TfrmMain.imgPayloadImageDblClick(Sender: TObject);
begin
  try
    if dlgOpenPicMain.Execute then
    begin
      ResizeImage(dlgOpenPicMain.FileName, 200, 200, imgPayloadImage);
    end;
  except
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    bmdthrdMain.Stop;
  except

  end;
end;

end.

