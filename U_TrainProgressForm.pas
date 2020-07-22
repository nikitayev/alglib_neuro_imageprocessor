unit U_TrainProgressForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls, XALGLIB;

type
  TTrainMode = (tmNone, tmRun);

type
  TTrainProgressForm = class(TForm)
    Panel1: TPanel;
    btStopTrainer: TButton;
    sgTrainProgressGrid: TStringGrid;
    procedure btStopTrainerClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentRow: Integer;
  public
    { Public declarations }
    FTrainMode: TTrainMode;
    procedure AddResults(aRep: Tmlpreport; info: NativeInt);
    procedure StartNewTask;
  end;

var
  TrainProgressForm: TTrainProgressForm;

implementation

{$R *.dfm}

{ TForm2 }

procedure TTrainProgressForm.AddResults(aRep: Tmlpreport; info: NativeInt);
begin
  with sgTrainProgressGrid do
  begin
    RowCount := RowCount + 1;
    Cells[0, FCurrentRow] := IntToStr(FCurrentRow);
    Cells[1, FCurrentRow] := FloatToStrF(aRep.relclserror, ffGeneral, 4, 2);
    Cells[2, FCurrentRow] := FloatToStrF(aRep.avgce, ffGeneral, 4, 2);
    Cells[3, FCurrentRow] := FloatToStrF(aRep.rmserror, ffGeneral, 4, 2);
    Cells[4, FCurrentRow] := FloatToStrF(aRep.avgerror, ffGeneral, 4, 2);
    Cells[5, FCurrentRow] := FloatToStrF(aRep.avgrelerror, ffGeneral, 4, 2);

    Cells[6, FCurrentRow] := IntToStr(aRep.ngrad);
    Cells[7, FCurrentRow] := IntToStr(aRep.nhess);
    Cells[8, FCurrentRow] := IntToStr(aRep.ncholesky);
    Cells[9, FCurrentRow] := IntToStr(info);
  end;
  Inc(FCurrentRow);
end;

procedure TTrainProgressForm.btStopTrainerClick(Sender: TObject);
begin
  FTrainMode := tmNone;
end;

procedure TTrainProgressForm.StartNewTask;
var
  i, j: Integer;
begin
  FCurrentRow := 1;
  with sgTrainProgressGrid do
  begin
    for i := 0 to ColCount - 1 do
      for j := 0 to RowCount - 1 do
        Cells[i, j] := '';

    ColCount := 10;
    RowCount := 2;
    Cells[0, 0] := '¹';
    Cells[1, 0] := 'relclserror';
    Cells[2, 0] := 'avgce';
    Cells[3, 0] := 'rmserror';
    Cells[4, 0] := 'avgerror';
    Cells[5, 0] := 'avgrelerror';
    Cells[6, 0] := 'ngrad';
    Cells[7, 0] := 'nhess';
    Cells[8, 0] := 'ncholesky';
    Cells[9, 0] := 'info';
  end;
end;

end.
