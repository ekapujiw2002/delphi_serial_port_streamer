unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CPort, StdCtrls, ExtCtrls,

  //for fast string
  FastStrings;

//image helper type
const
  PixelCountMax = 32768;

type
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;

type
  TForm1 = class(TForm)
    comportMain: TComPort;
    btnGetPict: TButton;
    btnCOMOpenClose: TButton;
    tmrRead: TTimer;
    lbl1: TLabel;
    mmo1: TMemo;
    img1: TImage;
    btn1: TButton;
    img2: TImage;
    cmdtpckt1: TComDataPacket;
    btn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCOMOpenCloseClick(Sender: TObject);
    procedure comportMainAfterClose(Sender: TObject);
    procedure comportMainAfterOpen(Sender: TObject);
    procedure comportMainRxChar(Sender: TObject; Count: Integer);
    procedure tmrReadTimer(Sender: TObject);
    procedure btnGetPictClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure cmdtpckt1Packet(Sender: TObject; const Str: string);
    procedure btn2Click(Sender: TObject);
    procedure cmdtpckt1Discard(Sender: TObject; const Str: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  streamImage: TMemoryStream;

implementation

{$R *.dfm}

function MemoryStreamToString(M: TMemoryStream): string;
begin
  SetString(Result, PChar(M.Memory), M.Size div SizeOf(Char));
end;

//find packet number of the data

function GetPacketNumber(aData: string; var aFrameData: string; var aGPSData:
  string): Integer;
var
  i, posx, resx: Integer;
begin
  resx := 0;
  aFrameData := '';
  aGPSData := '';
  for i := 200 downto 1 do
  begin
    posx := SmartPos(chr(255) + Format('%.3d', [i]), aData, False,
      Length(aData),
      False);
    //    posx := FastPos(aData, Format(#255'%.3d', [i]), Length(aData), 4, 1);
    if posx > 0 then
    begin
      resx := i;
      aFrameData := Copy(aData, posx + 4, 600);
      aGPSData := Copy(aData, posx + 605, 12);
      Break;
    end;
  end;
  Result := resx;
end;

function GetPacketNumber2(aData: string): Integer;
var
  i, posx, resx: Integer;
begin
  resx := 0;
  for i := 200 downto 1 do
  begin
    posx := SmartPos(chr(255) + Format('%.3d', [i]), aData, False,
      Length(aData),
      False);
    //    posx := FastPos(aData, Format(#255'%.3d', [i]), Length(aData), 4, 1);
    if posx > 0 then
    begin
      resx := i;
      Break;
    end;
  end;
  Result := resx;
end;

//get frame data

function ExtractFrameData(frameNumber: Integer; bufferData: string; const
  isIncludeGPSData: Boolean = False): string;
var
  i: Integer;
  sSearch: string;
begin
  sSearch := #255 + Format('%.3d', [frameNumber]);
  i := FastPos(bufferData, sSearch, Length(bufferData), Length(sSearch), 1);
  if i > 0 then
    Result := Copy(bufferData, i + 4, 600 + (ord(isIncludeGPSData) * 12))
  else
    Result := '';
end;

//display all image string

procedure ViewStringToImageAllFrame(aStringPackage: string; aImageHolder:
  TImage);
var
  i, j, k: INTEGER;
  Row: pRGBTripleArray;
  arrRGB: array[0..2] of Byte;
  aFrameStringPackage: string;
begin
  try
    for j := 0 to aImageHolder.Picture.Bitmap.Height - 1 do
    begin
      aFrameStringPackage := ExtractFrameData(j + 1, aStringPackage);

      //update scanline yg sesuai nomor framenya
      Row := aImageHolder.Picture.Bitmap.ScanLine[j];

      //load the data
      for i := 0 to aImageHolder.Picture.Bitmap.Width - 1 do
      begin

        try
          arrRGB[0] := ord(aFrameStringPackage[1 + (i * 3)]);
          arrRGB[1] := ord(aFrameStringPackage[1 + (i * 3) + 1]);
          arrRGB[2] := ord(aFrameStringPackage[1 + (i * 3) + 2]);
        except
          arrRGB[0] := 0;
          arrRGB[1] := 0;
          arrRGB[2] := 0;
        end;

        with Row[i] do
        begin
          if arrRGB[0] = $FE then
            arrRGB[0] := $FF;
          if arrRGB[1] = $FE then
            arrRGB[1] := $FF;
          if arrRGB[2] = $FE then
            arrRGB[2] := $FF;
          rgbtRed := arrRGB[0]; // pixels
          rgbtGreen := arrRGB[1];
          rgbtBlue := arrRGB[2];
        end;
      end;
    end;

  except

  end;

  // Display on screen
  aImageHolder.Refresh;
end;

//view image from string

procedure ViewStringToImage2(frameNum: Integer; aStringPackage: string;
  aImageHolder: TImage);
var
  i, j, k: INTEGER;
  Row: pRGBTripleArray;
  arrRGB: array[0..2] of Byte;
begin
  try
    //update scanline yg sesuai nomor framenya
    Row := aImageHolder.Picture.Bitmap.ScanLine[frameNum - 1];

    //load the data
    for i := 0 to aImageHolder.Picture.Bitmap.Width - 1 do
    begin

      if (Length(aStringPackage) - i - 1) >= 3 then
      begin
        arrRGB[0] := ord(aStringPackage[1 + (i * 3)]);
        arrRGB[1] := ord(aStringPackage[1 + (i * 3) + 1]);
        arrRGB[2] := ord(aStringPackage[1 + (i * 3) + 2]);

        with Row[i] do
        begin
          if arrRGB[0] = $FE then
            arrRGB[0] := $FF;
          if arrRGB[1] = $FE then
            arrRGB[1] := $FF;
          if arrRGB[2] = $FE then
            arrRGB[2] := $FF;
          rgbtRed := arrRGB[0]; // pixels
          rgbtGreen := arrRGB[1];
          rgbtBlue := arrRGB[2];
        end
      end
      else
        Break;
    end;

  except

  end;

  // Display on screen
  aImageHolder.Refresh;
end;

//reset image to black

procedure ResetImage(aImageHolder: TImage);
var
  i, j, k: INTEGER;
  Row: pRGBTripleArray;
  arrRGB: array[0..2] of Byte;
begin
  try
    for j := 0 to aImageHolder.Picture.Bitmap.Height - 1 do
    begin
      //update scanline yg sesuai nomor framenya
      Row := aImageHolder.Picture.Bitmap.ScanLine[j];

      //load the data
      for i := 0 to aImageHolder.Picture.Bitmap.Width - 1 do
      begin
        with Row[i] do
        begin
          rgbtRed := 0; // pixels
          rgbtGreen := 0;
          rgbtBlue := 0;
        end;
      end;
    end;

  except

  end;

  // Display on screen
  aImageHolder.Refresh;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  streamImage := TMemoryStream.Create;
  streamImage.Position := 0;

  cmdtpckt1.StartString := #$FF;
  cmdtpckt1.StopString := ' INA';
end;

procedure TForm1.btnCOMOpenCloseClick(Sender: TObject);
begin
  if btnCOMOpenClose.Caption = 'Open' then
  begin
    comportMain.Open;
  end
  else
  begin
    comportMain.Close;
  end;
end;

procedure TForm1.comportMainAfterClose(Sender: TObject);
begin
  btnCOMOpenClose.Caption := 'Open';
  tmrRead.Enabled := False;
  mmo1.Text := ExtractFrameData(200, MemoryStreamToString(streamImage), True);
end;

procedure TForm1.comportMainAfterOpen(Sender: TObject);
begin
  btnCOMOpenClose.Caption := 'Close';
end;

procedure TForm1.comportMainRxChar(Sender: TObject; Count: Integer);
var
  strx: string;
begin
  try
    comportMain.ReadStr(strx, Count);
    streamImage.Write(PChar(strx)^, Length(strx));
  except

  end;
end;

procedure TForm1.tmrReadTimer(Sender: TObject);
var
  adata, aframedate, agpsdata: string;
  fsx: TFileStream;
  strmTmp: TMemoryStream;
  fnum: Integer;
begin
  tmrRead.Enabled := False;
  try
    //    fsx := TFileStream.Create('img.log', fmShareDenyWrite or fmCreate);
    lbl1.Caption := 'L = ' + IntToStr(streamImage.Size);
    adata := MemoryStreamToString(streamImage);
    lbl1.Caption := lbl1.Caption + ' ( ' + IntToStr(Length(adata)) + ' )';

    fnum := GetPacketNumber(adata, aframedate, agpsdata);
    lbl1.Caption := lbl1.Caption + ' #' + IntToStr(fnum) + ' => ' +
      IntToStr(Length(aframedate));
    mmo1.Text := agpsdata;

    ViewStringToImage2(fnum, aframedate, img1);

    if (fnum = 200) and (Length(aframedate) >= 600) then
    begin
      tmrRead.Enabled := False;
      ViewStringToImageAllFrame(adata, img1);
    end
    else
      tmrRead.Enabled := True;
  except
    on e: Exception do
    begin
      fsx.Free;
      strmTmp.Free;
      lbl1.Caption := 'error : ' + e.Message;
    end;

  end;

end;

procedure TForm1.btnGetPictClick(Sender: TObject);
begin
  tmrRead.Enabled := False;
  streamImage.Clear;
  ResetImage(img1);
  comportMain.ClearBuffer(True, True);
  comportMain.WriteStr('ccc');
  //    tmrRead.Enabled := True;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  ViewStringToImageAllFrame(MemoryStreamToString(streamImage), img2);
end;

procedure TForm1.cmdtpckt1Packet(Sender: TObject; const Str: string);
var
  str1, frameData, gpsData: string;
  fnum: Integer;
begin
  try
    str1 := StringReplace(Str, #$FF#$0D, '', [rfReplaceAll]);
    fnum := StrToIntDef(Copy(Str1, 2, 3), -1);
    frameData := Copy(str1, 5, 600);
    gpsData := Copy(str1, 605, 12);
    mmo1.Text := IntToStr(fnum) + ' -> ' + IntToStr(Length(frameData)) + #13#10
      +
      gpsData;
    if (fnum > -1) then
      ViewStringToImage2(fnum, frameData, img1);
  except

  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  fsx: TFileStream;
begin
  fsx := TFileStream.Create('img.log', fmCreate or fmShareDenyWrite);
  with fsx do
  begin
    streamImage.Position := 0;
    CopyFrom(streamImage, streamImage.Size);
    Free;
  end;
end;

procedure TForm1.cmdtpckt1Discard(Sender: TObject; const Str: string);
begin
  mmo1.Text := 'discarded = '#13#10 + Str;
end;

end.

