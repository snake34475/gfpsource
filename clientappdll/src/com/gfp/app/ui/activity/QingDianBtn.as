package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.player.MovieClipPlayerEx;
   
   public class QingDianBtn extends BaseActivitySprite
   {
      
      private var _mcEffect:MovieClipPlayerEx;
      
      public function QingDianBtn(param1:ActivityNodeInfo)
      {
         super(param1);
         this._mcEffect = getEffect(1);
      }
      
      override protected function doAction() : void
      {
         super.doAction();
         this._mcEffect.visible = false;
      }
   }
}

