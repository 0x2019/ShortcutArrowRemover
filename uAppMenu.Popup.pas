unit uAppMenu.Popup;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Menus, uMain,

  uMenu.Popup;

procedure AppMenu_Popup_Init(F: TfrmMain);
procedure AppMenu_Popup_Copy(F: TfrmMain; Sender: TObject);
procedure AppMenu_Popup_SelectAll(F: TfrmMain; Sender: TObject);
procedure AppMenu_Popup_Update(F: TfrmMain; Sender: TObject; const Items: TPopupItems);

implementation

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

  UI_Menu_Popup_Update(Sender, Items);
end;

end.
