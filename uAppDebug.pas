unit uAppDebug;

interface

uses
  System.SysUtils, uMain,

  uRegUtils;

procedure AppDebug_UpdateHandlers(F: TfrmMain);
procedure AppDebug_ClearHandlers;

implementation

uses
  uAppLog, uAppStrings;

procedure AppDebug_RegError(F: TfrmMain; const ErrorState: TRegWriteErrorState; const ReadError: Boolean);
begin
  if F = nil then
    Exit;

  if IsRegDebugEnabled then
  begin
    AppLog_Info(F.redLog, RegDebugPath(ErrorState.Root, ErrorState.Path));

    if ErrorState.ErrorCode <> 0 then
      AppLog_Debug(F.redLog, SRegDebugError + Format('%s (Error code: %d)', [ErrorState.ErrorMessage, ErrorState.ErrorCode]))
    else
      AppLog_Debug(F.redLog, SRegDebugError + ErrorState.ErrorMessage);
  end
  else
  begin
    if ErrorState.ErrorCode <> 0 then
    begin
      if ReadError then
        AppLog_Warn(F.redLog, Format('%s (Error code: %d)', [ErrorState.ErrorMessage, ErrorState.ErrorCode]))
      else
        AppLog_Error(F.redLog, SRegDebugError + Format('%s (Error code: %d)', [ErrorState.ErrorMessage, ErrorState.ErrorCode]));
    end
    else
    begin
      if ReadError then
        AppLog_Warn(F.redLog, ErrorState.ErrorMessage)
      else
        AppLog_Error(F.redLog, SRegDebugError + ErrorState.ErrorMessage);
    end;
  end;
end;

procedure AppDebug_UpdateHandlers(F: TfrmMain);
begin
  if (F <> nil) and IsRegDebugEnabled then
    SetRegDebugLogProc(
      procedure(const Msg: string)
      begin
        AppLog_Info(F.redLog, Msg);
      end
    )
  else
    SetRegDebugLogProc(nil);

  if F <> nil then
    SetRegWriteErrorProc(
      procedure(const ErrorState: TRegWriteErrorState)
      begin
        AppDebug_RegError(F, ErrorState, False);
      end
    )
  else
    SetRegWriteErrorProc(nil);

  if F <> nil then
    SetRegReadErrorProc(
      procedure(const ErrorState: TRegWriteErrorState)
      begin
        AppDebug_RegError(F, ErrorState, True);
      end
    )
  else
    SetRegReadErrorProc(nil);
end;

procedure AppDebug_ClearHandlers;
begin
  SetRegDebugLogProc(nil);
  SetRegWriteErrorProc(nil);
  SetRegReadErrorProc(nil);
end;

end.
