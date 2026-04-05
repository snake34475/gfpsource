package com.gfp.app.cmdl
{
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.toolBar.HeadSummonPanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.action.ActionInfo;
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.action.data.NodeInfo;
   import com.gfp.core.action.net.NetSkillAction;
   import com.gfp.core.action.normal.SkillAction;
   import com.gfp.core.behavior.MonsterDialogBehavior;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.effect.IEffect;
   import com.gfp.core.events.SkillEvent;
   import com.gfp.core.events.UILoadEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.CDInfo;
   import com.gfp.core.info.PointEffectInfo;
   import com.gfp.core.info.UserSummonInfos;
   import com.gfp.core.info.fight.SkillConfigInfo;
   import com.gfp.core.info.fight.SkillExtraEffectInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.RideManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.PointEffectModel;
   import com.gfp.core.model.SpriteModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.UILoader;
   import com.gfp.core.utils.Direction;
   import com.gfp.core.utils.FightMode;
   import com.gfp.core.utils.SpriteType;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Utils;
   
   public class SkillCmdListener extends BaseBean
   {
      
      private const EXTRA_EFFECT_PATH:String = "com.gfp.core.effect.skill.";
      
      public function SkillCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ACTION_SKILL,this.onEvent);
         SocketConnection.addCmdListener(CommandID.ACTION_SKILL_STOP,this.onSkillEndHandle);
         SocketConnection.addCmdListener(CommandID.SUMMON_SKILL,this.onSummonSkill);
         SocketConnection.addCmdListener(CommandID.POINT_SKILL_EFFECT,this.onPointSkillEffect);
         SocketConnection.addCmdListener(CommandID.SUMMON_PICK_ITEM,this.onSmmonPickItem);
         SocketConnection.addCmdListener(CommandID.SUMMON_RAGE_CHANGE,this.onSummonRageChange);
         SocketConnection.addCmdListener(CommandID.ACTION_SKILL_FAIL,this.onSkillFail);
         SocketConnection.addCmdListener(CommandID.SKILL_CD_CHANGE,this.onSkillCDHandle);
         finish();
      }
      
      private function onEvent(param1:SocketEvent) : void
      {
         var _loc12_:SkillLevelInfo = null;
         var _loc13_:Point = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:ActionInfo = null;
         var _loc17_:BaseAction = null;
         var _loc18_:NodeInfo = null;
         var _loc19_:SkillLevelInfo = null;
         var _loc20_:UILoader = null;
         var _loc2_:uint = uint(param1.headInfo.userID);
         var _loc3_:ByteArray = param1.data as ByteArray;
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc6_:uint = _loc3_.readUnsignedInt();
         var _loc7_:uint = _loc3_.readUnsignedInt();
         var _loc8_:int = int(SpriteModel.getSpriteType(_loc5_));
         if(_loc2_ != MainManager.actorID || FightManager.fightMode == FightMode.WATCH)
         {
            _loc12_ = SkillXMLInfo.getLevelInfo(_loc6_,_loc7_);
            if((Boolean(_loc12_)) && _loc12_.actionID != 0)
            {
               _loc13_ = new Point(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
               _loc14_ = _loc3_.readUnsignedInt();
               _loc15_ = _loc3_.readUnsignedInt();
               _loc16_ = ActionXMLInfo.getInfo(_loc12_.actionID);
               _loc16_.skillID = _loc6_;
               if(_loc8_ == SpriteType.OGRE || _loc8_ == SpriteType.NPC)
               {
                  if(_loc16_.nodes.length > 0)
                  {
                     _loc18_ = _loc16_.nodes[0];
                     _loc18_.duration += RoleXMLInfo.getAtkDuration(_loc5_);
                  }
               }
               _loc17_ = new NetSkillAction(_loc16_,_loc12_,_loc13_,_loc14_,_loc4_,_loc2_);
               _loc17_.direction = _loc15_;
               UserManager.execAction(_loc2_,_loc17_);
            }
         }
         else
         {
            if(_loc6_ == 100607)
            {
               CDManager.skillCD.stopInitiativeCD();
            }
            if(RideManager.isRideSkillID(_loc6_))
            {
               _loc19_ = SkillXMLInfo.getLevelInfo(_loc6_,1);
               MainManager.actorModel.execAction(new SkillAction(ActionXMLInfo.getInfo(_loc19_.actionID),_loc19_));
            }
         }
         if(_loc8_ == SpriteType.OGRE || _loc8_ == SpriteType.NPC)
         {
            UserManager.execBehavior(_loc2_,new MonsterDialogBehavior(_loc6_));
         }
         var _loc9_:SkillConfigInfo = SkillXMLInfo.getInfo(_loc6_);
         var _loc10_:int = _loc9_ ? int(_loc9_.useEffect) : 0;
         if(_loc10_)
         {
            _loc20_ = new UILoader(ClientConfig.getSkillEffect(_loc6_.toString()));
            _loc20_.addEventListener(UILoadEvent.COMPLETE,this.skillEfffectHandler);
            _loc20_.load();
         }
         var _loc11_:UserModel = UserManager.getModel(_loc2_);
         if(_loc11_)
         {
            this.processExtraEffect(_loc9_,_loc11_);
         }
         UserManager.dispatchEvent(new SkillEvent(SkillEvent.SKILL_ACTION,_loc6_,_loc11_));
      }
      
      private function processExtraEffect(param1:SkillConfigInfo, param2:UserModel) : void
      {
         var _loc3_:SkillExtraEffectInfo = null;
         var _loc4_:* = undefined;
         var _loc5_:IEffect = null;
         if(param1.extraEffects)
         {
            for each(_loc3_ in param1.extraEffects)
            {
               _loc4_ = Utils.getClass(this.EXTRA_EFFECT_PATH + _loc3_.name);
               if(_loc4_)
               {
                  _loc5_ = new _loc4_() as IEffect;
                  _loc5_.params = _loc3_.params;
                  _loc5_.delay = _loc3_.delay;
                  _loc5_.duration = _loc3_.duration;
                  _loc5_.target = param2;
                  _loc5_.start();
                  param2.effectManager.addEffect(_loc5_);
               }
            }
         }
      }
      
      private function skillEfffectHandler(param1:UILoadEvent) : void
      {
         var loader:UILoader = null;
         var animat:MovieClip = null;
         var evt:UILoadEvent = param1;
         loader = evt.currentTarget as UILoader;
         animat = loader.content as MovieClip;
         loader.removeEventListener(UILoadEvent.COMPLETE,this.skillEfffectHandler);
         if(animat == null)
         {
            return;
         }
         LayerManager.topLevel.addChild(animat);
         animat.addFrameScript(animat.totalFrames - 1,function():void
         {
            animat.stop();
            DisplayUtil.removeForParent(animat);
            loader.destroy(true);
            loader = null;
         });
      }
      
      private function onSummonSkill(param1:SocketEvent) : void
      {
         var _loc2_:uint = uint(param1.headInfo.userID);
         var _loc3_:ByteArray = param1.data as ByteArray;
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc6_:Point = new Point(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
         var _loc7_:String = Direction.indexToStr(_loc3_.readUnsignedByte());
         var _loc8_:uint = _loc3_.readUnsignedInt();
         SummonManager.execAttack(_loc2_,_loc6_,_loc7_,_loc4_,_loc5_,_loc8_);
      }
      
      private function onSmmonPickItem(param1:SocketEvent) : void
      {
         var _loc2_:uint = uint(param1.headInfo.userID);
         var _loc3_:ByteArray = param1.data as ByteArray;
         var _loc4_:uint = _loc3_.readUnsignedInt();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc6_:Point = new Point(_loc3_.readUnsignedInt(),_loc3_.readUnsignedInt());
         var _loc7_:String = Direction.indexToStr(_loc3_.readUnsignedByte());
         var _loc8_:uint = _loc3_.readUnsignedInt();
         var _loc9_:uint = _loc3_.readUnsignedInt();
         SummonManager.execPickItem(_loc2_,_loc6_,_loc7_,_loc4_,_loc5_,_loc9_,_loc8_);
      }
      
      private function onPointSkillEffect(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:PointEffectInfo = new PointEffectInfo(_loc2_);
         var _loc4_:PointEffectModel = new PointEffectModel(_loc3_);
         MapManager.currentMap.addEffect(_loc4_);
      }
      
      private function onSummonRageChange(param1:SocketEvent) : void
      {
         var _loc7_:uint = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedShort();
         var _loc5_:UserSummonInfos = SummonManager.getActorSummonInfo();
         if(_loc5_.fightSummonInfo)
         {
            _loc7_ = uint(_loc5_.fightSummonInfo.roleID);
            if(_loc7_ > 8000 && _loc7_ <= 8500 && _loc5_.fightSummonInfo.lv < 45)
            {
               return;
            }
            _loc5_.fightSummonInfo.rage = _loc4_;
         }
         var _loc6_:SummonModel = MainManager.actorModel.fightSummonModel;
         if(_loc6_)
         {
            HeadSummonPanel.instance.setRage(_loc4_);
            _loc6_.summonInfo.rage = _loc4_;
            _loc6_.dispatchEvent(new UserEvent(UserEvent.SUMMONE_RAGE_CHANGE,_loc4_));
         }
      }
      
      private function onSkillFail(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         CDManager.skillCD.stopCDBySkillId(_loc3_);
         var _loc5_:SkillLevelInfo = SkillXMLInfo.getLevelInfo(_loc3_,_loc4_);
         if(_loc5_)
         {
            MainManager.actorModel.setMP(MainManager.actorModel.getMP() + _loc5_.mp);
            MainManager.actorModel.actionManager.clear();
            MainManager.actorModel.execStandAction();
         }
      }
      
      private function onSkillEndHandle(param1:SocketEvent) : void
      {
         var _loc10_:SkillConfigInfo = null;
         var _loc11_:SkillExtraEffectInfo = null;
         var _loc12_:IEffect = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:int = int(_loc2_.readUnsignedInt());
         var _loc8_:int = int(_loc2_.readUnsignedInt());
         var _loc9_:UserModel = UserManager.getModel(_loc4_);
         if((Boolean(_loc9_)) && _loc5_ == 2)
         {
            _loc10_ = SkillXMLInfo.getInfo(_loc3_);
            if(_loc10_.extraEffects)
            {
               for each(_loc11_ in _loc10_.extraEffects)
               {
                  _loc12_ = _loc9_.effectManager.getEffect(_loc11_.name);
                  if(_loc12_)
                  {
                     _loc9_.effectManager.removeEffect(_loc12_);
                  }
               }
            }
         }
      }
      
      private function onSkillCDHandle(param1:SocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:CDInfo = null;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = int(_loc2_.readUnsignedInt());
            _loc6_ = int(_loc2_.readUnsignedInt());
            CDManager.skillCD.stopCDBySkillId(_loc5_);
            if(_loc6_ > 0)
            {
               _loc7_ = new CDInfo();
               _loc7_.id = _loc5_;
               _loc7_.runTime = 0;
               _loc7_.cdTime = _loc6_;
               CDManager.skillCD.add(_loc7_);
            }
            _loc4_++;
         }
      }
   }
}

