unit uClaudiaFormStyleHook;

interface

uses
  Winapi.Windows, Vcl.Controls, Vcl.Graphics, Vcl.Forms, Vcl.Themes,
  Vcl.Imaging.pngimage;

type
  // �N���E�f�B�A������E���ɕ\������ Style Hook
  TClaudiaFormStyleHook = class(TFormStyleHook)
  private
    FClaudia: TPngImage;
  protected
    procedure PaintBackground(Canvas: TCanvas); override;
  public
    constructor Create(iControl: TWinControl); override;
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TClaudiaFormStyleHook }

constructor TClaudiaFormStyleHook.Create(iControl: TWinControl);
begin
  inherited;

  // PNG Image �𐶐�
  FClaudia := TPngImage.Create;

  // �N���E�f�B�A�̉摜��ǂݏo��
  FClaudia.LoadFromFile(ExtractFilePath(Application.ExeName) + '\Claudia.png');
end;

destructor TClaudiaFormStyleHook.Destroy;
begin
  // PNG Image ��j��
  FClaudia.Free;

  inherited;
end;

// WM_ERASEBKGND �������Ƃ��ɌĂ΂�郁�\�b�h
procedure TClaudiaFormStyleHook.PaintBackground(Canvas: TCanvas);
var
  FormCanvas: TCanvas;
  Back: TBitmap;
begin
  // �܂��e�� PaintBackground ���ĂсA���̃t�H�[���ɏ���Ă���
  // �q�R���g���[�����̔w�i��`�悷��
  inherited;

  // �w�i�p Bitmap �����
  Back := TBitmap.Create;
  try
    with Back, Canvas do begin
      // �傫���́A�t�H�[���̃N���C�A���g�G���A�Ɠ���
      SetSize(Control.Width, Control.Height);

      // �w�i�F�œh��Ԃ�
      Brush.Color := StyleServices.GetStyleColor(scWindow);
      FillRect(Rect(0, 0, Width, Height));

      // �N���E�f�B�A���E���ɕ`�悷��
      Draw(Width - FClaudia.Width, Height - FClaudia.Height, FClaudia);
    end;

    // �t�H�[���ɕ`�悷�邽�߂� Canvas �����
    // ������ Canvas �́ATBitmap �� Canvas �ł����Ȃ�����
    // Canvas �� Draw ���Ă��`�悳��Ȃ�
    FormCanvas := TCanvas.Create;
    try
      // �f�o�C�X�R���e�L�X�g���擾
      FormCanvas.Handle := GetDC(Control.Handle);
      try
        // �w�i�p Bitmap ��`�悷��
        FormCanvas.Draw(0, 0, Back);
      finally
        ReleaseDC(Control.Handle, FormCanvas.Handle);
      end;
    finally
      FormCanvas.Free;
    end;
  finally
    Back.Free;
  end;
end;

initialization
begin
  // �܂� TFormStyleHook �� TCustomForm ����O���Ȃ���
  // TClaudiaFormStyleHook �͌Ă΂�Ȃ�
  TCustomStyleEngine.UnregisterStyleHook(TCustomForm, TFormStyleHook);

  // TClaudiaFormStyleHook �� TCustomForm �� StyleHook �Ƃ��Đݒ�
  TCustomStyleEngine.RegisterStyleHook(TCustomForm, TClaudiaFormStyleHook);
end;

finalization
begin
  // TCustomForm �̓A�v���P�[�V�������I���j�������Ƃ� TFormStyleHook ��
  // UnregisterStyleHook ���悤�Ƃ���B
  // ���̂��߁A������ StyleHook �� TFormStyleHook ��o�^���Ă��B
  // �o�^���Ȃ��ƁA��O����������
  TCustomStyleEngine.RegisterStyleHook(TCustomForm, TFormStyleHook);
end;

end.
