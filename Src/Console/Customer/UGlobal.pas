unit UGlobal;

interface
uses
  Windows;
{
  控制台内部全局配置单元

}
const
  //验证版本号
  C_VERSION_CHECK = 'ver.php';
  //授权验证 获取游戏地址
  C_AUTH_CHECK = 'Auth.php';
var
  //控制台版本号
  ConsoleVersion:Integer = 20160825;
  //支持游戏ID
  GameId:Integer = 0;
  //控制台标题
  ConsoleTitle:String = '蛮荒搜神记';
implementation

end.
