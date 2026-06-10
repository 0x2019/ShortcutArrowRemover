unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils, Vcl.Buttons,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.ImgList, Vcl.StdCtrls,
  sSkinManager, sSkinProvider, sCheckBox, sPanel, acAlphaImageList, sBitBtn,
  acAlphaHints, System.ImageList, Vcl.ComCtrls, sRichEdit, Vcl.Menus, Vcl.Dialogs,

  uExplorer, uForms, uMenu.Popup, uMessageBox;

type
  TfrmMain = class(TForm)
    sSkinProvider: TsSkinProvider;
    sSkinManager: TsSkinManager;
    btnRestartExplorer: TsBitBtn;
    sAlphaImageList: TsAlphaImageList;
    pnlSAR: TsPanel;
    chkRSS: TsCheckBox;
    chkRSA: TsCheckBox;
    btnExit: TsBitBtn;
    btnAbout: TsBitBtn;
    sAlphaHints: TsAlphaHints;
    tmrRestartExplorer: TTimer;
    sCharImageList: TsCharImageList;
    redLog: TsRichEdit;
    pmLog: TPopupMenu;
    pmiCopy: TMenuItem;
    pmiSelectAll: TMenuItem;
    pmiSaveLog: TMenuItem;
    sMenuImageList: TsCharImageList;
    SaveFileDlg: TFileSaveDialog;
    pmPopup: TPopupMenu;
    pmiDebug: TMenuItem;
    pmiAlwaysOnTop: TMenuItem;
    N2: TMenuItem;
    procedure btnAboutClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnRestartExplorerClick(Sender: TObject);
    procedure tmrRestartExplorerTimer(Sender: TObject);
    procedure chkRSAClick(Sender: TObject);
    procedure chkRSSClick(Sender: TObject);
    procedure pmiDebugClick(Sender: TObject);
    procedure pmiAlwaysOnTopClick(Sender: TObject);
    procedure pmLogPopup(Sender: TObject);
    procedure pmiCopyClick(Sender: TObject);
    procedure pmiSelectAllClick(Sender: TObject);
    procedure pmiSaveLogClick(Sender: TObject);
  private
    { Private declarations }
  public
    FLogPath: string;
    procedure ChangeMessageBoxPosition(var Msg: TMessage); message mbMessage;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uAppController, uAppDebug, uAppMenu.Popup, uAppSettings, uAppStrings;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  AppController_About(Self);
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  AppController_Exit(Self);
end;

procedure TfrmMain.btnRestartExplorerClick(Sender: TObject);
begin
  AppController_RestartExplorer(Self);
end;

procedure TfrmMain.ChangeMessageBoxPosition(var Msg: TMessage);
begin
  UI_ChangeMessageBoxPosition(Self);
end;

procedure TfrmMain.chkRSAClick(Sender: TObject);
begin
  AppController_ToggleShortcutArrows(Self);
end;

procedure TfrmMain.chkRSSClick(Sender: TObject);
begin
  AppController_ToggleShortcutSuffix(Self);
end;

procedure TfrmMain.pmiDebugClick(Sender: TObject);
begin
  AppMenu_Popup_Debug(Self);
end;

procedure TfrmMain.pmiAlwaysOnTopClick(Sender: TObject);
begin
  AppMenu_Popup_AlwaysOnTop(Self);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  UI_SetMinConstraints(Self);
  UI_EnableDragForm(Self);
  AppController_Init(Self);
  AppMenu_Popup_Init(Self);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AppSettings_Save(Self);
  AppDebug_ClearHandlers;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  AppController_Exit(Self);
end;

procedure TfrmMain.pmLogPopup(Sender: TObject);
var
  Items: TPopupItems;
begin
  Items := Default(TPopupItems);
  Items.Copy := pmiCopy;
  Items.SelectAll := pmiSelectAll;
  AppMenu_Popup_Update(Self, Sender, Items);
end;

procedure TfrmMain.pmiCopyClick(Sender: TObject);
begin
  AppMenu_Popup_Copy(Self, Sender);
end;

procedure TfrmMain.pmiSelectAllClick(Sender: TObject);
begin
  AppMenu_Popup_SelectAll(Self, Sender);
end;

procedure TfrmMain.pmiSaveLogClick(Sender: TObject);
begin
  AppMenu_Popup_SaveLog(Self);
end;

procedure TfrmMain.tmrRestartExplorerTimer(Sender: TObject);
begin
  AppController_RestartExplorerTimer(Self);
end;

end.
