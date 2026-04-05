package com.gfp.app.cmdl
{
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.buff.BuffInfo;
   import com.gfp.core.buff.IBuff;
   import com.gfp.core.buff.bitmap.BitmapBuff;
   import com.gfp.core.buff.movie.IconBuff;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.effect.IEffect;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.fight.BuffConfigInfo;
   import com.gfp.core.info.fight.SkillExtraEffectInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.TextUtil;
   import flash.filters.GlowFilter;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Utils;
   
   public class BuffCmdListener extends BaseBean
   {
      
      private const EXTRA_EFFECT_PATH:String = "com.gfp.core.effect.skill.";
      
      public function BuffCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.BUFF_STATE,this.onBuffState);
         SocketConnection.addCmdListener(CommandID.HALO_STATE,this.onHaloState);
         SocketConnection.addCmdListener(CommandID.LIST_BUFF_STATE,this.onListBuffState);
         finish();
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc8_:IBuff = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedByte();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:Boolean = _loc2_.readUnsignedByte() == 1;
         var _loc7_:SkillLevelInfo = SkillXMLInfo.getLevelInfo(_loc3_,_loc4_);
         if(_loc7_)
         {
            if(_loc6_)
            {
               if(_loc7_.buffInfo)
               {
                  _loc8_ = new BitmapBuff(_loc7_.buffInfo.clone(),false);
                  UserManager.execBuff(_loc5_,_loc8_,true);
               }
            }
            else if(_loc7_.hitBuffInfo)
            {
               _loc8_ = new BitmapBuff(_loc7_.hitBuffInfo.clone(),false);
               UserManager.execBuff(_loc5_,_loc8_,true);
            }
         }
      }
      
      private function onBuffState(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedShort();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:Boolean = _loc2_.readUnsignedByte() == 1;
         this.updateState(_loc3_,_loc4_,_loc5_,_loc6_);
         UserManager.dispatchEvent(new UserEvent(UserEvent.BUFF,_loc4_));
      }
      
      private function onHaloState(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedShort() + 40000;
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:Boolean = _loc2_.readUnsignedByte() == 1;
         this.updateState(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      private function onListBuffState(param1:SocketEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc10_ = _loc2_.readUnsignedShort();
               _loc11_ = _loc2_.readUnsignedInt();
               this.updateState(_loc5_,_loc10_,_loc11_,true,false);
               _loc7_++;
            }
            _loc8_ = _loc2_.readUnsignedInt();
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc12_ = _loc2_.readUnsignedShort() + 40000;
               _loc13_ = _loc2_.readUnsignedInt();
               this.updateState(_loc5_,_loc12_,_loc13_,true,false);
               _loc9_++;
            }
            _loc4_++;
         }
      }
      
      private function updateState(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Boolean = true) : void
      {
         var _loc8_:BuffInfo = null;
         var _loc9_:IBuff = null;
         var _loc6_:UserModel = UserManager.getModel(param1);
         var _loc7_:BuffConfigInfo = SkillXMLInfo.getBuffConfigInfo(param3);
         if(Boolean(_loc6_) && Boolean(_loc7_))
         {
            this.processExtraEffect(_loc7_,_loc6_,param4);
         }
         if(param4)
         {
            if(param2 == 1423)
            {
               UserManager.execFilters(param1,[new GlowFilter(16711680,1,15,15)]);
            }
            _loc8_ = new BuffInfo();
            _loc8_.id = param3;
            _loc8_.keyID = param2;
            if(_loc7_ == null)
            {
               if(_loc6_)
               {
                  _loc6_.execServerBuff(_loc8_);
               }
               return;
            }
            _loc8_.view = _loc7_.buffViewID;
            _loc8_.layer = _loc7_.buffLayer;
            _loc8_.align = _loc7_.buffAlign;
            _loc8_.name = _loc7_.buffName;
            if(_loc7_.isChangeViewBuff)
            {
               this.changeRoleView(param1,_loc7_,true);
               if(MainManager.actorID == param1)
               {
                  ActorOperateBuffManager.instance.addChangeViewBuff(_loc7_);
               }
            }
            switch(param2)
            {
               case 2416:
                  this.stealhModel(param1,_loc8_,true);
            }
            if(Boolean(_loc7_.isIconBuff) || Boolean(_loc7_.isEffectBuff))
            {
               _loc9_ = new IconBuff(_loc8_,false);
               UserManager.execBuff(param1,_loc9_,true);
            }
            if(param1 == MainManager.actorID)
            {
               HeadSelfPanel.instance.addBuffIcon(param2,param3);
               if(_loc7_.buffExec != "")
               {
                  ActorOperateBuffManager.instance.execute(param2,_loc7_.buffExec);
                  MainManager.actorModel.actionManager.clear();
                  MainManager.actorModel.execStandAction();
               }
            }
            if(param5 && Boolean(_loc6_))
            {
               TextAlert.show(TextUtil.htmlEncode(_loc6_.info.nick) + "获得(" + _loc8_.name + ")");
            }
         }
         else
         {
            if(param1 == MainManager.actorID)
            {
               HeadSelfPanel.instance.removeBuffIcon(param2);
               ActorOperateBuffManager.instance.end(param2);
            }
            if(param2 == 1423)
            {
               UserManager.execFilters(param1,[]);
            }
            switch(param2)
            {
               case 2416:
                  this.stealhModel(param1,_loc8_,false);
            }
            var _loc10_:uint = param2;
            switch(0)
            {
            }
            this.changeRoleView(param1,_loc7_,false);
            if(MainManager.actorID == param1 && Boolean(_loc7_))
            {
               ActorOperateBuffManager.instance.removeChangeViewBuff(_loc7_);
            }
            UserManager.endKeyBuff(param1,param2);
         }
         if(_loc6_)
         {
            if(param2 == 2522 || param2 == 2817 || param2 == 2822)
            {
               if(param4)
               {
                  if(_loc6_.info.troop == MainManager.actorInfo.troop)
                  {
                     _loc6_.visible = true;
                     _loc6_.alpha = 0.5;
                  }
                  else
                  {
                     _loc6_.visible = false;
                     _loc6_.alpha = 1;
                  }
               }
               else
               {
                  _loc6_.visible = true;
                  _loc6_.alpha = 1;
               }
            }
         }
      }
      
      private function processExtraEffect(param1:BuffConfigInfo, param2:UserModel, param3:Boolean) : void
      {
         var _loc4_:SkillExtraEffectInfo = null;
         var _loc5_:* = undefined;
         var _loc6_:IEffect = null;
         if(param1.extraEffects)
         {
            for each(_loc4_ in param1.extraEffects)
            {
               if(param3)
               {
                  _loc5_ = Utils.getClass(this.EXTRA_EFFECT_PATH + _loc4_.name);
                  if(_loc5_)
                  {
                     _loc6_ = new _loc5_() as IEffect;
                     _loc6_.params = _loc4_.params;
                     _loc6_.delay = _loc4_.delay;
                     _loc6_.duration = _loc4_.duration;
                     _loc6_.target = param2;
                     _loc6_.start();
                     param2.effectManager.addEffect(_loc6_);
                  }
               }
               else
               {
                  _loc6_ = param2.effectManager.getEffect(_loc4_.name);
                  if(_loc6_)
                  {
                     param2.effectManager.removeEffect(_loc6_);
                  }
               }
            }
         }
      }
      
      private function changeRoleView(param1:int, param2:BuffConfigInfo, param3:Boolean = false) : void
      {
         var _loc4_:UserModel = null;
         if(Boolean(param2) && Boolean(param2.isChangeViewBuff))
         {
            if(param3)
            {
               _loc4_ = UserManager.getModel(param1);
               if((Boolean(_loc4_)) && _loc4_.roleChangeStatus != 2)
               {
                  _loc4_.changeRoleView(param2.buffViewID);
               }
            }
            else
            {
               _loc4_ = UserManager.getModel(param1);
               if((Boolean(_loc4_)) && _loc4_.roleChangeStatus == 1)
               {
                  _loc4_.changeRoleView(0);
               }
            }
         }
      }
      
      private function stealhModel(param1:int, param2:BuffInfo, param3:Boolean = false) : void
      {
         var _loc4_:UserModel = null;
         if(param3)
         {
            _loc4_ = UserManager.getModel(param1);
            if(_loc4_)
            {
               _loc4_.player.alpha = 0;
               _loc4_.hideNick();
               _loc4_.hideShadow();
               _loc4_.alphaBloodBar();
               if(RoleXMLInfo.getType(_loc4_.info.roleType) == 1)
               {
                  _loc4_.hideRing();
               }
            }
         }
         else
         {
            _loc4_ = UserManager.getModel(param1);
            if(_loc4_)
            {
               _loc4_.player.alpha = 1;
               _loc4_.showNick();
               _loc4_.showShadow();
               _loc4_.alphaBloodBar(true);
               if(RoleXMLInfo.getType(_loc4_.info.roleType) == 1)
               {
                  _loc4_.showRing(ClientConfig.getBuff("boss_ring"));
               }
            }
         }
      }
   }
}

