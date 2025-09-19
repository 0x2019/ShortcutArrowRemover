unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, sSkinProvider,
  Vcl.StdCtrls, sCheckBox, Vcl.ExtCtrls, sPanel, System.ImageList, Vcl.ImgList,
  acAlphaImageList, Vcl.Buttons, sBitBtn, acAlphaHints;

const
  mbMessage = WM_USER + 1024;
  APP_NAME    = 'Shortcut Arrow Remover';
  APP_VERSION = 'v1.0.0.0';
  APP_RELEASE = 'September 19, 2025';
  APP_URL     = 'https://github.com/0x2019/ShortcutArrowRemover';

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
    procedure ChangeMessageBoxPosition(var Msg: TMessage); message mbMessage;
  public
    procedure DragForm(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;

var
  frmMain: TfrmMain;
  xMsgCaption: PWideChar;

implementation

{$R *.dfm}

uses
  uMain.UI,
  uMain.UI.TweaksR, uMain.UI.TweaksW;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  PostMessage(Handle, mbMessage, 0, 0);
  xMsgCaption := '';

  Application.MessageBox(
  APP_NAME + ' ' + APP_VERSION + sLineBreak +
  'c0ded by 龍, written in Delphi.' + sLineBreak + sLineBreak +
  'Release Date: ' + APP_RELEASE + sLineBreak +
  'URL: ' + APP_URL, xMsgCaption, MB_ICONQUESTION);
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnRestartExplorerClick(Sender: TObject);
begin
  UI_RestartExplorer(Self);
end;

procedure TfrmMain.ChangeMessageBoxPosition(var Msg: TMessage);
var
  mbHWND: LongWord;
  mbRect: TRect;
  x, y, w, h: Integer;
begin
  mbHWND := FindWindow(MAKEINTRESOURCE(WC_DIALOG), xMsgCaption);
  if (mbHWND <> 0) then begin
    GetWindowRect(mbHWND, mbRect);
  with mbRect do begin
    w := Right - Left;
    h := Bottom - Top;
  end;
  x := frmMain.Left + ((frmMain.Width - w) div 2);
  if x < 0 then
    x := 0
    else if x + w > Screen.Width then x := Screen.Width - w;
      y := frmMain.Top + ((frmMain.Height - h) div 2);
  if y < 0 then y := 0
    else if y + h > Screen.Height then y := Screen.Height - h;
    SetWindowPos(mbHWND, 0, x, y, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
  end;
end;

procedure TfrmMain.DragForm(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

procedure TfrmMain.chkRSAClick(Sender: TObject);
begin
  if chkRSA.Checked then
    RemoveShortcutArrowsW('On')
  else
    RemoveShortcutArrowsW('Off');
end;

procedure TfrmMain.chkRSSClick(Sender: TObject);
begin
  if chkRSS.Checked then
    RemoveShortcutSuffixW('On')
  else
    RemoveShortcutSuffixW('Off');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  UI_Init(Self);
  UI_LoadTweaks(Self);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TfrmMain.tmrRestartExplorerTimer(Sender: TObject);
begin
  UI_RestartExplorerTimer(Self);
end;

end.
