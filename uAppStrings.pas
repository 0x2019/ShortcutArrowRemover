unit uAppStrings;

interface

resourcestring
  APP_NAME                            = 'Shortcut Arrow Remover';
  APP_VERSION                         = 'v1.0.0.0';
  APP_RELEASE                         = 'September 19, 2025';
  APP_URL                             = 'https://github.com/0x2019/ShortcutArrowRemover';

  SLogOSVersion                       = 'OS: %s';

  SRestartExplorerMsg                 = 'Do you want to restart Windows Explorer?';

  SLogExplorerRestarting              = 'Restarting Windows Explorer...';
  SLogExplorerTerminated              = 'Terminated %s (PID: %d)';
  SLogExplorerStarted                 = 'Started %s (PID: %d)';
  SLogExplorerFailedToTerminate       = 'Failed to terminate Windows Explorer (Error code: %d)';
  SLogExplorerFailedToStart           = 'Failed to start Windows Explorer (Error code: %d)';
  SLogExplorerRestartCompleted        = 'Windows Explorer restarted successfully.';

  SLogEnabled                         = '%s enabled.';
  SLogDisabled                        = '%s disabled.';

  SLogSaved                           = 'Log saved: %s';
  SLogSaveFailed                      = 'Failed to save log. (Details: %s)';

  SAboutMsg                           = '%s %s' + sLineBreak +
                                        'c0ded by 龍, written in Delphi.' + sLineBreak + sLineBreak +
                                        'Release Date: %s' + sLineBreak +
                                        'URL: %s';

const
  SRegDebug                           = '[DEBUG]';
  SRegDebugPath                       = 'Path: ';
  SRegDebugCreatedKey                 = 'Created key: ';
  SRegDebugCreatedValue               = 'Created value: ';
  SRegDebugUpdatedValue               = 'Updated value: ';
  SRegDebugDeletedValue               = 'Deleted value: ';
  SRegDebugDeletedSubKey              = 'Deleted subkey: ';
  SRegDebugDeletedParentKey           = 'Deleted parent key: ';
  SRegDebugValue                      = 'Value: ';
  SRegDebugType                       = 'Type: ';
  SRegDebugData                       = 'Data: ';
  SRegDebugError                      = 'Error: ';

implementation

end.
