unit U_NeuralTrainerThread;

interface

uses
  Windows, System.Classes, XALGLIB, U_WMUtils;

type
  TNeuralTrainerThread = class(TThread)
  private
    { Private declarations }
    FMatrix: TMatrix;
  protected
    procedure Execute; override;
  public
    rep: Tmlpreport;
    info: NativeInt;
    FNetwork: Tmultilayerperceptron;
    FNetworkFileName: string;
    FInfoFileName: string;
    constructor Create(aNetwork: Tmultilayerperceptron; aMatrix: TMatrix;
      const aNetworkFileName, aInfoFileName: string);
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

{ TNeuralTrainerThread }

constructor TNeuralTrainerThread.Create(aNetwork: Tmultilayerperceptron; aMatrix: TMatrix;
  const aNetworkFileName, aInfoFileName: string);
begin
  FNetwork := aNetwork;
  FMatrix := aMatrix;
  FNetworkFileName := aNetworkFileName;
  FInfoFileName := aInfoFileName;
  inherited Create;
end;

procedure TNeuralTrainerThread.Execute;
begin
  { Place thread code here }
  mlptrainlm(FNetwork, FMatrix, Length(FMatrix), 0.001, 1, info, rep);
  SetLength(FMatrix, 0);
  PostMessage(Application.MainForm.Handle, WM_EndOfTrain, NativeUInt(Self), 0);
end;

end.
