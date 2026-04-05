package com.gfp.app.cmdl
{
   import com.gfp.app.info.DefeatHeroInfo;
   import com.gfp.core.CommandID;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class HeromeetCmdListener extends BaseBean
   {
      
      public function HeromeetCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.HEROMEET_SIMPLE_INFO,this.onHeromeetSimpleInfo);
         finish();
         SocketConnection.send(CommandID.HEROMEET_SIMPLE_INFO);
      }
      
      public function onHeromeetSimpleInfo(param1:SocketEvent) : void
      {
         var _loc6_:DefeatHeroInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         MainManager.actorInfo.defeatHeros = [];
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new DefeatHeroInfo(_loc2_);
            MainManager.actorInfo.defeatHeros.push(_loc6_.heroID);
            _loc5_++;
         }
         MainManager.actorInfo.heroTermID = _loc3_;
      }
   }
}

