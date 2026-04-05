package com.gfp.app.quickWord
{
   import com.gfp.core.manager.FocusManager;
   import com.gfp.core.manager.LayerManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class QuickWord
   {
      
      private static var _instance:QuickWord;
      
      private var cls:Class = QuickWord_cls;
      
      private var xml:XML;
      
      private var qw:QuickWordList;
      
      private var timer:Timer;
      
      public function QuickWord()
      {
         super();
         this.xml = new XML(new this.cls());
         this.timer = new Timer(500,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.addStageListener);
      }
      
      public static function get instance() : QuickWord
      {
         if(_instance == null)
         {
            _instance = new QuickWord();
         }
         return _instance;
      }
      
      public function show(param1:DisplayObject) : void
      {
         if(this.qw)
         {
            this.hide();
            return;
         }
         var _loc2_:Point = param1.localToGlobal(new Point());
         this.qw = new QuickWordList(this.xml);
         this.qw.x = _loc2_.x - 50;
         this.qw.y = _loc2_.y - this.qw.height - 10;
         this.qw.addEventListener(Event.CLOSE,this.closeQw);
         LayerManager.topLevel.addChild(this.qw);
         this.timer.stop();
         this.timer.start();
         this.qw.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this.qw);
         this.closeQw(null);
      }
      
      private function onRemoveStage(param1:Event) : void
      {
         param1.target.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
         FocusManager.setDefaultFocus();
      }
      
      private function addStageListener(param1:TimerEvent) : void
      {
         LayerManager.stage.addEventListener(MouseEvent.CLICK,this.stageClick);
      }
      
      private function stageClick(param1:MouseEvent) : void
      {
         if(!this.qw.hitTestPoint(LayerManager.stage.mouseX,LayerManager.stage.mouseY,true))
         {
            this.qw.destroy();
         }
      }
      
      private function closeQw(param1:Event) : void
      {
         LayerManager.stage.removeEventListener(MouseEvent.CLICK,this.stageClick);
         this.qw.removeEventListener(Event.CLOSE,this.closeQw);
         this.qw = null;
         FocusManager.setDefaultFocus();
         this.timer.stop();
      }
   }
}

