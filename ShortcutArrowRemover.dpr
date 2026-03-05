program ShortcutArrowRemover;

uses
  Winapi.Windows,
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uAppController in 'uAppController.pas',
  uAppStrings in 'uAppStrings.pas',
  uTweaksR in 'uTweaksR.pas',
  uTweaksW in 'uTweaksW.pas',
  uExplorer in '..\Common\uExplorer.pas',
  uForms in '..\Common\uForms.pas',
  uMessageBox in '..\Common\uMessageBox.pas',
  uOSUtils in '..\Common\uOSUtils.pas';

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
