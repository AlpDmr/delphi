program ChangeStdIO;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, Winapi.Windows;

function Exec(const iCommand, iParam: String): String;
var
  ReadHandle, WriteHandle: THandle;
  SA: TSecurityAttributes;
  SI: TStartUpInfo;
  PI: TProcessInformation;
  Buffer: RawByteString;
  Len: Cardinal;

  // �p�C�v����l��ǂݏo��
  procedure ReadResult;
  var
    Count: DWORD;
    ReadableByte: DWORD;
    Data: RawByteString;
  begin
    // �ǂݏo���o�b�t�@���N���A
    ZeroMemory(PRawByteString(Buffer), Len);

    // �p�C�v�ɓǂݏo����o�C�g������������̂����ׂ�
    PeekNamedPipe(ReadHandle, PRawByteString(Buffer), Len, nil, nil, nil);
    ReadableByte := Length(Trim(String(Buffer)));

    // �ǂݍ��߂镶���񂪂���Ȃ�
    if (ReadableByte > 0) then begin
      while
        (ReadFile(ReadHandle, PRawByteString(Buffer)^, Len, Count, nil))
      do begin
        Data := Data + RawByteString(Copy(Buffer, 1, Count));

        if (Count >= ReadableByte) then
          Break;
      end;

      Result := Result + Data;
    end;
  end;

begin
  Result := '';

  ZeroMemory(@SA, SizeOf(SA));
  SA.nLength := SizeOf(SA);
  SA.bInheritHandle := True;

  // �p�C�v�����
  CreatePipe(ReadHandle, WriteHandle, @SA, 0);
  try
    // StartInfo ��������
    ZeroMemory(@SI, SizeOf(SI));
    with SI do begin
      cb := SizeOf(SI);
      dwFlags := STARTF_USESTDHANDLES; // �W�����o�̓n���h�����g���܂��I�錾
      hStdOutput := WriteHandle;       // �W���o�͂��o�̓p�C�v�ɕύX
      hStdError := WriteHandle;        // �W���G���[�o�͂��o�̓p�C�v�ɕύX
    end;

    // �v���Z�X���쐬
    if (not CreateProcess(
      PChar(iCommand),
      PChar(iParam),
      nil,
      nil,
      True,
      0,
      nil,
      nil,
      SI,
      PI))
    then
      Exit;

    // �ǂݏo���o�b�t�@�� 4096[byte] �m��
    SetLength(Buffer, 4096);
    Len := Length(Buffer);

    with PI do begin
      // �v���Z�X���I������܂ŁA�p�C�v��ǂݏo��
      while (WaitForSingleObject(hProcess, 100) = WAIT_TIMEOUT) do
        ReadResult;

      ReadResult;

      // �v���Z�X�����
      CloseHandle(hProcess);
      CloseHandle(hThread);
    end;
  finally
    // �p�C�v�����
    CloseHandle(WriteHandle);
    CloseHandle(ReadHandle);
  end;
end;

begin
  // dir �̌��ʂ��o��
  Writeln(Exec('C:\Windows\System32\CMD.exe', '/C dir'));
  Readln;
end.
