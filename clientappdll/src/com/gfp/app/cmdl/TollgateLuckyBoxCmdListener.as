package com.gfp.app.cmdl
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.LuckyBoxAwardInfo;
   import com.gfp.core.info.LuckyBoxSingleInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.language.ModuleLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.alert.AlertInfo;
   import com.gfp.core.manager.alert.AlertType;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.Alert;
   import com.gfp.core.utils.TextFormatUtil;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class TollgateLuckyBoxCmdListener extends BaseBean
   {
      
      public function TollgateLuckyBoxCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.LUCKY_BOX_AWARD,this.onLuckyBoxAward);
         finish();
      }
      
      private function onLuckyBoxAward(param1:SocketEvent) : void
      {
         var _loc2_:LuckyBoxAwardInfo = param1.data as LuckyBoxAwardInfo;
         var _loc3_:LuckyBoxSingleInfo = _loc2_.awardInfo;
         this.addAward(_loc3_,_loc2_.boxType == 2);
      }
      
      private function addAward(param1:LuckyBoxSingleInfo, param2:Boolean) : void
      {
         var _loc7_:String = null;
         var _loc8_:AlertInfo = null;
         var _loc9_:Alert = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:SingleEquipInfo = null;
         var _loc3_:String = "";
         if(param1 == null)
         {
            return;
         }
         var _loc4_:int = int(param1.itemID);
         if(_loc4_ == 1)
         {
            MainManager.actorInfo.coins += param1.itemCount;
            _loc3_ = "个 " + ModuleLanguageDefine.COIN_STR;
         }
         else if(_loc4_ == 2)
         {
            MainManager.actorInfo.exp += param1.itemCount;
            _loc3_ = "点 " + ModuleLanguageDefine.EXP_STR;
         }
         else if(_loc4_ == 3)
         {
            MainManager.actorInfo.skillPoint += param1.itemCount;
            _loc3_ = "点 " + ModuleLanguageDefine.SKILLPOINT_STR;
         }
         else if(_loc4_ == 4)
         {
            MainManager.actorInfo.huntAward += param1.itemCount;
            _loc3_ = "点 " + ModuleLanguageDefine.HUNTAWART_STR;
         }
         var _loc5_:int = param2 ? 0 : 1;
         var _loc6_:String = ModuleLanguageDefine.LUCKY_BOX_MSG_ARR[_loc5_];
         if(_loc4_ < 5)
         {
            _loc7_ = TextFormatUtil.substitute(ModuleLanguageDefine.LUCKY_BOX_MSG_ARR[2],_loc6_);
            _loc3_ = _loc7_ + param1.itemCount + _loc3_;
            _loc8_ = new AlertInfo();
            _loc8_.str = _loc3_;
            _loc8_.type = AlertType.ALARM;
            _loc9_ = new Alert(_loc8_);
            AlertManager.showForInfo(_loc8_);
         }
         else
         {
            _loc10_ = ItemXMLInfo.getName(_loc4_);
            _loc11_ = TextFormatUtil.substitute(ModuleLanguageDefine.LUCKY_BOX_MSG_ARR[3],param1.itemCount,_loc10_);
            if(param1.isToBag)
            {
               if(ItemXMLInfo.isEquipt(_loc4_))
               {
                  _loc12_ = new SingleEquipInfo();
                  _loc12_.itemID = _loc4_;
                  _loc12_.duration = param1.duration;
                  _loc12_.leftTime = param1.unique;
                  _loc12_.strengthenLV = param1.strengthenLevel;
                  ItemManager.addEquip(_loc12_);
               }
               else
               {
                  ItemManager.addItem(_loc4_,param1.itemCount);
               }
               _loc11_ += ModuleLanguageDefine.LUCKY_BOX_MSG_ARR[4];
            }
            else
            {
               _loc11_ += ModuleLanguageDefine.LUCKY_BOX_MSG_ARR[5];
            }
         }
      }
   }
}

