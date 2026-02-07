unit uMain.UI.TweaksR;

interface

uses
  Winapi.Windows, Registry;

function RemoveShortcutArrowsR: Boolean;
function RemoveShortcutSuffixR: Boolean;

implementation

function RemoveShortcutArrowsR: Boolean;
const
  ROOT  = HKEY_CLASSES_ROOT;
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
  xReg: TRegistry;
  i: Integer;
  Removed: Boolean;
begin
  Removed := True;
  xReg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    xReg.RootKey := ROOT;
    for i := Low(PATHS) to High(PATHS) do
    begin
      if xReg.OpenKeyReadOnly(PATHS[i]) then
      try
        if xReg.ValueExists(VALUE) then
        begin
          Removed := False;
          Break;
        end;
      finally
        xReg.CloseKey;
      end;
    end;
  finally
    xReg.Free;
  end;
  Result := Removed;
end;

function RemoveShortcutSuffixR: Boolean;
const
  ROOT  = HKEY_CURRENT_USER;
  PATH  = 'Software\Microsoft\Windows\CurrentVersion\Explorer';
  VALUE = 'link';
var
  xReg: TRegistry;
  Data: Cardinal;
  Removed: Boolean;
begin
  Removed := False;
  xReg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    xReg.RootKey := ROOT;
    if xReg.OpenKeyReadOnly(PATH) then
    try
      if xReg.ValueExists(VALUE) then
      begin
        if (xReg.GetDataType(VALUE) = rdBinary) and
           (xReg.GetDataSize(VALUE) = SizeOf(Data)) then
        begin
          if xReg.ReadBinaryData(VALUE, Data, SizeOf(Data)) = SizeOf(Data) then
            Removed := (Data = 0);
        end;
      end;
    finally
      xReg.CloseKey;
    end;
  finally
    xReg.Free;
  end;
  Result := Removed;
end;

end.
