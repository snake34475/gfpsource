package com.gfp.app.ui.activity
{
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.core.player.MovieClipPlayerEx;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class KengButton extends BaseActivityMultiSprite
   {
      
      private var mc:MovieClip;
      
      private var m1c:MovieClipPlayerEx;
      
      private var numTxt:TextField;
      
      public function KengButton(param1:ActivityMultiNodeInfo)
      {
         super(param1);
         this.mc = this.yuanjian;
         this.numTxt = this.mc["numTxt"];
         this.numTxt.text = (param1 as ActivityMultiNodeInfo).childNum.toString();
      }
   }
}

