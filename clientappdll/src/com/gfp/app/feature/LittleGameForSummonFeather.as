package com.gfp.app.feature
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ActivityExchangeXMLInfo;
   import com.gfp.core.events.ExchangeEvent;
   import com.gfp.core.manager.ActivityExchangeCommander;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.FilterUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class LittleGameForSummonFeather
   {
      
      private var _mainUI:Sprite;
      
      private var expTxt:TextField;
      
      private var bornTxt:TextField;
      
      private var btns:Vector.<SimpleButton> = new Vector.<SimpleButton>();
      
      private var headMc:MovieClip;
      
      private var tips:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var dBtn:SimpleButton;
      
      private var zhangMcs:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var clickMes:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var tiaoMc:MovieClip;
      
      private var config_ids:Array;
      
      private var EXP_SWAP_ID:int;
      
      private var BORN_SWAP_ID:int;
      
      private var AWARD_SWAP_ID:int;
      
      private var HAS_GOTTON_ID:int;
      
      private var DANG_FEN:int;
      
      private var SCORE_SWAP_ID:int;
      
      private var UserUI:Sprite;
      
      private var _x:int = 0;
      
      private var _y:int = 0;
      
      private var m_state:Array = [0,0,0,0,0];
      
      public function LittleGameForSummonFeather(param1:Sprite, param2:Array, param3:Sprite, param4:int = 0, param5:int = 0)
      {
         super();
         this._x = param4;
         this._y = param5;
         if(param1)
         {
            this._mainUI = param1;
            if(param3)
            {
               this.UserUI = param3;
               if(param2)
               {
                  this.config_ids = param2.concat();
                  if(this.config_ids.length != 11)
                  {
                     throw new Error("使用LittleGameForSummonFeather传入的配置Id数量有误。");
                  }
                  this.EXP_SWAP_ID = this.config_ids[0];
                  this.BORN_SWAP_ID = this.config_ids[1];
                  this.HAS_GOTTON_ID = this.config_ids[7];
                  this.DANG_FEN = this.config_ids[8];
                  this.SCORE_SWAP_ID = this.config_ids[9];
                  this.setUp();
                  return;
               }
               throw new Error("使用LittleGameForSummonFeather需要配置参数。");
            }
            throw new Error("使用LittleGameForSummonFeather需要传入使用者的UI");
         }
         throw new Error("使用LittleGameForSummonFeather需要一个绑定的UI");
      }
      
      private function setUp() : void
      {
         this.bandUI();
         this.addEvent();
         this.addToStage();
      }
      
      private function addToStage() : void
      {
         this.UserUI.addChild(this._mainUI);
         if(this._x > 0)
         {
            this._mainUI.x = this._x;
            this._mainUI.y = this._y;
         }
         if(this.SCORE_SWAP_ID > 0)
         {
            ActivityExchangeTimesManager.addEventListener(this.SCORE_SWAP_ID,this.infoBack);
            ActivityExchangeTimesManager.getTimes(this.SCORE_SWAP_ID);
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,this.onGetSwapActionTime);
            SocketConnection.send(CommandID.ACTIVITY_EXCHANGE_TIMES);
         }
      }
      
      private function onGetSwapActionTime(param1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,this.onGetSwapActionTime);
         ActivityExchangeTimesManager.readForLogin(param1.data as ByteArray);
         this.updateView();
      }
      
      private function bandUI() : void
      {
         this.expTxt = this._mainUI["expTxt"];
         this.bornTxt = this._mainUI["bornTxt"];
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.btns.push(this._mainUI["btn" + _loc1_]);
            this.zhangMcs.push(this._mainUI["zhangMc" + _loc1_]);
            this.tips.push(this._mainUI["tip" + _loc1_]);
            this.tips[_loc1_].visible = false;
            this.tips[_loc1_].mouseEnabled = false;
            this.tips[_loc1_].mouseChildren = false;
            this.clickMes.push(this._mainUI["clickMe" + _loc1_]);
            this.clickMes[_loc1_].visible = false;
            _loc1_++;
         }
         this.headMc = this._mainUI["headMc"];
         this.headMc.mouseEnabled = false;
         this.headMc.mouseChildren = false;
         this.tips[0].gotoAndStop(1);
         this.dBtn = this._mainUI["dBtn"];
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            if(ActivityExchangeXMLInfo.getActivityById(this.config_ids[2 + _loc1_]).rewardVect.length >= 2)
            {
               this.tips[_loc1_]["exp"].text = "X" + ActivityExchangeXMLInfo.getActivityById(this.config_ids[2 + _loc1_]).rewardVect[0].count + "万";
               this.tips[_loc1_]["born"].text = "X" + ActivityExchangeXMLInfo.getActivityById(this.config_ids[2 + _loc1_]).rewardVect[0].count + "万";
            }
            _loc1_++;
         }
         if(ActivityExchangeTimesManager.getTimes(this.HAS_GOTTON_ID) == 0)
         {
            this.tips[0].gotoAndStop(2);
         }
         else
         {
            this.tips[0].gotoAndStop(1);
         }
         this.tiaoMc = this._mainUI["tiaoMc"];
         this.tiaoMc.gotoAndStop(1);
      }
      
      private function addEvent() : void
      {
         this.dBtn.addEventListener(MouseEvent.CLICK,this.turnMod);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.btns[_loc1_].addEventListener(MouseEvent.CLICK,this.onAward);
            this.btns[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.tipsShow);
            this.btns[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.tipsHide);
            _loc1_++;
         }
      }
      
      private function tipsHide(param1:MouseEvent) : void
      {
         var _loc2_:int = this.btns.indexOf(param1.currentTarget);
         this.tips[_loc2_].visible = false;
      }
      
      private function tipsShow(param1:MouseEvent) : void
      {
         var _loc2_:int = this.btns.indexOf(param1.currentTarget);
         this.tips[_loc2_].visible = true;
      }
      
      protected function turnMod(param1:MouseEvent) : void
      {
         ModuleManager.turnAppModule(this.config_ids[10]);
         ModuleManager.destoryAllModule();
      }
      
      protected function onAward(param1:MouseEvent) : void
      {
         var _loc2_:int = this.btns.indexOf(param1.currentTarget);
         if(this.m_state[_loc2_] == 2)
         {
            TextAlert.show("需要" + this.DANG_FEN / 5 * (_loc2_ + 1) + "积分才能领取该当奖励哦，小侠士继续加油吧↖(^ω^)↗。");
            return;
         }
         ActivityExchangeCommander.addEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeCom);
         ActivityExchangeCommander.exchange(this.config_ids[_loc2_ + 2]);
      }
      
      private function onExchangeCom(param1:ExchangeEvent) : void
      {
         if(this.config_ids.indexOf(param1.info.id) != 0)
         {
            if(this.config_ids.indexOf(param1.info.id) >= 2 && this.config_ids.indexOf(param1.info.id) <= 6)
            {
               ActivityExchangeTimesManager.addEventListener(this.BORN_SWAP_ID,this.infoBack);
               ActivityExchangeTimesManager.addEventListener(this.EXP_SWAP_ID,this.infoBack);
               ActivityExchangeTimesManager.getActiviteTimeInfo(this.BORN_SWAP_ID);
               ActivityExchangeTimesManager.getActiviteTimeInfo(this.EXP_SWAP_ID);
            }
            if(param1.info.id == this.HAS_GOTTON_ID)
            {
               ActivityExchangeTimesManager.updataTimesByOnce(this.HAS_GOTTON_ID);
            }
            ActivityExchangeCommander.removeEventListener(ExchangeEvent.EXCHANGE_COMPLETE,this.onExchangeCom);
            this.updateView();
         }
      }
      
      private function infoBack(param1:Event) : void
      {
         this.updateView();
      }
      
      public function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         if(this.SCORE_SWAP_ID > 0)
         {
            _loc1_ = int(ActivityExchangeTimesManager.getTimes(this.SCORE_SWAP_ID));
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               _loc2_ += ActivityExchangeTimesManager.getTimes(7642 + _loc4_);
               _loc4_++;
            }
            _loc1_ = _loc2_ * 80;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            if(_loc1_ >= this.DANG_FEN / 5 * (_loc3_ + 1))
            {
               if(ActivityExchangeTimesManager.getTimes(this.config_ids[2 + _loc3_]) == 0)
               {
                  this.viewControl(_loc3_,0);
               }
               else
               {
                  this.viewControl(_loc3_,1);
               }
            }
            else
            {
               this.viewControl(_loc3_,2);
            }
            _loc3_++;
         }
         if(_loc1_ >= this.DANG_FEN / 5 && ActivityExchangeTimesManager.getTimes(this.config_ids[2]) == 0 && ActivityExchangeTimesManager.getTimes(this.config_ids[7]) == 0)
         {
            this.headMc.visible = true;
         }
         else
         {
            this.headMc.visible = false;
         }
         this.tiaoMc.gotoAndStop(int(Math.min(_loc1_,this.DANG_FEN) / this.DANG_FEN * this.tiaoMc.totalFrames));
         this.expTxt.text = ActivityExchangeTimesManager.getTimes(this.EXP_SWAP_ID).toString();
         this.bornTxt.text = ActivityExchangeTimesManager.getTimes(this.BORN_SWAP_ID).toString();
      }
      
      private function viewControl(param1:int, param2:int) : void
      {
         this.m_state[param1] = param2;
         switch(param2)
         {
            case 0:
               this.btns[param1].filters = [];
               this.btns[param1].addEventListener(MouseEvent.CLICK,this.onAward);
               this.zhangMcs[param1].visible = false;
               this.clickMes[param1].visible = true;
               break;
            case 1:
               this.btns[param1].filters = [];
               this.btns[param1].removeEventListener(MouseEvent.CLICK,this.onAward);
               this.zhangMcs[param1].visible = true;
               this.clickMes[param1].visible = false;
               break;
            case 2:
               this.btns[param1].filters = FilterUtil.GRAY_FILTER;
               this.zhangMcs[param1].visible = false;
               this.clickMes[param1].visible = false;
         }
      }
      
      private function removeEvent() : void
      {
         this.dBtn.removeEventListener(MouseEvent.CLICK,this.turnMod);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.btns[_loc1_].removeEventListener(MouseEvent.CLICK,this.onAward);
            this.btns[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.tipsShow);
            this.btns[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.tipsHide);
            _loc1_++;
         }
         ActivityExchangeTimesManager.removeEventListener(this.EXP_SWAP_ID,this.infoBack);
         ActivityExchangeTimesManager.removeEventListener(this.SCORE_SWAP_ID,this.infoBack);
         ActivityExchangeTimesManager.removeEventListener(this.BORN_SWAP_ID,this.infoBack);
         SocketConnection.removeCmdListener(CommandID.ACTIVITY_EXCHANGE_TIMES,this.onGetSwapActionTime);
      }
      
      public function desdroy() : void
      {
         this.removeEvent();
         this._mainUI = null;
      }
   }
}

