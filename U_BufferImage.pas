unit U_BufferImage;

interface

uses Math, DIB;

const
  CImgMaxWidth = 1999;
  CImgMaxHeight = 1999;

type

  TBufferImage = array [0 .. CImgMaxHeight, 0 .. CImgMaxWidth] of TBGR;
  PBufferImage = ^TBufferImage;

function CreateImageCopy(aSrcImage: TDIB): PBufferImage;
procedure DrawCopy2Image(const aSrcImage: TBufferImage; aDstImage: TDIB);
procedure FreeImageCopy(var aImage: PBufferImage);

implementation

function CreateImageCopy(aSrcImage: TDIB): PBufferImage;
var
  x, y: Integer;
  SrcP: PBGR;
  width, height: Integer;
  linesize: Integer;
begin
  new(Result);
  width := min(CImgMaxWidth, aSrcImage.width - 1);
  height := min(CImgMaxHeight, aSrcImage.height - 1);
  linesize := width * sizeof(TBGR);
  for y := 0 to height do
    move(aSrcImage.ScanLineReadOnly[y]^, Result[y, 0], linesize);
end;

procedure DrawCopy2Image(const aSrcImage: TBufferImage; aDstImage: TDIB);
var
  x, y: Integer;
  SrcP: PBGR;
  width, height: Integer;
  linesize: Integer;
begin
  if (aDstImage.BitCount <> 24) then
    aDstImage.BitCount := 24;
  width := min(CImgMaxWidth, aDstImage.width - 1);
  height := min(CImgMaxHeight, aDstImage.height - 1);
  linesize := width * sizeof(TBGR);
  for y := 0 to height do
    move(aSrcImage[y, 0], aDstImage.ScanLineReadOnly[y]^, linesize);
end;

procedure FreeImageCopy(var aImage: PBufferImage);
begin
  dispose(aImage);
end;

end.
