package com.gfp.app.feature
{
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   import com.gfp.core.player.MovieClipPlayerEx;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import org.taomee.utils.DisplayUtil;
   
   public class CheckForOpenFeather
   {
      
      private var _items:Vector.<InteractiveObject>;
      
      private var _modulePlayers:Vector.<MovieClipPlayerEx>;
      
      private var _overEffect:Dictionary;
      
      public function CheckForOpenFeather()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc2_:InteractiveObject = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClipPlayerEx = null;
         this._items = new Vector.<InteractiveObject>();
         this._modulePlayers = new Vector.<MovieClipPlayerEx>();
         this._overEffect = new Dictionary();
         var _loc1_:MapModel = MapManager.currentMap;
         this.checkContentOpenElement(_loc1_.contentLevel);
         this.checkContentOpenElement(_loc1_.upLevel);
         this.checkContentOpenElement(_loc1_.downLevel);
         for each(_loc2_ in this._items)
         {
            _loc3_ = _loc2_.parent.getChildByName(_loc2_.name + "_effect") as MovieClip;
            if(_loc3_)
            {
               this._overEffect[_loc2_.name] = _loc3_;
               _loc3_.visible = false;
            }
            _loc4_ = new MovieClipPlayerEx(_loc2_ as MovieClip);
            _loc2_.parent.addChild(_loc4_);
            _loc4_.x = _loc2_.x;
            _loc4_.y = _loc2_.y;
            _loc4_.name = _loc2_.name;
            _loc4_.currentFrame = 0;
            _loc4_.buttonMode = true;
            _loc4_.addEventListener(MouseEvent.ROLL_OVER,this.overHandle);
            _loc4_.addEventListener(MouseEvent.ROLL_OUT,this.outHandle);
            _loc4_.addEventListener(MouseEvent.CLICK,this.onChildClick);
            this._modulePlayers.push(_loc4_);
            DisplayUtil.removeForParent(_loc2_);
         }
      }
      
      protected function overHandle(param1:MouseEvent) : void
      {
         var _loc2_:MovieClipPlayerEx = param1.currentTarget as MovieClipPlayerEx;
         _loc2_.currentFrame = 1;
         if(this._overEffect[_loc2_.name])
         {
            this._overEffect[_loc2_.name].visible = true;
            this._overEffect[_loc2_.name].play();
            this._overEffect[_loc2_.name].parent.setChildIndex(this._overEffect[_loc2_.name],this._overEffect[_loc2_.name].parent.numChildren - 1);
         }
      }
      
      protected function outHandle(param1:MouseEvent) : void
      {
         var _loc2_:MovieClipPlayerEx = param1.currentTarget as MovieClipPlayerEx;
         _loc2_.currentFrame = 0;
         if(this._overEffect[_loc2_.name])
         {
            this._overEffect[_loc2_.name].visible = false;
            this._overEffect[_loc2_.name].stop();
         }
      }
      
      private function checkContentOpenElement(param1:DisplayObjectContainer) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:String = null;
         var _loc2_:int = param1.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is InteractiveObject && _loc4_.name.indexOf("openApp") == 0 && _loc4_.name.indexOf("_effect") == -1)
            {
               _loc5_ = _loc4_.name.substr(7);
               this._items.push(_loc4_ as InteractiveObject);
            }
            _loc3_++;
         }
      }
      
      private function onChildClick(param1:MouseEvent) : void
      {
         var _loc2_:InteractiveObject = param1.currentTarget as InteractiveObject;
         var _loc3_:String = _loc2_.name.substr(7);
         CityMap.instance.tranChangeMapByStr(_loc3_);
      }
      
      public function destory() : void
      {
         var _loc1_:MovieClipPlayerEx = null;
         this._items = null;
         while(this._modulePlayers.length)
         {
            _loc1_ = this._modulePlayers.pop();
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.overHandle);
            _loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.outHandle);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onChildClick);
            _loc1_.destory();
            DisplayUtil.removeForParent(_loc1_);
         }
         this._overEffect = null;
      }
   }
}

