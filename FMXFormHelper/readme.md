#FMX.FormHelper �w���p�[�N���X

FireMonkey �� TForm �ɁuAlt + Enter �̖������v�u�ŏ����T�C�Y�̐ݒ�v�@�\��ǉ�����w���p�[�N���X�ł��B

##�g�p���@

1.  
FMX.FormHelper �� uses ���Ă��������B

2.  
TForm.OnCreate �ȂǂŃw���p�[���\�b�h���Ă�ł��������B

��

```Unit1.pas
procedure TForm1.FormCreate(Sender: TObject);
begin
  DisableAltEnter;
  SetMinSize(300, 200);
end;
```

