#Log ���[�e�B���e�B�[

���̃��[�e�B���e�B�[�́AWindows / OS X / iOS / Android �̃A�v���P�[�V�����Łu���O�o�́v�𓝈�I�Ɏg�p������@��񋟂��܂��B  
���̃��[�e�B���e�B�[��p�������O�͉��L�̏ꏊ�ɏo�͂���܂��B  

|Platform|Out to                                   |Implementation      |
|--------|-----------------------------------------|--------------------|
|Windows |Console                                  |WriteLn             |
|OS X    |Console (PAServer)                       |WriteLn             |
|iOS     |Console (Organizer -> Device -> Console) |NSLog               |
|Android |System Log                               |__android_log_write |

##�����
Delphi / C++Builder / RAD Studio �� XE5, XE6  
Appmethod 1.14  

##�t�@�C��

�ȉ��̃t�@�C�����_�E�����[�h���܂��B

    FMX.Log.pas

##�g�p���@

FMX.Log �� uses ����� Log �N���X���g����悤�ɂȂ�܂��B  
Log.d �Ƃ������N���X���\�b�h���g���ƃ��O���o�͂���܂��B  
  
���x���ɂ���ĉ��L�̗l�Ɏg�����\�b�h���ς��܂��B  

|Level   |Method Name|
|--------|-----------|
|VERBOSE |Log.v      |
|DEBUG   |Log.d      |
|INFO    |Log.i      |
|WARN    |Log.w      |
|ERROR   |Log.e      |
|FATAL   |Log.f      |

�܂��A�����̒l��n�����Ƃ��ł��܂��B  

```pascal
  Log.d('������');              // �P�̈����ł͕�����̂ݎw��\
  Log.d(['������', 123, True]); // ���������ł́A�l�X�Ȓl���w��\
```


##��
```pascal
uses
  FMX.Log;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FWebBrowser: TWebBrowserEx;
  end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Log.i('�{�^���P�������ꂽ��'); // Info Level �ŏo��
  Log.d(['������', 100]);        // Debug Level �ŏo��
end;

```

##���쌠
���p�E�񏤗p�Ɋւ�炸���R�Ɏg�p���č\���܂���B  
���ς������R�ɂǂ����B  
�Ȃ��A���쌠�͕������Ă��܂���̂ŁA�u���� �l��/���Ђ� ������񂾁[�I�v���Ă����͖̂����ł��B  
