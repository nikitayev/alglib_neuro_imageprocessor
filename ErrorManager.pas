unit ErrorManager;

{$I+}
// ***********************************************
//        
//          Модуль обработки ошибок 
//   (с) Петушков А. Л.  2002 г.
//
// ***********************************************

interface

uses Windows, Classes, SysUtils, Messages,
  jclSynch, jclStrings;

type
  tEventType = (etLog, etHint, etWarning, etError, etDebug);

type
  tLogEvent = procedure(var Event: String; var EventType: tEventType) of object;

type
  tErrorManager = class
  PRIVATE
    FAppId: Integer;
    FShowMessages: Boolean;
    FAppName: String;
    FOnLogEvent: tLogEvent;
    FLogName: String;
    procedure SetShowMessages(const Value: Boolean); inline;
    procedure SetAppName(const Value: String); inline;
    procedure SetOnLogEvent(const Value: tLogEvent); inline;
    procedure AppendToFile(const s: String); inline;
    procedure SetLogName(const Value: String); inline;
  PUBLIC
    Lock: tJCLOptex;
    ExcludedModules: TStringList;
    ReportedModules: TStringList;
    TextList: TStringList;

    // имя файла с отчетом
    property LogName: String READ FLogName WRITE SetLogName;

    // опция показа сообщений об ошибках
    property ShowMessages: Boolean READ FShowMessages WRITE SetShowMessages;
    // имя приложения
    property AppName: String READ FAppName WRITE SetAppName;

    // обработчик события "на лог"
    property OnLogEvent: tLogEvent READ FOnLogEvent WRITE SetOnLogEvent;

    constructor Create(const LogFileName: String);
    destructor Destroy; OVERRIDE;
    // занести событие в журнал
    procedure Log(Event: String; EventType: tEventType); 
    // стереть содержимое лог-файла
    procedure ResetLogFile; inline;
    // программа запущена
    procedure ProgramRun; inline;
    // программа завершена
    procedure ProgramTerminate; inline;

    procedure ExcludeModuleFromReports(const Module: String); inline;
    procedure ExcludeTextFromReports(const TextMessage: String); inline;
    procedure ReportOnlyException(const Module: String); inline;
  end;

function GetLogName: String; inline;
procedure OutputDebugString( const s: string );

implementation

{ tErrorManager }

function GetLogName: String;
begin
  Result := copy(ParamStr(0), 1, Length(ParamStr(0)) - 4) {+
    '_'+FormatDateTime('dd-mm-yy',now)} + '.err';
end;


procedure tErrorManager.AppendToFile(const s: String);
var
  F: TextFile;
begin
  Lock.Enter;
  try
    AssignFile(F, LogName);
    try
      if FileExists(LogName) then
        Append(F)
      else
        Rewrite(F);
      if (FileSize(F) < 512 * 1024 * 1024) then
        Writeln(F, S);
      CloseFile(F);
    except
      on E: Exception do ;
    end;
  finally
    Lock.Leave;
  end;
end;

constructor tErrorManager.Create(const LogFileName: String);
begin
  inherited Create;
  Randomize;
  FAppId := Random(1000000000);
  ShowMessages := TRUE;
  LogName := LogFileName;
  AppName := ExtractFileName(ParamStr(0));
  ExcludedModules := TStringList.Create;
  ReportedModules := TStringList.Create;
  TextList := TStringList.Create;
  Lock := TJclOptex.Create('ErrorManager_' +
    StrRemoveChars(LogFileName, ['\', '/']));
end;

destructor tErrorManager.Destroy;
begin
  try
    FreeAndNil(TextList);
    FreeAndNil(ExcludedModules);
    FreeAndNil(ReportedModules);
    FreeAndNil(Lock);
  except
    on E: Exception do ;
  end;
  inherited;
end;

procedure tErrorManager.ExcludeModuleFromReports(const Module: String);
begin
  ExcludedModules.Add(UpperCase(Module));
end;

procedure tErrorManager.ExcludeTextFromReports(const TextMessage: String);
begin
  TextList.Add(TextMessage);
end;

procedure tErrorManager.Log(Event: String; EventType: tEventType);
var
  S: String;
begin
  if Self = NIL then
    exit;
  if assigned(@OnLogEvent) then
    try
      OnLogEvent(Event, EventType);
    except
      on E: Exception do ;
    end;
  S := FormatDateTime('dd-mm-yy hh:mm:ss ', now);
  case EventType of
    etLog:
      S := S + '    ' + Event;
    etHint:
      S := S + 'hnt ' + Event;
    etWarning:
      S := S + 'wrn ' + Event;
    etError:
      S := S + 'err ' + Event;
    etDebug:
      S := S + 'dbg ' + Event;
  end;
  AppendToFile(S);
  //if EventType=etWarning then MessageBox(0, pchar(Event), pchar(AppName), MB_ICONWARNING) else
  //if EventType=etError   then MessageBox(0, pchar(Event), pchar(AppName), MB_ICONERROR);
end;

procedure tErrorManager.ProgramRun;
begin
  // можно еще применить GetModuleName(HInstance)
  if IsLibrary then
    Log(Format('Library Id:%d loaded', [FAppId]), etLog)
  else
    Log(Format('Program Id:%d run', [FAppId]), etLog);
end;

procedure tErrorManager.ProgramTerminate;
begin
  if IsLibrary then
    Log(Format('Library Id:%d unloaded', [FAppId]), etLog)
  else
    Log(Format('Program Id:%d terminate', [FAppId]), etLog);
end;

procedure tErrorManager.ReportOnlyException(const Module: String);
begin
  ReportedModules.Add(UpperCase(Module));
end;

procedure tErrorManager.ResetLogFile;
var
  F: TextFile;
begin
  AssignFile(F, LogName);
  try
    Rewrite(F);
    CloseFile(F);
  except
    on E: Exception do ;
  end;
end;

procedure tErrorManager.SetAppName(const Value: String);
begin
  FAppName := Value;
end;

procedure tErrorManager.SetLogName(const Value: String);
begin
  FLogName := Value;
  if ExtractFilePath(Value) = '' then
    FLogName := ExtractFilePath(ParamStr(0)) + Value;
  // если не указан путь - берется путь к каталогу, 
  // из которого запустили ...
end;

procedure tErrorManager.SetOnLogEvent(const Value: tLogEvent);
begin
  FOnLogEvent := Value;
end;

procedure tErrorManager.SetShowMessages(const Value: Boolean);
begin
  FShowMessages := Value;
end;

procedure OutputDebugString( const s: string );
begin
  Windows.OutputDebugString( pchar(s) );
end;

end.
