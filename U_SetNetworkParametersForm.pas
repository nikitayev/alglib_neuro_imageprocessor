unit U_SetNetworkParametersForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Math, U_Utils;

type
  TSetNetworkParametersForm = class(TForm)
    edNHID1: TEdit;
    edNHID2: TEdit;
    edNHID3: TEdit;
    edDecay: TEdit;
    edRestarts: TEdit;
    edWStep: TEdit;
    edIts: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btSettingsSoft: TButton;
    btSettingsPrecission: TButton;
    procedure btSettingsSoftClick(Sender: TObject);
    procedure btSettingsPrecissionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetNetworkParametersForm: TSetNetworkParametersForm;

implementation

{$R *.dfm}


procedure TSetNetworkParametersForm.btSettingsPrecissionClick(Sender: TObject);
begin
  edNHID1.Text := IntToStr(max(StrToInt(edNHID1.Text), 30));
  edNHID2.Text := IntToStr(max(StrToInt(edNHID2.Text), 30));
  edNHID3.Text := IntToStr(max(StrToInt(edNHID3.Text), 10));
  edDecay.Text := '0.001';
  edRestarts.Text := '1';
  edWStep.Text := '0';
  edIts.Text := '300';
end;

procedure TSetNetworkParametersForm.btSettingsSoftClick(Sender: TObject);
begin
  edNHID1.Text := IntToStr(max(StrToInt(edNHID1.Text), 30));
  edNHID2.Text := IntToStr(max(StrToInt(edNHID2.Text), 30));
  edNHID3.Text := IntToStr(max(StrToInt(edNHID3.Text), 10));
  edDecay.Text := '0.01';
  edRestarts.Text := '1';
  edWStep.Text := '0';
  edIts.Text := '30';
end;

end.
