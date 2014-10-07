unit FMX.WebBrowser.Mac;

interface

uses
  FMX.WebBrowserEx;

procedure RegisterWebBrowserService;
procedure UnRegisterWebBrowserService;

implementation

uses
  System.Classes, System.SysUtils, System.Types, System.Math
  , Macapi.WebView, Macapi.Foundation, Macapi.AppKit, Macapi.CocoaTypes
  , Macapi.CoreGraphics, Macapi.Helpers
  , FMX.Types, FMX.WebBrowser, FMX.Platform, FMX.Platform.Mac, FMX.Forms
  , FMX.Graphics, FMX.Surfaces
  ;

type
  TMacWebBrowserService =
    class(TInterfacedObject, ICustomBrowser, IWebBrowserEx)
  private const
    WEBKIT_FRAMEWORK: String =
      '/System/Library/Frameworks/WebKit.framework/WebKit';
  private var
    FURL: String;
    FWebView: WebView;
    FWebControl: TCustomWebBrowser;
    FNSCachePolicy: NSURLRequestCachePolicy;
    FModule: HMODULE;
    FForm: TCommonCustomForm;
  private
    function GetBounds: TRectF;
    function GetNSBounds: NSRect;
  protected
    { ICustomBrowser }
    function GetURL: string;
    function CaptureBitmap: TBitmap;
    function GetCanGoBack: Boolean;
    function GetCanGoForward: Boolean;
    procedure SetURL(const AValue: string);
    function GetEnableCaching: Boolean;
    procedure SetEnableCaching(const Value : Boolean);
    procedure SetWebBrowserControl(const AValue: TCustomWebBrowser);
    function GetParent: TFmxObject;
    function GetVisible : Boolean;
    procedure UpdateContentFromControl;
    procedure Navigate;
    procedure Reload;
    procedure Stop;
    procedure EvaluateJavaScript(const JavaScript: string);
    procedure LoadFromStrings(const Content: string; const BaseUrl: string);
    procedure GoBack;
    procedure GoForward;
    procedure GoHome;
    procedure Show;
    procedure Hide;
    property URL: string read GetURL write SetURL;
    property EnableCaching: Boolean read GetEnableCaching write SetEnableCaching;
    property CanGoBack: Boolean read GetCanGoBack;
    property CanGoForward: Boolean read GetCanGoForward;
    { IWebBrowserEx }
    function GetTagValue(const iTagName, iValueName: String): String;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TMacWBService = class(TWBFactoryService)
  protected
    function DoCreateWebBrowser: ICustomBrowser; override;
  end;

var
  GWBService: TMacWBService;

{ TMacWBService }

function TMacWBService.DoCreateWebBrowser: ICustomBrowser;
begin
  Result := TMacWebBrowserService.Create;
end;

procedure RegisterWebBrowserService;
begin
  GWBService := TMacWBService.Create;
  TPlatformServices.Current.AddPlatformService(IFMXWBService, GWBService);
end;

procedure UnRegisterWebBrowserService;
begin
  TPlatformServices.Current.RemovePlatformService(IFMXWBService);
end;

{ TMacWebBrowserService }

function TMacWebBrowserService.CaptureBitmap: TBitmap;
var
  Surface: TBitmapSurface;
  Size: NSSize;
  ContRef: CGContextRef;
  OldWantLayer: Boolean;
begin
  Result := TBitmap.Create;

  Surface := TBitmapSurface.Create;
  try
    Size := FWebView.frame.size;
    Surface.SetSize(Ceil(Size.width), Ceil(Size.height));

    ContRef :=
      CGBitmapContextCreate(
        Surface.Bits,
        Surface.Width,
        Surface.Height,
        8,
        4 * Surface.Width,
        CGColorSpaceCreateDeviceRGB,
        kCGImageAlphaPremultipliedLast or kCGBitmapByteOrder32Big);
    try
      OldWantLayer := FWebView.wantsLayer;
      FWebView.setWantsLayer(True);
      try
        if (FWebView.layer <> nil) then
          FWebView.layer.renderInContext(ContRef);
      finally
        FWebView.setWantsLayer(OldWantLayer);
      end;
    finally
      CGContextRelease(ContRef);
    end;

    Result.Assign(Surface);
  finally
    Surface.Free;
  end;
end;

constructor TMacWebBrowserService.Create;
begin
  inherited;

  FModule := LoadLibrary(PWideChar(WEBKIT_FRAMEWORK));
  FNSCachePolicy := NSURLRequestReloadRevalidatingCacheData;

  FWebView :=
    TWebView.Wrap(
      TWebView.Alloc.initWithFrame(MakeNSRect(0, 0, 100, 100), nil, nil));
end;

destructor TMacWebBrowserService.Destroy;
begin
  FWebView.release;

  FreeLibrary(FModule);

  inherited;
end;

procedure TMacWebBrowserService.EvaluateJavaScript(const JavaScript: String);
begin
  FWebView.stringByEvaluatingJavaScriptFromString(StrToNSSTR(JavaScript));
  UpdateContentFromControl;
end;

function TMacWebBrowserService.GetBounds: TRectF;
var
  Pt: TPointF;
begin
  Result.Empty;

  if (FWebControl <> nil) and (FForm <> nil) then begin
    Pt := FWebControl.LocalToAbsolute(FWebControl.Position.Point);
    Result :=
      TRectF.Create(
        Pt.X,
        FForm.ClientHeight - Pt.Y - FWebControl.Height,
        FWebControl.Width,
        FWebControl.Height);
  end;
end;

function TMacWebBrowserService.GetCanGoBack: Boolean;
begin
  Result := FWebView.canGoBack;
end;

function TMacWebBrowserService.GetCanGoForward: Boolean;
begin
  Result := FWebView.canGoForward;
end;

function TMacWebBrowserService.GetEnableCaching: Boolean;
begin
  Result := (FNSCachePolicy = NSURLRequestReloadRevalidatingCacheData);
end;

function TMacWebBrowserService.GetNSBounds: NSRect;
var
  Bounds: TRectF;
begin
  Bounds := GetBounds;
  Result := MakeNSRect(Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom);
end;

function TMacWebBrowserService.GetParent: TFmxObject;
begin
  if (FWebControl <> nil) then
    Result := FWebControl.Parent
  else
    Result := nil;
end;

function TMacWebBrowserService.GetTagValue(
  const iTagName, iValueName: String): String;
var
  Res: NSString;
begin
  Res :=
    FWebView.stringByEvaluatingJavaScriptFromString(
      StrToNSSTR(
        'document.getElementById("' + iTagName + '").' + iValueName
      )
    );

  Result := String(Res.UTF8String);
end;

function TMacWebBrowserService.GetURL: string;
begin
  Result := FURL;
end;

function TMacWebBrowserService.GetVisible: Boolean;
begin
  if (FWebControl <> nil) then
    Result := FWebControl.Visible
  else
    Result := False;
end;

procedure TMacWebBrowserService.GoBack;
begin
  FWebView.goBack;
end;

procedure TMacWebBrowserService.GoForward;
begin
  FWebView.goForward;
end;

procedure TMacWebBrowserService.GoHome;
begin

end;

procedure TMacWebBrowserService.Hide;
begin
  if (FWebView <> nil) and (not FWebView.isHidden) then
    FWebView.setHidden(True);
end;

procedure TMacWebBrowserService.LoadFromStrings(const Content, BaseUrl: String);
var
  tmpContent: NSString;
  URL: NSURL;
  Base: NSString;
begin
  tmpContent := StrToNSStr(Content);

  if (BaseUrl.IsEmpty) then
    URL := nil
  else begin
    Base := StrToNSStr(BaseUrl);
    URL := TNSUrl.Wrap(TNSUrl.OCClass.URLWithString(Base));
  end;

  FWebView.mainFrame.loadHTMLString(tmpContent, URL);

  UpdateContentFromControl;
end;

procedure TMacWebBrowserService.Navigate;
const
  cTheTimeoutIntervalForTheNewRequest = 0;
var
  Url: NSURL;
  Req: NSURLRequest;
begin
  Url := TNSURL.Wrap(TNSURL.Alloc.initWithString(StrToNSSTR(FURL)));

  Req :=
    TNSURLRequest.Wrap(
      TNSURLRequest.OCClass.requestWithURL(
        Url,
        FNSCachePolicy,
        cTheTimeoutIntervalForTheNewRequest
      )
    );

  FWebView.mainFrame.loadRequest(Req);
end;

procedure TMacWebBrowserService.Reload;
begin

end;

procedure TMacWebBrowserService.SetEnableCaching(const Value: Boolean);
begin
  if (Value) then
    FNSCachePolicy := NSURLRequestReloadRevalidatingCacheData
  else
    FNSCachePolicy := NSURLRequestReloadIgnoringLocalCacheData;
end;

procedure TMacWebBrowserService.SetURL(const AValue: string);
begin
  FURL := AValue;
end;

procedure TMacWebBrowserService.SetWebBrowserControl(
  const AValue: TCustomWebBrowser);
begin
  FWebControl := AValue;

  if
    (FWebControl <> nil)
    and (FWebControl.Root <> nil)
    and (FWebControl.Root.GetObject is TCommonCustomForm)
  then
    FForm := TCommonCustomForm(FWebControl.Root.GetObject);

  UpdateContentFromControl;
end;

procedure TMacWebBrowserService.Show;
begin
  if (FWebView <> nil) and (FWebView.isHidden) then
    FWebView.setHidden(False);
end;

procedure TMacWebBrowserService.Stop;
begin

end;

procedure TMacWebBrowserService.UpdateContentFromControl;
var
  View: NSView;
  Bounds: TRectF;
begin
  if (FWebView <> nil) then begin
    if
      (FWebControl <> nil)
      and not (csDesigning in FWebControl.ComponentState)
      and (FForm <> nil)
    then begin
      Bounds := GetBounds;

      View := WindowHandleToPlatform(FForm.Handle).View;
      if (View <> nil) then begin
        View.addSubview(FWebView);

        if (SameValue(Bounds.Width, 0)) or (SameValue(Bounds.Height, 0)) then
          FWebView.setHidden(True)
        else begin
          FWebView.setFrame(GetNSBounds);
          FWebView.setHidden(not FWebControl.ParentedVisible);
        end;
      end;
    end
    else
      FWebView.setHidden(True);
  end;
end;

initialization
  RegisterWebBrowserService;

end.
