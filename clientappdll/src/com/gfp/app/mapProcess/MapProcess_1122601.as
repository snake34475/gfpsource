package com.gfp.app.mapProcess
{
   import com.gfp.app.toolBar.HeadOgrePanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.BruiseInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.NumSprite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1122601 extends BaseMapProcess
   {
      
      private var tips:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var totleHp:uint = 0;
      
      private var _p:Array = [0,0,0,0];
      
      private var timers:Vector.<uint> = new Vector.<uint>();
      
      private var timNs:Vector.<NumSprite> = new Vector.<NumSprite>();
      
      public function MapProcess_1122601()
      {
         super();
         this.addEvent();
         HeadOgrePanel.instance.isShow = false;
         HeadOgrePanel.instance.hide();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            this.tips.push(_mapModel.libManager.getMovieClip("UI_P" + _loc1_));
            _loc1_++;
         }
         this.flyTips(1);
      }
      
      private function addEvent() : void
      {
         StageResizeController.instance.register(this.layout);
         SocketConnection.addCmdListener(CommandID.ACTION_BRUISE,this.onBossHp);
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBorn);
         SocketConnection.addCmdListener(CommandID.ITEM_QUICK_PICKUP,this.whenQuickPickUpHandler);
      }
      
      private function onMonsterBorn(param1:UserEvent) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:NumSprite = null;
         var _loc2_:UserModel = param1.data as UserModel;
         var _loc3_:UserInfo = _loc2_.info;
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.roleType >= 14637 && _loc3_.roleType <= 14644)
         {
            if(this.totleHp == 0)
            {
               this.totleHp = _loc3_.hp;
            }
            else
            {
               _loc4_ = _mapModel.libManager.getMovieClip("UI_NUM");
               _loc5_ = new NumSprite(_loc4_,30,false);
               _loc4_.y = 32;
               _loc4_.y = 0 - _loc2_.height - 60;
               this.timNs.push(_loc5_);
               _loc2_.addChild(_loc4_);
               this.timers.push(setInterval(this.countDown,1000));
            }
         }
      }
      
      private function countDown() : void
      {
         var _loc1_:NumSprite = null;
         for each(_loc1_ in this.timNs)
         {
            if(_loc1_.value > 0)
            {
               --_loc1_.value;
            }
            else
            {
               _loc1_.content.visible = false;
            }
         }
      }
      
      private function layout() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.tips[_loc1_].x = LayerManager.stageWidth - this.tips[_loc1_].width;
            _loc1_++;
         }
         this.tips[_loc1_].y = 0;
      }
      
      private function onBossHp(param1:SocketEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:BruiseInfo = param1.data as BruiseInfo;
         if(_loc2_.roleID >= 14637 && _loc2_.roleID <= 14644 || _loc2_.roleID == 14632)
         {
            _loc3_ = _loc2_.hp / this.totleHp;
            if(this._p[this.calculateP(_loc3_) - 1] == 0)
            {
               this.flyTips(this.calculateP(_loc3_));
            }
         }
      }
      
      private function flyTips(param1:int) : void
      {
         this._p[param1 - 1] = 1;
         LayerManager.topLevel.addChild(this.tips[param1 - 1]);
         this.tips[param1 - 1].y = LayerManager.stageHeight;
         this.tips[param1 - 1].x = LayerManager.stageWidth - this.tips[param1 - 1].width;
         if(param1 > 1)
         {
            TweenLite.to(this.tips[param1 - 1],3,{
               "y":0,
               "onComplete":this.TweenCom,
               "onCompleteParams":[param1]
            });
         }
         else
         {
            TweenLite.to(this.tips[param1 - 1],3,{"y":0});
         }
      }
      
      private function TweenCom(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            if(param1 != _loc2_ + 1)
            {
               DisplayUtil.removeForParent(this.tips[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      private function calculateP(param1:Number) : int
      {
         var _loc2_:int = 1;
         if(param1 >= 0.755)
         {
            _loc2_ = 1;
         }
         else if(param1 >= 0.55 && param1 < 0.755)
         {
            _loc2_ = 2;
         }
         else if(param1 >= 0.255 && param1 < 0.55)
         {
            _loc2_ = 3;
         }
         else if(param1 >= 0 && param1 < 0.255)
         {
            _loc2_ = 4;
         }
         return _loc2_;
      }
      
      private function whenQuickPickUpHandler(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         AlertManager.showSimpleItemAlarmFly(ItemXMLInfo.getName(_loc4_),ClientConfig.getItemIcon(_loc4_),{"num":_loc6_},null);
      }
      
      override public function destroy() : void
      {
         var _loc1_:MovieClip = null;
         super.destroy();
         SocketConnection.removeCmdListener(CommandID.ITEM_QUICK_PICKUP,this.whenQuickPickUpHandler);
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBorn);
         StageResizeController.instance.unregister(this.layout);
         for each(_loc1_ in this.tips)
         {
            DisplayUtil.removeForParent(_loc1_);
         }
      }
   }
}

