package com.gfp.app.cmdl
{
   import com.gfp.app.manager.FashionClothMananger;
   import com.gfp.app.toolBar.TootalExpBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.KeyManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.SkillManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class AdvancedCmdListener extends BaseBean
   {
      
      public function AdvancedCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ADVANCED_BROADCAST,this.onUserAdvanced);
         SocketConnection.addCmdListener(CommandID.ADVANCED,this.onAdvancedSuccess);
         SocketConnection.addCmdListener(CommandID.ADVANCED3,this.onAdvanced3Success);
         SocketConnection.addCmdListener(CommandID.TURN_BACK,this.onTurnBack);
         SocketConnection.addCmdListener(CommandID.ITEM_TURN_BACK,this.onItemTurnBack);
         SocketConnection.addCmdListener(CommandID.SECOND_TURN_BACK,this.responseSecondTurnback);
         finish();
      }
      
      private function responseSecondTurnback(param1:SocketEvent) : void
      {
         var _loc7_:KeyInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         MainManager.actorInfo.skills = new Vector.<KeyInfo>();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = new KeyInfo();
            _loc7_.dataID = _loc2_.readUnsignedInt();
            _loc7_.lv = 1;
            MainManager.actorInfo.skills.push(_loc7_);
            _loc6_++;
         }
         SkillManager.resetListFlag();
         SkillManager.getData();
         KeyManager.upDateSkillQuickKeys(MainManager.actorInfo.skills);
         MainManager.actorInfo.roleType = _loc3_;
         MainManager.actorInfo.secondTurnBackType = _loc4_ - 1;
         FashionClothMananger.instance.resetActorModel();
         TootalExpBar.refreshExpBar();
         MainManager.actorModel.upDateNickText();
         ActivityExchangeTimesManager.updataTimes(5220,120);
         MainManager.actorModel.dispatchEvent(new UserEvent(UserEvent.ACTIVE_NEW_LV));
         UserManager.dispatchEvent(new UserEvent(UserEvent.SECOND_TURN_BACK));
      }
      
      private function onAdvancedSuccess(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:Boolean = _loc2_.readUnsignedInt() == 1;
         if(_loc3_)
         {
            _loc4_ = _loc2_.readUnsignedInt();
            MainManager.actorInfo.isAdvanced = true;
            ItemManager.addItem(1500387,1);
            ItemManager.addItem(1410145,1);
            AlertManager.showSimpleAlarm("恭喜你，小侠士进阶成功~");
            AlertManager.showItemGetAlert(1500387,1);
            AlertManager.showItemGetAlert(1410145,1);
            SkillManager.resetSkill();
            MainManager.actorInfo.skillPoint = _loc4_;
            if(MainManager.roleType != Constant.ROLE_TYPE_HORSE)
            {
               FashionClothMananger.instance.resetActorModel();
            }
            MainManager.actorModel.setNicStyle(15658734);
         }
         else
         {
            AlertManager.showSimpleAlarm("进阶失败~");
         }
      }
      
      private function onAdvanced3Success(param1:SocketEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:Boolean = _loc2_.readUnsignedInt() == 2;
         if(_loc3_)
         {
            _loc4_ = _loc2_.readUnsignedInt();
            ItemManager.addItem(1410081,1);
            AlertManager.showSimpleAlarm("恭喜你，小侠士进阶三阶成功~");
            AlertManager.showItemGetAlert(1410081,1);
            SkillManager.resetSkill();
            MainManager.actorInfo.skillPoint = _loc4_;
            MainManager.actorInfo.isSuperAdvc = true;
            if(MainManager.roleType != Constant.ROLE_TYPE_HORSE)
            {
               FashionClothMananger.instance.resetActorModel();
            }
         }
         else
         {
            AlertManager.showSimpleAlarm("进阶三阶失败~");
         }
      }
      
      private function onUserAdvanced(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:UserModel = UserManager.getModel(_loc3_);
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         if(_loc4_)
         {
            if(_loc5_ == 1)
            {
               _loc4_.info.isAdvanced = true;
               _loc4_.setNicStyle(15658734);
            }
            else if(_loc5_ == 2)
            {
               _loc4_.info.isSuperAdvc = true;
            }
         }
      }
      
      private function onItemTurnBack(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         MainManager.actorInfo.roleType = _loc2_.readUnsignedInt();
         var _loc3_:uint = _loc2_.readUnsignedInt();
         ItemManager.removeItem(_loc3_,1);
         this.dealTurnBack(_loc2_);
      }
      
      private function onTurnBack(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         MainManager.actorInfo.roleType = _loc2_.readUnsignedInt();
         MainManager.actorInfo.lv = _loc2_.readUnsignedInt();
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         MainManager.actorInfo.exp = (_loc3_ << 32) + _loc4_;
         this.dealTurnBack(_loc2_);
      }
      
      private function dealTurnBack(param1:ByteArray) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:KeyInfo = null;
         var _loc2_:uint = param1.readUnsignedInt();
         _loc2_ = _loc2_ > 5 ? 5 : _loc2_;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc7_ = new KeyInfo();
            _loc7_.dataID = param1.readUnsignedInt();
            _loc7_.funcID = KeyManager.skillQuickKeys[_loc4_];
            _loc7_.lv = 1;
            _loc3_.push(_loc7_);
            _loc4_++;
         }
         KeyManager.setSkillQuickKeys(_loc3_);
         MainManager.actorInfo.isTurnBack = true;
         SkillManager.resetSkill();
         FashionClothMananger.instance.resetActorModel();
         TootalExpBar.refreshExpBar();
         MainManager.actorModel.upDateNickText();
         var _loc5_:Array = TasksManager.taskHash.getKeys();
         for each(_loc6_ in _loc5_)
         {
            TasksManager.removeBufInfo(_loc6_,false);
            TasksManager.setTaskStatus(_loc6_,TasksManager.UN_ACCEPT);
         }
         TasksManager.setTaskStatus(45,TasksManager.COMPLETE);
         TasksManager.setTaskStatus(199,TasksManager.COMPLETE);
         TasksManager.setTaskStatus(1,TasksManager.COMPLETE);
         TasksManager.setTaskStatus(299,TasksManager.COMPLETE);
         if(MainManager.actorInfo.lv == 80)
         {
            ModuleManager.turnAppModule("TurnBackAwardPanel");
         }
         SightManager.refreshTaskSign();
         UserManager.dispatchEvent(new UserEvent(UserEvent.TURN_BACK));
      }
   }
}

