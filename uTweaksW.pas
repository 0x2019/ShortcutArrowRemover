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
  ROOT2 = HKEY_LOCAL_MACHINE;
  PATH2 = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons';
  VALUE2 = '29';
  DATA2 = '%WINDIR%\System32\shell32.dll,-50';
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

  if Option then
  begin
    if not WriteRegString(ROOT2, PATH2, VALUE2, DATA2) then
      Result := False;
  end
  else
  begin
    if not DeleteRegValue(ROOT2, PATH2, VALUE2, REG_SZ) then
      Result := False;

    if not DeleteRegKeyIfEmpty(ROOT2, PATH2) then
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
