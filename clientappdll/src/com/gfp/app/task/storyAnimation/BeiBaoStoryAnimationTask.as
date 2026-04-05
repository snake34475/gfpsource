package com.gfp.app.task.storyAnimation
{
   import com.gfp.app.toolBar.CityToolBar;
   import com.gfp.core.map.CityMap;
   import flash.display.SimpleButton;
   import flash.geom.Point;
   
   public class BeiBaoStoryAnimationTask extends PureStoryAnimationTask
   {
      
      public static const NONE:int = 0;
      
      public static const BAG:int = 1;
      
      public static const SKILL:int = 2;
      
      public static const SUMMON:int = 3;
      
      public static const STRENGTH:int = 4;
      
      public var offsetPoint:Point = new Point(675,592);
      
      public function BeiBaoStoryAnimationTask()
      {
         super();
      }
      
      override protected function layout() : void
      {
         this.setBtnPostion();
      }
      
      public function setBtnPostion() : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc1_:SimpleButton = this.getBtnByType();
         if(_loc1_)
         {
            _loc2_ = _loc1_.localToGlobal(new Point(0,0));
            _loc3_ = _loc2_.subtract(this.offsetPoint);
            _storyMc.x = _loc3_.x + _offsetX;
            _storyMc.y = _loc3_.y + _offsetY;
         }
      }
      
      public function getBtnByType() : SimpleButton
      {
         switch(customData)
         {
            case BAG:
               return CityToolBar.instance.bagBtn;
            case SKILL:
               return CityToolBar.instance.skillBtn;
            case SUMMON:
               return CityToolBar.instance.summonBtn;
            case STRENGTH:
               return CityToolBar.instance.strengthBtn;
            default:
               return null;
         }
      }
      
      override public function onFinish() : void
      {
         super.onFinish();
         if(this.params == "task352_0")
         {
            CityMap.instance.tranChangeMapByStr("PANEL_EquipCastingPanel,1");
         }
      }
   }
}

