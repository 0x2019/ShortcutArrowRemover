unit uTweaksR;

interface

uses
  Winapi.Windows, Registry;

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
  Reg: TRegistry;
  i: Integer;
  Removed: Boolean;
begin
  Removed := True;
  Reg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    Reg.RootKey := ROOT;
    for i := Low(PATHS) to High(PATHS) do
    begin
      if Reg.OpenKeyReadOnly(PATHS[i]) then
      try
        if Reg.ValueExists(VALUE) then
        begin
          Removed := False;
          Break;
        end;
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
  Result := Removed;
end;

function RemoveShortcutSuffixR: Boolean;
const
  ROOT = HKEY_CURRENT_USER;
  PATH = 'Software\Microsoft\Windows\CurrentVersion\Explorer';
  VALUE = 'link';
var
  Reg: TRegistry;
  Data: Cardinal;
  Removed: Boolean;
begin
  Removed := False;
  Reg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    Reg.RootKey := ROOT;
    if Reg.OpenKeyReadOnly(PATH) then
    try
      if Reg.ValueExists(VALUE) then
      begin
        if (Reg.GetDataType(VALUE) = rdBinary) and
           (Reg.GetDataSize(VALUE) = SizeOf(Data)) then
        begin
          if Reg.ReadBinaryData(VALUE, Data, SizeOf(Data)) = SizeOf(Data) then
            Removed := (Data = 0);
        end;
      end;
    finally
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  Result := Removed;
end;

end.
