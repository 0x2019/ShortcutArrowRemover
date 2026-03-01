program ShortcutArrowRemover;

uses
  Winapi.Windows,
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uTweaksR in 'uTweaksR.pas',
  uTweaksW in 'uTweaksW.pas',
  uAppStrings in 'uAppStrings.pas',
  uMessageBox in 'Common\uMessageBox.pas',
  uOSUtils in 'Common\uOSUtils.pas',
  uExplorer in 'Common\uExplorer.pas',
  uAppController in 'uAppController.pas',
  uForms in 'Common\uForms.pas';

var
  uMutex: THandle;

{$R *.res}

begin
  uMutex := CreateMutex(nil, True, 'SAR!');
  if (uMutex <> 0) and (GetLastError = 0) then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;

    if uMutex <> 0 then
      CloseHandle(uMutex);
  end;
end.
