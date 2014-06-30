#TWebBrowserEx �N���X

���̃N���X�́AWindows / OS X �� FireMonkey �A�v���P�[�V������ WebBrowser ���g�p������@��񋟂��܂��B  
���̃N���X���g���č���� Web Browser �͉��L�̂悤�Ƀv���b�g�t�H�[���ɓ��ڂ���Ă���f�t�H���g�̃E�F�u�u���E�U�R���g���[�����g���܂��B

|Platform|Component       |
|--------|----------------|
|Windows |IWebBrowser(IE) |
|OS X    |WebView(Safari) |

##�����
Delphi / C++Builder / RAD Studio �� XE5 �ȏ�

##�t�@�C��

�ȉ��̃t�@�C����S�ă_�E�����[�h���܂��B

    FMX.WebBrowser.Mac.pas    OS X �p WebBrowser �N���X
    FMX.WebBrowser.Win.pas    Windows �p WebBrowser �N���X
    FMX.WebBrowserEx.pas      Windows / OS X �p�� WebBrowser �𓝈�I�Ɉ����N���X
    Macapi.WebView.pas        OS X �� WebView �̒�`�� Delphi �ɈڐA�������j�b�g

##�g�p���@

���L�̂悤�ɁAiOS/Android �� TWebBrowser �Ɠ����悤�Ɏg���܂��B

```pascal
uses
  FMX.WebBrowserEx;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FWebBrowser: TWebBrowserEx;
  end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FWebBrowser := TWebBrowserEx.Create(Self);
  FWebBrowser.Parent := Panel1;
  FWebBrowser.Align := TAlignLayout.Client;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FWebBrowser.URL := 'http://www.embarcadero.com/';
  FWebBrowser.Navigate;
end;

```

�܂��A���L�̂悤�ɁAJavaScript ���g���܂��B

```pascal
procedure TForm1.Button2Click(Sender: TObject);
var
  Value: String;
begin
  // HTML �ɒ�`����Ă��� JavaScript �֐� foo �Ɉ������Q�n���ČĂ�
  FWebBrowser.CallJS('foo', [Param1, Param2]);
  
  // HTML �̃^�O�̒l���擾����
  // <input type="text" id="bar" value="" /> �Ƃ����^�O���������ꍇ��
  // ������� bar �Ƃ��� id �̑����l value ���擾�ł���
  Value := FWebBrowser.GetTagValue('bar', 'value'); 
end;
```

##���쌠
���p�E�񏤗p�Ɋւ�炸���R�Ɏg�p���č\���܂���B  
�Ȃ��A���쌠�͕������Ă��܂���B  
