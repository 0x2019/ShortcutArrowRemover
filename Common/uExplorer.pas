unit uExplorer;

interface

uses
  Winapi.Windows, System.SysUtils, TlHelp32;

function IsExplorerRunning: Boolean;
function IsExplorerUILoaded: Boolean;

var
  IsRestartingExplorer: Boolean;

implementation

function IsExplorerRunning: Boolean;
var
  SnapProcHandle: THandle;
  ProcEntry: TProcessEntry32;
begin
  Result := False;
  SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if SnapProcHandle = INVALID_HANDLE_VALUE then Exit;
  try
    ProcEntry.dwSize := SizeOf(TProcessEntry32);
    if Process32First(SnapProcHandle, ProcEntry) then
      repeat
        if SameText(ProcEntry.szExeFile, 'explorer.exe') then
        begin
          Result := True;
          Break;
        end;
      until not Process32Next(SnapProcHandle, ProcEntry);
  finally
    CloseHandle(SnapProcHandle);
  end;
end;

function IsExplorerUILoaded: Boolean;
var
  hProgman, hTaskbar: HWND;
begin
  hProgman := FindWindow('Progman', nil);
  if hProgman = 0 then
    hProgman := FindWindow('WorkerW', nil);

  hTaskbar := FindWindow('Shell_TrayWnd', nil);

  Result := IsExplorerRunning and
    (hProgman <> 0) and IsWindowVisible(hProgman) and
    (hTaskbar <> 0) and IsWindowVisible(hTaskbar);
end;

end.
