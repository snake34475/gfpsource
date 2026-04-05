package com.gfp.app.ui.activity
{
   import com.gfp.core.info.fight.SkillInfo;
   import com.gfp.core.ui.SkillIcon;
   import com.gfp.core.utils.FilterUtil;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class SkillBar extends Sprite
   {
      
      private var ids:Array;
      
      public function SkillBar(param1:Array, param2:int = 5)
      {
         var _loc5_:int = 0;
         var _loc6_:SkillInfo = null;
         var _loc7_:SkillIcon = null;
         super();
         this.ids = param1;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = int(param1[_loc4_]);
            _loc6_ = new SkillInfo();
            _loc6_.id = _loc5_;
            _loc6_.lv = 1;
            _loc7_ = new SkillIcon(true);
            _loc7_.setInfo(_loc6_);
            _loc7_.x = _loc4_ * 40 + param2 * _loc4_;
            addChild(_loc7_);
            _loc4_++;
         }
      }
      
      public function disableSkill(param1:int) : void
      {
         var _loc3_:SkillIcon = null;
         var _loc2_:int = this.ids.indexOf(param1);
         if(_loc2_ != -1)
         {
            _loc3_ = this.getChildAt(_loc2_) as SkillIcon;
            if(_loc3_)
            {
               _loc3_.filters = FilterUtil.GRAY_FILTER;
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:SkillIcon = null;
         while(this.numChildren > 0)
         {
            _loc1_ = this.removeChildAt(0) as SkillIcon;
            if(_loc1_)
            {
               _loc1_.destroy();
            }
         }
         DisplayUtil.removeForParent(this);
      }
   }
}

