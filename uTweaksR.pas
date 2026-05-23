unit uTweaksR;

interface

uses
  Winapi.Windows, uRegUtils;

function RemoveShortcutArrowsR: Boolean;
function RemoveShortcutSuffixR: Boolean;

implementation

function RemoveShortcutArrowsR: Boolean;
const
  ROOT = HKEY_CLASSES_ROOT;
  VALUE = 'IsShortcut';
  PATHS: array[0..7] of string =
  (
    'lnkfile',
    'InternetShortcut',
    'Application.Reference',
    'IE.AssocFile.URL',
    'IE.AssocFile.WEBSITE',
    'Microsoft.Website',
    'piffile',
    'WSHFile'
  );
var
  i: Integer;
begin
  for i := Low(PATHS) to High(PATHS) do
  begin
    if RegValueExists(ROOT, PATHS[i], VALUE) then
      Exit(False);
  end;

  Result := True;
end;

function RemoveShortcutSuffixR: Boolean;
const
  ROOT = HKEY_CURRENT_USER;
  PATH = 'Software\Microsoft\Windows\CurrentVersion\Explorer';
  VALUE = 'link';
var
  Data: Cardinal;
begin
  Result := ReadRegBinary(ROOT, PATH, VALUE, Data) and (Data = 0);
end;

end.
