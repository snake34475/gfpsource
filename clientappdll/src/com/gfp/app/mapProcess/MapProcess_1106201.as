package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.ShowCartoonFeather;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.info.HpMpInfo;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.strength.SwfLoaderHelper;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1106201 extends BaseMapProcess
   {
      
      private var _feather1:ShowCartoonFeather;
      
      private var _feather2:ShowCartoonFeather;
      
      private var _feather3:ShowCartoonFeather;
      
      private var _maxHp:int;
      
      private var _hasDamaged:Boolean = false;
      
      private var zpd:int = 0;
      
      private var mc:MovieClip;
      
      public function MapProcess_1106201()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._feather1 = null;
         this._feather2 = null;
         this._feather3 = null;
         this._maxHp = MainManager.actorInfo.hp;
         var _loc1_:SwfLoaderHelper = new SwfLoaderHelper();
         _loc1_.loadFile(ClientConfig.getCartoon("ling_sheng_tips1"),this.movieCallBack);
         if(ActivityExchangeTimesManager.getTimes(5721) > 0)
         {
            this._hasDamaged = false;
            SocketConnection.addCmdListener(CommandID.INFORM_USER_HPMP,this.onRevive);
            SocketConnection.addCmdListener(CommandID.ACTION_BRUISE,this.onSetHas);
         }
         if(ActivityExchangeTimesManager.getTimes(5721) > 1)
         {
            SocketConnection.addCmdListener(CommandID.BUFF_STATE,this.onWudi);
         }
      }
      
      private function movieCallBack(param1:Loader) : void
      {
         this._feather1 = new ShowCartoonFeather("ling_sheng_tips1");
      }
      
      private function onSetHas(param1:SocketEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(_loc2_.decHP >= MainManager.actorInfo.hp && _loc2_.atkerID != MainManager.actorID)
         {
            SocketConnection.removeCmdListener(CommandID.ACTION_BRUISE,this.onSetHas);
            this._hasDamaged = true;
         }
      }
      
      private function onRevive(param1:SocketEvent) : void
      {
         if(MainManager.actorInfo.hp == this._maxHp && this._hasDamaged)
         {
            SocketConnection.removeCmdListener(CommandID.INFORM_USER_HPMP,this.onRevive);
            this._feather2 = new ShowCartoonFeather("ling_sheng_tips2");
         }
         var _loc2_:HpMpInfo = param1.data as HpMpInfo;
      }
      
      private function onWudi(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedShort();
         var _loc5_:uint = _loc2_.readUnsignedByte();
         var _loc6_:Boolean = _loc2_.readUnsignedByte() == 1;
         if(_loc4_ == 2426)
         {
            if(this.zpd % 2 == 0)
            {
               this._feather3 = new ShowCartoonFeather("ling_sheng_tips3");
            }
            ++this.zpd;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._feather1)
         {
            this._feather1.destroy();
         }
         if(this._feather2)
         {
            this._feather2.destroy();
         }
         if(this._feather3)
         {
            this._feather3.destroy();
         }
         SocketConnection.removeCmdListener(CommandID.ACTION_BRUISE,this.onRevive);
         SocketConnection.removeCmdListener(CommandID.BUFF_STATE,this.onWudi);
         SocketConnection.removeCmdListener(CommandID.ACTION_BRUISE,this.onSetHas);
         DisplayUtil.removeForParent(this.mc);
      }
   }
}

