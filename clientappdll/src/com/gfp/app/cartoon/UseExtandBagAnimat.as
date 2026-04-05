package com.gfp.app.cartoon
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.DailyActivityXMLInfo;
   import com.gfp.core.info.DailyActiveAwardInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.info.item.SingleItemInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.net.SocketConnection;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.motion.easing.Quad;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class UseExtandBagAnimat extends AnimatBase
   {
      
      private static var _instance:UseExtandBagAnimat;
      
      private var awardInfo:DailyActiveAwardInfo;
      
      private var dailyActivityId:int;
      
      private var _bagMC:MovieClip;
      
      private var item:ExtendBagItem;
      
      private var _itemArr:Array;
      
      public function UseExtandBagAnimat()
      {
         super();
      }
      
      public static function get instance() : UseExtandBagAnimat
      {
         if(_instance == null)
         {
            _instance = new UseExtandBagAnimat();
         }
         return _instance;
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.DAILY_ACTIVITY,this.onExtendBag);
         finish();
      }
      
      private function onExtendBag(param1:SocketEvent) : void
      {
         this.awardInfo = param1.data as DailyActiveAwardInfo;
         var _loc2_:uint = uint(this.awardInfo.type);
         if(_loc2_ != DailyActivityXMLInfo.TYPE_EXTENDS_BAG)
         {
            return;
         }
         this.dailyActivityId = this.awardInfo.dailyActivityId;
         this.getItemArr();
         MainManager.closeOperate(true);
         if(this.dailyActivityId == 448 || this.dailyActivityId == 449)
         {
            this.playToBag();
         }
         else
         {
            this.play(this.dailyActivityId);
         }
      }
      
      public function play(param1:int) : void
      {
         loadMC(ClientConfig.getCartoon("useExtendBag_" + param1));
      }
      
      override protected function playAnimat() : void
      {
         super.playAnimat();
         this._bagMC = animatMC["animat"];
         LayerManager.topLevel.addChild(this._bagMC);
         DisplayUtil.align(this._bagMC,null,AlignType.MIDDLE_CENTER,new Point(-150,-200));
         this._bagMC.addEventListener(Event.ENTER_FRAME,this.animatEnter);
         this._bagMC.play();
      }
      
      private function animatEnter(param1:Event) : void
      {
         if(this._bagMC.currentFrame == this._bagMC.totalFrames)
         {
            this._bagMC.stop();
            this._bagMC.removeEventListener(Event.ENTER_FRAME,this.animatEnter);
            this.playToBag();
            destroy();
         }
      }
      
      private function playToBag() : void
      {
         var _loc1_:int = this._itemArr.shift();
         if(_loc1_)
         {
            this.item = new ExtendBagItem(_loc1_);
            LayerManager.topLevel.addChild(this.item);
            DisplayUtil.align(this.item,null,AlignType.MIDDLE_CENTER,new Point(70,-90));
            TweenLite.to(this.item,1,{
               "x":541,
               "y":520,
               "ease":Quad.easeIn,
               "onComplete":this.onFinishToBag
            });
         }
         else
         {
            MainManager.openOperate();
            DisplayUtil.removeForParent(this._bagMC);
            DailyActivityAward.addAward(this.awardInfo,false);
         }
      }
      
      private function onFinishToBag() : void
      {
         DisplayUtil.removeForParent(this.item);
         this.item.destroy();
         this.playToBag();
      }
      
      private function getItemArr() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:SingleItemInfo = null;
         var _loc4_:SingleEquipInfo = null;
         this._itemArr = new Array();
         _loc2_ = 0;
         while(_loc2_ < this.awardInfo.itemCount)
         {
            _loc3_ = this.awardInfo.itemArr[_loc2_];
            _loc1_ = int(_loc3_.itemID);
            if(_loc1_ > 10)
            {
               this._itemArr.push(_loc1_);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.awardInfo.equiptCount)
         {
            _loc4_ = this.awardInfo.equiptArr[_loc2_];
            _loc1_ = int(_loc4_.itemID);
            this._itemArr.push(_loc1_);
            _loc2_++;
         }
      }
   }
}

