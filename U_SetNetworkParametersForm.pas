unit U_SetNetworkParametersForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TSetNetworkParametersForm = class(TForm)
    edNHID1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edNHID2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    edDecay: TEdit;
    Label4: TLabel;
    edRestarts: TEdit;
    Label5: TLabel;
    edWStep: TEdit;
    Label6: TLabel;
    edIts: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetNetworkParametersForm: TSetNetworkParametersForm;

implementation

{$R *.dfm}

end.
