unit UHideSelf;

interface
uses
  windows;

Procedure HideSelf();

implementation


Procedure MyFakeApi(NewProc:Pointer;SrcProc:Cardinal;SizeOfImage:Cardinal);Stdcall;
var
  Proc:Pointer;
begin
  Proc:=GetProcAddress(LoadLibrary('kernel32.dll'),'VirtualAlloc');
  FreeLibrary(SrcProc);
  asm
    push $40
    push $3000
    push SizeOfImage
    push SrcProc
    call Proc
  end;
  CopyMemory(Pointer(SrcProc),Newproc,SizeOfImage);
end;


Procedure HideSelf();
var
  DosHead: ^IMAGE_DOS_HEADER;
  NThead: ^IMAGE_NT_HEADERS;
  SizeOfImage:Cardinal;
  NewProc:Pointer;
  pFakeApi:procedure (NewProc:Pointer;SrcProc:Cardinal;SizeOfImage:Cardinal);Stdcall;
  Offset:Cardinal;
begin
  {$i vmp_begin.inc}
  DosHead:= Pointer(HInstance);
  NThead:= Pointer(DosHead._lfanew + Integer(HInstance));
  //获取模块大小
  SizeOfImage:=NTHead.OptionalHeader.SizeOfImage;
  NewProc:=VirtualAlloc(nil,SizeOfImage,MEM_COMMIT,PAGE_EXECUTE_READWRITE);
  //将原来的代码复制到新内存
  CopyMemory(Newproc,Pointer(HInstance),SizeOfImage);
  Offset:= Cardinal(@MyFakeApi) - HInstance;
  pFakeApi:= Pointer(Cardinal(NewProc)+ Offset);
  //执行新内存
  pFakeApi(NewProc,HInstance,SizeOfImage);
  //释放
  VirtualFree(NewProc,SizeOfImage,MEM_COMMIT);
  {$i vmp_end.inc}
end;



end.
