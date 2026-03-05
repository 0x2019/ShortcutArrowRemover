unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils, Vcl.Buttons,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.ImgList, Vcl.StdCtrls,
  sSkinManager, sSkinProvider, sCheckBox, sPanel, acAlphaImageList, sBitBtn,
  acAlphaHints, System.ImageList,

  uExplorer, uForms, uMessageBox;

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
    procedure btnAboutClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnRestartExplorerClick(Sender: TObject);
    procedure tmrRestartExplorerTimer(Sender: TObject);
    procedure chkRSAClick(Sender: TObject);
    procedure chkRSSClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ChangeMessageBoxPosition(var Msg: TMessage); message mbMessage;
    procedure DragForm(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uAppController, uAppStrings;

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

procedure TfrmMain.DragForm(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  UI_DragForm(Self, Button);
end;

procedure TfrmMain.chkRSAClick(Sender: TObject);
begin
  AppController_ToggleShortcutArrows(Self);
end;

procedure TfrmMain.chkRSSClick(Sender: TObject);
begin
  AppController_ToggleShortcutSuffix(Self);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  UI_SetMinConstraints(Self);
  UI_SetAlwaysOnTop(Self, True);

  pnlSAR.OnMouseDown := DragForm;

  AppController_LoadTweaks(Self);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  AppController_Exit(Self);
end;

procedure TfrmMain.tmrRestartExplorerTimer(Sender: TObject);
begin
  AppController_RestartExplorerTimer(Self);
end;

end.
