unit uAppController;

interface

uses
  Winapi.Windows, System.SysUtils, ShellAPI, uMain;

procedure AppController_LoadTweaks(F: TfrmMain);
procedure AppController_RestartExplorer(F: TfrmMain);
procedure AppController_RestartExplorerTimer(F: TfrmMain);

procedure AppController_About(F: TfrmMain);
procedure AppController_Exit(F: TfrmMain);
procedure AppController_ToggleShortcutArrows(F: TfrmMain);
procedure AppController_ToggleShortcutSuffix(F: TfrmMain);

implementation

uses
  uExplorer, uMessageBox, uOSUtils,
  uAppStrings, uTweaksR, uTweaksW;

procedure AppController_LoadTweaks(F: TfrmMain);
begin
  if F = nil then Exit;
  F.chkRSA.Checked := RemoveShortcutArrowsR;
  F.chkRSS.Checked := RemoveShortcutSuffixR;
end;

procedure AppController_RestartExplorer(F: TfrmMain);
begin
  if F = nil then Exit;

  if UI_ConfirmYesNo(F, SRestartExplorerMsg) then
  begin
    F.btnRestartExplorer.Enabled := False;
    IsRestartingExplorer := True;

    ShellExecute(0, 'open', 'taskkill', '/f /im explorer.exe', nil, SW_HIDE);

    F.tmrRestartExplorer.Interval := 1000;
    F.tmrRestartExplorer.Enabled := True;
  end;
end;

procedure AppController_RestartExplorerTimer(F: TfrmMain);
begin
  if F = nil then Exit;

  if IsExplorerUILoaded then
  begin
    F.tmrRestartExplorer.Enabled := False;
    F.btnRestartExplorer.Enabled := True;
    IsRestartingExplorer := False;
    Exit;
  end;

  if not IsExplorerRunning then
  begin
    DisableWow64FsRedirection(
      procedure
      var
        R: NativeInt;
      begin
        R := NativeInt(ShellExecute(F.Handle, 'open', 'explorer.exe', nil, nil, SW_SHOWNORMAL));

        if R <= 32 then
          UI_MessageBox(F, Format(SRestartExplorerFailMsg, [R]), MB_ICONWARNING or MB_OK);
      end
    );
  end;
end;

procedure AppController_About(F: TfrmMain);
begin
  if F = nil then Exit;
  UI_MessageBox(F, Format(SAboutMsg, [APP_NAME, APP_VERSION, APP_RELEASE, APP_URL]), MB_ICONQUESTION or MB_OK);
end;

procedure AppController_Exit(F: TfrmMain);
begin
  if F = nil then Exit;
  F.Close;
end;

procedure AppController_ToggleShortcutArrows(F: TfrmMain);
begin
  if F = nil then Exit;
  RemoveShortcutArrowsW(F.chkRSA.Checked);
end;

procedure AppController_ToggleShortcutSuffix(F: TfrmMain);
begin
  if F = nil then Exit;
  RemoveShortcutSuffixW(F.chkRSS.Checked);
end;

end.
