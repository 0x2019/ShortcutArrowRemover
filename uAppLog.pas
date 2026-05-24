unit uAppLog;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.ComCtrls, Vcl.Graphics,
  uRichEdit;

procedure AppLog_Init(ARichEdit: TCustomRichEdit);

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Msg: string);
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
begin
  if ARichEdit = nil then
    Exit;

  RichEdit_SetCaret(ARichEdit);
  RichEdit_SetSelectionText(ARichEdit, Format('[%s] ', [AppLog_TimeStamp]), [fsBold], clWindowText);
  RichEdit_SetSelectionText(ARichEdit, Msg, Style, Color);
  ARichEdit.SelText := sLineBreak;
  AppLog_UpdateView(ARichEdit);
end;

procedure AppLog_AppendKeyValue(ARichEdit: TCustomRichEdit; const KeyFormat, Value: string);
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

procedure AppLog_Init(ARichEdit: TCustomRichEdit);
begin
  if ARichEdit = nil then
    Exit;

  ARichEdit.Lines.BeginUpdate;
  try
    ARichEdit.Clear;
    AppLog_Append(ARichEdit, APP_NAME + ' ' + APP_VERSION, [fsBold], clWindowText);
    AppLog_AppendKeyValue(ARichEdit, SLogOSVersion, TOSVersion.ToString);
  finally
    ARichEdit.Lines.EndUpdate;
  end;
end;

procedure AppLog_Info(ARichEdit: TCustomRichEdit; const Msg: string);
begin
  AppLog_Append(ARichEdit, Msg, [fsBold], clWindowText);
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
