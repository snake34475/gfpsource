package com.gfp.app.systems
{
   import com.gfp.core.manager.UIManager;
   import org.taomee.text.TextMix;
   
   public class TextMixGlobals
   {
      
      public function TextMixGlobals()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 24)
         {
            TextMix.addEmbed("e" + _loc1_.toString(),UIManager.getClass("e" + _loc1_.toString()));
            _loc1_++;
         }
      }
   }
}

