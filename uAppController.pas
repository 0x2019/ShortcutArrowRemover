unit uAppController;

interface

uses
  Winapi.Windows, System.SysUtils, uMain,

  uExplorer, uForms, uMessageBox, uRegUtils;

procedure AppController_Init(F: TfrmMain);
procedure AppController_LoadTweaks(F: TfrmMain);
procedure AppController_RestartExplorer(F: TfrmMain);
procedure AppController_RestartExplorerTimer(F: TfrmMain);

procedure AppController_About(F: TfrmMain);
procedure AppController_Exit(F: TfrmMain);

procedure AppController_ToggleDebug(F: TfrmMain);
procedure AppController_ToggleShortcutArrows(F: TfrmMain);
procedure AppController_ToggleShortcutSuffix(F: TfrmMain);

implementation

uses
  uAbout, uAppDebug, uAppStrings, uAppLog, uAppSettings,
  uTweaks.Consts, uTweaksR, uTweaksW;

var
  IsLoadingTweaks: Boolean = False;

procedure AppController_Debug(F: TfrmMain; const TweakName: string; const Enabled: Boolean; const Disabled: Boolean = True);
begin
  if F = nil then
    Exit;

  if (not Enabled) and (not Disabled) then
    Exit;

  AppLog_Info(F.redLog, TweakName, Enabled);
end;

procedure AppController_Init(F: TfrmMain);
begin
  if F = nil then Exit;

  AppSettings_Load(F);
  SetRegDebugEnabled(F.chkDebug.Checked);
  AppDebug_UpdateHandlers(F);
  AppLog_Init(F.redLog);
  AppController_Debug(F, SDebugMode, F.chkDebug.Checked, False);
  AppController_LoadTweaks(F);
end;

procedure AppController_LoadTweaks(F: TfrmMain);
begin
  if F = nil then Exit;

  IsLoadingTweaks := True;
  try
    F.chkRSA.Checked := RemoveShortcutArrowsR;
    F.chkRSS.Checked := RemoveShortcutSuffixR;
  finally
    IsLoadingTweaks := False;
  end;

  AppController_Debug(F, STweakShortcutArrows, F.chkRSA.Checked);
  AppController_Debug(F, STweakShortcutSuffix, F.chkRSS.Checked);
end;

procedure AppController_RestartExplorer(F: TfrmMain);
var
  i: Integer;
  Event: Integer;
  State: Integer;
begin
  if F = nil then Exit;

  if UI_ConfirmYesNo(F, SRestartExplorerMsg) then
  begin
    F.btnRestartExplorer.Enabled := False;
    IsRestartingExplorer := True;
    F.tmrRestartExplorer.Tag := WaitTerminate;

    AppLog_Info(F.redLog, SLogExplorerRestarting);

    State := F.tmrRestartExplorer.Tag;
    Event := Explorer_RestartProcess(State);
    F.tmrRestartExplorer.Tag := State;

    if Event < 0 then
    begin
      if Event = ErrRestartTerminate then
        AppLog_Error(F.redLog, Format(SLogExplorerFailedToTerminate, [ErrorCode]))
      else
        AppLog_Error(F.redLog, Format(SLogExplorerFailedToStart, [ErrorCode]));

      IsRestartingExplorer := False;
      F.tmrRestartExplorer.Tag := State;
      F.tmrRestartExplorer.Enabled := False;
      F.btnRestartExplorer.Enabled := True;
      Exit;
    end;

    for i := Low(PIDs) to High(PIDs) do
      AppLog_Info(F.redLog, Format(SLogExplorerTerminated, [ProcessName, PIDs[i]]));

    F.tmrRestartExplorer.Interval := 1000;
    F.tmrRestartExplorer.Enabled := True;
  end;
end;

procedure AppController_RestartExplorerTimer(F: TfrmMain);
var
  Event: Integer;
  State: Integer;
begin
  if F = nil then Exit;

  if not IsRestartingExplorer then
  begin
    F.tmrRestartExplorer.Enabled := False;
    Exit;
  end;

  State := F.tmrRestartExplorer.Tag;
  Event := Explorer_RestartProcess(State);
  F.tmrRestartExplorer.Tag := State;

  if Event < 0 then
  begin
    if Event = ErrRestartTerminate then
      AppLog_Error(F.redLog, Format(SLogExplorerFailedToTerminate, [ErrorCode]))
    else
      AppLog_Error(F.redLog, Format(SLogExplorerFailedToStart, [ErrorCode]));

    IsRestartingExplorer := False;
    F.tmrRestartExplorer.Enabled := False;
    F.btnRestartExplorer.Enabled := True;
    Exit;
  end;

  case Event of
    EvtRestartStarted:
    begin
      if Length(PIDs) > 0 then
        AppLog_Info(F.redLog, Format(SLogExplorerStarted, [ProcessName, PIDs[0]]));
    end;

    EvtRestartCompleted:
    begin
      AppLog_Success(F.redLog, SLogExplorerRestartCompleted);
      IsRestartingExplorer := False;
      F.tmrRestartExplorer.Enabled := False;
      F.btnRestartExplorer.Enabled := True;
    end;
  end;
end;

procedure AppController_About(F: TfrmMain);
begin
  if F = nil then Exit;
  UI_ShowModalForm(TfrmAbout.Create(F));
end;

procedure AppController_Exit(F: TfrmMain);
begin
  if F = nil then Exit;
  AppDebug_ClearHandlers;
  F.Close;
end;

procedure AppController_ToggleDebug(F: TfrmMain);
begin
  if F = nil then Exit;
  SetRegDebugEnabled(F.chkDebug.Checked);
  AppDebug_UpdateHandlers(F);
  AppSettings_Save(F);
  AppController_Debug(F, SDebugMode, F.chkDebug.Checked);
end;

procedure AppController_ToggleShortcutArrows(F: TfrmMain);
begin
  if (F = nil) or IsLoadingTweaks then Exit;
  RemoveShortcutArrowsW(F.chkRSA.Checked);
  AppController_Debug(F, STweakShortcutArrows, F.chkRSA.Checked);
end;

procedure AppController_ToggleShortcutSuffix(F: TfrmMain);
begin
  if (F = nil) or IsLoadingTweaks then Exit;
  RemoveShortcutSuffixW(F.chkRSS.Checked);
  AppController_Debug(F, STweakShortcutSuffix, F.chkRSS.Checked);
end;

end.
