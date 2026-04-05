package com.gfp.app.mapProcess
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.time.TimerComponents;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1147501 extends BaseMapProcess
   {
      
      private var _tipMc:MovieClip;
      
      private var _over:Boolean = false;
      
      private var _attackTipMc:MovieClip;
      
      private var _num:int;
      
      public function MapProcess_1147501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._attackTipMc = _mapModel.libManager.getMovieClip("UI_AttackTip1475");
         LayerManager.topLevel.addChild(this._attackTipMc);
         StageResizeController.instance.register(this.relayout);
         this.relayout();
         SocketConnection.addCmdListener(CommandID.ACTION_BRUISE,this.bruiseHandle);
         this._num = 0;
         (this._attackTipMc["numTxt"] as TextField).text = this._num.toString();
      }
      
      private function relayout() : void
      {
         this._attackTipMc.x = 510;
         this._attackTipMc.y = 452;
      }
      
      private function bruiseHandle(param1:SocketEvent) : void
      {
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         var _loc3_:UserModel = UserManager.getModel(_loc2_.userID);
         if(_loc2_.userID == MainManager.actorID && _loc2_.decHP > 0 && _loc2_.skillID != 0)
         {
            ++this._num;
            (this._attackTipMc["numTxt"] as TextField).text = this._num.toString();
            if(this._num >= 10 && this._over == false)
            {
               this._over = true;
               FightManager.actorLifeTime = TimerComponents.instance.timeCost;
            }
         }
      }
      
      private function whenQuickPickUpHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         AlertManager.showSimpleAlarm("小侠士，你通过本次挑战获得" + _loc6_ + "个" + ItemXMLInfo.getName(_loc4_) + "！");
      }
      
      override public function destroy() : void
      {
         StageResizeController.instance.unregister(this.relayout);
         DisplayUtil.removeForParent(this._attackTipMc);
         SocketConnection.removeCmdListener(CommandID.ACTION_BRUISE,this.bruiseHandle);
      }
   }
}

