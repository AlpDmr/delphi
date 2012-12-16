unit uConsole;

interface

type
  // �R���\�[���C�x���g
  TConsoleEventType = (
    ceC,       // CTRL + C �������ꂽ
    ceBreak,   // CTRL + BREAK �������ꂽ
    ceClose,   // �R���\�[���E�B���h�E������ꂽ
    ceLogOff,  // ���O�I�t���ꂽ
    ceShutdown // �V���b�g�_�E�����ꂽ
  );

  // �R���\�[���C�x���g�^
  TConsoleEvent = procedure(const iType: TConsoleEventType) of object;

// �R���\�[���C�x���g���󂯎�郊�X�i�[��ǉ��E����
procedure AddConsoleEventListener(const iListener: TConsoleEvent);
procedure RemoveConsoleEventListener(const iListener: TConsoleEvent);

// �R���\�[�����當�����ǂݎ��
function ReadConsole(
  const iPrompt: String = '';
  const iToLower: Boolean = False): String;

implementation

uses
  Winapi.Windows,  Generics.Collections, System.SysUtils;

var
  // �R���\�[���E�B���h�E�̃n���h��
  GWnd: HWND;
  // �C�x���g���X�i���Ǘ����郊�X�g
  GListeners: TList<TConsoleEvent>;

// �R���\�[���C�x���g���X�i��ǉ�
procedure AddConsoleEventListener(const iListener: TConsoleEvent);
begin
  if (GListeners.IndexOf(iListener) < 0) then
    GListeners.Add(iListener);
end;

// �R���\�[���C�x���g���X�i���폜
procedure RemoveConsoleEventListener(const iListener: TConsoleEvent);
begin
  if (GListeners.IndexOf(iListener) > -1) then
    GListeners.Remove(iListener);
end;

// �R���\�[�����當�����ǂݎ��
// iPrompt  �ǂݎ��O�ɕ\�����镶����iex. 'Please input your name: '�j
// iToLower �ǂݎ������������������ɂ���Ȃ� True
function ReadConsole(
  const iPrompt: String = '';
  const iToLower: Boolean = False): String;
begin
  // �v�����v�g�̕\��
  if (iPrompt <> '') then
    Write(iPrompt);

  // �R���\�[���ɓ��̓t�H�[�J�X��^����
  ShowWindow(GWnd, SW_SHOW);
  SetForegroundWindow(GWnd);

  // �ǂݍ���
  Readln(Result);

  // ��������
  if (iToLower) then
    Result := LowerCase(Result);
end;

// �R���\�[���C�x���g���N�����Ƃ��ɌĂ΂��֐�
function HandlerRoutine(dwCtrlType: DWORD): BOOL; stdcall;
var
  Listener: TConsoleEvent;
begin
  Result := True; // False �̏ꍇ�A�C�x���g�� OS ���K�؂ɏ�������
                  //�iex. CTRL + C �������ꂽ��A�v���P�[�V�������I��������j
                  // True �̏ꍇ�AOS �͉������Ȃ�

  for Listener in GListeners do
    Listener(TConsoleEventType(dwCtrlType));
end;

// �R���\�[���̏����ݒ�
// �R���\�[���� Window Handle �̓���
// �R���\�[���̃^�C�g���̐ݒ�
procedure InitConsole;
var
  Cap: String;
begin
  // Window Caption �� GUID ��ݒ肷��
  Cap := TGUID.NewGuid.ToString;
  SetConsoleTitle(PWideChar(Cap));

  Sleep(40); // Caption ���m���ɐݒ肳��邽�߂� 40[msec] �҂�
             // http://support.microsoft.com/kb/124103/ja

  // GUID �ŃE�B���h�E��T��
  GWnd := FindWindow(nil, PChar(Cap));

  if (GWnd <> 0) then
    // ��������X�^�C������ System Menu ���O��
    //�i�R���\�[��������ɕ����Ȃ��悤�ɂ��邽�߁j
    SetWindowLong(
      GWnd,
      GWL_STYLE,
      GetWindowLong(GWnd, GWL_STYLE) and not WS_SYSMENU);

  // �R���\�[���̃^�C�g�����A�v���P�[�V�����̃p�X�ɂ���
  SetConsoleTitle(PWideChar(ParamStr(0)));
end;

// ������
initialization
begin
  // �C�x���g�n���h���Ǘ��p���X�g�̐���
  GListeners := TList<TConsoleEvent>.Create;

  // �A�v���P�[�V�����ɃR���\�[�������蓖�Ă�
  AllocConsole;

  // �R���\�[���C�x���g�̃n���h����ݒ肷��
  SetConsoleCtrlHandler(@HandlerRoutine, True);

  // �R���\�[���̏����ݒ�
  InitConsole;
end;

// �I������
finalization
begin
  // �R���\�[���C�x���g�̃n���h��������
  SetConsoleCtrlHandler(@HandlerRoutine, False);

  // ���蓖�čς݂̃R���\�[��������
  FreeConsole;

  // �C�x���g�n���h���Ǘ��p���X�g�̔j��
  GListeners.Free;
end;

end.
