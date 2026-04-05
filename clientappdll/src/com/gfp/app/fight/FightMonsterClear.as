package com.gfp.app.fight
{
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.map.MapManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class FightMonsterClear extends Sprite
   {
      
      private static var _instance:FightMonsterClear;
      
      public static var FIGHT_MONSTER_CLEAR:String = "Fight_Monster_Clear";
      
      private var _mainUI:MovieClip;
      
      private var _enabledShow:Boolean = true;
      
      public function FightMonsterClear()
      {
         super();
         var _loc1_:int = int(uint((MapManager.mapInfo.id - 1000000) / 100));
         if(_loc1_ != 801 && _loc1_ != 806)
         {
            this._mainUI = UIManager.getSprite("Monster_clear") as MovieClip;
         }
         else
         {
            this._mainUI = UIManager.getSprite("SptMonster_clear") as MovieClip;
         }
         addChild(this._mainUI);
      }
      
      public static function get instance() : FightMonsterClear
      {
         if(_instance == null)
         {
            _instance = new FightMonsterClear();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function set enabledShow(param1:Boolean) : void
      {
         this._enabledShow = param1;
      }
      
      public function show() : void
      {
         instance.dispatchEvent(new Event(FIGHT_MONSTER_CLEAR));
         if(!this._enabledShow)
         {
            return;
         }
         LayerManager.topLevel.addChild(this);
         this._mainUI.gotoAndPlay(1);
         var _loc1_:uint = uint((MapManager.mapInfo.id - 1000000) / 100);
         var _loc2_:Number = LayerManager.stageWidth / 960;
         var _loc3_:Number = LayerManager.stageHeight / 560;
         if(_loc1_ != 801 && _loc1_ != 806)
         {
            DisplayUtil.align(this,null,AlignType.MIDDLE_LEFT,new Point(5 * _loc2_,-200 * _loc3_));
         }
         else
         {
            DisplayUtil.align(this,null,AlignType.MIDDLE_LEFT,new Point(505 * _loc2_,-200 * _loc3_));
         }
         this._mainUI.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._mainUI.currentFrame == this._mainUI.totalFrames)
         {
            this.hide();
         }
      }
      
      public function destroy() : void
      {
         this.hide();
         this._mainUI = null;
      }
      
      public function hide() : void
      {
         if(this._mainUI)
         {
            this._mainUI.stop();
            this._mainUI.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         DisplayUtil.removeForParent(this,false);
      }
   }
}

