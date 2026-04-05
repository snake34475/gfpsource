package com.gfp.app.cmdl
{
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.behavior.ClothBehavior;
   import com.gfp.core.info.item.ChangeClothInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.net.SocketConnection;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class ChangeClothCmdListener extends BaseBean
   {
      
      public function ChangeClothCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANGE_CLOTH,this.onChange);
         finish();
      }
      
      private function onChange(param1:SocketEvent) : void
      {
         var _loc2_:uint = uint(param1.headInfo.userID);
         var _loc3_:ChangeClothInfo = param1.data as ChangeClothInfo;
         HeadSelfPanel.instance.refreshUserInfo();
         var _loc4_:Vector.<SingleEquipInfo> = _loc3_.cloths.concat(_loc3_.fashionCloths);
         UserManager.execBehavior(_loc2_,new ClothBehavior(_loc4_,false),true);
      }
   }
}

