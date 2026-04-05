package com.gfp.app.toolBar
{
   import com.gfp.app.control.BaseBuffControl;
   import com.gfp.app.manager.SceneBuffManager;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.SkillStateInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TeamsRelationManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.SkillStateIcon;
   import com.gfp.core.xmlconfig.SkillStateXMLInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class BuffIconBar extends Sprite
   {
      
      private var _baseBuffList:Array = [];
      
      private var _buffList:Array = [];
      
      private var _skillStageIcons:Vector.<SkillStateIcon> = new Vector.<SkillStateIcon>();
      
      private var _keys:HashMap = new HashMap();
      
      private var _sceneBuffManager:SceneBuffManager;
      
      private var _baseBuffIconList:Array = [];
      
      public function BuffIconBar()
      {
         super();
         this._sceneBuffManager = new SceneBuffManager(this);
         SocketConnection.addCmdListener(CommandID.TEAM_ACTIVATE_SUMMON,this.updateTeamBuff);
         TeamsRelationManager.instance.addEventListener(TeamsRelationManager.SUMMON_EVOLVE,this.updateTeamBuff);
      }
      
      private function updateTeamBuff(param1:Event) : void
      {
         this.updateView();
      }
      
      public function updateSkillStateIcon() : void
      {
         var _loc1_:KeyInfo = null;
         var _loc2_:Vector.<SkillStateInfo> = null;
         var _loc3_:int = 0;
         var _loc5_:SkillStateInfo = null;
         var _loc6_:SkillStateInfo = null;
         var _loc7_:SkillStateIcon = null;
      }
      
      private function destroySkillStateIcon() : void
      {
         var _loc1_:SkillStateIcon = null;
         while(this._skillStageIcons.length)
         {
            _loc1_ = this._skillStageIcons.pop();
            DisplayUtil.removeForParent(_loc1_);
         }
      }
      
      public function updateBuff() : void
      {
         this._sceneBuffManager.initBuff();
      }
      
      public function addBaseBuff(param1:uint, param2:Boolean = true) : void
      {
         if(!this.hasBaseBuff(param1))
         {
            this._baseBuffList.push(param1);
            if(param2)
            {
               this.updateView();
            }
         }
      }
      
      public function hasBaseBuff(param1:uint) : Boolean
      {
         var _loc2_:int = this._baseBuffList.indexOf(param1);
         if(_loc2_ == -1)
         {
            return false;
         }
         return true;
      }
      
      public function removeBaseBuff(param1:uint) : void
      {
         var _loc2_:int = this._baseBuffList.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._baseBuffList.splice(_loc2_,1);
            this.updateView();
         }
      }
      
      public function addKeyBuff(param1:uint, param2:uint) : void
      {
         if(this._keys.getValue(param1) != null)
         {
            return;
         }
         this._keys.add(param1,param2);
         this.addBuff(param2);
      }
      
      public function removeKeyBuff(param1:uint) : void
      {
         var _loc2_:uint = uint(this._keys.remove(param1));
         if(_loc2_ == 0)
         {
            return;
         }
         this.removeBuff(_loc2_);
      }
      
      public function addBuff(param1:uint) : void
      {
         if(this._buffList.indexOf(param1) == -1)
         {
            this._buffList.push(param1);
            this.updateView();
         }
      }
      
      public function removeBuff(param1:uint) : void
      {
         var _loc2_:int = this._buffList.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._buffList.splice(_loc2_,1);
            this.updateView();
         }
      }
      
      public function updateView() : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:uint = 0;
         this.clear();
         var _loc1_:int = 0;
         var _loc2_:int = int(HeadRideBar.instance.getLength());
         _loc1_ = 0;
         for(; _loc1_ < this._baseBuffList.length; _loc1_++)
         {
            _loc4_ = uint(this._baseBuffList[_loc1_]);
            if(BaseBuffControl.checkBaseBuff(_loc4_))
            {
               if(this._sceneBuffManager.hasBuff(_loc4_))
               {
                  if(!this._sceneBuffManager.checkBuff(_loc4_))
                  {
                     continue;
                  }
               }
               _loc3_ = UIManager.getSprite("BaseBuffIcon_" + SkillXMLInfo.getBaseBuffViewID(this._baseBuffList[_loc1_]).toString());
               if(_loc3_)
               {
                  this._baseBuffIconList[_loc4_] = _loc3_;
                  _loc3_.cacheAsBitmap = true;
                  _loc3_.x = BaseBuffControl.DISTANCE_X * int(_loc2_ % BaseBuffControl.ROW_SIZE);
                  _loc3_.y = BaseBuffControl.DISTANCE_Y * int(_loc2_ / BaseBuffControl.ROW_SIZE);
                  addChild(_loc3_);
                  if(_loc4_ == 1)
                  {
                     ToolTipManager.add(_loc3_,TeamsRelationManager.instance.getTeamPropString(),200,false);
                  }
                  else
                  {
                     ToolTipManager.add(_loc3_,SkillXMLInfo.getBaseBuffDesc(this._baseBuffList[_loc1_]));
                  }
                  _loc2_++;
               }
            }
         }
         _loc1_ = 0;
         while(_loc1_ < this._skillStageIcons.length)
         {
            _loc3_ = this._skillStageIcons[_loc1_];
            _loc3_.x = BaseBuffControl.DISTANCE_X * int(_loc2_ % BaseBuffControl.ROW_SIZE) + BaseBuffControl.DISTANCE_X * 0.5;
            _loc3_.y = BaseBuffControl.DISTANCE_X * int(_loc2_ / BaseBuffControl.ROW_SIZE) + BaseBuffControl.DISTANCE_Y;
            addChild(_loc3_);
            _loc2_++;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._buffList.length)
         {
            _loc3_ = UIManager.getSprite("BuffIcon_" + SkillXMLInfo.getBuffViewID(this._buffList[_loc1_]).toString());
            if(_loc3_)
            {
               _loc3_.cacheAsBitmap = true;
               _loc3_.x = BaseBuffControl.DISTANCE_X * int((_loc2_ + _loc1_) % BaseBuffControl.ROW_SIZE);
               _loc3_.y = BaseBuffControl.DISTANCE_X * int((_loc2_ + _loc1_) / BaseBuffControl.ROW_SIZE);
               addChild(_loc3_);
               ToolTipManager.add(_loc3_,SkillXMLInfo.getBuffName(this._buffList[_loc1_]));
            }
            _loc1_++;
         }
      }
      
      public function updateBuffDesc(param1:int, param2:uint) : void
      {
         var _loc3_:Sprite = this._baseBuffIconList[param1];
         if(!_loc3_)
         {
            return;
         }
         ToolTipManager.remove(_loc3_);
         var _loc4_:String = SkillXMLInfo.getBaseBuffDesc(param1);
         _loc4_ = _loc4_.replace("#0",param2);
         ToolTipManager.add(_loc3_,_loc4_);
      }
      
      public function clear() : void
      {
         var _loc1_:Sprite = null;
         while(numChildren > 0)
         {
            _loc1_ = removeChildAt(0) as Sprite;
            ToolTipManager.remove(_loc1_);
         }
      }
      
      public function clearFightBuff() : void
      {
         this._buffList = [];
         this._keys.clear();
         this.destroySkillStateIcon();
         this.updateView();
      }
      
      public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_ACTIVATE_SUMMON,this.updateTeamBuff);
         TeamsRelationManager.instance.removeEventListener(TeamsRelationManager.SUMMON_EVOLVE,this.updateTeamBuff);
         this._baseBuffList = [];
         this._baseBuffIconList = [];
         this._buffList = [];
         this.clear();
         this.destroySkillStateIcon();
      }
   }
}

