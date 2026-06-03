unit uAppMenu.Popup;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Menus, uMain,

  uFileDialog, uMenu.Popup;

procedure AppMenu_Popup_Init(F: TfrmMain);
procedure AppMenu_Popup_Copy(F: TfrmMain; Sender: TObject);
procedure AppMenu_Popup_SelectAll(F: TfrmMain; Sender: TObject);
procedure AppMenu_Popup_SaveLog(F: TfrmMain);
procedure AppMenu_Popup_Update(F: TfrmMain; Sender: TObject; const Items: TPopupItems);

implementation

uses
  uAppLog, uAppStrings;

procedure AppMenu_Popup_Init(F: TfrmMain);
begin
  if (F = nil) or (F.sSkinManager = nil) then
    Exit;

  F.sSkinManager.SkinnedPopups := True;

  if F.pmPopup <> nil then
    F.sSkinManager.SkinableMenus.HookPopupMenu(F.pmPopup, True);
end;

procedure AppMenu_Popup_Copy(F: TfrmMain; Sender: TObject);
begin
  if F = nil then
    Exit;

  UI_Menu_Popup_Copy(Sender);
end;

procedure AppMenu_Popup_SelectAll(F: TfrmMain; Sender: TObject);
begin
  if F = nil then
    Exit;

  UI_Menu_Popup_SelectAll(Sender);
end;

procedure AppMenu_Popup_SaveLog(F: TfrmMain);
var
  FileName: string;
  Lines: TStringList;
begin
  if (F = nil) or (F.redLog = nil) or (F.SaveFileDlg = nil) then
    Exit;

  try
    if not UI_SaveFileDialog(F.SaveFileDlg, F.Handle,
      IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
      Format('%s_%s.log', [APP_NAME, FormatDateTime('yyyymmdd_hhnnss', Now)]),
      FileName) then
      Exit;

    Lines := TStringList.Create;
    try
      Lines.Text := F.redLog.Lines.Text;
      Lines.SaveToFile(FileName, TEncoding.UTF8);
      AppLog_Info(F.redLog, SLogSaved, FileName);
    finally
      Lines.Free;
    end;
  except
    on E: Exception do
      AppLog_Error(F.redLog, Format(SLogSaveFailed, [E.Message]));
  end;
end;

procedure AppMenu_Popup_Update(F: TfrmMain; Sender: TObject; const Items: TPopupItems);
var
  PopupComponent: TComponent;
begin
  if F = nil then
    Exit;

  PopupComponent := nil;
  if Sender is TPopupMenu then
    PopupComponent := TPopupMenu(Sender).PopupComponent;

  if Assigned(Items.SelectAll) then
    Items.SelectAll.Visible := PopupComponent = F.redLog;
  if Assigned(F.pmiSaveLog) then
  begin
    F.pmiSaveLog.Visible := PopupComponent = F.redLog;
    F.pmiSaveLog.Enabled := (F.redLog <> nil) and (F.redLog.Lines.Count > 0);
  end;

  UI_Menu_Popup_Update(Sender, Items);
end;

end.
