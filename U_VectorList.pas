unit U_VectorList;

interface

uses Classes, Ap, mlpbase;
  //XALGLIB;

type

  TVectorByte = pbyte;

  TVectorList = class(TList)
  private
    FVectorLength: Integer;
    function GetItems(Index: Integer): TVectorByte;
    procedure SetItems(Index: Integer; const Value: TVectorByte);
    procedure SetVectorLength(const Value: Integer);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function Add(aVector: TVectorByte): Integer;
    function IndexOf(aVector: TVectorByte): Integer;
    property Items[Index: Integer]: TVectorByte read GetItems write SetItems; default;
    property VectorLength:Integer read FVectorLength write SetVectorLength;
  end;

function ConstructMatrixFromVectorList(aVectorList: TVectorList): TReal2DArray;

implementation

function VectorByteIsEquals(aV1, aV2: TVectorByte; aVectorLength: Integer): boolean;
var
  i: Integer;
begin
  result := true;
  for i := 0 to aVectorLength - 1 do
    if (aV1[i] <> aV2[i]) then
    begin
      result := false;
      exit;
    end;
end;

function ConstructMatrixFromVectorList(aVectorList: TVectorList): TReal2DArray;
var
  i, j: Integer;
begin
  if (aVectorList.Count > 0) then
  begin
    SetLength(result, aVectorList.Count, aVectorList.VectorLength);
    for i := 0 to aVectorList.Count - 1 do
      for j := 0 to aVectorList.VectorLength - 1 do
        result[i, j] := aVectorList[i][j];
  end
  else
    SetLength(result, 0);
end;

{ TVectorList }

function TVectorList.Add(aVector: TVectorByte): Integer;
var
  zVector: TVectorByte;
begin
  // добавим в список, если такого вектора нет и удалим, если есть
  result := IndexOf(aVector);
  if (result = -1) then
  begin
    GetMem(zVector, FVectorLength);
    system.move(aVector^, zVector^, FVectorLength);
    result := inherited Add(zVector);
  end;
end;

function TVectorList.GetItems(Index: Integer): TVectorByte;
begin
  result := TVectorByte(inherited Items[Index]);
end;

function TVectorList.IndexOf(aVector: TVectorByte): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if (VectorByteIsEquals(aVector, Items[i], FVectorLength)) then
    begin
      result := i;
      exit;
    end;
end;

procedure TVectorList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  case Action of
    lnAdded:
      ;
    lnExtracted:
      ;
    lnDeleted:
      FreeMem(Ptr);
  end;
end;

procedure TVectorList.SetItems(Index: Integer; const Value: TVectorByte);
begin
  inherited Items[Index] := Value;
end;

procedure TVectorList.SetVectorLength(const Value: Integer);
begin
  FVectorLength := Value;
end;

end.
