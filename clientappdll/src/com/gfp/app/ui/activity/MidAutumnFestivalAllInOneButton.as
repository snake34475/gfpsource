package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.player.MovieClipPlayerEx;
   
   public class MidAutumnFestivalAllInOneButton extends BaseActivitySprite
   {
      
      private var _mcEffect9:MovieClipPlayerEx;
      
      private var _mcEffectnor9:MovieClipPlayerEx;
      
      public function MidAutumnFestivalAllInOneButton(param1:ActivityNodeInfo)
      {
         super(param1);
         this._mcEffect9 = getEffect(1);
         this._mcEffectnor9 = getEffect(2);
         if(MainManager.actorInfo.lv % 10 == 9)
         {
            this._mcEffectnor9.visible = false;
         }
         else
         {
            this._mcEffect9.visible = false;
         }
         if(MainManager.actorInfo.lv < 60 || MainManager.actorInfo.lv > 99)
         {
            this._mcEffect9.visible = false;
            this._mcEffectnor9.visible = false;
         }
      }
      
      override protected function doAction() : void
      {
         this._mcEffect9.visible = false;
         this._mcEffectnor9.visible = false;
         super.doAction();
      }
   }
}

