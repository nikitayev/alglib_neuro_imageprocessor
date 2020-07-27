//{$I fullcheck.inc}
unit ErrorQueue;

interface
// Использует JEDI библиотеки для отладки
uses
  Classes,
  ErrorManager, JclSynch,
  JclDebug,
  JclHookExcept,
  TypInfo;

var
  Errors: tErrorManager;

// Is equalent to Errors.Log();
procedure AddLogErr(const Msg: String); inline;
// previous + Dialog
procedure AddLogErrWithDevelopersNames(const Msg: String); inline;

implementation

uses
  SysUtils;

procedure AddLogErr(const Msg: String); inline;
begin
  //DeviceName:='INI-файл';
  //MessageDlg(Msg,mtError,[mbOK],0);
  Errors.Log(Msg, etLog);
end;

procedure AddLogErrWithDevelopersNames(const Msg: String); inline;
begin
  //DeviceName:='INI-файл';
  //MessageDlg(Msg+Pauk_Developers,mtError,[mbOK],0);
  Errors.Log(Msg, etLog);
end;

procedure LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
var
  TmpS: String;
  ModInfo: TJclLocationInfo;
  I: Integer;
  ExceptionHandled: Boolean;
  HandlerLocation: Pointer;
  ExceptFrame: TJclExceptFrame;
  ExceptStack: TJclStackInfoItem;
begin
  if Errors = NIL then
    exit;
  ModInfo := GetLocationInfo(ExceptAddr);
  if Errors.ExcludedModules.IndexOf(UpperCase(ModInfo.UnitName)) >= 0 then
    exit;
  TmpS := 'Exception ' + ExceptObj.ClassName;
  if ExceptObj is Exception then
    TmpS := TmpS + ': ' + Exception(ExceptObj).Message;
  if IsOS then
    TmpS := TmpS + ' (OS Exception)';
  // ignore errors with specified text
  with Errors.TextList do
    for i := 0 to Count - 1 do
      if pos(Strings[i], TmpS) > 0 then
        Exit;
  Errors.Log(TmpS, etHint);
  if Errors.ReportedModules.IndexOf(UpperCase(ModInfo.UnitName)) >= 0 then
    exit;
  Errors.Log(Format(
    '  Exception occured at $%p (Module "%s", Procedure "%s", Unit "%s", Line %d)',
    [ModInfo.Address, ModInfo.UnitName, ModInfo.ProcedureName,
    ModInfo.SourceName, ModInfo.LineNumber]), etHint);
  if stExceptFrame in JclStackTrackingOptions then
  begin
    Errors.Log('  Except frame-dump:', etHint);
    I := 0;
    //    ExceptionHandled := False;
    while {(chkShowAllFrames.Checked or not ExceptionHandled) and}
      (I < JclLastExceptFrameList.Count) do
    begin
      ExceptFrame := JclLastExceptFrameList.Items[I];
      ExceptionHandled := ExceptFrame.HandlerInfo(ExceptObj, HandlerLocation);
      if (ExceptFrame.FrameKind = efkFinally) or (ExceptFrame.FrameKind = efkUnknown) or
        not ExceptionHandled then
        HandlerLocation := ExceptFrame.CodeLocation;
      ModInfo := GetLocationInfo(HandlerLocation);
      TmpS := Format('    Frame at $%p (type: %s',
        [ExceptFrame.CodeLocation, GetEnumName(TypeInfo(TExceptFrameKind),
        Ord(ExceptFrame.FrameKind))]);
      if ExceptionHandled then
        TmpS := TmpS + ', handles exception)'
      else
        TmpS := TmpS + ')';
      Errors.Log(TmpS, etHint);
      if ExceptionHandled then
        Errors.Log(Format('      Handler at $%p', [HandlerLocation]), etHint)
      else
        Errors.Log(Format('      Code at $%p', [HandlerLocation]), etHint);
      Errors.Log(Format('      Module "%s", Procedure "%s", Unit "%s", Line %d',
        [ModInfo.UnitName, ModInfo.ProcedureName, ModInfo.SourceName,
        ModInfo.LineNumber]), etHint);
      Inc(I);
      //      FreeAndNil(ModInfo.DebugInfo);
    end;
  end;
  if stStack in JclStackTrackingOptions then
  begin
    Errors.Log('  Stack frame-dump:', etHint);
    I := 0;
    while (I < JclLastExceptStackList.Count) do
    begin
      ExceptStack := JclLastExceptStackList.Items[I];
      HandlerLocation := ExceptStack.CallerAddr;
      ModInfo := GetLocationInfo(HandlerLocation);
      Errors.Log(Format('      Code at $%p', [HandlerLocation]), etHint);
      Errors.Log(Format('      Module "%s", Procedure "%s", Unit "%s", Line %d',
        [ModInfo.UnitName, ModInfo.ProcedureName, ModInfo.SourceName,
        ModInfo.LineNumber]), etHint);
      Inc(I);
    end;
  end;
  Errors.Log('', etHint);
end;


initialization
  IsMultiThread := TRUE;
  SetMinimumBlockAlignment(mba16Byte);
  Errors := tErrorManager.Create(GetLogName);
  // Добавим спсиок юнитов, ошибки которых не писатьв лог
  //  Errors.ReportOnlyException('');  // noname
  Errors.ReportOnlyException('idtcpconnection');
  // indy's tcp connectionn raises lot of exceptions
  Errors.ReportOnlyException('idstack');
  Errors.ReportOnlyException('idiohandlersocket');
  Errors.ReportOnlyException('IdStackBSDBase');
  Errors.ExcludeModuleFromReports('IdCustomTCPServer');
  Errors.ExcludeTextFromReports('406D1388'); // SetThreadName

  //  JclStackTrackingOptions := JclStackTrackingOptions + [stAllModules, stExceptFrame];
  JclStackTrackingOptions := JclStackTrackingOptions + [stStack, stAllModules];
  JclStartExceptionTracking;
  JclAddExceptNotifier(LogException);

finalization
  JclStopExceptionTracking;
  try
    FreeAndNil(Errors);
  except
    on E: Exception do ;
  end;
end.
