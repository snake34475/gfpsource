package com.gfp.app.mapProcess
{
   import com.gfp.core.action.keyboard.KeySkillProcess;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.CDEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.CDInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1123901 extends BaseMapProcess
   {
      
      private var _canReleaseSkill:Boolean;
      
      private var _totalExp:int;
      
      private var _costedExp:int;
      
      private var _totalGrowth:int;
      
      private var _costedGrowth:int;
      
      private var _expPanel:Sprite;
      
      private var _skillAlert:Sprite;
      
      public function MapProcess_1123901()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:CDInfo = new CDInfo();
         _loc1_.id = 4021056;
         _loc1_.runTime = 5000;
         _loc1_.cdTime = 15000;
         CDManager.skillCD.add(_loc1_);
         CDManager.skillCD.addEventListener(CDEvent.START,this.onCdStartHandler);
         CDManager.skillCD.addEventListener(CDEvent.CDED,this.onCdEndHandler);
         LayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         StageResizeController.instance.register(this.layout);
         UserManager.addEventListener(UserEvent.DIE,this.onUserDieHandle);
         this._expPanel = _mapModel.libManager.getSprite("ExpPanel");
         LayerManager.topLevel.addChild(this._expPanel);
         this._skillAlert = _mapModel.libManager.getSprite("ShenTongSkillAlert");
         LayerManager.topLevel.addChild(this._skillAlert);
         this._skillAlert.alpha = 0;
         this.requestExpAndGrowth();
         this.updatePoint();
         this.layout();
      }
      
      override public function destroy() : void
      {
         CDManager.skillCD.removeEventListener(CDEvent.START,this.onCdStartHandler);
         CDManager.skillCD.removeEventListener(CDEvent.CDED,this.onCdEndHandler);
         LayerManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         StageResizeController.instance.unregister(this.layout);
         UserManager.removeEventListener(UserEvent.DIE,this.onUserDieHandle);
         ActivityExchangeTimesManager.removeEventListener(8881,this.responseExpAndGrowth);
         ActivityExchangeTimesManager.removeEventListener(8882,this.responseExpAndGrowth);
         ActivityExchangeTimesManager.removeEventListener(8883,this.responseExpAndGrowth);
         ActivityExchangeTimesManager.removeEventListener(8884,this.responseExpAndGrowth);
         DisplayUtil.removeForParent(this._expPanel);
         DisplayUtil.removeForParent(this._skillAlert);
      }
      
      private function requestExpAndGrowth() : void
      {
         ActivityExchangeTimesManager.getActiviteTimeInfo(8881);
         ActivityExchangeTimesManager.getActiviteTimeInfo(8882);
         ActivityExchangeTimesManager.getActiviteTimeInfo(8883);
         ActivityExchangeTimesManager.getActiviteTimeInfo(8884);
         ActivityExchangeTimesManager.addEventListener(8881,this.responseExpAndGrowth);
         ActivityExchangeTimesManager.addEventListener(8882,this.responseExpAndGrowth);
         ActivityExchangeTimesManager.addEventListener(8883,this.responseExpAndGrowth);
         ActivityExchangeTimesManager.addEventListener(8884,this.responseExpAndGrowth);
      }
      
      private function responseExpAndGrowth(param1:Event) : void
      {
         this._totalExp = ActivityExchangeTimesManager.getTimes(8881);
         this._totalGrowth = ActivityExchangeTimesManager.getTimes(8882);
         this._costedExp = ActivityExchangeTimesManager.getTimes(8883);
         this._costedGrowth = ActivityExchangeTimesManager.getTimes(8884);
         this.updatePoint();
      }
      
      private function onCdStartHandler(param1:CDEvent) : void
      {
         if(param1.targetID == 4021056)
         {
            this._canReleaseSkill = false;
            this._skillAlert.alpha = 1;
            TweenLite.to(this._skillAlert,0.5,{"alpha":0});
         }
      }
      
      private function onCdEndHandler(param1:CDEvent) : void
      {
         if(param1.targetID == 4021056)
         {
            this._canReleaseSkill = true;
            this._skillAlert.alpha = 0;
            TweenLite.to(this._skillAlert,0.5,{"alpha":1});
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:KeyInfo = null;
         if(param1.keyCode == Keyboard.B)
         {
            _loc2_ = new KeyInfo();
            _loc2_.dataID = 4021056;
            _loc2_.lv = 1;
            KeySkillProcess.exec(MainManager.actorModel,_loc2_);
         }
      }
      
      private function onUserDieHandle(param1:UserEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:UserModel = param1.data as UserModel;
         if(_loc2_.info.roleType == 14665)
         {
            _loc3_ = this._totalExp;
            this._totalExp += 2500;
            if(MainManager.actorInfo.isVip)
            {
               this._totalExp += 2500;
            }
            if(this._totalExp > 5000000)
            {
               this._totalExp = 5000000;
            }
            _loc4_ = this._totalExp - _loc3_;
            if(_loc4_ > 0)
            {
               this.addExpOrGrowth(_loc2_,true);
            }
         }
         else if(_loc2_.info.roleType == 14666)
         {
            _loc5_ = this._totalGrowth;
            this._totalGrowth += 2;
            if(MainManager.actorInfo.isVip)
            {
               this._totalGrowth += 2;
            }
            if(this._totalGrowth > 100)
            {
               this._totalGrowth = 100;
            }
            _loc6_ = this._totalGrowth - _loc5_;
            if(_loc6_ > 0)
            {
               this.addExpOrGrowth(_loc2_,false);
            }
         }
         this.updatePoint();
      }
      
      private function addExpOrGrowth(param1:UserModel, param2:Boolean) : void
      {
         var item:MovieClip = null;
         var user:UserModel = param1;
         var exp:Boolean = param2;
         item = _mapModel.libManager.getMovieClip("AddNumberUI");
         item.gotoAndStop(MainManager.actorInfo.isVip ? (exp ? 2 : 4) : (exp ? 1 : 3));
         _mapModel.upLevel.addChild(item);
         item.x = user.x;
         item.y = user.y - user.height;
         TweenLite.to(item,3,{
            "alpha":0,
            "y":"-100",
            "onComplete":function():void
            {
               DisplayUtil.removeForParent(item);
            }
         });
      }
      
      private function updatePoint() : void
      {
         this._expPanel["expLabel"].text = Math.max(0,this._totalExp - this._costedExp);
         this._expPanel["growthLabel"].text = Math.max(0,this._totalGrowth - this._costedGrowth);
         this._expPanel["expBar"].gotoAndStop(int(this._totalExp / 5000000 * 100));
         this._expPanel["growthBar"].gotoAndStop(int(this._totalGrowth));
      }
      
      private function layout() : void
      {
         this._skillAlert.x = LayerManager.stageWidth - this._skillAlert.width >> 1;
         this._skillAlert.y = 200;
         this._expPanel.x = 0;
         this._expPanel.y = 150;
      }
   }
}

