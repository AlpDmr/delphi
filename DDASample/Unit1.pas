unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure FormDestroy(Sender: TObject);
  private
    FBmp: TBitmap;
  public
  end;

var
  Form1: TForm1;

implementation

uses
  uDDASample;

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
var
  BmpData: TBitmapData;
begin
  FBmp := TBitmap.Create(320, 240);

  // �`��J�n
  FBmp.Canvas.BeginScene;

  // DrawLine �ɂ��`��  ���と�E���@�_
  FBmp.Canvas.Stroke.Color := $ff0000ff;
  FBmp.Canvas.DrawLine(
    TPointF.Create(0, 0),                    // �n�_�� X, Y�i����j
    TPointF.Create(FBmp.Width, FBmp.Height), // �I�_�� X, Y�i�E���j
    1);

  // DDA �ɂ��`��       �������E��@�^
  if (FBmp.Map(TMapAccess.maWrite, BmpData)) then
    try
      DDA(
        FBmp.Width - 1, 0,   // �n�_�� X, Y�i�����j
        0, FBmp.Height - 1,  // �I�_�� X, Y�i�E��j
        procedure (const iX, iY: Integer; const iData: Pointer)
        begin
          PAlphaColorArray(iData)[iY * FBmp.Width + iX] := $ffff0000;
        end,
        BmpData.Data);
    finally
      FBmp.Unmap(BmpData);
    end;

  // �`��I��
  FBmp.Canvas.EndScene;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FBmp.Free;
end;

procedure TForm1.FormPaint(
  Sender: TObject;
  Canvas: TCanvas;
  const ARect: TRectF);
var
  W, H: Integer;
begin
  W := FBmp.Width;
  H := FBmp.Height;

  Canvas.DrawBitmap(
    FBmp,
    TRectF.Create(0, 0, W, H),
    TRectF.Create(0, 0, W, H),
    1);
end;

end.
