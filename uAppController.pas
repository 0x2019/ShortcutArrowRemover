unit uAppController;

interface

uses
  Winapi.Windows, System.SysUtils, ShellAPI;

procedure App_LoadTweaks(AForm: TObject);

procedure App_RestartExplorer(AForm: TObject);
procedure App_RestartExplorerTimer(AForm: TObject);

implementation

uses
  uAppStrings, uMain, uTweaksR,
  uExplorer, uMessageBox, uOSUtils;

procedure App_LoadTweaks(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  F.chkRSA.Checked := RemoveShortcutArrowsR;
  F.chkRSS.Checked := RemoveShortcutSuffixR;
end;

procedure App_RestartExplorer(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  if UI_ConfirmYesNo(F, SRestartExplorerMsg) then
  begin
    F.btnRestartExplorer.Enabled := False;
    IsRestartingExplorer := True;

    ShellExecute(0, 'open', 'taskkill', '/f /im explorer.exe', nil, SW_HIDE);

    F.tmrRestartExplorer.Interval := 1000;
    F.tmrRestartExplorer.Enabled := True;
  end;
end;

procedure App_RestartExplorerTimer(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

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
        R: HINST;
      begin
        R := ShellExecute(F.Handle, 'open', 'explorer.exe', nil, nil, SW_SHOWNORMAL);

        if NativeInt(R) <= 32 then
          UI_MessageBox(F,
            Format(SRestartExplorerFailMsg, [NativeInt(R)]),
            MB_ICONWARNING or MB_OK);
      end
    );
  end;
end;

end.
