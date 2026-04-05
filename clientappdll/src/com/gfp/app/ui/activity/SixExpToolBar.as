package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.toolBar.DynamicActivityEntry;
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class SixExpToolBar extends BaseActivitySprite
   {
      
      private var startDate:Date = new Date(2014,4,1,14,0,0,0);
      
      private var endDate:Date = new Date(2014,4,3,15,0,0,0);
      
      private var lips:Vector.<Date>;
      
      private var timer:Timer;
      
      private var exps:Array;
      
      private var hours:int = 14;
      
      private var buffs:Array;
      
      private var currentBuff:int;
      
      private var time:uint;
      
      public function SixExpToolBar(param1:ActivityNodeInfo)
      {
         super(param1);
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.lips = new Vector.<Date>();
         (_sprite as MovieClip).gotoAndStop(1);
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         var _loc5_:MovieClip = null;
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < this.lips.length)
         {
            if(_loc2_ < this.lips[_loc4_])
            {
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         if(_loc3_ == false)
         {
            DynamicActivityEntry.instance.updateAlign();
         }
         else
         {
            _sprite["txtTime"].text = TimeUtil.getTimeStr((this.lips[_loc4_].time - _loc2_.time) / 1000);
            (_sprite["mc"] as MovieClip).gotoAndStop("e_" + this.exps[_loc4_]);
            if(this.currentBuff != this.buffs[_loc4_] && this.currentBuff != 0)
            {
               HeadSelfPanel.instance.removeBaseBuff(this.currentBuff);
            }
            this.currentBuff = this.buffs[_loc4_];
            HeadSelfPanel.instance.addBaseBuff(this.buffs[_loc4_]);
            _loc5_ = _sprite as MovieClip;
            if(this.exps[_loc4_] == 6)
            {
               if(_loc5_.currentFrame == 1)
               {
                  _loc5_.gotoAndStop(2);
               }
            }
            else
            {
               _loc5_.gotoAndStop(1);
            }
         }
      }
      
      private function generateLip() : void
      {
         var _loc1_:Date = TimeUtil.getSeverDateObject();
         this.lips[0] = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date,this.hours,5,0,0);
         this.lips[1] = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date,this.hours,20,0,0);
         this.lips[2] = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date,this.hours,40,0,0);
         this.lips[3] = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date,this.hours,55,0,0);
         this.lips[4] = new Date(_loc1_.fullYear,_loc1_.month,_loc1_.date,this.hours + 1,0,0,0);
         this.exps = [4,5,6,5,4];
         this.buffs = [10,11,12,11,10];
      }
      
      override protected function doAction() : void
      {
      }
      
      override public function executeShow() : Boolean
      {
         var _loc3_:Date = null;
         var _loc4_:Date = null;
         var _loc1_:Boolean = true;
         var _loc2_:Date = TimeUtil.getSeverDateObject();
         if(_loc2_ >= this.endDate)
         {
            _loc1_ = false;
         }
         else if(_loc2_ < this.startDate)
         {
            _loc1_ = false;
            clearTimeout(this.time);
            this.time = setTimeout(this.updateAlign,this.startDate.time - _loc2_.time);
         }
         else
         {
            _loc3_ = new Date(_loc2_.fullYear,_loc2_.month,_loc2_.date,this.startDate.hours,this.startDate.minutes,this.startDate.seconds,this.startDate.milliseconds);
            _loc4_ = new Date(_loc2_.fullYear,_loc2_.month,_loc2_.date,this.endDate.hours,this.endDate.minutes,this.endDate.seconds,this.endDate.milliseconds);
            if(_loc2_ > _loc4_)
            {
               _loc1_ = false;
            }
            else if(_loc2_ < _loc3_)
            {
               _loc1_ = false;
               clearTimeout(this.time);
               this.time = setTimeout(this.updateAlign,_loc3_.time - _loc2_.time);
            }
         }
         if(!_loc1_)
         {
            if(this.timer.running)
            {
               this.timer.stop();
            }
            if(this.currentBuff != 0)
            {
               HeadSelfPanel.instance.removeBaseBuff(this.currentBuff);
            }
            this.currentBuff = 0;
            return false;
         }
         if(!this.timer.running)
         {
            if(this.lips.length == 0)
            {
               this.generateLip();
            }
            this.timer.start();
            this.onTimer(null);
         }
         return true;
      }
      
      private function updateAlign() : void
      {
         DynamicActivityEntry.instance.updateAlign();
      }
   }
}

