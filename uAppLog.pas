unit uAppLog;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.ComCtrls, Vcl.Graphics,
  uRichEdit;

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

function AppLog_TimeStamp: string;
begin
  Result := FormatDateTime('hh:nn:ss', Now);
end;

procedure AppLog_UpdateView(ARichEdit: TCustomRichEdit);
begin
  RichEdit_SetCaret(ARichEdit);
  RichEdit_ScrollToBottom(ARichEdit);
end;

procedure AppLog_Append(ARichEdit: TCustomRichEdit; const Msg: string; const Style: TFontStyles; const Color: TColor);
begin
  if ARichEdit = nil then
    Exit;

  RichEdit_SetCaret(ARichEdit);
  RichEdit_SetSelectionText(ARichEdit, Format('[%s] ', [AppLog_TimeStamp]), [fsBold], clWindowText);
  RichEdit_SetSelectionText(ARichEdit, Trim(Msg), Style, Color);

  ARichEdit.SelText := sLineBreak;
  AppLog_UpdateView(ARichEdit);
end;

procedure AppLog_AppendKeyValue(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string; const Color: TColor);
var
  Key: string;
begin
  if ARichEdit = nil then
    Exit;

  Key := Format(KeyFormat, ['']);

  RichEdit_SetCaret(ARichEdit);
  RichEdit_SetSelectionText(ARichEdit, Format('[%s] ', [AppLog_TimeStamp]), [fsBold], clWindowText);
  RichEdit_SetSelectionText(ARichEdit, Key, [fsBold], Color);
  RichEdit_SetSelectionText(ARichEdit, Value, [], Color);
  ARichEdit.SelText := sLineBreak;
  AppLog_UpdateView(ARichEdit);
end;

procedure AppLog_AppendDebugKeyValue(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string;
  const KeyColor, ValueColor: TColor; const ValueStyle: TFontStyles = []);
var
  Key: string;
begin
  if ARichEdit = nil then
    Exit;

  Key := Format(KeyFormat, ['']);
  if (Key <> '') and (Key[Length(Key)] <> ' ') then
    Key := Key + ' ';

  RichEdit_SetCaret(ARichEdit);
  RichEdit_SetSelectionText(ARichEdit, Format('[%s] ', [AppLog_TimeStamp]), [fsBold], clWindowText);
  RichEdit_SetSelectionText(ARichEdit, SRegDebug + ' ', [fsBold], clMaroon);
  if Key <> '' then
    RichEdit_SetSelectionText(ARichEdit, Key, [fsBold], KeyColor);
  if Value <> '' then
    RichEdit_SetSelectionText(ARichEdit, Value, ValueStyle, ValueColor);
  ARichEdit.SelText := sLineBreak;
  AppLog_UpdateView(ARichEdit);
end;

procedure AppLog_Init(ARichEdit: TCustomRichEdit);
begin
  if ARichEdit = nil then
    Exit;

  ARichEdit.Lines.BeginUpdate;
  try
    ARichEdit.Clear;
    AppLog_Append(ARichEdit, APP_NAME + ' ' + APP_VERSION, [fsBold], clWindowText);
    AppLog_Info(ARichEdit, SLogOSVersion, TOSVersion.ToString);
  finally
    ARichEdit.Lines.EndUpdate;
  end;
end;

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Msg: string); overload;
begin
  AppLog_Append(ARichEdit, Msg, [], clWindowText);
end;

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Tweak: string; const Enabled: Boolean); overload;
var
  Suffix: string;
const
  MsgColor: array[Boolean] of TColor = (clWindowText, clGreen);
begin
  if ARichEdit = nil then
    Exit;

  if Enabled then
    Suffix := SLogEnabled
  else
    Suffix := SLogDisabled;

  Suffix := StringReplace(Suffix, '%s', '', [rfReplaceAll]);
  if (Suffix <> '') and (Suffix[1] <> ' ') then
    Suffix := ' ' + Suffix;

  RichEdit_SetCaret(ARichEdit);
  RichEdit_SetSelectionText(ARichEdit, Format('[%s] ', [AppLog_TimeStamp]), [fsBold], clWindowText);
  RichEdit_SetSelectionText(ARichEdit, '[' + Tweak + ']', [fsBold], MsgColor[Enabled]);
  RichEdit_SetSelectionText(ARichEdit, Suffix, [], MsgColor[Enabled]);
  ARichEdit.SelText := sLineBreak;
  AppLog_UpdateView(ARichEdit);
end;

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  AppLog_AppendKeyValue(ARichEdit, KeyFormat, Value, clWindowText);
end;

procedure AppLog_Debug(ARichEdit: TCustomRichEdit; const Msg: string);
var
  Line: string;
  Value: string;
const
  Labels: array[0..9] of string = (
    SRegDebugPath,
    SRegDebugCreatedValue,
    SRegDebugUpdatedValue,
    SRegDebugDeletedValue,
    SRegDebugDeletedSubKey,
    SRegDebugDeletedParentKey,
    SRegDebugError,
    SRegDebugValue,
    SRegDebugType,
    SRegDebugData
  );
var
  LabelText: string;
  i: Integer;
begin
  if ARichEdit = nil then
    Exit;

  Line := TrimLeft(Msg);
  if Copy(Line, 1, Length(SRegDebug)) = SRegDebug then
  begin
    Delete(Line, 1, Length(SRegDebug));
    Line := TrimLeft(Line);
  end;

  if Line = '' then
  begin
    AppLog_Append(ARichEdit, '', [], clWindowText);
    Exit;
  end;

  for i := Low(Labels) to High(Labels) do
  begin
    LabelText := Labels[i];
    if Copy(Line, 1, Length(LabelText)) = LabelText then
    begin
      Value := Copy(Line, Length(LabelText) + 1, MaxInt);
      if LabelText = SRegDebugError then
        AppLog_AppendDebugKeyValue(ARichEdit, LabelText, Value, clRed, clRed)
      else
        AppLog_AppendDebugKeyValue(ARichEdit, LabelText, Value, clWindowText, clWindowText);
      Exit;
    end;
  end;

  AppLog_AppendDebugKeyValue(ARichEdit, '', Line, clWindowText, clWindowText);
end;

procedure AppLog_Debug(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  AppLog_AppendDebugKeyValue(ARichEdit, KeyFormat, Value, clWindowText, clWindowText);
end;

procedure AppLog_Warn(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  AppLog_Append(ARichEdit, Msg, [], clOlive);
end;

procedure AppLog_Warn(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  AppLog_AppendKeyValue(ARichEdit, KeyFormat, Value, clOlive);
end;

procedure AppLog_Error(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  AppLog_Append(ARichEdit, Msg, [], clRed);
end;

procedure AppLog_Error(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  AppLog_AppendKeyValue(ARichEdit, KeyFormat, Value, clRed);
end;

procedure AppLog_Success(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  AppLog_Append(ARichEdit, Msg, [], clGreen);
end;

procedure AppLog_Success(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
begin
  AppLog_AppendKeyValue(ARichEdit, KeyFormat, Value, clGreen);
end;

end.
