unit UHookLib;

interface
  uses
    Windows;


const
  IMPORTED_NAME_OFFSET = $00000002;
  IMAGE_ORDINAL_FLAG32 = $80000000;
  IMAGE_ORDINAL_MASK32 = $0000FFFF;

  Opcodes1: array[0..255] of word =
  (
    (16913), (17124), (8209), (8420), (33793), (35906), (0), (0), (16913),
    (17124), (8209), (8420), (33793), (35906), (0), (0), (16913),
    (17124), (8209), (8420), (33793), (35906), (0), (0), (16913), (17124),
    (8209), (8420), (33793), (35906), (0), (0), (16913),
    (17124), (8209), (8420), (33793), (35906), (0), (32768), (16913), (17124),
    (8209), (8420), (33793), (35906), (0), (32768), (16913),
    (17124), (8209), (8420), (33793), (35906), (0), (32768), (529), (740), (17),
    (228), (1025), (3138), (0), (32768), (24645),
    (24645), (24645), (24645), (24645), (24645), (24645), (24645), (24645),
    (24645), (24645), (24645), (24645), (24645), (24645), (24645), (69),
    (69), (69), (69), (69), (69), (69), (69), (24645), (24645), (24645),
    (24645), (24645), (24645), (24645), (24645), (0),
    (32768), (228), (16922), (0), (0), (0), (0), (3072), (11492), (1024),
    (9444), (0), (0), (0), (0), (5120),
    (5120), (5120), (5120), (5120), (5120), (5120), (5120), (5120), (5120),
    (5120), (5120), (5120), (5120), (5120), (5120), (1296),
    (3488), (1296), (1440), (529), (740), (41489), (41700), (16913), (17124),
    (8209), (8420), (17123), (8420), (227), (416), (0),
    (57414), (57414), (57414), (57414), (57414), (57414), (57414), (32768), (0),
    (0), (0), (0), (0), (0), (32768), (33025),
    (33090), (769), (834), (0), (0), (0), (0), (1025), (3138), (0), (0),
    (32768), (32768), (0), (0), (25604),
    (25604), (25604), (25604), (25604), (25604), (25604), (25604), (27717),
    (27717), (27717), (27717), (27717), (27717), (27717), (27717), (17680),
    (17824), (2048), (0), (8420), (8420), (17680), (19872), (0), (0), (2048),
    (0), (0), (1024), (0), (0), (16656),
    (16800), (16656), (16800), (33792), (33792), (0), (32768), (8), (8), (8),
    (8), (8), (8), (8), (8), (5120),
    (5120), (5120), (5120), (33793), (33858), (1537), (1602), (7168), (7168),
    (0), (5120), (32775), (32839), (519), (583), (0),
    (0), (0), (0), (0), (0), (8), (8), (0), (0), (0), (0), (0), (0), (16656),
    (416)
    );

  Opcodes2: array[0..255] of word =
  (
    (280), (288), (8420), (8420), (65535), (0), (0), (0), (0), (0), (65535),
    (65535), (65535), (272), (0), (1325), (63),
    (575), (63), (575), (63), (63), (63), (575), (272), (65535), (65535),
    (65535), (65535), (65535), (65535), (65535), (16419),
    (16419), (547), (547), (65535), (65535), (65535), (65535), (63), (575),
    (47), (575), (61), (61), (63), (63), (0),
    (32768), (32768), (32768), (0), (0), (65535), (65535), (65535), (65535),
    (65535), (65535), (65535), (65535), (65535), (65535), (8420),
    (8420), (8420), (8420), (8420), (8420), (8420), (8420), (8420), (8420),
    (8420), (8420), (8420), (8420), (8420), (8420), (16935),
    (63), (63), (63), (63), (63), (63), (63), (63), (63), (63), (63), (63),
    (63), (63), (63), (237),
    (237), (237), (237), (237), (237), (237), (237), (237), (237), (237), (237),
    (237), (237), (101), (237), (1261),
    (1192), (1192), (1192), (237), (237), (237), (0), (65535), (65535), (65535),
    (65535), (65535), (65535), (613), (749), (7168),
    (7168), (7168), (7168), (7168), (7168), (7168), (7168), (7168), (7168),
    (7168), (7168), (7168), (7168), (7168), (7168), (16656),
    (16656), (16656), (16656), (16656), (16656), (16656), (16656), (16656),
    (16656), (16656), (16656), (16656), (16656), (16656), (16656), (0),
    (0), (32768), (740), (18404), (17380), (49681), (49892), (0), (0), (0),
    (17124), (18404), (17380), (32), (8420), (49681),
    (49892), (8420), (17124), (8420), (8932), (8532), (8476), (65535), (65535),
    (1440), (17124), (8420), (8420), (8532), (8476), (41489),
    (41700), (1087), (548), (1125), (9388), (1087), (33064), (24581), (24581),
    (24581), (24581), (24581), (24581), (24581), (24581), (65535),
    (237), (237), (237), (237), (237), (749), (8364), (237), (237), (237),
    (237), (237), (237), (237), (237), (237),
    (237), (237), (237), (237), (237), (63), (749), (237), (237), (237), (237),
    (237), (237), (237), (237), (65535),
    (237), (237), (237), (237), (237), (237), (237), (237), (237), (237), (237),
    (237), (237), (237), (0)
    );

  Opcodes3: array[0..9] of array[0..15] of word =
  (
    ((1296), (65535), (16656), (16656), (33040), (33040), (33040), (33040),
    (1296), (65535), (16656), (16656), (33040), (33040), (33040), (33040)),
    ((3488), (65535), (16800), (16800), (33184), (33184), (33184), (33184),
    (3488), (65535), (16800), (16800), (33184), (33184), (33184), (33184)),
    ((288), (288), (288), (288), (288), (288), (288), (288), (54), (54), (48),
    (48), (54), (54), (54), (54)),
    ((288), (65535), (288), (288), (272), (280), (272), (280), (48), (48), (0),
    (48), (0), (0), (0), (0)),
    ((288), (288), (288), (288), (288), (288), (288), (288), (54), (54), (54),
    (54), (65535), (0), (65535), (65535)),
    ((288), (65535), (288), (288), (65535), (304), (65535), (304), (54), (54),
    (54), (54), (0), (54), (54), (0)),
    ((296), (296), (296), (296), (296), (296), (296), (296), (566), (566), (48),
    (48), (566), (566), (566), (566)),
    ((296), (65535), (296), (296), (272), (65535), (272), (280), (48), (48),
    (48), (48), (48), (48), (65535), (65535)),
    ((280), (280), (280), (280), (280), (280), (280), (280), (566), (566), (48),
    (566), (566), (566), (566), (566)),
    ((280), (65535), (280), (280), (304), (296), (304), (296), (48), (48), (48),
    (48), (0), (54), (54), (65535))
    );

function SaveOldFunction(Proc: pointer; Old: pointer; bytescopy: integer = -1):
  longword; forward;

function HookCode(TargetProc, NewProc: pointer; var OldProc: pointer; bytescopy:
  integer = -1): boolean;

  
function HookApi(Dllname, ApiName: string; NewProc: pointer; var OldProc:
  pointer): boolean;

  
implementation


function SizeOfCode(Code: pointer): longword;
var
  Opcode: word;
  Modrm: byte;
  Fixed, AddressOveride: boolean;
  Last, OperandOveride, Flags, Rm, Size, Extend: longword;
begin
  try
    Last := longword(Code);
    if Code <> nil then
    begin
      AddressOveride := False;
      Fixed := False;
      OperandOveride := 4;
      Extend := 0;
      repeat
        Opcode := byte(Code^);
        Code := pointer(longword(Code) + 1);
        if Opcode = $66 then
        begin
          OperandOveride := 2;
        end
        else if Opcode = $67 then
        begin
          AddressOveride := True;
        end
        else
        begin
          if not ((Opcode and $E7) = $26) then
          begin
            if not (Opcode in [$64..$65]) then
            begin
              Fixed := True;
            end;
          end;
        end;
      until Fixed;
      if Opcode = $0F then
      begin
        Opcode := byte(Code^);
        Flags := Opcodes2[Opcode];
        Opcode := Opcode + $0F00;
        Code := pointer(longword(Code) + 1);
      end
      else
      begin
        Flags := Opcodes1[Opcode];
      end;
      if ((Flags and $0038) <> 0) then
      begin
        Modrm := byte(Code^);
        Rm := Modrm and $7;
        Code := pointer(longword(Code) + 1);
        case (Modrm and $C0) of
          $40: Size := 1;
          $80:
            begin
              if AddressOveride then
              begin
                Size := 2;
              end
              else
                Size := 4;
            end;
        else
          begin
            Size := 0;
          end;
        end;
        if not (((Modrm and $C0) <> $C0) and AddressOveride) then
        begin
          if (Rm = 4) and ((Modrm and $C0) <> $C0) then
          begin
            Rm := byte(Code^) and $7;
          end;
          if ((Modrm and $C0 = 0) and (Rm = 5)) then
          begin
            Size := 4;
          end;
          Code := pointer(longword(Code) + Size);
        end;
        if ((Flags and $0038) = $0008) then
        begin
          case Opcode of
            $F6: Extend := 0;
            $F7: Extend := 1;
            $D8: Extend := 2;
            $D9: Extend := 3;
            $DA: Extend := 4;
            $DB: Extend := 5;
            $DC: Extend := 6;
            $DD: Extend := 7;
            $DE: Extend := 8;
            $DF: Extend := 9;
          end;
          if ((Modrm and $C0) <> $C0) then
          begin
            Flags := Opcodes3[Extend][(Modrm shr 3) and $7];
          end
          else
          begin
            Flags := Opcodes3[Extend][((Modrm shr 3) and $7) + 8];
          end;
        end;
      end;
      case (Flags and $0C00) of
        $0400: Code := pointer(longword(Code) + 1);
        $0800: Code := pointer(longword(Code) + 2);
        $0C00: Code := pointer(longword(Code) + OperandOveride);
      else
        begin
          case Opcode of
            $9A, $EA: Code := pointer(longword(Code) + OperandOveride + 2);
            $C8: Code := pointer(longword(Code) + 3);
            $A0..$A3:
              begin
                if AddressOveride then
                begin
                  Code := pointer(longword(Code) + 2)
                end
                else
                begin
                  Code := pointer(longword(Code) + 4);
                end;
              end;
          end;
        end;
      end;
    end;
    Result := longword(Code) - Last;
  except
    Result := 0;
  end;
end;

function SaveOldFunction(Proc: pointer; Old: pointer; Bytescopy: integer = -1):
  longword;
var
  SaveSize, Size: longword;
  Next: pointer;
begin
  SaveSize := 0;
  Next := Proc;
  if bytescopy <= 0 then
  begin
    while SaveSize < 5 do
    begin
      Size := SizeOfCode(Next);
      Next := pointer(longword(Next) + Size);
      Inc(SaveSize, Size);
    end;
  end
  else
  begin
    savesize := bytescopy;
    Next := pointer(longword(Next) + cardinal(bytescopy));
  end;
  CopyMemory(Old, Proc, SaveSize);
  byte(pointer(longword(Old) + SaveSize)^) := $E9;
  longword(pointer(longword(Old) + SaveSize + 1)^) := longword(Next) -
    longword(Old) - SaveSize - 5;
  Result := SaveSize;
end;

function HookCode(TargetProc, NewProc: pointer; var OldProc: pointer; bytescopy:
  integer = -1): boolean;
var
  Address: longword;
  OldProtect: longword;
  OldFunction: pointer;
  Proc: pointer;
begin
  Result := False;
  try
    Proc := TargetProc;
    Address := longword(NewProc) - longword(Proc) - 5;
    VirtualProtect(Proc, 5, PAGE_EXECUTE_READWRITE, OldProtect);
    GetMem(OldFunction, 255);
    VirtualProtect(OldFunction, 255, PAGE_EXECUTE_READWRITE, OldProtect);
    longword(OldFunction^) := longword(Proc);
    byte(pointer(longword(OldFunction) + 4)^) := SaveOldFunction(Proc,
      pointer(longword(OldFunction) + 5), bytescopy);
    byte(pointer(Proc)^) := $E9;
    longword(pointer(longword(Proc) + 1)^) := Address;
    //VirtualProtect(Proc, 5, OldProtect, OldProtect);
    OldProc := pointer(longword(OldFunction) + 5);
  except
    Exit;
  end;
  Result := True;
end;

function HookApi(Dllname, ApiName: string; NewProc: pointer; var OldProc:
  pointer): boolean;
var
  Module: Thandle;
  Apicode: pointer;
begin
  Module := LoadLibrary(pchar(Dllname));
  result := false;
  if Module > 0 then
  begin
    ApiCode := GetProcAddress(Module, pchar(ApiName));
    if Apicode <> nil then
    begin
      result := HookCode(ApiCode, NewProc, OldProc);
    end;
  end;
end;
end.
