package com.gfp.app.mapProcess
{
   import com.gfp.app.feature.LeftTimeFeather;
   import com.gfp.app.fight.FightManager;
   import com.gfp.app.toolBar.FightToolBar;
   import com.gfp.core.CommandID;
   import com.gfp.core.buff.ActorOperateBuffManager;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.SkillXMLInfo;
   import com.gfp.core.controller.StageResizeController;
   import com.gfp.core.events.FightEvent;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.info.CDInfo;
   import com.gfp.core.info.KeyInfo;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.info.fight.SkillLevelInfo;
   import com.gfp.core.language.CoreLanguageDefine;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.CDManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.ActorModel;
   import com.gfp.core.model.PeopleModel;
   import com.gfp.core.model.SummonModel;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.QuickButton;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.Direction;
   import com.gfp.core.utils.FilterUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_1104401 extends BaseMapProcess
   {
      
      private var _mySelfSumPanel:MovieClip;
      
      private var _oppositeSumPanel:MovieClip;
      
      private var _selfSumList:Array;
      
      private var _oppSumList:Array;
      
      private var _operPanel:MovieClip;
      
      private var _showIndex:int;
      
      private var _showList:Array;
      
      private var _skillIDList:Array = [4051007,4051008,4051009];
      
      private var _leftX:int = 50;
      
      private var _rightX:int = 950;
      
      private var _flagMovies:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _timeId:int;
      
      private var _feather:LeftTimeFeather;
      
      public function MapProcess_1104401()
      {
         super();
      }
      
      override protected function init() : void
      {
         var i:int = 0;
         this._mySelfSumPanel = _mapModel.libManager.getMovieClip("UI_SummonRaceLeftHp");
         this._oppositeSumPanel = _mapModel.libManager.getMovieClip("UI_SummonRaceRightHp");
         i = 0;
         while(i < 3)
         {
            this._mySelfSumPanel["infoBar" + i.toString()].visible = false;
            this._oppositeSumPanel["infoBar" + i.toString()].visible = false;
            i++;
         }
         this._mySelfSumPanel.y = 180;
         this._oppositeSumPanel.y = 180;
         LayerManager.topLevel.addChild(this._mySelfSumPanel);
         LayerManager.topLevel.addChild(this._oppositeSumPanel);
         MapManager.addEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onPlayCreate);
         TasksManager.addActionListener(TaskActionEvent.TASK_PVP_WIN,null,this.showAlert);
         this._mySelfSumPanel.addEventListener(MouseEvent.CLICK,this.onSelPanelClick);
         ActorOperateBuffManager.instance.operaterDisable = true;
         FightManager.instance.addEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         StageResizeController.instance.register(this.resizePos);
         i = 0;
         while(i < FightToolBar.instance.getQickBar().SUMRACE_START_INDEX + 3)
         {
            FightToolBar.instance.getQickBar().sumRaceList.push(null);
            i++;
         }
         this._selfSumList = [];
         this._oppSumList = [];
         FightToolBar.instance.getQickBar().visible = false;
         FightToolBar.instance.getQickBar().initSumRaceSkillQuickKeys();
         this._timeId = setTimeout(function():void
         {
            LayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
            _feather = new LeftTimeFeather(60 * 3 * 1000,"剩余时间");
         },6800);
         i = FightToolBar.instance.getQickBar().SUMRACE_START_INDEX;
         while(i < FightToolBar.instance.getQickBar().sumRaceList.length)
         {
            FightToolBar.instance.getQickBar().sumRaceList[i].y = -45;
            FightToolBar.instance.getQickBar().sumRaceList[i].x = 15 + (i - FightToolBar.instance.getQickBar().SUMRACE_START_INDEX) * 53;
            this._mySelfSumPanel.addChild(FightToolBar.instance.getQickBar().sumRaceList[i]);
            i++;
         }
         UserInfoManager.ed.addEventListener(UserEvent.HP_CHANGE,this.onEvent);
         MapManager.setMapEndAction("open:ChooseSummonForRacePanel");
      }
      
      private function showAlert(param1:TaskActionEvent) : void
      {
         AlertManager.showSimpleAlarm("恭喜小侠士赢的此次比赛，胜利次数+1！");
      }
      
      private function resizePos() : void
      {
         if(this._mySelfSumPanel.x > this._oppositeSumPanel.x)
         {
            this._mySelfSumPanel.x = LayerManager.stageWidth - 255;
         }
         else
         {
            this._oppositeSumPanel.x = LayerManager.stageWidth - 255;
         }
      }
      
      private function onPlayCreate(param1:*) : void
      {
         this.getSceneSelfList();
         this.update();
         this.showSelBuf();
      }
      
      private function onSelPanelClick(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.target.name;
         var _loc3_:int = int(_loc2_.substr(_loc2_.length - 1,1));
         if(_loc2_.indexOf("buff") != -1)
         {
            SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,5,this._skillIDList[_loc3_],0);
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc5_:SkillLevelInfo = null;
         var _loc6_:CDInfo = null;
         var _loc2_:int = 0;
         switch(param1.keyCode)
         {
            case Keyboard.NUMBER_1:
               _loc2_ = 0;
               break;
            case Keyboard.NUMBER_2:
               _loc2_ = 1;
               break;
            case Keyboard.NUMBER_3:
               _loc2_ = 2;
         }
         var _loc3_:QuickButton = FightToolBar.instance.getQickBar().sumRaceList[FightToolBar.instance.getQickBar().SUMRACE_START_INDEX + _loc2_];
         var _loc4_:KeyInfo = _loc3_.keyInfo;
         if(CDManager.skillCD.cdContains(_loc4_.dataID))
         {
            TextAlert.show(CoreLanguageDefine.TEXTALERT_MSG_ARR[0]);
            return;
         }
         if(Boolean(_loc3_.keyInfo) && _loc4_.dataID != 0)
         {
            _loc5_ = SkillXMLInfo.getLevelInfo(_loc4_.dataID,1);
            _loc6_ = new CDInfo();
            _loc6_.id = _loc4_.dataID;
            _loc6_.runTime = _loc5_.duration;
            _loc6_.cdTime = _loc5_.cd;
            CDManager.skillCD.add(_loc6_);
         }
         SocketConnection.send(CommandID.FIGHT_ACTIVITY_EFFECT,5,_loc2_,0);
      }
      
      private function onModelDied(param1:FightEvent) : void
      {
         var _loc2_:SummonModel = null;
         for each(_loc2_ in this._oppSumList)
         {
            if(_loc2_.info == param1.data)
            {
               this._oppositeSumPanel["infoBar" + this._oppSumList.indexOf(_loc2_).toString()]["head0"].filters = FilterUtil.GRAY_FILTER;
               _loc2_ = null;
            }
         }
         for each(_loc2_ in this._selfSumList)
         {
            if(_loc2_.info == param1.data)
            {
               this._mySelfSumPanel["infoBar" + this._selfSumList.indexOf(_loc2_).toString()]["head0"].filters = FilterUtil.GRAY_FILTER;
               _loc2_ = null;
            }
         }
      }
      
      private function update() : void
      {
         this.hidePeopleModel();
         this._showIndex = 0;
         this.initPanel(this._mySelfSumPanel,this._selfSumList);
         var _loc1_:int = 0;
         while(_loc1_ < this._oppSumList.length)
         {
            this._oppositeSumPanel["infoBar" + _loc1_.toString()].visible = true;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._selfSumList.length)
         {
            this._mySelfSumPanel["infoBar" + _loc1_.toString()].visible = true;
            _loc1_++;
         }
      }
      
      private function showSelBuf() : void
      {
      }
      
      private function hidePeopleModel() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in UserManager.getModels())
         {
            if(_loc1_ is PeopleModel || _loc1_ is ActorModel)
            {
               _loc1_.visible = false;
               if((_loc1_ as PeopleModel).info.userID != MainManager.actorModel.info.userID)
               {
                  if(_loc1_.pos.x > 400)
                  {
                     this._oppositeSumPanel.x = this._rightX;
                  }
                  else
                  {
                     this._oppositeSumPanel.x = this._leftX;
                  }
               }
            }
         }
         if(this._oppositeSumPanel.x == this._rightX)
         {
            this._mySelfSumPanel.x = this._leftX;
         }
         else
         {
            this._mySelfSumPanel.x = this._rightX;
         }
         MainManager.actorModel.visible = false;
      }
      
      private function getSceneSelfList() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:MovieClip = null;
         for each(_loc1_ in UserManager.getModels())
         {
            if(_loc1_ is SummonModel)
            {
               (_loc1_ as SummonModel).direction = Direction.indexToStr2((_loc1_ as SummonModel).summonInfo.direction);
               if((_loc1_ as SummonModel).summonInfo.masterID == MainManager.actorInfo.userID)
               {
                  if(this._selfSumList.indexOf(_loc1_ as SummonModel) == -1)
                  {
                     this._selfSumList.push(_loc1_ as SummonModel);
                  }
               }
               else
               {
                  if(this._oppSumList.indexOf(_loc1_ as SummonModel) == -1)
                  {
                     this._oppSumList.push(_loc1_ as SummonModel);
                  }
                  _loc2_ = MapManager.currentMap.libManager.getMovieClip("UI_Sum_Race_Circle");
                  if(_loc2_)
                  {
                     _loc2_.mouseEnabled = false;
                     _loc2_.mouseChildren = false;
                     _loc1_.addChildAt(_loc2_,0);
                     this._flagMovies.push(_loc2_);
                  }
               }
            }
         }
      }
      
      private function clearPanel(param1:MovieClip, param2:Array) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param1["infoBar" + this._showIndex.toString()]["head0"].numChildren > 0)
            {
               param1["infoBar" + this._showIndex.toString()]["head0"].removeChildAt(0);
            }
            _loc3_++;
         }
      }
      
      private function initPanel(param1:MovieClip, param2:Array) : void
      {
         if(this._showIndex >= param2.length)
         {
            if(param2 != this._oppSumList)
            {
               this._showIndex = 0;
               this.initPanel(this._oppositeSumPanel,this._oppSumList);
            }
            return;
         }
         this._showList = param2;
         this._operPanel = param1;
         param1["infoBar" + this._showIndex.toString()].visible = true;
         if(!param2[this._showIndex])
         {
            param1["infoBar" + this._showIndex.toString()]["head0"].filters = FilterUtil.GRAY_FILTER;
         }
         else
         {
            if(param1["infoBar" + this._showIndex.toString()]["head0"].numChildren > 0)
            {
               param1["infoBar" + this._showIndex.toString()]["head0"].removeChildAt(0);
            }
            param1["infoBar" + this._showIndex.toString()]["head0"].filters = null;
            param1["infoBar" + this._showIndex.toString()]["lvTxt"].text = (param2[this._showIndex] as SummonModel).summonInfo.lv.toString();
            param1["infoBar" + this._showIndex.toString()]["nameTxt"].text = (param2[this._showIndex] as SummonModel).summonInfo.nick;
            param1["infoBar" + this._showIndex.toString()]["hpTxt"].text = (param2[this._showIndex] as SummonModel).summonInfo.hp.toString() + "/" + (param2[this._showIndex] as SummonModel).summonInfo.hp;
            this.showSumIcon((param2[this._showIndex] as SummonModel).summonInfo.roleID);
         }
      }
      
      private function updateSummonHp(param1:int) : void
      {
      }
      
      private function showSumIcon(param1:int) : void
      {
         var _loc2_:int = param1;
         var _loc3_:int = _loc2_ % 10;
         var _loc4_:String = ClientConfig.getRoleIcon(_loc2_ + (6 - _loc3_));
         SwfCache.getSwfInfo(_loc4_,this.onIconLoaded);
      }
      
      private function onIconLoaded(param1:SwfInfo) : void
      {
         var _loc2_:Sprite = param1.content as Sprite;
         _loc2_.scaleX = _loc2_.scaleY = 0.8;
         this._operPanel["infoBar" + this._showIndex.toString()]["head0"].addChild(_loc2_);
         ++this._showIndex;
         this.initPanel(this._operPanel,this._showList);
      }
      
      private function onEvent(param1:UserEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc2_:UserInfo = param1.data as UserInfo;
         var _loc3_:UserModel = UserManager.getModel(_loc2_.userID);
         if(_loc3_)
         {
            _loc4_ = this._selfSumList.indexOf(_loc3_);
            _loc5_ = _loc2_.hp < 0 ? 0 : int(_loc2_.hp);
            if(_loc4_ != -1)
            {
               _loc6_ = _loc5_ / _loc3_.getTotalHP();
               this._mySelfSumPanel["infoBar" + _loc4_.toString()]["hpBar"].scaleX = _loc6_;
               this._mySelfSumPanel["infoBar" + _loc4_.toString()]["hpTxt"].text = _loc5_.toString() + "/" + _loc3_.getTotalHP().toString();
               return;
            }
            _loc4_ = this._oppSumList.indexOf(_loc3_);
            if(_loc4_ != -1)
            {
               _loc6_ = _loc5_ / _loc3_.getTotalHP();
               this._oppositeSumPanel["infoBar" + _loc4_.toString()]["hpBar"].scaleX = _loc6_;
               this._oppositeSumPanel["infoBar" + _loc4_.toString()]["hpTxt"].text = _loc5_.toString() + "/" + _loc3_.getTotalHP().toString();
            }
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:MovieClip = null;
         super.destroy();
         TasksManager.removeActionListener(TaskActionEvent.TASK_PVP_WIN,null,this.showAlert);
         LayerManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._mySelfSumPanel.removeEventListener(MouseEvent.CLICK,this.onSelPanelClick);
         MapManager.removeEventListener(MapEvent.STAGE_USER_LISET_COMPLETE,this.onPlayCreate);
         FightManager.instance.removeEventListener(FightEvent.OGRE_DIE,this.onModelDied);
         MainManager.actorModel.visible = true;
         FightToolBar.instance.getQickBar().visible = true;
         DisplayUtil.removeForParent(this._mySelfSumPanel);
         DisplayUtil.removeForParent(this._oppositeSumPanel);
         FightToolBar.instance.getQickBar().clearSumRaceQuickKeys();
         ActorOperateBuffManager.instance.operaterDisable = false;
         this._mySelfSumPanel = null;
         this._oppositeSumPanel = null;
         for each(_loc1_ in this._flagMovies)
         {
            DisplayUtil.removeForParent(_loc1_);
         }
         clearTimeout(this._timeId);
         if(this._feather)
         {
            this._feather.destroy();
            this._feather = null;
         }
         UserInfoManager.ed.removeEventListener(UserEvent.HP_CHANGE,this.onEvent);
         StageResizeController.instance.unregister(this.resizePos);
      }
   }
}

