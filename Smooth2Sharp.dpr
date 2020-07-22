// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program Smooth2Sharp;

uses
  FastMM5,
  Vcl.Forms,
  main in 'main.pas' {Form1},
  U_VectorList in 'U_VectorList.pas',
  xalglib in 'xalglib.pas',
  U_NeuralTrainerThread in 'U_NeuralTrainerThread.pas',
  U_WMUtils in 'U_WMUtils.pas',
  U_TrainProgressForm in 'U_TrainProgressForm.pas' {TrainProgressForm},
  U_SetNetworkParametersForm in 'U_SetNetworkParametersForm.pas' {SetNetworkParametersForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTrainProgressForm, TrainProgressForm);
  Application.CreateForm(TSetNetworkParametersForm, SetNetworkParametersForm);
  Application.Run;
end.
