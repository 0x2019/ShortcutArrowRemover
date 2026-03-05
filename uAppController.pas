unit uAppController;

interface

uses
  Winapi.Windows, System.SysUtils, ShellAPI, uMain;

procedure AppController_LoadTweaks(AForm: TfrmMain);
procedure AppController_RestartExplorer(AForm: TfrmMain);
procedure AppController_RestartExplorerTimer(AForm: TfrmMain);

procedure AppController_About(AForm: TfrmMain);
procedure AppController_Exit(AForm: TfrmMain);
procedure AppController_ToggleShortcutArrows(AForm: TfrmMain);
procedure AppController_ToggleShortcutSuffix(AForm: TfrmMain);

implementation

uses
  uExplorer, uMessageBox, uOSUtils,
  uAppStrings, uTweaksR, uTweaksW;

procedure AppController_LoadTweaks(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  AForm.chkRSA.Checked := RemoveShortcutArrowsR;
  AForm.chkRSS.Checked := RemoveShortcutSuffixR;
end;

procedure AppController_RestartExplorer(AForm: TfrmMain);
begin
  if AForm = nil then Exit;

  if UI_ConfirmYesNo(AForm, SRestartExplorerMsg) then
  begin
    AForm.btnRestartExplorer.Enabled := False;
    IsRestartingExplorer := True;

    ShellExecute(0, 'open', 'taskkill', '/f /im explorer.exe', nil, SW_HIDE);

    AForm.tmrRestartExplorer.Interval := 1000;
    AForm.tmrRestartExplorer.Enabled := True;
  end;
end;

procedure AppController_RestartExplorerTimer(AForm: TfrmMain);
begin
  if AForm = nil then Exit;

  if IsExplorerUILoaded then
  begin
    AForm.tmrRestartExplorer.Enabled := False;
    AForm.btnRestartExplorer.Enabled := True;
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
        R := NativeInt(ShellExecute(AForm.Handle, 'open', 'explorer.exe', nil, nil, SW_SHOWNORMAL));

        if R <= 32 then
          UI_MessageBox(AForm, Format(SRestartExplorerFailMsg, [R]), MB_ICONWARNING or MB_OK);
      end
    );
  end;
end;

procedure AppController_About(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  UI_MessageBox(AForm, Format(SAboutMsg, [APP_NAME, APP_VERSION, APP_RELEASE, APP_URL]), MB_ICONQUESTION or MB_OK);
end;

procedure AppController_Exit(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  AForm.Close;
end;

procedure AppController_ToggleShortcutArrows(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  RemoveShortcutArrowsW(AForm.chkRSA.Checked);
end;

procedure AppController_ToggleShortcutSuffix(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  RemoveShortcutSuffixW(AForm.chkRSS.Checked);
end;

end.
