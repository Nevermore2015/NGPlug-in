unit UWorkProc;

interface

uses
  Windows,Messages,Classes,superobject,GD_Utils,IdHTTP,SysUtils,IdComponent;

const
  UP_FILE = 'upfilelist.json';
type
  _FileNode = class
    private
      mHttp:TIdHTTP;
      mFileStream:TMemoryStream;
      mFileName,mMD5Str,mUrl:string;
    public
      constructor Create(_FileName,_MD5Str,_Url:string;_Http:TidHttp);
      destructor Destroy; override;
      Function DoProc():Bool;

      property FileName:String read mFileName;
      property MD5Str:String read mMD5Str;
      property Url:String read mUrl;
  end;


  TWorkProc = class(TThread)
  private
    ver:Integer;
    iMax,iProc,iFile:Integer;
    List:TList;
    mHttp:TIdHTTP;
    procedure UpdataUI;
    function LoadUpFile(): Integer;
    procedure UpdataVer;
    procedure OnWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Integer);
    procedure OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Integer);
    procedure OnWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  protected
    procedure Execute; override;
  end;

implementation
  uses
    UUpdateForm,UConfig;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TWorkProc.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TWorkProc }

Function TWorkProc.LoadUpFile():Integer;
var
  Rep:String;
  jo,jsub: ISuperObject;
  ja:TSuperArray;
  Node:_FileNode;
  I:Integer;
begin
  Result:= -1;
  mHttp:=TidHttp.Create(nil);

  if g_Config.Active then
    begin
      Rep:=mHttp.Get(g_Config.UpdateUrl + UP_FILE);
      if Strlen(Pchar(Rep)) > 0 then
        begin
          try
            Dbgprint(Rep,[]);
            jo := SO(Rep);
            ja := jo.A['files'];
            Dbgprint('File Count = %d',[ja.Length]);
            for i := 0 to ja.Length - 1 do
              begin
                jsub:=So(ja[i].AsString);
                Dbgprint('File:%s MD5:%s Url:%s',[
                  jsub['file'].AsString,
                  jsub['md5'].AsString,
                  jsub['url'].AsString
                ]);
                Node:=_FileNode.Create(
                  jsub['file'].AsString,
                  jsub['md5'].AsString,
                  g_Config.UpdateUrl + jsub['url'].AsString,
                  mHttp
                );

                List.Add(Node);
              end;
            Result:=jo['version'].AsInteger;
          except
            Dbgprint('read json error',[]);
          end;
        end;
    end;
end;

procedure TWorkProc.UpdataUI();
begin
  Form1.g1.Progress:=iFile;
  Form1.g2.Progress:=iProc;
  Form1.g2.MaxValue:=iMax;
end;

procedure TWorkProc.UpdataVer();
begin
  Form1.lbl2.Caption:= Format('·þÎñÆ÷°æ±¾:%d',[ver]);
  Form1.g1.MaxValue:=List.Count;
  Form1.g1.Progress:=1;
  mHttp.OnWork:=OnWork;
  mHttp.OnWorkBegin:=OnWorkBegin;
  mHttp.OnWorkEnd:=OnWorkEnd;
end;


procedure TWorkProc.Execute;
var
  i:Integer;
  Node:_FileNode;
begin
  Sleep(1000);
  List:=TList.Create;
  try
    ver:=LoadUpFile();
    Synchronize(UpdataVer);
    iFile:= 1;
    for i := 0 to List.Count - 1 do
      begin
        Node:=List[i];
        if not(Node.DoProc()) then
          begin
            MessageBox(0,PChar(Format('Update Error [%s]. Please try again',[Node.FileName])),'Error',0);
            Break;
          end
        else
          begin
            if LowerCase(Node.MD5Str) <> HashFile('.\'+Node.FileName) then
              begin
                MessageBox(0,PChar(Format('File Hash Error [%s]. Please try again',[Node.FileName])),'Error',0);
                Break;
              end;
          end;
        Inc(iFile);
        Synchronize(UpdataUI);
      end;
    if iFile > List.Count then
      MessageBox(0,'Update Done.','Success',0);
  finally
    List.Free;
  end;

  PostMessage(form1.Handle,WM_QUIT,0,0);
end;

procedure TWorkProc.OnWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Integer);
begin
  iProc:=AWorkCount;
  Synchronize(UpdataUI);
end;

procedure TWorkProc.OnWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Integer);
begin
  iMax:=AWorkCountMax;
  Synchronize(UpdataUI);
end;

procedure TWorkProc.OnWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  iProc:=iMax;
  Synchronize(UpdataUI);
end;


{ _FileNode }
constructor _FileNode.Create(_FileName, _MD5Str, _Url: string;_Http:TidHTTP);
begin
  mFileName:=_FileName;
  mMD5Str:=_MD5Str;
  mUrl:=_Url;
  mHttp:=_Http;
  mFileStream:=TMemoryStream.Create;
end;

destructor _FileNode.Destroy;
begin
  inherited;
  mFileStream.Free;
  mHttp.Free;
end;

function _FileNode.DoProc: Bool;
begin
  try
    mHttp.Get(mUrl,mFileStream);
    mFileStream.SaveToFile('.\' + mFileName);
    Result:=True;
  except
    Result:=False;
  end;
end;

end.
