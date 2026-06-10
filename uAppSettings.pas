unit uAppSettings;

interface

uses
  System.SysUtils, Vcl.Forms, IniFiles, uMain,

  uPathUtils;

procedure AppSettings_Load(F: TfrmMain);
procedure AppSettings_Save(F: TfrmMain);

implementation

procedure AppSettings_Load(F: TfrmMain);
var
  Ini: TMemIniFile;
begin
  if F = nil then Exit;

  Ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'), TEncoding.UTF8);
  try
    F.pmiAlwaysOnTop.Checked := Ini.ReadBool('Main', 'AlwaysOnTop', True);
    F.pmiDebug.Checked := Ini.ReadBool('Main', 'Debug', False);

    F.FLogPath := Ini.ReadString('Log', 'Path', '');
    if F.FLogPath <> '' then
      F.FLogPath := ExpandPathVariables(F.FLogPath);
    F.FLogPath := ExcludeTrailingPathDelimiter(NormalizePath(F.FLogPath));
    if F.FLogPath = '' then
      F.FLogPath := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  finally
    Ini.Free;
  end;
end;

procedure AppSettings_Save(F: TfrmMain);
var
  Ini: TMemIniFile;
begin
  if F = nil then Exit;

  Ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'), TEncoding.UTF8);
  try
    Ini.WriteBool('Main', 'AlwaysOnTop', F.pmiAlwaysOnTop.Checked);
    Ini.WriteBool('Main', 'Debug', F.pmiDebug.Checked);

    Ini.WriteString('Log', 'Path', ExcludeTrailingPathDelimiter(NormalizePath(F.FLogPath)));
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

end.
