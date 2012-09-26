unit uDDASample;

interface

type
  TDDAEvent =
    reference to procedure(const iX, iY: Integer; const iData: Pointer);

procedure DDA(
  iX1, iY1, iX2, iY2: Integer;
  const iOnDDAEvent: TDDAEvent;
  const iData: Pointer);

implementation

procedure DDA(
  iX1, iY1, iX2, iY2: Integer;
  const iOnDDAEvent: TDDAEvent;
  const iData: Pointer);
var
  Flag: Integer;
  X, Y: Integer;
  Sign: Integer;
  XSize, YSize: Integer;
begin
  XSize := abs(iX2 - iX1);
  YSize := abs(iY2 - iY1);

  if (XSize > YSize) then begin
    // ���������̕����L���ꍇ
    Flag := XSize shr 1;

    if (iX1 < iX2) then begin
      // ���̕����������ꍇ
      if (iY1 < iY2) then
        Sign := +1
      else
        Sign := -1;

      Y := iY1;

      for X := iX1 to iX2 do begin
        iOnDDAEvent(X, Y, iData);

        Dec(Flag, YSize);
        if (Flag < 0) then begin
          Inc(Flag, XSize);
          Inc(Y, Sign);
        end;
      end;
    end
    else begin
      // �E�̕����������ꍇ
      Y := iY1;
      iY1 := iY2;
      iY2 := Y;

      if (iY1 > iY2) then
        Sign := +1
      else
        Sign := -1;

      for X := iX1 downto iX2 do begin
        iOnDDAEvent(X, Y, iData);

        Dec(Flag, YSize);
        if (Flag < 0) then begin
          Inc(Flag, XSize);
          Inc(Y, Sign);
        end;
      end;
    end;
  end
  else begin
    // ���������̕����L���ꍇ
    Flag := YSize shr 1;

    if (iY1 < iY2) then begin
      // ��̕����������ꍇ
      if (iX1 < iX2) then
        Sign := +1
      else
        Sign := -1;

      X := iX1;

      for Y := iY1 to iY2 do begin
        iOnDDAEvent(X, Y, iData);

        Dec(Flag, XSize);
        if (Flag < 0) then begin
          Inc(Flag, YSize);
          Inc(X, Sign);
        end;
      end;
    end
    else begin
      // ���̕����������ꍇ
      X := iX1;
      iX1 := iX2;
      iX2 := X;

      if (iX1 > iX2) then
        Sign := +1
      else
        Sign := -1;

      for Y := iY1 downto iY2 do begin
        iOnDDAEvent(X, Y, iData);

        Dec(Flag, XSize);
        if (Flag < 0) then begin
          Inc(Flag, YSize);
          Inc(X, Sign);
        end;
      end;
    end;
  end;
end;

end.
