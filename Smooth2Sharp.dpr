// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program Smooth2Sharp;

uses
  FastMM5,
  Vcl.Forms,
  main in 'main.pas' {Form1},
  U_VectorList in 'U_VectorList.pas',
  xalglib in 'xalglib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
