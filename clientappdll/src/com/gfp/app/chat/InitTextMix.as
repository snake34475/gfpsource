package com.gfp.app.chat
{
   import com.gfp.core.info.EmotionElement;
   import com.gfp.core.manager.UIManager;
   import org.taomee.bean.BaseBean;
   import org.taomee.text.TextMix;
   
   public class InitTextMix extends BaseBean
   {
      
      public function InitTextMix()
      {
         super();
      }
      
      override public function start() : void
      {
         TextMix.addElement("e",EmotionElement);
         var _loc1_:int = 0;
         while(_loc1_ < 24)
         {
            TextMix.addEmbed("e" + _loc1_.toString(),UIManager.getClass("e" + _loc1_.toString()));
            _loc1_++;
         }
         finish();
      }
   }
}

