unit uAppController;

interface

uses
  Winapi.Windows, System.SysUtils, ShellAPI, uMain,

  uExplorer, uForms, uMessageBox, uOSUtils, uProcessUtils, uRegUtils;

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
  uAbout, uAppStrings, uAppLog, uAppSettings,
  uTweaks.Consts, uTweaksR, uTweaksW;

var
  IsLoadingTweaks: Boolean = False;

procedure AppController_UpdateDebugLog(F: TfrmMain);
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
end;

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
  AppController_UpdateDebugLog(F);
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
  PIDs: TArray<Cardinal>;
begin
  if F = nil then Exit;

  if UI_ConfirmYesNo(F, SRestartExplorerMsg) then
  begin
    F.btnRestartExplorer.Enabled := False;
    IsRestartingExplorer := True;
    F.tmrRestartExplorer.Tag := 0;

    AppLog_Info(F.redLog, SLogExplorerRestarting);

    PIDs := GetProcessIDs(PROCESS_NAME);
    for i := Low(PIDs) to High(PIDs) do
      AppLog_Info(F.redLog, Format(SLogExplorerTerminated, [PROCESS_NAME, PIDs[i]]));

    ShellExecute(0, 'open', 'taskkill', PChar('/f /im ' + PROCESS_NAME), nil, SW_HIDE);

    F.tmrRestartExplorer.Interval := 1000;
    F.tmrRestartExplorer.Enabled := True;
  end;
end;

procedure AppController_RestartExplorerTimer(F: TfrmMain);
var
  i: Integer;
  R: NativeInt;
  PIDs: TArray<Cardinal>;
begin
  if F = nil then Exit;

  if IsExplorerUILoaded then
  begin
    if IsRestartingExplorer then
      AppLog_Success(F.redLog, SLogExplorerRestartCompleted);

    F.tmrRestartExplorer.Enabled := False;
    F.btnRestartExplorer.Enabled := True;
    IsRestartingExplorer := False;
    F.tmrRestartExplorer.Tag := 0;
    Exit;
  end;

  if IsExplorerRunning then
  begin
    if F.tmrRestartExplorer.Tag = 0 then
    begin
      PIDs := GetProcessIDs(PROCESS_NAME);
      for i := Low(PIDs) to High(PIDs) do
      begin
        AppLog_Info(F.redLog, Format(SLogExplorerStarted, [PROCESS_NAME, PIDs[i]]));
        Break;
      end;
      if Length(PIDs) > 0 then
        F.tmrRestartExplorer.Tag := 1;
    end;
    Exit;
  end;

  DisableWow64FsRedirection(
    procedure
    begin
      R := NativeInt(ShellExecute(F.Handle, 'open', PChar(PROCESS_NAME), nil, nil, SW_SHOWNORMAL));

      if R <= 32 then
        AppLog_Error(F.redLog, Format(SLogExplorerFailedToStart, [R]));
    end
  );
end;

procedure AppController_About(F: TfrmMain);
begin
  if F = nil then Exit;
  UI_ShowModalForm(TfrmAbout.Create(F));
end;

procedure AppController_Exit(F: TfrmMain);
begin
  if F = nil then Exit;
  SetRegDebugLogProc(nil);
  F.Close;
end;

procedure AppController_ToggleDebug(F: TfrmMain);
begin
  if F = nil then Exit;
  SetRegDebugEnabled(F.chkDebug.Checked);
  AppController_UpdateDebugLog(F);
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
