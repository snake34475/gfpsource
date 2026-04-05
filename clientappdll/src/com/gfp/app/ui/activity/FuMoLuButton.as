package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.core.manager.ShaoDangMananger;
   import com.gfp.core.utils.TimeUtil;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import org.taomee.manager.ToolTipManager;
   
   public class FuMoLuButton extends BaseActivityMultiSprite
   {
      
      private var _txtTime:TextField;
      
      public function FuMoLuButton(param1:ActivityMultiNodeInfo)
      {
         super(param1);
      }
      
      override public function addEvent() : void
      {
         super.addEvent();
         ShaoDangMananger.instance.addEventListener(TimerEvent.TIMER,this.onShaoDangTimer);
         ShaoDangMananger.instance.addEventListener(Event.CHANGE,this.onShaoDangTimer);
         this.onShaoDangTimer(null);
         ToolTipManager.add(_sprite,"伏魔录");
      }
      
      override public function removeEvent() : void
      {
         super.removeEvent();
         ShaoDangMananger.instance.removeEventListener(TimerEvent.TIMER,this.onShaoDangTimer);
         ShaoDangMananger.instance.removeEventListener(Event.CHANGE,this.onShaoDangTimer);
         ToolTipManager.remove(_sprite);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._txtTime = _sprite["txtTime"];
      }
      
      protected function onShaoDangTimer(param1:Event) : void
      {
         if(_sprite == null)
         {
            return;
         }
         if(ShaoDangMananger.isShaoDang)
         {
            this._txtTime.visible = true;
            this._txtTime.text = TimeUtil.getTimeStr(ShaoDangMananger.shaoDangEndTime - TimeUtil.getServerSecond());
         }
         else
         {
            this._txtTime.visible = false;
         }
      }
   }
}

