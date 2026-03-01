unit uTweaksW;

interface

uses
  Winapi.Windows, System.SysUtils, Registry, uOSUtils;

function RemoveShortcutArrowsW(AOption: Boolean): Boolean;
function RemoveShortcutSuffixW(AOption: Boolean): Boolean;

implementation

function RemoveShortcutArrowsW(AOption: Boolean): Boolean;
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
begin
  Result := AOption;

  Reg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
  try
    Reg.RootKey := ROOT;

    if AOption then
    begin
      for i := Low(PATHS) to High(PATHS) do
      begin
        if Reg.OpenKey(PATHS[i], True) then
        try
          try
            Reg.DeleteValue(VALUE);
          except
            on E: Exception do
              OutputDebugString(PChar('DeleteValue failed at ' + PATHS[i] + ': ' + E.Message));
          end;
        finally
          Reg.CloseKey;
        end;
      end;
    end
    else
    begin
      for i := Low(PATHS) to High(PATHS) do
      begin
        if Reg.OpenKey(PATHS[i], True) then
        try
          try
            Reg.WriteString(VALUE, '');
          except
            on E: Exception do
              OutputDebugString(PChar('WriteString failed at ' + PATHS[i] + ': ' + E.Message));
          end;
        finally
          Reg.CloseKey;
        end;
      end;

      Result := False;
    end;
  finally
    Reg.Free;
  end;
end;

function RemoveShortcutSuffixW(AOption: Boolean): Boolean;
const
  ROOT  = HKEY_CURRENT_USER;
  PATH  = 'Software\Microsoft\Windows\CurrentVersion\Explorer';
  VALUE = 'link';
var
  Reg: TRegistry;
  Data: Cardinal;
begin
  Result := AOption;

  Reg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
  try
    Reg.RootKey := ROOT;
    if Reg.OpenKey(PATH, True) then
    try
      try
        if AOption then
        begin
          Data := 0;
        end
        else
        begin
          // Windows 7: 16 00 00 00
          // Windows 10+: 1E 00 00 00
          if IsWindowsVersionOrGreater(10, 0, 0) then
            Data := $1E
          else
            Data := $16;
        end;

        Reg.WriteBinaryData(VALUE, Data, SizeOf(Data));
      except
        on E: Exception do
          OutputDebugString(PChar('WriteBinaryData failed at ' + PATH + '\' + VALUE + ': ' + E.Message));
      end;
    finally
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

end.
