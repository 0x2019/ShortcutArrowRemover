unit uTweaksW;

interface

uses
  Winapi.Windows, uOSUtils, uRegUtils;

function RemoveShortcutArrowsW(Option: Boolean): Boolean;
function RemoveShortcutSuffixW(Option: Boolean): Boolean;

implementation

function RemoveShortcutArrowsW(Option: Boolean): Boolean;
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
  Result := True;

  for i := Low(PATHS) to High(PATHS) do
    if Option then
    begin
      if not DeleteRegValue(ROOT, PATHS[i], VALUE) then
        Result := False;
    end
    else
    begin
      if not WriteRegString(ROOT, PATHS[i], VALUE, '') then
        Result := False;
    end;
end;

function RemoveShortcutSuffixW(Option: Boolean): Boolean;
const
  ROOT = HKEY_CURRENT_USER;
  PATH = 'Software\Microsoft\Windows\CurrentVersion\Explorer';
  VALUE = 'link';
var
  Data: Cardinal;
begin
  if Option then
    Data := 0
  else
  begin
    // Windows 7: 16 00 00 00
    // Windows 10+: 1E 00 00 00
    if IsWindowsVersionOrGreater(10, 0, 0) then
      Data := $1E
    else
      Data := $16;
  end;

  Result := WriteRegBinary(ROOT, PATH, VALUE, Data);
end;

end.
