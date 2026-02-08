unit uMain.UI;

interface

uses
  Winapi.Windows, System.SysUtils, ShellAPI;

procedure UI_Init(AForm: TObject);
procedure UI_About(AForm: TObject);
procedure UI_Exit(AForm: TObject);

procedure UI_LoadTweaks(AForm: TObject);

procedure UI_RestartExplorer(AForm: TObject);
procedure UI_RestartExplorerTimer(AForm: TObject);

implementation

uses
  uExt, uMain, uMain.UI.Messages, uMain.UI.Strings, uMain.UI.TweaksR;

procedure UI_Init(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  F.Constraints.MinWidth := F.Width;
  F.Constraints.MinHeight := F.Height;

  F.pnlSAR.OnMouseDown := F.DragForm;
  SetWindowPos(F.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure UI_About(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  UI_MessageBox(F, Format(SAboutMsg, [APP_NAME, APP_VERSION, APP_RELEASE, APP_URL]), MB_ICONQUESTION or MB_OK);
end;

procedure UI_Exit(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  F.Close;
end;

procedure UI_LoadTweaks(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  F.chkRSA.Checked := RemoveShortcutArrowsR;
  F.chkRSS.Checked := RemoveShortcutSuffixR;
end;

procedure UI_RestartExplorer(AForm: TObject);
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

procedure UI_RestartExplorerTimer(AForm: TObject);
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
