program AdminCMD;

// ������\���������Ȃ��̂Ŏw�肵�Ȃ�
//{$APPTYPE CONSOLE}

uses
  Winapi.Windows, Winapi.ShellApi, System.SysUtils;

// �Ǘ��Ҍ����Ŏ��s����
function RunAsAdmin(const iExeName, iParam: String): Boolean;
var
  SEI: TShellExecuteInfo;
begin
  Result := False;

  // runas �́AVista �ȍ~�̂ݓ��삷��
  if (CheckWin32Version(6)) then begin
    ZeroMemory(@SEI, SizeOf(SEI));

    with SEI do begin
      cbSize := SizeOf(SEI);
      Wnd := 0;
      fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
      lpVerb := 'runas';
      lpFile := PChar(iExeName);
      lpParameters := PChar(iParam);
      nShow := SW_SHOW;
    end;

    Result := ShellExecuteEx(@SEI);
  end;
end;

var
  CmdPath: String;
begin
  // ���ϐ����� CMD.exe �̃p�X���擾����
  CmdPath := StringOfChar(#0, MAX_PATH);
  ExpandEnvironmentStrings(
    PChar('%ComSpec%'),
    PChar(CmdPath),
    Length(CmdPath));

  CmdPath := Trim(CmdPath);

  // �Ǘ��Ҍ����Ŏ��s
  RunAsAdmin(CmdPath, '');
end.
