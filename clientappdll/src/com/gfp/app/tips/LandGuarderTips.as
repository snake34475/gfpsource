package com.gfp.app.tips
{
   import com.gfp.core.ui.tips.BaseTips;
   
   public class LandGuarderTips extends BaseTips
   {
      
      public function LandGuarderTips(param1:*)
      {
         super(param1);
      }
      
      override public function setup() : void
      {
         mcContainer = new LandGuarderTipPanel();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            mcContainer["mcRole" + _loc1_].stop();
            mcContainer["mcRole" + _loc1_].visible = false;
            _loc1_++;
         }
         var _loc2_:Array = _info as Array;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            mcContainer["mcRole" + _loc1_].gotoAndStop(_loc2_[_loc1_][0]);
            mcContainer["mcRole" + _loc1_].visible = true;
            mcContainer["nameLabel" + _loc1_].text = (_loc2_[_loc1_][1] == 0 ? "洲长" : "副洲长") + "：" + _loc2_[_loc1_][2];
            _loc1_++;
         }
         addChild(mcContainer);
      }
   }
}

