unit uMain.UI.TweaksW;

interface

uses
  Winapi.Windows, System.SysUtils, Registry;

function RemoveShortcutArrowsW(Enable: Boolean): Boolean;
function RemoveShortcutSuffixW(Enable: Boolean): Boolean;

implementation

uses
  uExt;

function RemoveShortcutArrowsW(Enable: Boolean): Boolean;
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
begin
  Result := Enable;

  xReg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
  try
    xReg.RootKey := ROOT;

    if Enable then
    begin
      for i := Low(PATHS) to High(PATHS) do
      begin
        if xReg.OpenKey(PATHS[i], True) then
        try
          try
            xReg.DeleteValue(VALUE);
          except
            on E: Exception do
              OutputDebugString(PChar('DeleteValue failed at ' + PATHS[i] + ': ' + E.Message));
          end;
        finally
          xReg.CloseKey;
        end;
      end;
    end
    else
    begin
      for i := Low(PATHS) to High(PATHS) do
      begin
        if xReg.OpenKey(PATHS[i], True) then
        try
          try
            xReg.WriteString(VALUE, '');
          except
            on E: Exception do
              OutputDebugString(PChar('WriteString failed at ' + PATHS[i] + ': ' + E.Message));
          end;
        finally
          xReg.CloseKey;
        end;
      end;

      Result := False;
    end;
  finally
    xReg.Free;
  end;
end;

function RemoveShortcutSuffixW(Enable: Boolean): Boolean;
const
  ROOT  = HKEY_CURRENT_USER;
  PATH  = 'Software\Microsoft\Windows\CurrentVersion\Explorer';
  VALUE = 'link';
var
  xReg: TRegistry;
  Data: Cardinal;
begin
  Result := Enable;

  xReg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
  try
    xReg.RootKey := ROOT;
    if xReg.OpenKey(PATH, True) then
    try
      try
        if Enable then
        begin
          Data := 0;
          xReg.WriteBinaryData(VALUE, Data, SizeOf(Data));
        end
        else
        begin
          // Windows 7: 16 00 00 00
          // Windows 10+: 1E 00 00 00
          if IsWindowsVersionLower(10, 0, 0) then
            Data := $16
          else
            Data := $1E;

          xReg.WriteBinaryData(VALUE, Data, SizeOf(Data));
          Result := False;
        end;
      except
        on E: Exception do
          OutputDebugString(PChar('WriteBinaryData failed at ' + PATH + '\' + VALUE + ': ' + E.Message));
      end;
    finally
      xReg.CloseKey;
    end;
  finally
    xReg.Free;
  end;
end;

end.
