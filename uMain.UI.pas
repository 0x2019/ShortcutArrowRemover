unit uMain.UI;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.Forms, ShellAPI;

procedure UI_Init(AForm: TObject);
procedure UI_Free(AForm: TObject);

procedure UI_LoadTweaks(AForm: TObject);

procedure UI_RestartExplorer(AForm: TObject);
procedure UI_RestartExplorerTimer(AForm: TObject);

implementation

uses
  uMain, uMain.UI.TweaksR, uExt;

procedure UI_Init(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  F.pnlSAR.OnMouseDown := F.DragForm;
  SetWindowPos(F.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure UI_Free(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);
  F.tmrRestartExplorer.Enabled := False;
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

  PostMessage(F.Handle, mbMessage, 100, 0);
  xMsgCaption := '';

  if Application.MessageBox('Do you want to restart Windows Explorer?',
                            xMsgCaption,
                            MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = IDYES then
  begin
    IsRestartingExplorer := True;
    ShellExecute(0, 'open', 'taskkill', '/f /im explorer.exe', nil, SW_HIDE);

    F.tmrRestartExplorer.Interval := 1000;
    F.tmrRestartExplorer.Enabled  := True;
  end;
end;

procedure UI_RestartExplorerTimer(AForm: TObject);
var
  F: TfrmMain;
  OldFsRedirState: Pointer;
  FsRedirDisabled: BOOL;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  if IsExplorerUILoaded then
  begin
    F.tmrRestartExplorer.Enabled := False;
    if IsRestartingExplorer then
      IsRestartingExplorer := False;
    Exit;
  end;

  if not IsExplorerRunning then
  begin
    FsRedirDisabled := Wow64DisableWow64FsRedirection(OldFsRedirState);
    try
      ShellExecute(F.Handle, 'open', 'explorer.exe', nil, nil, SW_SHOWNORMAL);
    finally
      if FsRedirDisabled then
        Wow64RevertWow64FsRedirection(OldFsRedirState);
    end;
  end;
end;

end.
