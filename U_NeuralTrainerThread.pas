unit U_NeuralTrainerThread;

interface

uses
  Windows, SysUtils, System.Classes, 
  //XALGLIB,
  Ap, mlpbase, mlptrain,
  U_WMUtils, SyncObjs;

type
  TNeuralTrainerThread = class(TThread)
  private
    { Private declarations }
    FMatrix: TReal2DArray;
  protected
    procedure Execute; override;
  public
    rep: mlpreport;
    info: Integer;
    FNetwork: MultiLayerPerceptron;
    FNetworkFileName: string;
    FInfoFileName: string;
    FDoRandomize: boolean;
    FDecay: double;
    FRestart: Integer;
    Fwstep: double;
    FMaxIts: Integer;
    FIsTerminated: PBoolean;
    constructor Create(aNetwork: MultiLayerPerceptron; aMatrix: TReal2DArray;
      const aNetworkFileName, aInfoFileName: string; aDoRandomize: boolean;
      aDecay: double; aRestart: Integer; awstep: double; aMaxIts: Integer);
  end;

implementation

uses Forms;

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

  Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

  procedure TNeuralTrainerThread.UpdateCaption;
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
var
  GStartCount: Cardinal = 0;
  GLock: TCriticalSection;

function GetNextStartCount: Cardinal;
begin
  GLock.Enter;
  result := GStartCount;
  inc(GStartCount);
  GLock.Leave;
end;

{ TNeuralTrainerThread }

constructor TNeuralTrainerThread.Create(aNetwork: MultiLayerPerceptron; aMatrix: TReal2DArray;
  const aNetworkFileName, aInfoFileName: string; aDoRandomize: boolean;
  aDecay: double; aRestart: Integer; awstep: double; aMaxIts: Integer);
begin
  FNetwork := aNetwork;
  FMatrix := aMatrix;
  FNetworkFileName := aNetworkFileName;
  FInfoFileName := aInfoFileName;
  FDoRandomize := aDoRandomize;
  FDecay := aDecay;
  FRestart := aRestart;
  Fwstep := awstep;
  FMaxIts := aMaxIts;
  new(FIsTerminated);
  inherited Create;
end;

procedure TNeuralTrainerThread.Execute;
begin
  { Place thread code here }
  if (FDoRandomize) then
  begin
    // randomize network weights
    mlprandomize(FNetwork);
  end;

  // mlptrainlm(FNetwork, FMatrix, Length(FMatrix), 0.001, 1, info, rep);
  mlptrainlbfgs(FNetwork, FMatrix, Length(FMatrix), FDecay, FRestart, Fwstep, FMaxIts, info, rep, FIsTerminated, rep.rmserror);
  //rep.rmserror := mlprmserror(FNetwork, FMatrix, Length(FMatrix));
  SetLength(FMatrix, 0);
  PostMessage(Application.MainForm.Handle, WM_EndOfTrain, NativeUInt(Self), 0);
  dispose(FIsTerminated);
end;

initialization

GLock := TCriticalSection.Create;

finalization

FreeAndNil(GLock);

end.
