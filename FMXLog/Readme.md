#Log ���[�e�B���e�B�[

���̃��[�e�B���e�B�[�́AWindows / OS X / iOS / Android �̃A�v���P�[�V�����Łu���O�o�́v�𓝈�I�Ɏg�p������@��񋟂��܂��B  
���̃��[�e�B���e�B�[��p�������O�͉��L�̏ꏊ�ɏo�͂���܂��B  

|Platform|Out to                                   |Implementation      |
|--------|-----------------------------------------|--------------------|
|Windows |Console and Delphi's  Event Log          |WriteLn             |
|OS X    |Console (PAServer)                       |WriteLn             |
|iOS     |Console (Organizer -> Device -> Console) |NSLog               |
|Android |System Log                               |__android_log_write |

##�����
Delphi / C++Builder / RAD Studio �� XE5, XE6, XE7, XE8, 10 Seattle  
Appmethod 1.14, 1.15, 1.16, 1.17  

##�ŏI�X�V��
2016/02/05  

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

�����̒l��n�����Ƃ��ł��܂��B  

```pascal
  Log.d('������');              // �P�̈����ł͕�����̂ݎw��\  
  Log.d(['������', 123, True]); // ���������ł́A�l�X�Ȓl���w��\  
```

TRectF, TPointF, TSizeF �𕶎���ɕϊ����郁�\�b�h������܂��B  

```pascal
  Log.d(Log.PointFToString(TPointF.Create(100, 100)));    
  Log.d(Log.RectFToString(TRectF.Create(100, 100, 100, 100)));    
```

Enabled �v���p�e�B�ɂ���āA�o�͂�}���\�ł��B  

```pascal
  {$IFDEF RELEASE}  
  Log.Enabled := False; // �����[�X�r���h�ł̓��O���o�͂��Ȃ�  
  {$ENDIF}  
```

##��
```pascal
uses
  FMX.Log;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Log.i('�{�^���P�������ꂽ��'); // Info Level �ŏo��
  Log.d(['������', 100]);        // Debug Level �ŏo��
end;

```

##���쌠
�{�\�t�g�E�F�A�́u����̂܂܁v�ŁA�����ł��邩�Öقł��邩���킸�A����̕ۏ؂��Ȃ��񋟂���܂��B
�{�\�t�g�E�F�A�̎g�p�ɂ���Đ����邢���Ȃ鑹�Q�ɂ��Ă��A��҂͈�؂̐ӔC�𕉂�Ȃ����̂Ƃ��܂��B

�ȉ��̐����ɏ]������A���p�A�v���P�[�V�������܂߂āA�{�\�t�g�E�F�A��C�ӂ̖ړI�Ɏg�p���A���R�ɉ��ς��čĔЕz���邱�Ƃ����ׂĂ̐l�ɋ����܂��B

1. �{�\�t�g�E�F�A�̏o���ɂ��ċ��U�̕\�������Ă͂Ȃ�܂���B
   ���Ȃ����I���W�i���̃\�t�g�E�F�A���쐬�����Ǝ咣���Ă͂Ȃ�܂���B
   ���Ȃ����{�\�t�g�E�F�A�𐻕i���Ŏg�p����ꍇ�A���i�̕����Ɏӎ������Ă���������΍K���ł����A�K�{�ł͂���܂���B

2. �\�[�X��ύX�����ꍇ�́A���̂��Ƃ𖾎����Ȃ���΂Ȃ�܂���B
   �I���W�i���̃\�t�g�E�F�A�ł���Ƃ������U�̕\�������Ă͂Ȃ�܂���B

3. �\�[�X�̔Еz������A���̕\�����폜������A�\���̓��e��ύX�����肵�Ă͂Ȃ�܂���B

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented;
   you must not claim that you wrote the original software.
   If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
