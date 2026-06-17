unit uAppLog;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.ComCtrls, Vcl.Graphics,

  uOSUtils, uRichEdit, uRichEdit.Log;

procedure AppLog_Init(ARichEdit: TCustomRichEdit);

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Msg: string); overload;
procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Tweak: string; const Enabled: Boolean); overload;
procedure AppLog_Info(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;

procedure AppLog_Debug(ARichEdit: TCustomRichEdit; const Msg: string); overload;
procedure AppLog_Debug(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;

procedure AppLog_Warn(ARichEdit: TCustomRichEdit; const Msg: string); overload;
procedure AppLog_Warn(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;

procedure AppLog_Error(ARichEdit: TCustomRichEdit; const Msg: string); overload;
procedure AppLog_Error(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;

procedure AppLog_Success(ARichEdit: TCustomRichEdit; const Msg: string); overload;
procedure AppLog_Success(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;

implementation

uses
  uAppStrings;

procedure AppLog_Init(ARichEdit: TCustomRichEdit);
begin
  if ARichEdit = nil then
    Exit;

  ARichEdit.Lines.BeginUpdate;
  try
    ARichEdit.Clear;
    UI_Log_Info(ARichEdit, APP_NAME + ' ' + APP_VERSION, [fsBold], clWindowText);
    UI_Log_Info(ARichEdit, SLogOSVersion, TOSVersion.ToString);
    UI_Log_Info(ARichEdit, SLogLocale, GetCurrentLocale);
  finally
    ARichEdit.Lines.EndUpdate;
  end;
end;

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Msg: string); overload;
begin
  UI_Log_Info(ARichEdit, Msg);
end;

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Tweak: string; const Enabled: Boolean); overload;
begin
  UI_Log_Info(ARichEdit, Tweak, Enabled);
end;

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  UI_Log_Info(ARichEdit, KeyFormat, Value);
end;

procedure AppLog_Debug(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  UI_Log_Debug(ARichEdit, Msg, SRegDebug + ' ', SRegDebugError,
    [
      SRegDebugPath,
      SRegDebugCreatedKey,
      SRegDebugCreatedSubKey,
      SRegDebugCreatedValue,
      SRegDebugUpdatedValue,
      SRegDebugDeletedValue,
      SRegDebugDeletedSubKey,
      SRegDebugDeletedParentKey,
      SRegDebugError,
      SRegDebugValue,
      SRegDebugType,
      SRegDebugData
    ]
  );
end;

procedure AppLog_Debug(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  UI_Log_Debug(ARichEdit, KeyFormat, Value, SRegDebug + ' ');
end;

procedure AppLog_Warn(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  UI_Log_Warn(ARichEdit, Msg);
end;

procedure AppLog_Warn(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  UI_Log_Warn(ARichEdit, KeyFormat, Value);
end;

procedure AppLog_Error(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  UI_Log_Error(ARichEdit, Msg);
end;

procedure AppLog_Error(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  UI_Log_Error(ARichEdit, KeyFormat, Value);
end;

procedure AppLog_Success(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  UI_Log_Success(ARichEdit, Msg);
end;

procedure AppLog_Success(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  UI_Log_Success(ARichEdit, KeyFormat, Value);
end;

end.
