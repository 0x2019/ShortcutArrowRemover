unit uAppLog;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.ComCtrls, Vcl.Graphics,
  uRichEdit;

procedure AppLog_Init(ARichEdit: TCustomRichEdit);

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Msg: string); overload;
procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Tweak: string; const Enabled: Boolean); overload;
procedure AppLog_Info(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string); overload;
procedure AppLog_Debug(ARichEdit: TCustomRichEdit; const Msg: string);
procedure AppLog_Warn(ARichEdit: TCustomRichEdit; const Msg: string);
procedure AppLog_Error(ARichEdit: TCustomRichEdit; const Msg: string);
procedure AppLog_Success(ARichEdit: TCustomRichEdit; const Msg: string);

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
var
  Line: string;
  Error: string;
begin
  if ARichEdit = nil then
    Exit;

  Line := Trim(Msg);

  RichEdit_SetCaret(ARichEdit);
  RichEdit_SetSelectionText(ARichEdit, Format('[%s] ', [AppLog_TimeStamp]), [fsBold], clWindowText);

  if Copy(Line, 1, Length(SRegDebugError)) = SRegDebugError then
  begin
    Error := Copy(Line, Length(SRegDebugError) + 1, MaxInt);
    RichEdit_SetSelectionText(ARichEdit, SRegDebugError, [fsBold], clRed);
    if Error <> '' then
      RichEdit_SetSelectionText(ARichEdit, Error, [], clWindowText);
  end
  else
    RichEdit_SetSelectionText(ARichEdit, Msg, Style, Color);

  ARichEdit.SelText := sLineBreak;
  AppLog_UpdateView(ARichEdit);
end;

procedure AppLog_AppendDebug(ARichEdit: TCustomRichEdit; const Msg: string);
var
  Line: string;
  FieldLabel: string;
  FieldValue: string;
  HasLabel: Boolean;
  BracketEnd: Integer;
  Bracket: string;
  Suffix: string;
  i: Integer;
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
begin
  if ARichEdit = nil then
    Exit;

  Line := Trim(Msg);
  if Copy(Line, 1, Length(SRegDebug)) = SRegDebug then
    Delete(Line, 1, Length(SRegDebug));

  Line := TrimLeft(Line);

  RichEdit_SetCaret(ARichEdit);
  RichEdit_SetSelectionText(ARichEdit, Format('[%s] ', [AppLog_TimeStamp]), [fsBold], clWindowText);
  RichEdit_SetSelectionText(ARichEdit, SRegDebug, [fsBold], clMaroon);

  if Line <> '' then
  begin
    HasLabel := False;
    FieldLabel := '';
    FieldValue := Line;

    for i := Low(Labels) to High(Labels) do
    begin
      if Copy(Line, 1, Length(Labels[i])) = Labels[i] then
      begin
        HasLabel := True;
        FieldLabel := Labels[i];
        FieldValue := Copy(Line, Length(Labels[i]) + 1, MaxInt);
        Break;
      end;
    end;

    if HasLabel then
    begin
      if FieldLabel = SRegDebugError then
      begin
        RichEdit_SetSelectionText(ARichEdit, ' ' + FieldLabel, [fsBold], clRed);
        if FieldValue <> '' then
          RichEdit_SetSelectionText(ARichEdit, FieldValue, [], clWindowText);
      end
      else
      begin
        RichEdit_SetSelectionText(ARichEdit, ' ' + FieldLabel, [fsBold], clWindowText);
        if FieldValue <> '' then
          RichEdit_SetSelectionText(ARichEdit, FieldValue, [], clWindowText);
      end;
    end
    else
    begin
      BracketEnd := 0;
      if Line[1] = '[' then
        BracketEnd := Pos(']', Line);

      if BracketEnd > 1 then
      begin
        Bracket := Copy(Line, 1, BracketEnd);
        Suffix := Copy(Line, BracketEnd + 1, MaxInt);
        RichEdit_SetSelectionText(ARichEdit, ' ' + Bracket, [fsBold], clWindowText);
        if Bracket <> '' then
          RichEdit_SetSelectionText(ARichEdit, Bracket, [], clWindowText);
      end
      else
        RichEdit_SetSelectionText(ARichEdit, ' ' + Line, [], clWindowText);
    end;
  end;

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
  if Copy(TrimLeft(Msg), 1, Length(SRegDebug)) = SRegDebug then
    AppLog_AppendDebug(ARichEdit, Msg)
  else
    AppLog_Append(ARichEdit, Msg, [fsBold], clWindowText);
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
var
  Key: string;
begin
  if ARichEdit = nil then
    Exit;

  Key := Format(KeyFormat, ['']);

  RichEdit_SetCaret(ARichEdit);
  RichEdit_SetSelectionText(ARichEdit, Format('[%s] ', [AppLog_TimeStamp]), [fsBold], clWindowText);
  RichEdit_SetSelectionText(ARichEdit, Key, [fsBold], clWindowText);
  RichEdit_SetSelectionText(ARichEdit, Value, [], clWindowText);
  ARichEdit.SelText := sLineBreak;
  AppLog_UpdateView(ARichEdit);
end;

procedure AppLog_Debug(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  AppLog_AppendDebug(ARichEdit, Msg);
end;

procedure AppLog_Warn(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  AppLog_Append(ARichEdit, Msg, [fsBold], clOlive);
end;

procedure AppLog_Error(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  AppLog_Append(ARichEdit, Msg, [fsBold], clRed);
end;

procedure AppLog_Success(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  AppLog_Append(ARichEdit, Msg, [fsBold], clGreen);
end;

end.
