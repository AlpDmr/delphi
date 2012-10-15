unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs;

type
  TForm1 = class(TForm)
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
  private
    { private �錾 }
  public
    { public �錾 }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormPaint(
  Sender: TObject;
  Canvas: TCanvas;
  const ARect: TRectF);

  procedure FillRect(
    const iColor: TAlphaColor;
    const iPos: Integer;
    const iRect: TRectF);
  begin
    Canvas.Fill.Color := iColor;
    Canvas.FillRect(iRect, 0, 0, [], 1);
  end;

  procedure Fill(const iColor: TAlphaColor; const iPos: Integer);
  begin
    FillRect(iColor, iPos, TRectF.Create(iPos, iPos, iPos + 100, iPos + 100));
  end;

begin
  FillRect($ffffffff, 0, ARect); // �t�H�[���𔒂œh��Ԃ�
  Fill($80ff0000, 10);           // 50% �̓��ߗ��ŐԂ�h��
  Fill($cc0000ff, 60);           // 80% �̓��ߗ��Ő�h��
end;

end.
