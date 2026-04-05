package com.gfp.app.im
{
   import com.gfp.app.im.ui.IMPanel;
   import com.gfp.core.info.UserInfo;
   import org.taomee.utils.DisplayUtil;
   
   public class IMController
   {
      
      private static var _panel:IMPanel;
      
      public function IMController()
      {
         super();
      }
      
      public static function get panel() : IMPanel
      {
         if(_panel == null)
         {
            _panel = new IMPanel();
         }
         return _panel;
      }
      
      public static function updateInfo(param1:UserInfo) : void
      {
         if(DisplayUtil.hasParent(panel))
         {
            panel.updateInfo(param1);
         }
      }
      
      public static function show() : void
      {
         if(DisplayUtil.hasParent(panel))
         {
            panel.hide();
         }
         else
         {
            panel.show();
         }
      }
   }
}

