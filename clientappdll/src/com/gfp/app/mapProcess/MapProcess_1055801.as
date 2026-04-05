package com.gfp.app.mapProcess
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1055801 extends BaseMapProcess
   {
      
      private var _boxMC1:MovieClip;
      
      private var _boxModel1:UserModel;
      
      private var _boxMC2:MovieClip;
      
      private var _boxModel2:UserModel;
      
      private var _bossMC:MovieClip;
      
      public function MapProcess_1055801()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      private function onStageProChange(param1:SocketEvent) : void
      {
         var _loc6_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ != 558)
         {
            return;
         }
         if(_loc5_ < 10)
         {
            _loc6_ = 5;
         }
         else if(_loc5_ < 19)
         {
            _loc6_ = 7;
         }
         else
         {
            _loc6_ = 10;
         }
         if(_loc5_ > 1)
         {
            this._boxModel1 = UserManager.getModelByRoleType(11739);
            if(this._boxModel1)
            {
               this._boxMC1.y = -210;
               this._boxModel1.addChild(this._boxMC1);
               this._boxMC1.gotoAndPlay(1);
               this._boxMC1.addEventListener(Event.ENTER_FRAME,this.onEnterFame1);
            }
            this._boxModel2 = UserManager.getModelByRoleType(11740);
            if(this._boxModel2)
            {
               this._boxMC2.y = -210;
               this._boxModel2.addChild(this._boxMC2);
               this._boxMC2.gotoAndPlay(1);
               this._boxMC2.addEventListener(Event.ENTER_FRAME,this.onEnterFame2);
            }
         }
         TextAlert.show("第" + _loc5_ + "波怪物" + _loc6_ + "秒后来袭，请保护宝藏。");
      }
      
      private function onUserBorn(param1:UserEvent) : void
      {
         var _loc2_:UserModel = param1.data as UserModel;
         if(RoleXMLInfo.getType(_loc2_.info.roleType) == 1)
         {
            this._bossMC.y = -100;
            _loc2_.addChild(this._bossMC);
            this._bossMC.gotoAndPlay(1);
            this._bossMC.addEventListener(Event.ENTER_FRAME,this.onEnterFame3);
         }
      }
      
      private function onEnterFame1(param1:Event) : void
      {
         if(this._boxMC1.currentFrame == this._boxMC1.totalFrames)
         {
            DisplayUtil.removeForParent(this._boxMC1);
            this._boxMC1.removeEventListener(Event.ENTER_FRAME,this.onEnterFame1);
         }
      }
      
      private function onEnterFame2(param1:Event) : void
      {
         if(this._boxMC2.currentFrame == this._boxMC2.totalFrames)
         {
            DisplayUtil.removeForParent(this._boxMC2);
            this._boxMC2.removeEventListener(Event.ENTER_FRAME,this.onEnterFame2);
         }
      }
      
      private function onEnterFame3(param1:Event) : void
      {
         if(this._bossMC.currentFrame == this._bossMC.totalFrames)
         {
            DisplayUtil.removeForParent(this._bossMC);
            this._bossMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFame3);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         SocketConnection.removeCmdListener(CommandID.STAGE_MONSTER_PRO_CHANGE,this.onStageProChange);
         UserManager.removeEventListener(UserEvent.BORN,this.onUserBorn);
         if(this._boxMC1)
         {
            DisplayUtil.removeForParent(this._boxMC1);
            this._boxMC1.removeEventListener(Event.ENTER_FRAME,this.onEnterFame1);
            this._boxMC1 = null;
         }
         if(this._boxModel1)
         {
            this._boxModel1.destroy();
            this._boxModel1 = null;
         }
         if(this._boxModel2)
         {
            this._boxModel2.destroy();
            this._boxModel2 = null;
         }
         if(this._boxMC2)
         {
            DisplayUtil.removeForParent(this._boxMC2);
            this._boxMC2.removeEventListener(Event.ENTER_FRAME,this.onEnterFame2);
            this._boxMC2 = null;
         }
         if(this._bossMC)
         {
            DisplayUtil.removeForParent(this._bossMC);
            this._bossMC.removeEventListener(Event.ENTER_FRAME,this.onEnterFame3);
            this._bossMC = null;
         }
      }
   }
}

