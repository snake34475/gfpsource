package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   public class _1cd2cbcf26a33bd28f04a9924d5a039f4f0606d3d0e6b68cd699b89717fb7d54_flash_display_Sprite extends Sprite
   {
      
      public function _1cd2cbcf26a33bd28f04a9924d5a039f4f0606d3d0e6b68cd699b89717fb7d54_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

