package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1067501 extends BaseMapProcess
   {
      
      private var _tmpHint:MovieClip;
      
      private var _foodArr:Array;
      
      private var _zlNeedArr:Array;
      
      private var _flNeedArr:Array;
      
      private var _tlNeedArr:Array;
      
      private var _zlCount:int;
      
      private var _flCount:int;
      
      private var _tlCount:int;
      
      private var _tczCount:int;
      
      private var _dddwCount:int;
      
      private var _currFoodId:uint;
      
      private var _lastExp:int;
      
      private var _dddwExpCount:Number;
      
      private var _tczExpCount:Number;
      
      private var _startMc:MovieClip;
      
      private var _endMC:MovieClip;
      
      private var _lastFoodId:int;
      
      private var _tmpBegin:MovieClip;
      
      private var _tmpEnd:MovieClip;
      
      private var _movieArr:Array;
      
      private var _checkMc:MovieClip;
      
      private var _checkMcIng:Boolean;
      
      public function MapProcess_1067501()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initHint();
         this.addEvent();
      }
      
      private function initHint() : void
      {
         this._movieArr = [];
         this._lastFoodId = this._dddwExpCount = this._tczExpCount = this._lastExp = 0;
         this._zlCount = this._flCount = this._tlCount = this._tczCount = this._dddwCount = 0;
         this._foodArr = [0,"宫保鸡丁","龙井虾仁","三套鸭","佛跳墙","荷包里脊","东坡肘子","松鼠鳜鱼","清炖蟹粉狮子头","水晶肴蹄","灯影牛肉","砂锅鱼头","大煮干丝","腌笃鲜"];
         this._zlNeedArr = [0,15,10,20,18,10,18,18,21,25,20,18,8,18];
         this._flNeedArr = [0,10,18,3,3,10,2,3,6,2,2,5,18,18];
         this._tlNeedArr = [0,5,2,7,9,10,10,9,3,3,8,7,4,4];
         this._tmpHint = new MovieClip();
         this._tmpHint.x = 5;
         this._tmpHint.y = 80;
         this._tmpHint["ifShowAllBtn"].gotoAndStop(1);
         (this._tmpHint["ifShowAllBtn"] as MovieClip).buttonMode = true;
         this._tmpHint["board"].visible = false;
         this._tmpBegin = this._tmpHint["tmpBegin"];
         this._tmpEnd = this._tmpHint["tmpEnd"];
         this._tmpBegin.gotoAndStop(1);
         this._tmpEnd.gotoAndStop(1);
         this._tmpBegin.x = this._tmpEnd.x = 480;
         this._tmpBegin.y = this._tmpEnd.y = 160;
         (this._tmpBegin["mc"] as MovieClip).gotoAndStop(1);
         (this._tmpEnd["mc"] as MovieClip).gotoAndStop(1);
         this._tmpBegin.visible = this._tmpEnd.visible = false;
         LayerManager.toolUiLevel.addChild(this._tmpHint);
      }
      
      private function removeHint() : void
      {
         this._tmpBegin.stop();
         this._tmpEnd.stop();
         DisplayUtil.removeForParent(this._tmpHint,true);
         DisplayUtil.removeForParent(this._tmpBegin,true);
         DisplayUtil.removeForParent(this._tmpEnd,true);
         this._tmpBegin = null;
         this._tmpEnd = null;
         this._tmpHint = null;
         if(this._checkMc)
         {
            this._checkMc.gotoAndStop(1);
            this._checkMc.removeEventListener(Event.ENTER_FRAME,this.onCheckMc);
            this._checkMc = null;
         }
      }
      
      private function onWaterPipeChange(param1:SocketEvent) : void
      {
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == 675 && _loc4_ == 1067501)
         {
            if(_loc5_ == 11633)
            {
               _loc6_ = _loc2_.readUnsignedInt();
               this.updateTczExpTxt(_loc6_);
            }
            else if(_loc5_ == 11634)
            {
               _loc6_ = _loc2_.readUnsignedInt();
               this.updateDddwExpTxt(_loc6_);
            }
            else
            {
               this._currFoodId = _loc5_;
               this.runHint();
            }
         }
      }
      
      private function runHint() : void
      {
         this._tmpHint["board"].visible = true;
         this._tmpHint["ifShowAllBtn"].gotoAndStop(this._tmpHint["board"].visible ? 2 : 1);
         var _loc1_:String = this._foodArr[this._currFoodId];
         this._tmpHint["board"]["foodNameTxt"]["text"] = _loc1_;
         this._zlCount = this._flCount = this._tlCount = 0;
         this.updateZlNum();
         this.updateFlNum();
         this.updateTlNum();
         this.showStartMc();
      }
      
      private function showStartMc() : void
      {
         LayerManager.toolUiLevel.addChild(this._tmpBegin);
         LayerManager.toolUiLevel.addChild(this._tmpEnd);
         if(this._lastFoodId > 0)
         {
            this._movieArr.push("end_" + this._lastFoodId);
         }
         this._movieArr.push("begin_" + this._currFoodId);
         this.checkMovie();
         this._lastFoodId = this._currFoodId;
      }
      
      private function checkMovie() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(this._checkMcIng)
         {
            return;
         }
         if(this._movieArr.length > 0)
         {
            _loc1_ = (this._movieArr.shift() as String).split("_");
            _loc2_ = int(_loc1_[1]);
            if(_loc1_[0] == "begin")
            {
               (this._tmpBegin["mc"] as MovieClip).gotoAndStop(_loc2_);
               this._checkMc = this._tmpBegin;
            }
            else if(_loc1_[0] == "end")
            {
               (this._tmpEnd["mc"] as MovieClip).gotoAndStop(_loc2_);
               this._checkMc = this._tmpEnd;
            }
            this._checkMcIng = true;
            this._checkMc.gotoAndPlay(1);
            this._checkMc.visible = true;
            this._checkMc.addEventListener(Event.ENTER_FRAME,this.onCheckMc);
         }
      }
      
      protected function onCheckMc(param1:Event) : void
      {
         if(this._checkMc.currentFrame == this._checkMc.totalFrames)
         {
            this._checkMc.gotoAndStop(1);
            this._checkMc.visible = false;
            this._checkMc.removeEventListener(Event.ENTER_FRAME,this.onCheckMc);
            this._checkMc = null;
            this._checkMcIng = false;
            this.checkMovie();
         }
      }
      
      private function updateTlNum(param1:Number = 0) : void
      {
         var _loc2_:int = int(this._tlNeedArr[this._currFoodId]);
         this._tlCount += param1;
         if(this._tlCount > _loc2_)
         {
            this._tlCount = _loc2_;
         }
         else if(this._tlCount < 0)
         {
            this._tlCount = 0;
         }
         this._tmpHint["board"]["tlPerTxt"]["text"] = this._tlCount + "/" + _loc2_;
         (this._tmpHint["board"]["tlBar"]["bar"] as MovieClip).scaleX = Number(Number(this._tlCount / _loc2_).toFixed(2));
      }
      
      private function updateFlNum(param1:Number = 0) : void
      {
         var _loc2_:int = int(this._flNeedArr[this._currFoodId]);
         this._flCount += param1;
         if(this._flCount > _loc2_)
         {
            this._flCount = _loc2_;
         }
         else if(this._flCount < 0)
         {
            this._flCount = 0;
         }
         this._tmpHint["board"]["flPerTxt"]["text"] = this._flCount + "/" + _loc2_;
         (this._tmpHint["board"]["flBar"]["bar"] as MovieClip).scaleX = Number(Number(this._flCount / _loc2_).toFixed(2));
      }
      
      private function updateZlNum(param1:Number = 0) : void
      {
         var _loc2_:int = int(this._zlNeedArr[this._currFoodId]);
         this._zlCount += param1;
         if(this._zlCount > _loc2_)
         {
            this._zlCount = _loc2_;
         }
         else if(this._zlCount < 0)
         {
            this._zlCount = 0;
         }
         this._tmpHint["board"]["zlPerTxt"]["text"] = this._zlCount + "/" + _loc2_;
         (this._tmpHint["board"]["zlBar"]["bar"] as MovieClip).scaleX = Number(Number(this._zlCount / _loc2_).toFixed(2));
      }
      
      private function updateTczNum(param1:Number = 0) : void
      {
         this._tczCount += param1;
         this._tmpHint["board"]["tczNumTxt"]["text"] = this._tczCount.toString();
      }
      
      private function updateDddwNum(param1:Number = 0) : void
      {
         this._dddwCount += param1;
         this._tmpHint["board"]["dddwNumTxt"]["text"] = this._dddwCount.toString();
      }
      
      private function addEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onWaterPipeChange);
         this._tmpHint["ifShowAllBtn"].addEventListener(MouseEvent.CLICK,this.onHintClickHandler);
         UserManager.addEventListener(UserEvent.DIE,this.onMonsterDieHandler);
         UserManager.addEventListener(UserEvent.BORN,this.onMonsterBornHandler);
         UserManager.addEventListener(UserEvent.EXPLODED,this.onTczLeaveHandler);
      }
      
      private function updateDddwExpTxt(param1:Number = 0) : void
      {
         this._dddwExpCount += param1;
         this._tmpHint["board"]["dddwAwardTxt"]["text"] = this._dddwExpCount.toString();
      }
      
      private function updateTczExpTxt(param1:Number = 0) : void
      {
         this._tczExpCount += param1;
         this._tmpHint["board"]["tczAwardTxt"]["text"] = this._tczExpCount.toString();
      }
      
      private function onTczLeaveHandler(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data;
         var _loc3_:int = int(_loc2_.info.roleType);
         if(_loc3_ == 11633)
         {
            TextAlert.show("偷吃贼偷走了你的食材，下次可别让他跑掉。");
            this.updateZlNum(-1);
            this.updateFlNum(-1);
            this.updateTlNum(-1);
         }
         if(_loc3_ >= 11627 && _loc3_ <= 11634)
         {
            _loc2_.destroy();
         }
      }
      
      private function onMonsterBornHandler(param1:UserEvent) : void
      {
         var model:UserModel = null;
         var arr:Array = null;
         var e:UserEvent = param1;
         model = e.data;
         var id:int = int(model.info.roleType);
         if(id == 11634)
         {
            arr = ["大王派我来巡山，我就喜欢捣糨糊！"];
            model.showBox(arr[0],0,function():void
            {
               if(!model.isDestroy)
               {
                  model.startAutoDialog(7,["有我在，你休想做成菜，哈哈，你咬我啊！"]);
               }
            });
         }
         else if(id == 11633)
         {
            if(!model.isDestroy)
            {
               model.startAutoDialog(7,["大王派我来偷菜，边吃边走真是爽！","我一走，你的食材就要减少啦！"]);
            }
         }
      }
      
      private function onMonsterDieHandler(param1:UserEvent) : void
      {
         var _loc4_:Array = null;
         var _loc2_:UserModel = param1.data;
         var _loc3_:int = int(_loc2_.info.roleType);
         if(_loc3_ == 11627 || _loc3_ == 11628)
         {
            this.updateZlNum(1);
         }
         else if(_loc3_ == 11629 || _loc3_ == 11630)
         {
            this.updateTlNum(1);
         }
         else if(_loc3_ == 11631 || _loc3_ == 11632)
         {
            this.updateFlNum(1);
         }
         else if(_loc3_ == 11633)
         {
            this.updateTczNum(1);
         }
         else if(_loc3_ == 11634)
         {
            this.updateDddwNum(1);
         }
         if(_loc3_ == 11627 || _loc3_ == 11629 || _loc3_ == 11631)
         {
            _loc4_ = ["你这黑白不分的家伙，我是来帮你抢材料的啊！你会有报应的！"];
         }
         else if(_loc3_ == 11628 || _loc3_ == 11630 || _loc3_ == 11632)
         {
            _loc4_ = ["被抓住了，看来我还是太年轻啊。"];
         }
         else if(_loc3_ == 11633)
         {
            _loc4_ = ["被发现了，下次得跟大王说说换身好行头！"];
         }
         _loc2_.stopAutoDialog();
         if(_loc4_)
         {
            _loc2_.showBox(_loc4_[0]);
         }
      }
      
      private function onHintClickHandler(param1:MouseEvent) : void
      {
         this._tmpHint["board"].visible = !this._tmpHint["board"].visible;
         this._tmpHint["ifShowAllBtn"].gotoAndStop(this._tmpHint["board"].visible ? 2 : 1);
         param1.stopImmediatePropagation();
      }
      
      private function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onWaterPipeChange);
         this._tmpHint["ifShowAllBtn"].removeEventListener(MouseEvent.CLICK,this.onHintClickHandler);
         UserManager.removeEventListener(UserEvent.DIE,this.onMonsterDieHandler);
         UserManager.removeEventListener(UserEvent.BORN,this.onMonsterBornHandler);
         UserManager.removeEventListener(UserEvent.EXPLODED,this.onTczLeaveHandler);
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
         this.removeHint();
         super.destroy();
      }
   }
}

