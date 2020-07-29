// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program Smooth2Sharp;

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF }
  Vcl.Forms,
  main in 'main.pas' {Form1},
  U_VectorList in 'U_VectorList.pas',
  U_NeuralTrainerThread in 'U_NeuralTrainerThread.pas',
  U_WMUtils in 'U_WMUtils.pas',
  U_TrainProgressForm in 'U_TrainProgressForm.pas' {TrainProgressForm},
  U_SetNetworkParametersForm in 'U_SetNetworkParametersForm.pas' {SetNetworkParametersForm},
  ap in 'alglib\ap.pas',
  mlpbase in 'alglib\mlpbase.pas',
  mlptrain in 'alglib\mlptrain.pas',
  reflections in 'alglib\reflections.pas',
  creflections in 'alglib\creflections.pas',
  hqrnd in 'alglib\hqrnd.pas',
  matgen in 'alglib\matgen.pas',
  ablasf in 'alglib\ablasf.pas',
  ablas in 'alglib\ablas.pas',
  trfac in 'alglib\trfac.pas',
  trlinsolve in 'alglib\trlinsolve.pas',
  safesolve in 'alglib\safesolve.pas',
  rcond in 'alglib\rcond.pas',
  matinv in 'alglib\matinv.pas',
  linmin in 'alglib\linmin.pas',
  minlbfgs in 'alglib\minlbfgs.pas',
  hblas in 'alglib\hblas.pas',
  sblas in 'alglib\sblas.pas',
  ortfac in 'alglib\ortfac.pas',
  blas in 'alglib\blas.pas',
  rotations in 'alglib\rotations.pas',
  bdsvd in 'alglib\bdsvd.pas',
  svd in 'alglib\svd.pas',
  xblas in 'alglib\xblas.pas',
  densesolver in 'alglib\densesolver.pas',
  U_ImageModificatorThread in 'U_ImageModificatorThread.pas',
  U_BufferImage in 'U_BufferImage.pas',
  U_Utils in 'U_Utils.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTrainProgressForm, TrainProgressForm);
  Application.CreateForm(TSetNetworkParametersForm, SetNetworkParametersForm);
  Application.Run;

end.
