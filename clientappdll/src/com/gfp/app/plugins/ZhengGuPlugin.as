package com.gfp.app.plugins
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.ZhengGuInfo;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.FunctionManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.utils.TimeUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class ZhengGuPlugin extends BasePlugin
   {
      
      private var timer:uint;
      
      private var _users:Vector.<PeopleModel>;
      
      public function ZhengGuPlugin()
      {
         super();
      }
      
      private function canZhengOther() : Boolean
      {
         return ItemManager.getItemCount(2740798) > 0;
      }
      
      override public function install() : void
      {
         super.install();
         this._users = new Vector.<PeopleModel>();
         UserManager.addEventListener(UserEvent.BORN,this.onUserChange);
         SocketConnection.addCmdListener(CommandID.ZHENG_GU_CMD,this.onZhengGuBack);
      }
      
      private function onUserChange(param1:UserEvent) : void
      {
         var _loc2_:PeopleModel = param1.data as PeopleModel;
         this.updateUser(_loc2_,true);
      }
      
      private function updateUser(param1:PeopleModel, param2:Boolean) : void
      {
         var _loc3_:Sprite = null;
         if(!param1)
         {
            return;
         }
         if(param2)
         {
            _loc3_ = param1.headContainer.getChildByName("UI_ZhengGuIcon") as Sprite;
            if(_loc3_ == null)
            {
               _loc3_ = UIManager.getSprite("UI_ZhengGuIcon");
               _loc3_.x = -_loc3_.width * 0.5;
               _loc3_.addEventListener(MouseEvent.CLICK,this.zhengHandle,false,0,false);
               _loc3_.name = "UI_ZhengGuIcon";
               param1.addHeadContainerChild(_loc3_);
               _loc3_.scaleX = 1.5;
               _loc3_.scaleY = 1.5;
            }
            this._users.push(param1);
         }
         else
         {
            _loc3_ = param1.headContainer.getChildByName("UI_ZhengGuIcon") as Sprite;
            if(_loc3_)
            {
               param1.removeHeadContainerChild(_loc3_);
               DisplayUtil.removeForParent(_loc3_);
               _loc3_["btn"].removeEventListener(MouseEvent.CLICK,this.zhengHandle);
            }
         }
         var _loc4_:Number = Number(TimeUtil.severDate.time);
         if(param1.info.zhengGuType != 0 && _loc4_ - param1.info.zhengGuTM * 1000 < 100 * 1000)
         {
            param1.changeRoleView(ZhengGuInfo.monster_Map[param1.info.zhengGuType]);
         }
      }
      
      private function countDown(param1:TextField) : void
      {
         if(int(param1.text) > 0)
         {
            param1.text = (int(param1.text) - 1).toString();
            param1.visible = true;
         }
         else
         {
            FunctionManager.disabledTradeHouse = false;
            param1.text = "100";
            clearInterval(this.timer);
            SocketConnection.send(CommandID.ZHENG_GU_CMD,0);
            param1.visible = false;
            MainManager.actorModel.isZhengGued = false;
         }
      }
      
      private function zhengHandle(param1:MouseEvent) : void
      {
         var user:PeopleModel;
         var info:UserInfo = null;
         var event:MouseEvent = param1;
         if(MapManager.currentMap.info.mapType != 0)
         {
            return;
         }
         if(!this.canZhengOther())
         {
            AlertManager.showSimpleAlert("你还没有整蛊盒，是否参与活动赢取?",function():void
            {
               ModuleManager.turnAppModule("ZhengGuPanel");
            });
         }
         user = event.currentTarget.parent.parent as PeopleModel;
         if(Boolean(user) && this.canZhengOther())
         {
            info = user.info;
            if(user.info.monsterID == 10807)
            {
               AlertManager.showSimpleAlarm("请不要整蛊正在淘金的小侠士(⊙﹏⊙)b。");
               return;
            }
            if(user.info.monsterID == 10403)
            {
               AlertManager.showSimpleAlarm("请不要整蛊正在押镖的小侠士(⊙﹏⊙)b。");
               return;
            }
            if(user.roleChangeStatus == 2)
            {
               AlertManager.showSimpleAlarm("请不要整蛊72变状态的小侠士(⊙﹏⊙)b。");
               return;
            }
            SocketConnection.send(CommandID.ZHENG_GU_CMD,info.userID);
         }
      }
      
      private function onZhengGuBack(param1:SocketEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Sprite = null;
         var _loc2_:ZhengGuInfo = param1.data as ZhengGuInfo;
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.scourceUID == 0)
         {
            UserManager.getModel(_loc2_.changerUID).changeRoleView(0);
            return;
         }
         if(_loc2_.startTM != 0)
         {
            if(_loc2_.changerUID == MainManager.actorID)
            {
               if(_loc2_.changerUID == _loc2_.scourceUID)
               {
                  AlertManager.showSimpleAlarm("你被自己变成<font color=\'#ff0000\'>" + RoleXMLInfo.getInfo(_loc2_.monsterID).name + "</font>了。");
               }
               else
               {
                  AlertManager.showSimpleAlarm("你被<font color=\'#ff0000\'>" + UserManager.getModel(_loc2_.scourceUID).info.nick + "</font>变成<font color=\'#ff0000\'>" + RoleXMLInfo.getInfo(_loc2_.monsterID).name + "</font>了。");
               }
               MainManager.actorModel.changeRoleView(_loc2_.monsterID);
               FunctionManager.disabledTradeHouse = true;
               _loc3_ = TimeUtil.severDate.time / 1000;
               _loc4_ = MainManager.actorModel.headContainer.getChildByName("UI_ZhengGuCD") as Sprite;
               if(_loc4_ == null)
               {
                  _loc4_ = UIManager.getSprite("UI_ZhengGuCD");
                  _loc4_.name = "UI_ZhengGuCD";
               }
               _loc4_.x = -_loc4_.width * 0.5;
               MainManager.actorModel.addHeadContainerChild(_loc4_);
               if(this.timer)
               {
                  clearInterval(this.timer);
                  FunctionManager.disabledTradeHouse = false;
                  MainManager.actorModel.isZhengGued = false;
                  _loc4_["countDownTxt"].text = "100";
               }
               this.timer = setInterval(this.countDown,1000,_loc4_["countDownTxt"]);
            }
            else
            {
               if(_loc2_.scourceUID == MainManager.actorID)
               {
                  if(UserManager.getModel(_loc2_.changerUID))
                  {
                     AlertManager.showSimpleAlarm("聪明绝顶的你成功整蛊<font color=\'#00ff00\'>" + UserManager.getModel(_loc2_.changerUID).info.nick + "</font>将他变为<font color=\'#ff0000\'>" + RoleXMLInfo.getInfo(_loc2_.monsterID).name + "</font>了。");
                  }
                  else
                  {
                     AlertManager.showSimpleAlarm("聪明绝顶的你整蛊成功,将其变为<font color=\'#ff0000\'>" + RoleXMLInfo.getInfo(_loc2_.monsterID).name + "</font>了。");
                  }
               }
               UserManager.getModel(_loc2_.changerUID).changeRoleView(_loc2_.monsterID);
            }
         }
         else
         {
            if(_loc2_.scourceUID == _loc2_.changerUID)
            {
               AlertManager.showSimpleAlarm("你尝试对自己使用整蛊盒失败了，但是获得了<font color=\'#0000ff\'>" + _loc2_.itemCnt + "个" + ItemXMLInfo.getName(_loc2_.itemID) + "</font>。");
               return;
            }
            if(_loc2_.changerUID == MainManager.actorID)
            {
               AlertManager.showSimpleAlarm("<font color=\'#00ff00\'>" + UserManager.getModel(_loc2_.scourceUID).info.nick + "</font>企图整蛊你，被你机智地识破了。你获得<font color=\'#ff0000\'>" + _loc2_.itemCnt + "</font><font color=\'#000000\'>个</font><font color=\'#0000ff\'>" + ItemXMLInfo.getName(_loc2_.itemID) + "</font>。");
            }
            else if(_loc2_.scourceUID == MainManager.actorID)
            {
               AlertManager.showSimpleAlarm("你企图整蛊<font color=\'#00ff00\'>" + UserManager.getModel(_loc2_.changerUID).info.nick + "</font>，但他慧眼独具将你识破，他获得<font color=\'#0000ff\'>" + _loc2_.itemCnt + "个" + ItemXMLInfo.getName(_loc2_.itemID) + "</font>。");
            }
         }
      }
   }
}

