package com.gfp.app.toolBar.taskTrack
{
   import com.gfp.app.info.ActivityTansInfo;
   import com.gfp.core.map.CityMap;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class ActivityTrackItem extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _nameTxt:TextField;
      
      private var _transBtn:SimpleButton;
      
      private var _pos:String;
      
      public function ActivityTrackItem(param1:ActivityTansInfo)
      {
         super();
         this._mainUI = new UI_ActivityTrackItem();
         addChild(this._mainUI);
         this._pos = param1.pos;
         var _loc2_:String = this._pos.split("_")[0];
         var _loc3_:String = param1.title;
         if(!_loc3_)
         {
            switch(_loc2_)
            {
               case "NPC":
                  _loc3_ = "【NPC】";
                  break;
               case "TOLLGATE":
                  _loc3_ = "【关卡】";
                  break;
               default:
                  _loc3_ = "【场景】";
            }
         }
         this._nameTxt = this._mainUI["nameTxt"];
         this._nameTxt.htmlText = _loc3_ + "<u><a href=\'event:TRANS\'>" + param1.name + "</a></u>";
         this._nameTxt.height = this._nameTxt.textHeight + 4;
         this._nameTxt.mouseWheelEnabled = false;
         this._nameTxt.addEventListener(TextEvent.LINK,this.onClick);
      }
      
      private function onClick(param1:Event) : void
      {
         CityMap.instance.tranChangeMapByStr(this._pos);
      }
      
      public function destroy() : void
      {
         this._nameTxt.removeEventListener(TextEvent.LINK,this.onClick);
         DisplayUtil.removeForParent(this._mainUI);
         this._mainUI = null;
      }
   }
}

