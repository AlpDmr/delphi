unit Unit1;

interface

uses
  Winapi.Windows, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  uConsole;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure ConsoleEventListener(const iType: TConsoleEventType);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  // ������̕\��
  Writeln('Hello, World !');

  // ������ Boolean�A������Ȃǂ����݂��ĕ\���ł���
  Writeln(123456789, ' ', True);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Str: String;
begin
  // ���߂��R���\�[������ǂݎ��
  Str := ReadConsole('Input Command: ', True);

  // exit �Ȃ�I��
  if (Str = 'exit') then
    Close
  // notepad �Ȃ�u�������v���N��
  else if (Str = 'notepad') then
    WinExec('notepad.exe', SW_SHOW)
  // ����ȊO�Ȃ�s���ƕ\��
  else
    Writeln('Unknown command:', Str);
end;

procedure TForm1.ConsoleEventListener(const iType: TConsoleEventType);
begin
  // �R���\�[���C�x���g�̎�ނ��R���\�[���ɕ\��
  case iType of
    ceC:
      Writeln('Ctrl + C ��������܂���');

    ceBreak:
      Writeln('Ctrl + BREAK ��������܂���');

    ceClose:
      Writeln('�R���\�[���������܂���');

    ceLogOff:
      Writeln('���O�I�t����܂���');

    ceShutdown:
      Writeln('�V���b�g�_�E������܂���');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // �R���\�[���C�x���g���X�i��ǉ�
  AddConsoleEventListener(ConsoleEventListener);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // �R���\�[���C�x���g���X�i���폜
  RemoveConsoleEventListener(ConsoleEventListener);
end;

end.
