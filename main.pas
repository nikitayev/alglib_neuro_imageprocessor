unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask, JvToolEdit, Vcl.ExtCtrls,
  DIB, XALGLIB, UITypes, Vcl.Menus, U_VectorList, IOUtils, math, U_TrainProgressForm,
  U_WMUtils, U_NeuralTrainerThread, JclSysInfo, U_SetNetworkParametersForm;

type

  TForm1 = class(TForm)
    DXDIBSrc: TDXDIB;
    ScrollBoxSrc: TScrollBox;
    ImageSrc: TImage;
    DXDIBAfterEffect: TDXDIB;
    Panel1: TPanel;
    JvFilenameEdit: TJvFilenameEdit;
    Splitter1: TSplitter;
    ScrollBoxAfterEffect: TScrollBox;
    ImageAfterEffect: TImage;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N1x1: TMenuItem;
    N2x1: TMenuItem;
    N3x1: TMenuItem;
    N4x1: TMenuItem;
    miProduct: TMenuItem;
    miGenerateVariant1: TMenuItem;
    N3: TMenuItem;
    miStartNeuroTrain: TMenuItem;
    miSaveNetworkToFile: TMenuItem;
    miLoadNetwork: TMenuItem;
    OpenDialogNetwork: TOpenDialog;
    miApplyNetwork: TMenuItem;
    N21: TMenuItem;
    miStartNeuroTrainRadius2: TMenuItem;
    miStartNeuroTrainRadius3: TMenuItem;
    miGenerateVariant2: TMenuItem;
    miStartNeuroTrainRadius4: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    procedure JvFilenameEditAfterDialog(Sender: TObject; var AName: string; var AAction: Boolean);
    procedure btGenerateClick(Sender: TObject);
    procedure N1x1Click(Sender: TObject);
    procedure miGenerateVariant1Click(Sender: TObject);
    procedure N2x1Click(Sender: TObject);
    procedure N3x1Click(Sender: TObject);
    procedure N4x1Click(Sender: TObject);
    procedure miSaveNetworkToFileClick(Sender: TObject);
    procedure miLoadNetworkClick(Sender: TObject);
    procedure miApplyNetworkClick(Sender: TObject);
    procedure miStartNeuroTrainRadius2Click(Sender: TObject);
    procedure miStartNeuroTrainRadius3Click(Sender: TObject);
    procedure miStartNeuroTrainRadius4Click(Sender: TObject);
    procedure miGenerateVariant2Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
  private
    procedure GenerateImages(SquareLen, SquareCount: Integer);
    procedure MessageReceiver(var msg: TMessage); message WM_EndOfTrain;
    procedure RunTraining(aRadius: byte; nhid1, nhid2: Cardinal);
    procedure ApplyNetworkRadiusX(aRadius: word);
    { Private declarations }
  public
    { Public declarations }
    // текущие используемые объекты (using objects)
    FNetworkSrc: Tmultilayerperceptron; // исходный объект нейросети
    FNetwork: Tmultilayerperceptron; // результирующая обученная нейросеть
    Frep: Tmlpreport;
    Finfo: NativeInt;
    FMatrix: TMatrix;
    FRunnedThreads: Integer; // всего запущено потоков
    FDoneThreadCount: Integer; // завершённых потоков
    FFileName: string;
    procedure ReDrawImages;
  end;

const
  SquareLen = 8;
  SquareCount = 4;
  LearningRadius = 2; // 5x5

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure GenerateRandom(aDIB: TDIB; SquareLen, SquareCount: Integer);
var
  x, y: Integer;
  brightness: byte;
begin
  for y := 0 to SquareLen * SquareCount do
    for x := 0 to SquareLen * SquareCount do
    begin
      brightness := random(256);
      aDIB.Pixels[x, y] := RGB(brightness, brightness, brightness);
    end;
end;

procedure GenerateLines(aDIB: TDIB; SquareLen, SquareCount: Integer);
var
  i: Integer;
begin
  aDIB.Canvas.Pen.Color := RGB(255, 255, 255);
  for i := 0 to SquareCount do
  begin
    aDIB.Canvas.MoveTo(i * SquareLen, 0);
    aDIB.Canvas.LineTo(i * SquareLen, SquareLen * SquareCount);
  end;
  for i := 0 to SquareCount do
  begin
    aDIB.Canvas.MoveTo(0, i * SquareLen);
    aDIB.Canvas.LineTo(SquareLen * SquareCount, i * SquareLen);
  end;
end;

procedure GenerateBlackAndWhiteSquare(aDIB: TDIB; SquareLen, SquareCount: Integer);
begin
  aDIB.Canvas.Brush.Color := RGB(255, 255, 255);
  aDIB.Canvas.Pen.Color := aDIB.Canvas.Brush.Color;
  aDIB.Canvas.Rectangle(0, SquareLen * (SquareCount - 1), SquareLen, SquareLen * SquareCount);
  aDIB.Canvas.Brush.Color := RGB(0, 0, 0);
  aDIB.Canvas.Pen.Color := aDIB.Canvas.Brush.Color;
  aDIB.Canvas.Rectangle(0, SquareLen * (SquareCount - 2), SquareLen, SquareLen * (SquareCount - 1));
end;

function GetAsByte(aValue: double): byte;
begin
  result := max(0, min(255, round(aValue)));
end;

// формирование обучающей матрицы
// исходный прямоугольник берётся с отступом в радиус от своих краёв
function GetMatrix(aDIBAfterEffect, aDIBSrc: TDIB; aRect: TRect; aRadius: Integer): TMatrix;
var
  x, y, xsrc, ysrc: Integer;
  zpossrc: Integer;
  zRealRect: TRect;
  zVectorList: TVectorList;
  zVector: TVectorByte;
  zVectorLength: Integer;
begin
  zRealRect.Left := aRect.Left + aRadius;
  zRealRect.Top := aRect.Top + aRadius;
  zRealRect.Right := aRect.Right - aRadius;
  zRealRect.Bottom := aRect.Bottom - aRadius;

  zVectorList := TVectorList.Create;

  zVectorLength := sqr(aRadius * 2 + 1) + 1;
  SetLength(result, 
    (zRealRect.Right - zRealRect.Left + 1) * (zRealRect.Bottom - zRealRect.Top + 1),
    zVectorLength);

  zVectorList.VectorLength := zVectorLength;
  GetMem(zVector, zVectorLength);
  for y := zRealRect.Top to zRealRect.Bottom do
    for x := zRealRect.Left to zRealRect.Right do
    begin
      // сначала заполним первые элементы - квадратом исходного изображения
      zpossrc := 0;
      for xsrc := x - aRadius to x + aRadius do
        for ysrc := y - aRadius to y + aRadius do
        begin
          zVector[zpossrc] := aDIBAfterEffect.Pixels[xsrc, ysrc] and $FF;
          inc(zpossrc);
        end;
      // в конце - положим результирующую яркость
      zVector[zpossrc] := aDIBSrc.Pixels[x, y] and $FF;
      zVectorList.Add(zVector);
    end;

  result := ConstructMatrixFromVectorList(zVectorList);

  FreeMem(zVector);
  FreeAndNil(zVectorList);
end;

function GetNetwork(aMatrix: TMatrix; nhid1, nhid2: Cardinal): Tmultilayerperceptron;
var
  trn: Tmlptrainer;
begin
  mlpcreatetrainer(Length(aMatrix[0]) - 1, 1, trn);
  mlpsetdataset(trn, aMatrix, Length(aMatrix));
  mlpcreateb2(Length(aMatrix[0]) - 1, nhid1, nhid2, 1, 0, 0, result);
end;

procedure TForm1.btGenerateClick(Sender: TObject);
begin

  // GetNeuroMatrix(DXDIBSample.DIB, DXDIB.DIB, rect(LearningRadius, LearningRadius, ));
end;

procedure TForm1.JvFilenameEditAfterDialog(Sender: TObject; var AName: string; var AAction: Boolean);
begin
  if (FileExists(AName)) then
  begin
    DXDIBSrc.DIB.LoadFromFile(AName);
    DXDIBAfterEffect.DIB.Assign(DXDIBSrc.DIB);
    ReDrawImages;
  end;
end;

procedure TForm1.MessageReceiver(var msg: TMessage);
var
  zThread: TNeuralTrainerThread;
  zstr: ansistring;
begin
  //
  zThread := TNeuralTrainerThread(msg.WParam);
  // отобразим результат
  TrainProgressForm.AddResults(zThread.rep, zThread.info);

  // если до этого момента не было обученной сети - то присвоим
  if (not Assigned(FNetwork)) then
  begin
    FNetwork := zThread.FNetwork;
    Frep := zThread.rep;
    Finfo := zThread.info;

    TFile.AppendAllText(zThread.FInfoFileName, 
      Format('time: %s, info: %d, relclserror: %e, avgce: %e, rmserror: %e, avgerror: %e, avgrelerror: %e, ngrad: %d, nhess: %d, ncholesky: %d'#13#10,
      [DateTimeToStr(Now), Finfo, 
      Frep.relclserror, Frep.avgce, Frep.rmserror, Frep.avgerror, Frep.avgrelerror, 
      Frep.ngrad, Frep.nhess, Frep.ncholesky]), TEncoding.UTF8);
    mlpserialize(FNetwork, zstr);
    TFile.WriteAllText(zThread.FNetworkFileName, string(zstr));
  end
  else
    if (zThread.rep.rmserror < Frep.rmserror) then
  begin
    FreeAndNil(FNetwork);
    FNetwork := zThread.FNetwork;
    Frep := zThread.rep;
    Finfo := zThread.info;

    TFile.AppendAllText(zThread.FInfoFileName, 
      Format('time: %s, info: %d, relclserror: %e, avgce: %e, rmserror: %e, avgerror: %e, avgrelerror: %e, ngrad: %d, nhess: %d, ncholesky: %d'#13#10,
      [DateTimeToStr(Now), Finfo, 
      Frep.relclserror, Frep.avgce, Frep.rmserror, Frep.avgerror, Frep.avgrelerror, 
      Frep.ngrad, Frep.nhess, Frep.ncholesky]), TEncoding.UTF8);
    mlpserialize(FNetwork, zstr);
    TFile.WriteAllText(zThread.FNetworkFileName, string(zstr));
  end
  else
  begin
    FreeAndNil(zThread.FNetwork);
  end;

  zThread.Free;

  // если процесс обучения не прервыан - то запустим ещё один поток
  if (TrainProgressForm.FTrainMode = tmRun) then
  begin
    if (zThread.rep.rmserror > 0) then
      TNeuralTrainerThread.Create(FNetworkSrc.Clone, Clone(FMatrix),
        FFileName + '.network', FFileName + '.info')
    else
      TrainProgressForm.FTrainMode := tmNone;
  end;
end;

procedure TForm1.miApplyNetworkClick(Sender: TObject);
begin
  if (Assigned(FNetwork)) then
  begin
    ApplyNetworkRadiusX(2);
  end;
end;

procedure TForm1.miGenerateVariant1Click(Sender: TObject);
begin
  GenerateImages(8, 4);

  ReDrawImages;
end;

procedure TForm1.miGenerateVariant2Click(Sender: TObject);
begin
  GenerateImages(16, 6);

  ReDrawImages;
end;

procedure TForm1.miLoadNetworkClick(Sender: TObject);
var
  zstr: string;
begin
  //
  if (OpenDialogNetwork.Execute()) then
  begin
    if (Assigned(FNetwork)) then
      FreeAndNil(FNetwork);
    zstr := TFile.ReadAllText(OpenDialogNetwork.FileName);
    mlpunserialize(zstr, FNetwork);
  end;
end;

procedure TForm1.miSaveNetworkToFileClick(Sender: TObject);
begin
  //
end;

procedure TForm1.miStartNeuroTrainRadius2Click(Sender: TObject);
begin
  if (SetNetworkParametersForm.ShowModal = mrOk) then
    RunTraining(2, StrToInt(SetNetworkParametersForm.edNHID1.Text), StrToInt(SetNetworkParametersForm.edNHID2.Text));
end;

procedure TForm1.miStartNeuroTrainRadius3Click(Sender: TObject);
begin
  if (SetNetworkParametersForm.ShowModal = mrOk) then
    RunTraining(3, StrToInt(SetNetworkParametersForm.edNHID1.Text), StrToInt(SetNetworkParametersForm.edNHID2.Text));
end;

procedure TForm1.N1x1Click(Sender: TObject);
begin
  DXDIBAfterEffect.DIB.Blur(24, 1);
  ReDrawImages;
end;

procedure TForm1.N2x1Click(Sender: TObject);
begin
  DXDIBAfterEffect.DIB.Blur(24, 1);
  DXDIBAfterEffect.DIB.Blur(24, 1);
  ReDrawImages;
end;

procedure TForm1.N31Click(Sender: TObject);
begin
  if (Assigned(FNetwork)) then
  begin
    ApplyNetworkRadiusX(3);
  end;
end;

procedure TForm1.N3x1Click(Sender: TObject);
begin
  DXDIBAfterEffect.DIB.Blur(24, 1);
  DXDIBAfterEffect.DIB.Blur(24, 1);
  DXDIBAfterEffect.DIB.Blur(24, 1);
  ReDrawImages;
end;

procedure TForm1.miStartNeuroTrainRadius4Click(Sender: TObject);
begin
  if (SetNetworkParametersForm.ShowModal = mrOk) then
    RunTraining(4, StrToInt(SetNetworkParametersForm.edNHID1.Text), StrToInt(SetNetworkParametersForm.edNHID2.Text));
end;

procedure TForm1.N41Click(Sender: TObject);
begin
  if (Assigned(FNetwork)) then
  begin
    ApplyNetworkRadiusX(4);
  end;
end;

procedure TForm1.N4x1Click(Sender: TObject);
begin
  DXDIBAfterEffect.DIB.Blur(24, 1);
  DXDIBAfterEffect.DIB.Blur(24, 1);
  DXDIBAfterEffect.DIB.Blur(24, 1);
  DXDIBAfterEffect.DIB.Blur(24, 1);
  ReDrawImages;
end;

procedure TForm1.ReDrawImages;
begin
  if (DXDIBSrc.DIB.Width < 256) then
  begin
    ImageSrc.Picture.Bitmap.SetSize(DXDIBSrc.DIB.Width * 8, DXDIBSrc.DIB.Height * 8);
    ImageSrc.Width := ImageSrc.Picture.Bitmap.Width;
    ImageSrc.Height := ImageSrc.Picture.Bitmap.Height;
    ImageSrc.Picture.Bitmap.Canvas.StretchDraw(rect(0, 0, ImageSrc.Width, ImageSrc.Height),
      DXDIBSrc.DIB);

    ImageAfterEffect.Picture.Bitmap.SetSize(DXDIBAfterEffect.DIB.Width * 8, DXDIBAfterEffect.DIB.Height * 8);
    ImageAfterEffect.Width := ImageAfterEffect.Picture.Bitmap.Width;
    ImageAfterEffect.Height := ImageAfterEffect.Picture.Bitmap.Height;
    ImageAfterEffect.Picture.Bitmap.Canvas.StretchDraw(rect(0, 0, ImageAfterEffect.Width, ImageAfterEffect.Height),
      DXDIBAfterEffect.DIB);
  end
  else
  begin
    ImageSrc.Picture.Bitmap.SetSize(DXDIBSrc.DIB.Width, DXDIBSrc.DIB.Height);
    ImageSrc.Width := ImageSrc.Picture.Bitmap.Width;
    ImageSrc.Height := ImageSrc.Picture.Bitmap.Height;
    ImageSrc.Picture.Bitmap.Canvas.StretchDraw(rect(0, 0, ImageSrc.Width, ImageSrc.Height),
      DXDIBSrc.DIB);

    ImageAfterEffect.Picture.Bitmap.SetSize(DXDIBAfterEffect.DIB.Width, DXDIBAfterEffect.DIB.Height);
    ImageAfterEffect.Width := ImageAfterEffect.Picture.Bitmap.Width;
    ImageAfterEffect.Height := ImageAfterEffect.Picture.Bitmap.Height;
    ImageAfterEffect.Picture.Bitmap.Canvas.StretchDraw(rect(0, 0, ImageAfterEffect.Width, ImageAfterEffect.Height),
      DXDIBAfterEffect.DIB);
  end;
end;

procedure TForm1.ApplyNetworkRadiusX(aRadius: word);
var
  zVectR: TVector;
  zVectG: TVector;
  zVectB: TVector;
  zVectYR: TVector;
  zVectYG: TVector;
  zVectYB: TVector;
  y: Integer;
  x: Integer;
  count: Integer;
  y1: Integer;
  x1: Integer;
  zColor: Cardinal;
begin
  Screen.Cursor := crHourGlass;
  SetLength(zVectR, sqr(aRadius + aRadius + 1));
  SetLength(zVectG, sqr(aRadius + aRadius + 1));
  SetLength(zVectB, sqr(aRadius + aRadius + 1));
  SetLength(zVectYR, 1);
  SetLength(zVectYG, 1);
  SetLength(zVectYB, 1);
  with DXDIBSrc do
    for y := aRadius to DIB.Height - aRadius - 1 do
      for x := aRadius to DIB.Width - aRadius - 1 do
      begin
        // calc R, G, B
        count := 0;
        for y1 := y - aRadius to y + aRadius do
          for x1 := x - aRadius to x + aRadius do
          begin
            zColor := DIB.Pixels[x1, y1];
            zVectR[count] := GetRValue(zColor);
            zVectG[count] := GetGValue(zColor);
            zVectB[count] := GetBValue(zColor);
            inc(count);
          end;
        mlpprocess(FNetwork, zVectR, zVectYR);
        mlpprocess(FNetwork, zVectG, zVectYG);
        mlpprocess(FNetwork, zVectB, zVectYB);
        DXDIBAfterEffect.DIB.Pixels[x, y] := RGB(GetAsByte(zVectYR[0]), GetAsByte(zVectYG[0]), GetAsByte(zVectYB[0]));
      end;
  SetLength(zVectR, 0);
  SetLength(zVectG, 0);
  SetLength(zVectB, 0);
  SetLength(zVectYR, 0);
  SetLength(zVectYG, 0);
  SetLength(zVectYB, 0);
  ReDrawImages;
  Screen.Cursor := crDefault;
end;

procedure TForm1.RunTraining(aRadius: byte; nhid1, nhid2: Cardinal);
var
  i: Integer;
begin
  // пока есть незавершённые потоки - не начинаем новый процесс
  if (FRunnedThreads = FDoneThreadCount) then
  begin
    if (Assigned(FNetwork)) then
      FreeAndNil(FNetwork);
    FFileName := Format('%sradius_%d_nhid1_%d_nhid2_%d', [
      ExtractFilePath(ParamStr(0)), aRadius, nhid1, nhid2]);
    SetLength(FMatrix, 0);
    TrainProgressForm.FTrainMode := tmRun;
    Screen.Cursor := crHourGlass;
    FMatrix := GetMatrix(DXDIBAfterEffect.DIB, DXDIBSrc.DIB, rect(aRadius, aRadius, 
      DXDIBSrc.DIB.Width - aRadius - 1, DXDIBSrc.DIB.Height - aRadius - 1), aRadius);
    FNetworkSrc := GetNetwork(FMatrix, nhid1, nhid2);
    for i := 0 to ProcessorCount - 1 do
    begin
      TNeuralTrainerThread.Create(FNetworkSrc.Clone, Clone(FMatrix),
        FFileName + '.network', FFileName + '.info');
    end;
    TrainProgressForm.StartNewTask;
    TrainProgressForm.Show;
    Screen.Cursor := crDefault;
  end
  else
    MessageDlg('Предыдущий процесс обучения ещё не завершён', mtInformation, [mbOk], 0, mbOk);

end;

procedure TForm1.GenerateImages(SquareLen, SquareCount: Integer);
var
  i: Integer;
begin
  DXDIBSrc.DIB.SetSize(SquareLen * SquareCount, SquareLen * SquareCount, 24);
  DXDIBSrc.DIB.Canvas.Brush.Color := clBlack;
  DXDIBSrc.DIB.Canvas.FillRect(rect(0, 0, SquareLen * SquareCount, SquareLen * SquareCount));
  GenerateRandom(DXDIBSrc.DIB, SquareLen, SquareCount);
  GenerateLines(DXDIBSrc.DIB, SquareLen, SquareCount);
  GenerateBlackAndWhiteSquare(DXDIBSrc.DIB, SquareLen, SquareCount);
  DXDIBSrc.DIB.Canvas.Font.Color := clWhite;
  DXDIBAfterEffect.DIB.Assign(DXDIBSrc.DIB);
  for i := 0 to 6 do
  begin
    DXDIBAfterEffect.DIB.DrawTo(DXDIBSrc.DIB, i * SquareLen, 0, SquareLen * SquareCount, SquareLen * SquareCount, 0, 0);
    DXDIBSrc.DIB.Blur(24, 1);
  end;
  DXDIBSrc.DIB.Assign(DXDIBAfterEffect.DIB);
end;

end.
