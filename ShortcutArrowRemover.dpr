program ShortcutArrowRemover;

uses
  Winapi.Windows,
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uAbout in 'uAbout.pas' {frmAbout},
  uAppController in 'uAppController.pas',
  uAppDebug in 'uAppDebug.pas',
  uAppLog in 'uAppLog.pas',
  uAppMenu.Popup in 'uAppMenu.Popup.pas',
  uAppSettings in 'uAppSettings.pas',
  uAppStrings in 'uAppStrings.pas',
  uTweaks.Consts in 'uTweaks.Consts.pas',
  uTweaksR in 'uTweaksR.pas',
  uTweaksW in 'uTweaksW.pas',
  uExplorer in '..\Common\uExplorer.pas',
  uForms in '..\Common\uForms.pas',
  uMenu.Popup in '..\Common\uMenu.Popup.pas',
  uMessageBox in '..\Common\uMessageBox.pas',
  uOSUtils in '..\Common\uOSUtils.pas',
  uRichEdit in '..\Common\uRichEdit.pas',
  uRegUtils in '..\Common\uRegUtils.pas',
  uMetaballs in '..\Common\About\uMetaballs.pas';

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
