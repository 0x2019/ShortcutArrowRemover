unit uTweaksR;

interface

uses
  Winapi.Windows, System.SysUtils, uRegUtils;

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
  ROOT2 = HKEY_LOCAL_MACHINE;
  PATH2 = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons';
  VALUE2 = '29';
  DATA2 = '%WINDIR%\System32\shell32.dll,-50';
var
  i: Integer;
  Data: string;
begin
  for i := Low(PATHS) to High(PATHS) do
  begin
    if RegValueExists(ROOT, PATHS[i], VALUE) then
      Exit(False);
  end;

  if not ReadRegString(ROOT2, PATH2, VALUE2, Data) then
    Exit(False);

  Result := SameText(Data, DATA2);
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
