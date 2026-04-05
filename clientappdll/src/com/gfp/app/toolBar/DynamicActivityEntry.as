package com.gfp.app.toolBar
{
   import com.gfp.app.cartoon.AnimationHelper;
   import com.gfp.app.config.xml.DynamicActivityXMLInfo;
   import com.gfp.app.info.ActivityMultiNodeInfo;
   import com.gfp.app.info.ActivityNodeInfo;
   import com.gfp.app.manager.CommMapEventManager;
   import com.gfp.app.manager.TurnBackGuideManager;
   import com.gfp.app.manager.mapEvents.CommMapEventIds;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.toolBar.activityEntry.ActivityCustomProcess;
   import com.gfp.app.turnbackguide.TurnBackGuideEvent;
   import com.gfp.app.ui.activity.BaseActivityMultiSprite;
   import com.gfp.app.ui.activity.BaseActivitySprite;
   import com.gfp.core.CommandID;
   import com.gfp.core.Constant;
   import com.gfp.core.cache.SwfCache;
   import com.gfp.core.cache.SwfInfo;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.TaskEvent;
   import com.gfp.core.events.UserEvent;
   import com.gfp.core.events.UserItemEvent;
   import com.gfp.core.manager.ActivityExchangeTimesManager;
   import com.gfp.core.manager.AlertManager;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SearchGodManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.manager.UserInfoManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.player.MovieClipPlayerEx;
   import com.gfp.core.ui.ItemIcon;
   import com.gfp.core.ui.TipsManager;
   import com.gfp.core.ui.tips.CommItemTips;
   import com.greensock.TweenLite;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class DynamicActivityEntry extends GFFitStageItem
   {
      
      private static var _instance:DynamicActivityEntry;
      
      public static var isShow:Boolean;
      
      private static var _suo:Boolean;
      
      private static var _suoBtn:InteractiveObject;
      
      private static var _shanMc:MovieClip;
      
      private static var _shanMcEx:MovieClipPlayerEx;
      
      private static var IconAggregateMc:MovieClip;
      
      public static var TempExpNums:int;
      
      private static var autoControl:int = 0;
      
      private var _container:Sprite;
      
      public const ITEMS_ID:Array = [1500726,1500727,1500728,1500729,1500730,1500731,1500732,1500733,1500734,1500735];
      
      public const MAPS_ID:Array = [6,14,27,33,34,54,56,65,63,66];
      
      private var activeIcon:MovieClip;
      
      private var tempMapId:int;
      
      private var IconAggregate:Sprite;
      
      private var duangCD:Boolean = true;
      
      private var buttons:Array = [];
      
      private var _bottom:Number = LayerManager.stageHeight - 360;
      
      private var _center:Number = LayerManager.stageWidth;
      
      private var _gap:Number = 5;
      
      private var _top2:int;
      
      private var _top1:int;
      
      private var _top0:int;
      
      private var _right:int;
      
      private var _suoY:Number;
      
      private var _suoX:Number;
      
      private var complete:Boolean = false;
      
      public function DynamicActivityEntry()
      {
         super();
      }
      
      public static function getIconAggregateMc() : MovieClip
      {
         return IconAggregateMc;
      }
      
      public static function get instance() : DynamicActivityEntry
      {
         if(!_instance)
         {
            _instance = new DynamicActivityEntry();
            SwfCache.getSwfInfo(ClientConfig.getSubUI("IconAggregate"),_instance.onIconLoaded);
         }
         return _instance;
      }
      
      private function onIconLoaded(param1:SwfInfo) : void
      {
         this.complete = true;
         IconAggregateMc = param1.content as MovieClip;
         this.init();
      }
      
      private function init() : void
      {
         _suoBtn = DynamicActivityEntry.IconAggregateMc["UI_SuoBtn"] as InteractiveObject;
         _shanMc = _suoBtn["shanMc"];
         _shanMcEx = new MovieClipPlayerEx(_shanMc);
         this._container = new Sprite();
         this.layout();
         LayerManager.toolsLevel.addChild(this._container);
         this.addEvent();
         this.initActivityConfig();
         _suo = false;
         super.show();
         isShow = true;
         this._container.visible = true;
         this.updateAlign();
      }
      
      override protected function layout() : void
      {
         this._bottom = LayerManager.stageHeight - 133;
         this._center = LayerManager.stageWidth;
         this._top2 = 210;
         this._top1 = 140;
         this._top0 = 70;
         this._right = LayerManager.stageWidth - 15;
         this.updateAlign();
      }
      
      private function onTurnBack(param1:Event) : void
      {
         if(MainManager.actorInfo.isTurnBack)
         {
            UserManager.removeEventListener(UserEvent.TURN_BACK,this.onTurnBack);
            this.updateAlign();
         }
      }
      
      private function goToNpc(param1:int, param2:int, param3:String) : void
      {
         var onMapComplete:Function = null;
         var map:int = param1;
         var npc:int = param2;
         var str:String = param3;
         CityMap.instance.tranChangeMapByStr(str);
         if(MapManager.mapInfo.id != map)
         {
            onMapComplete = function(param1:Event):void
            {
               MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapComplete);
               NpcDialogController.showForNpc(npc);
            };
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapComplete);
         }
         else
         {
            NpcDialogController.showForNpc(npc);
         }
      }
      
      private function initActivityConfig() : void
      {
         var _loc2_:BaseActivitySprite = null;
         var _loc3_:ActivityNodeInfo = null;
         var _loc4_:Class = null;
         var _loc5_:MovieClip = null;
         var _loc1_:Vector.<ActivityNodeInfo> = DynamicActivityXMLInfo.infos;
         this.buttons = [];
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.customClass)
            {
               _loc4_ = getDefinitionByName("com.gfp.app.ui.activity." + _loc3_.customClass) as Class;
               _loc2_ = new _loc4_(_loc3_) as BaseActivitySprite;
            }
            else if(_loc3_ is ActivityMultiNodeInfo)
            {
               _loc2_ = new BaseActivityMultiSprite(_loc3_ as ActivityMultiNodeInfo);
               _loc5_ = _loc2_.sprite as MovieClip;
            }
            else
            {
               _loc2_ = new BaseActivitySprite(_loc3_);
            }
            UIManager.setButtonAsBitmap(_loc2_);
            this.buttons.push(_loc2_);
            this._container.addChild(_loc2_);
            ActivityCustomProcess.initEntry(_loc3_,_loc2_);
         }
         this._container.addChildAt(_suoBtn,0);
         this._suoX = LayerManager.stageWidth;
         this._suoY = 30;
         _suoBtn.x = this._suoX;
         _suoBtn.y = this._suoY;
         (_suoBtn as MovieClip).addChild(_shanMcEx);
         _shanMcEx.visible = _suo;
         _shanMcEx.buttonMode = true;
         this.checkNewPlayerBtn();
         this.updateAlign();
      }
      
      private function checkNewPlayerBtn() : void
      {
         if(MainManager.isNewUser())
         {
            MainManager.actorModel.addEventListener(UserEvent.LVL_CHANGE,this.onLvlChange);
         }
      }
      
      private function onLvlChange(param1:UserEvent) : void
      {
         if(!MainManager.isNewUser())
         {
            MainManager.actorModel.removeEventListener(UserEvent.LVL_CHANGE,this.onLvlChange);
            this.updateAlign();
         }
      }
      
      public function updateAlign(... rest) : void
      {
         var params:Array = rest;
         SearchGodManager.ed.dispatchEvent(new Event(SearchGodManager.CHANGE_EVENT));
         if(!this.complete)
         {
            return;
         }
         _suoBtn.visible = MainManager.actorInfo.lv >= 60;
         if(Boolean(MapManager.currentMap) && Boolean(MapManager.currentMap.info) && MapManager.currentMap.info.id == 1104501)
         {
            isShow = false;
            if(this._container)
            {
               this._container.visible = false;
            }
            return;
         }
         if(this.duangCD)
         {
            this.duang();
            this.duangCD = false;
            setTimeout(function():void
            {
               duangCD = true;
            },30000);
         }
         else
         {
            this.updateBtn();
         }
      }
      
      private function duang() : void
      {
         this.alignRight();
         if(!_suo)
         {
            this.alignTop2();
         }
         this.alignTop3();
         this.alignLeftTop();
         CityToolBar.instance.update();
      }
      
      private function updateBtn() : void
      {
         this.alignRight(false);
         if(!_suo)
         {
            this.alignTop2(false);
         }
         this.alignTop3(false);
         this.alignLeftTop();
         CityToolBar.instance.update();
      }
      
      private function alignLeftTop() : void
      {
         var _loc2_:BaseActivitySprite = null;
         var _loc1_:int = 35;
         for each(_loc2_ in this.buttons)
         {
            if(_loc2_.info.pos == 4)
            {
               if(_loc2_.executeShow() && isShow)
               {
                  _loc2_.visible = true;
                  _loc2_.x = _loc1_;
                  _loc2_.y = 184;
                  _loc1_ += _loc2_.width + 20;
               }
               else
               {
                  _loc2_.visible = false;
               }
            }
         }
      }
      
      private function alignTop2(param1:Boolean = true) : void
      {
         var _loc8_:BaseActivitySprite = null;
         this._suoX = LayerManager.stageWidth - 15;
         this._suoY = 30;
         _suoBtn.x = this._suoX;
         _suoBtn.y = this._suoY;
         var _loc2_:Number = this._right;
         var _loc3_:Number = this._top0;
         var _loc4_:Number = this._right;
         var _loc5_:Number = this._top1;
         var _loc6_:Number = this._right;
         var _loc7_:Number = this._top2;
         autoControl = 0;
         for each(_loc8_ in this.buttons)
         {
            if(!(_loc8_.info.pos != 1 && _loc8_.info.pos != 2))
            {
               if(_loc8_.executeShow() && isShow)
               {
                  if(_loc8_.info.isAlign)
                  {
                     _loc8_.visible = true;
                     if(param1)
                     {
                        _loc8_.x = LayerManager.stageWidth - 15;
                        _loc8_.y = 0;
                        if(_loc8_.info.pos == 1)
                        {
                           TweenLite.to(_loc8_,1,{
                              "x":_loc2_ - _loc8_.width * 0.5,
                              "y":_loc3_
                           });
                           _loc2_ -= _loc8_.width + this._gap;
                        }
                        else
                        {
                           TweenLite.to(_loc8_,1,{
                              "x":_loc4_ - _loc8_.width * 0.5,
                              "y":_loc5_
                           });
                           _loc4_ -= _loc8_.width + this._gap;
                        }
                        if(autoControl >= 10 && autoControl < 20)
                        {
                           TweenLite.to(_loc8_,1,{
                              "x":_loc4_ - _loc8_.width * 0.5,
                              "y":_loc5_
                           });
                           _loc4_ -= _loc8_.width + this._gap;
                        }
                     }
                     else if(_loc8_.info.pos == 1)
                     {
                        _loc8_.x = _loc2_ - _loc8_.width * 0.5;
                        _loc8_.y = _loc3_;
                        _loc2_ -= _loc8_.width + this._gap;
                     }
                     else
                     {
                        _loc8_.x = _loc4_ - _loc8_.width * 0.5;
                        _loc8_.y = _loc5_;
                        _loc4_ -= _loc8_.width + this._gap;
                     }
                  }
                  else
                  {
                     _loc8_.resetPostion();
                  }
               }
               else
               {
                  _loc8_.visible = false;
               }
            }
         }
      }
      
      private function doSuo() : void
      {
         var _loc7_:BaseActivitySprite = null;
         var _loc1_:Number = this._right;
         var _loc2_:Number = this._top0;
         var _loc3_:Number = this._right;
         var _loc4_:Number = this._top1;
         var _loc5_:Number = this._right;
         var _loc6_:Number = this._top2;
         autoControl = 0;
         for each(_loc7_ in this.buttons)
         {
            if(!(_loc7_.info.pos != 1 && _loc7_.info.pos != 2))
            {
               if(_loc7_.executeShow() && isShow)
               {
                  if(_loc7_.info.isAlign)
                  {
                     _loc7_.visible = true;
                     if(!_suo)
                     {
                        _loc7_.x = LayerManager.stageWidth - 25;
                     }
                     if(_loc7_.info.pos == 1)
                     {
                        if(_suo)
                        {
                           TweenLite.to(_loc7_,1,{"x":LayerManager.stageWidth + 100});
                        }
                        else
                        {
                           TweenLite.to(_loc7_,1,{
                              "x":_loc1_ - _loc7_.width + 20,
                              "y":_loc2_
                           });
                        }
                        _loc1_ -= _loc7_.width + this._gap;
                     }
                     else
                     {
                        if(_suo)
                        {
                           TweenLite.to(_loc7_,1,{"x":LayerManager.stageWidth + 100});
                        }
                        else
                        {
                           TweenLite.to(_loc7_,1,{
                              "x":_loc3_ - _loc7_.width + 20,
                              "y":_loc4_
                           });
                        }
                        _loc3_ -= _loc7_.width + this._gap;
                     }
                  }
                  else
                  {
                     _loc7_.resetPostion();
                  }
               }
               else
               {
                  _loc7_.visible = false;
               }
            }
         }
      }
      
      private function alignTop3(param1:Boolean = true) : void
      {
         var _loc4_:BaseActivitySprite = null;
         var _loc2_:Number = 250;
         var _loc3_:Number = this._top0;
         for each(_loc4_ in this.buttons)
         {
            if(_loc4_.info.pos == 3)
            {
               if(_loc4_.executeShow() && isShow)
               {
                  if(_loc4_.info.isAlign)
                  {
                     if(param1)
                     {
                        _loc4_.x = LayerManager.stageWidth;
                        _loc4_.y = 0;
                        TweenLite.to(_loc4_,1,{
                           "x":_loc2_ + _loc4_.width - 20,
                           "y":_loc3_
                        });
                     }
                     else
                     {
                        _loc4_.x = _loc2_ + _loc4_.width;
                        _loc4_.y = _loc3_;
                     }
                     _loc2_ += _loc4_.width;
                  }
                  else
                  {
                     _loc4_.resetPostion();
                  }
                  _loc4_.visible = true;
               }
               else
               {
                  _loc4_.visible = false;
               }
            }
         }
      }
      
      private function alignRight(param1:Boolean = true) : void
      {
         var _loc4_:BaseActivitySprite = null;
         var _loc2_:Number = this._center;
         var _loc3_:Number = this._bottom;
         for each(_loc4_ in this.buttons)
         {
            if(_loc4_.info.pos == 0)
            {
               if(_loc4_.executeShow() && isShow)
               {
                  if(_loc4_.info.isAlign)
                  {
                     if(param1)
                     {
                        _loc4_.x = LayerManager.stageWidth;
                        _loc4_.y = 0;
                        TweenLite.to(_loc4_,1,{
                           "x":_loc2_ - _loc4_.width * 0.5 - 20,
                           "y":_loc3_ - 60
                        });
                        _loc3_ -= 60;
                     }
                     else
                     {
                        _loc4_.x = _loc2_ - _loc4_.width * 0.5 - 20;
                        _loc4_.y = _loc3_ - 60;
                        _loc3_ -= 60;
                     }
                  }
                  else
                  {
                     _loc4_.resetPostion();
                  }
                  _loc4_.visible = true;
               }
               else
               {
                  _loc4_.visible = false;
               }
            }
         }
      }
      
      private function addEvent() : void
      {
         _suoBtn.addEventListener(MouseEvent.CLICK,this.onSuoClick);
         MapManager.addEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.addEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
         ItemManager.addListener(UserItemEvent.USE_ACTIVITY_ITEM,this.onUseItem);
         TasksManager.addListener(TaskEvent.COMPLETE,this.onTaskComplete);
         UserManager.addEventListener(UserEvent.TURN_BACK,this.onTurnBack);
         UserInfoManager.ed.addEventListener(UserEvent.LVL_CHANGE,this.updateAlign);
         TurnBackGuideManager.instance.ed.addEventListener(TurnBackGuideEvent.HIDE_ICON,this.onHideIcon);
      }
      
      protected function onSuoClick(param1:MouseEvent) : void
      {
         this.suo = !this.suo;
      }
      
      private function removeEvent() : void
      {
         MapManager.removeEventListener(MapEvent.USER_ENTER_TRADE_MAP,this.onEnterTradeMap);
         MapManager.removeEventListener(MapEvent.USER_LEAVE_TRADE_MAP,this.onLeaveTradeMap);
         TasksManager.removeListener(TaskEvent.COMPLETE,this.onTaskComplete);
         ItemManager.removeListener(UserItemEvent.USE_ACTIVITY_ITEM,this.onUseItem);
         UserManager.removeEventListener(UserEvent.TURN_BACK,this.onTurnBack);
         UserInfoManager.ed.removeEventListener(UserEvent.LVL_CHANGE,this.updateAlign);
         TurnBackGuideManager.instance.ed.removeEventListener(TurnBackGuideEvent.HIDE_ICON,this.onHideIcon);
      }
      
      protected function onHideIcon(param1:Event) : void
      {
         this.updateAlign();
      }
      
      private function onTaskComplete(param1:TaskEvent) : void
      {
         var _loc2_:Vector.<ActivityNodeInfo> = null;
         var _loc3_:ActivityNodeInfo = null;
         if(param1.taskID >= 2007 || param1.taskID <= 2010)
         {
            ActivityExchangeTimesManager.updataTimesByOnce(2983);
         }
         if(param1.taskID == this.getTuCompleteTaskId())
         {
            isShow = true;
         }
         if(param1.taskID == 301)
         {
            this.updateAlign();
         }
         if(MainManager.actorInfo.lv < 80)
         {
            _loc2_ = DynamicActivityXMLInfo.infos;
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.unlockTaskID == param1.taskID)
               {
                  this.updateAlign();
                  break;
               }
            }
         }
      }
      
      private function getTuCompleteTaskId() : int
      {
         var _loc1_:uint = 1;
         switch(MainManager.roleType)
         {
            case Constant.ROLE_TYPE_DARGON:
               _loc1_ = 45;
               break;
            case Constant.ROLE_TYPE_TIGER:
            case Constant.ROLE_TYPE_CAT:
               _loc1_ = 199;
               break;
            case Constant.ROLE_TYPE_HORSE:
               _loc1_ = 299;
               break;
            default:
               _loc1_ = 1;
         }
         return _loc1_;
      }
      
      private function onUseItem(param1:UserItemEvent) : void
      {
         this.useMapItem(param1.param.itemID);
      }
      
      private function onActiveMouseClick(param1:MouseEvent = null) : void
      {
         var _loc2_:int = int(this.activeIcon.itemID);
         if(ItemManager.getItemCount(_loc2_) > 0)
         {
            ItemManager.useItem(_loc2_);
         }
      }
      
      private function useMapItem(param1:int) : void
      {
         var index:int;
         var mapId:int;
         var itemID:int = param1;
         if(itemID == 2740088)
         {
            if(MapManager.currentMap.info.id != 1051)
            {
               AlertManager.showSimpleAlert("小侠士，必须在广寒宫才能使用兔子变身符哦，是否前去？",function():void
               {
                  CityMap.instance.changeMap(1051);
               });
            }
            return;
         }
      }
      
      private function onRecFightMsg(param1:SocketEvent) : void
      {
         this.destoryShangeGu();
      }
      
      private function onItemGet(param1:SocketEvent) : void
      {
         this.destoryShangeGu();
         var _loc2_:AnimationHelper = new AnimationHelper();
         _loc2_.play("bao_xiang_dong_hua",null,"mc");
      }
      
      private function destoryShangeGu() : void
      {
         SocketConnection.removeCmdListener(CommandID.ITEM_QUICK_PICKUP2,this.onItemGet);
         SocketConnection.removeCmdListener(CommandID.REC_COMM_MAP_FIGHT,this.onRecFightMsg);
         CommMapEventManager.destroyEvtById(CommMapEventIds.TIME_FIGHT);
      }
      
      private function appyMapFun() : void
      {
         if(this.tempMapId != 0)
         {
            CityMap.instance.changeMap(this.tempMapId);
            this.tempMapId = 0;
         }
      }
      
      private function cancelMapFun() : void
      {
         this.tempMapId = 0;
      }
      
      private function showActiveIcon(param1:int) : void
      {
         var _loc2_:ItemIcon = null;
         var _loc3_:ItemIcon = null;
         if(this.activeIcon)
         {
            if(this.activeIcon.itemID != param1)
            {
               TipsManager.removeTip(this.activeIcon);
               this.activeIcon.removeChildAt(this.activeIcon.numChildren - 1);
               this.activeIcon.itemID = param1;
               _loc2_ = new ItemIcon();
               _loc2_.setID(param1);
               _loc2_.x = 3;
               _loc2_.y = -22;
               this.activeIcon.addChild(_loc2_);
               TipsManager.addTip(this.activeIcon,new CommItemTips(param1));
            }
         }
         else
         {
            this.activeIcon = new UI_ActiveIconBack();
            this.activeIcon.useHandCursor = true;
            this.activeIcon.buttonMode = true;
            this.activeIcon.x = this._container.stage.stageWidth - 150;
            this.activeIcon.y = this._container.stage.stageHeight - 300;
            this.activeIcon.addEventListener(MouseEvent.CLICK,this.onActiveMouseClick);
            this.activeIcon.itemID = param1;
            _loc3_ = new ItemIcon();
            _loc3_.setID(param1);
            _loc3_.x = 3;
            _loc3_.y = -22;
            this.activeIcon.addChild(_loc3_);
            this._container.addChild(this.activeIcon);
            TipsManager.addTip(this.activeIcon,new CommItemTips(param1));
         }
         this.activeIcon.visible = true;
      }
      
      private function hideActiveIcon() : void
      {
         if(this.activeIcon)
         {
            this.activeIcon.visible = false;
         }
      }
      
      private function onEnterTradeMap(param1:MapEvent) : void
      {
         this.hide();
      }
      
      private function onLeaveTradeMap(param1:MapEvent) : void
      {
         this.show();
      }
      
      override public function show() : void
      {
         isShow = true;
         if(this._container)
         {
            this._container.visible = true;
            LayerManager.toolsLevel.addChild(this._container);
         }
         this.updateAlign();
      }
      
      override public function hide() : void
      {
         super.hide();
         isShow = false;
         if(this._container)
         {
            this._container.visible = false;
         }
         this.updateAlign();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeEvent();
      }
      
      public function setBtnVisible(param1:Boolean) : void
      {
      }
      
      public function getDynamicBtn() : MovieClip
      {
         return null;
      }
      
      private function get suo() : Boolean
      {
         return _suo;
      }
      
      private function set suo(param1:Boolean) : void
      {
         _suo = param1;
         if(param1)
         {
            _shanMcEx.play();
            _shanMcEx.visible = true;
            _suoBtn.scaleX = -1;
            _suoBtn.x = LayerManager.stageWidth;
         }
         else
         {
            _shanMcEx.stop();
            _shanMcEx.visible = false;
            _suoBtn.scaleX = 1;
            _suoBtn.x = LayerManager.stageWidth - 15;
         }
         this.doSuo();
      }
   }
}

