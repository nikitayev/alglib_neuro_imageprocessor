unit U_ImageModificatorThread;

interface

uses
  Windows, SysUtils, System.Classes, Forms, DIB, U_BufferImage, Ap, mlpbase, U_WMUtils, Math;

type
  TImageModificatorThread = class(TThread)
  private
    { Private declarations }
    FImageSrc: PBufferImage;
    FImageDst: PBufferImage;
    FRect: TRect;
    FNetwork: MultiLayerPerceptron;
    FRadius: Integer;
  protected
    procedure Execute; override;
  public
    // установить координаты рассчитываемого прямоугольника используя aRect.Top, aRect.Bottom, aRect.Left, aRect.Right
    constructor Create(aImageSrc, aImageDst: PBufferImage; aRect: TRect; aRadius: Integer;
      aNetwork: MultiLayerPerceptron);
  end;

implementation

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

  Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

  procedure TImageModificatorThread.UpdateCaption;
  begin
  Form1.Caption := 'Updated in a thread';
  end; 
  
  or 
  
  Synchronize( 
  procedure 
  begin
  Form1.Caption := 'Updated in thread via an anonymous method' 
  end
  )
  );
  
  where an anonymous method is passed.
  
  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
  
}

{ TImageModificatorThread }

constructor TImageModificatorThread.Create(aImageSrc, aImageDst: PBufferImage; aRect: TRect; aRadius: Integer;
  aNetwork: MultiLayerPerceptron);
begin
  FImageSrc := aImageSrc;
  FImageDst := aImageDst;
  FRect := aRect;
  FRadius := aRadius;
  FNetwork := aNetwork;
  FreeOnTerminate := true;
  inherited Create;
end;

procedure TImageModificatorThread.Execute;
  function GetAsByte(aValue: double): byte;
  begin
    result := max(0, min(255, round(aValue)));
  end;

var
  zVectR: TReal1DArray;
  zVectG: TReal1DArray;
  zVectB: TReal1DArray;
  zVectYR: TReal1DArray;
  zVectYG: TReal1DArray;
  zVectYB: TReal1DArray;
  y: Integer;
  x: Integer;
  count: Integer;
  y1: Integer;
  x1: Integer;
  zColor: TBGR;
begin
  SetLength(zVectR, sqr(FRadius + FRadius + 1));
  SetLength(zVectG, sqr(FRadius + FRadius + 1));
  SetLength(zVectB, sqr(FRadius + FRadius + 1));
  SetLength(zVectYR, 1);
  SetLength(zVectYG, 1);
  SetLength(zVectYB, 1);
  for y := FRect.Top to FRect.Bottom do
    for x := FRect.Left to FRect.Right do
    begin
      // calc R, G, B
      count := 0;
      try
        for y1 := y - FRadius to y + FRadius do
          for x1 := x - FRadius to x + FRadius do
          begin
            zColor := FImageSrc[y1, x1];
            zVectR[count] := zColor.R;
            zVectG[count] := zColor.G;
            zVectB[count] := zColor.B;
            inc(count);
          end;
        mlpprocess(FNetwork, zVectR, zVectYR);
        mlpprocess(FNetwork, zVectG, zVectYG);
        mlpprocess(FNetwork, zVectB, zVectYB);
        FImageDst[y, x].B := GetAsByte(zVectYB[0]);
        FImageDst[y, x].G := GetAsByte(zVectYG[0]);
        FImageDst[y, x].R := GetAsByte(zVectYR[0]);
      except
        on E: Exception do
      end;
    end;
  SetLength(zVectR, 0);
  SetLength(zVectG, 0);
  SetLength(zVectB, 0);
  SetLength(zVectYR, 0);
  SetLength(zVectYG, 0);
  SetLength(zVectYB, 0);
  MLPFree(FNetwork);

  PostMessage(Application.MainForm.Handle, WM_EndOfImagePaint, 0, 0);
end;

end.
