﻿unit uExt;

interface

uses
  Winapi.Windows, System.SysUtils, System.Generics.Collections, ShellAPI, TlHelp32;

function RtlGetVersion(var RTL_OSVERSIONINFOEXW): LONG; stdcall; external 'ntdll.dll' Name 'RtlGetVersion';

function Wow64DisableWow64FsRedirection(var OldValue: Pointer): BOOL; stdcall; external 'kernel32.dll';
function Wow64RevertWow64FsRedirection(OldValue: Pointer): BOOL; stdcall; external 'kernel32.dll';

function IsExplorerRunning: Boolean;
function IsExplorerUILoaded: Boolean;

function IsWindowsVersionLower(Major, Minor, Build: DWORD): Boolean;

var
  IsRestartingExplorer: Boolean;

implementation

uses
  uMain.UI;

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

function IsWindowsVersionLower(Major, Minor, Build: DWORD): Boolean;
var
  winver: RTL_OSVERSIONINFOEXW;
begin
  FillChar(winver, SizeOf(winver), 0);
  winver.dwOSVersionInfoSize := SizeOf(winver);
  Result := False;
  if RtlGetVersion(winver) = 0 then
  begin
    if winver.dwMajorVersion < Major then
      Exit(True);
    if winver.dwMajorVersion = Major then
    begin
      if winver.dwMinorVersion < Minor then
        Exit(True);
      if winver.dwMinorVersion = Minor then
        Exit(winver.dwBuildNumber < Build);
    end;
  end;
end;

end.
