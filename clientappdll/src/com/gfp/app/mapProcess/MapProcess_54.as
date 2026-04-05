package com.gfp.app.mapProcess
{
   import com.gfp.core.action.BaseAction;
   import com.gfp.core.action.mouse.MouseProcess;
   import com.gfp.core.action.normal.PosMoveAction;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.config.xml.ActionXMLInfo;
   import com.gfp.core.controller.MouseController;
   import com.gfp.core.events.MapEvent;
   import com.gfp.core.events.MoveEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.info.TransportPoint;
   import com.gfp.core.info.UserInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.map.BaseMapProcess;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.utils.StringConstants;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   
   public class MapProcess_54 extends BaseMapProcess
   {
      
      private static const TASK_ID:uint = 82;
      
      private static const DOG_RES_ID:uint = 1003;
      
      private var loader:Loader;
      
      private var replacedMcs:Vector.<MovieClip>;
      
      private var replaceMcs:Vector.<MovieClip>;
      
      private var dogModel:UserModel;
      
      private var point:TransportPoint;
      
      private var yanMc:MovieClip;
      
      public function MapProcess_54()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(Boolean(TasksManager.isAccepted(TASK_ID)) && !TasksManager.isReady(TASK_ID))
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.switchCompleteHandler);
         }
      }
      
      private function switchCompleteHandler(param1:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.switchCompleteHandler);
         MainManager.closeOperate(true,true,true);
         MouseController.instance.clear();
         this.changeSceneView();
      }
      
      private function changeSceneView() : void
      {
         this.replacedMcs = new Vector.<MovieClip>();
         this.replaceMcs = new Vector.<MovieClip>();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderCompleteHandler);
         this.loader.load(new URLRequest(ClientConfig.getCartoon("task82_2")));
      }
      
      private function loaderCompleteHandler(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = LoaderInfo(param1.target).content;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loaderCompleteHandler);
         this.yanMc = _loc3_["yan_mc"] as MovieClip;
         var _loc5_:int = 1;
         while(_loc5_ <= 3)
         {
            _loc4_ = "huacong" + _loc5_ + "_mc";
            this.replacedMcs.push(_mapModel.contentLevel[_loc4_]);
            this.replaceMcs.push(_loc3_[_loc4_]);
            this.replaceMcs[_loc5_ - 1].x = this.replacedMcs[_loc5_ - 1].x;
            this.replaceMcs[_loc5_ - 1].y = this.replacedMcs[_loc5_ - 1].y;
            _loc2_ = int(_mapModel.contentLevel.getChildIndex(this.replacedMcs[_loc5_ - 1]));
            _mapModel.contentLevel.removeChild(this.replacedMcs[_loc5_ - 1]);
            _mapModel.contentLevel.addChildAt(this.replaceMcs[_loc5_ - 1],_loc2_);
            this.replaceMcs[_loc5_ - 1].buttonMode = true;
            _loc5_++;
         }
         this.replaceMcs[1].stop();
         this.replaceMcs[2].stop();
         this.point = new TransportPoint();
         this.point.mapId = 54;
         this.point.pos = new Point(813,743);
         CityMap.instance.tranChangeMap(this.point);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.endToTarget1Handler);
      }
      
      private function endToTarget1Handler(param1:MoveEvent) : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.endToTarget1Handler);
         MainManager.openOperate();
         MouseController.instance.init();
         this.replaceMcs[0].addEventListener(MouseEvent.CLICK,this.clickHua1Handler);
      }
      
      private function clickHua1Handler(param1:MouseEvent) : void
      {
         this.replaceMcs[0].removeEventListener(MouseEvent.CLICK,this.clickHua1Handler);
         MainManager.closeOperate(true,true,true);
         MouseController.instance.clear();
         this.replaceMcs[0].gotoAndPlay(6);
         this.replaceMcs[0].addEventListener(Event.ENTER_FRAME,this.checkEndHandler);
      }
      
      private function checkEndHandler(param1:Event) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.target);
         if(_loc2_ == this.replaceMcs[0])
         {
            if(_loc2_.currentFrame == 89)
            {
               _loc2_.stop();
               MainManager.openOperate();
               MouseController.instance.init();
               this.replaceMcs[1].gotoAndPlay(2);
               this.replaceMcs[1].addEventListener(MouseEvent.CLICK,this.clickHua2Handler);
               this.replaceMcs[0].removeEventListener(Event.ENTER_FRAME,this.checkEndHandler);
            }
            else if(_loc2_.currentFrame == 74)
            {
               this.point.pos = new Point(786,489);
               CityMap.instance.tranChangeMap(this.point);
            }
         }
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.checkEndHandler);
            _loc2_.stop();
            switch(_loc2_)
            {
               case this.replaceMcs[0]:
                  this.resetView(0);
                  break;
               case this.replaceMcs[1]:
                  this.resetView(1);
                  break;
               case this.replaceMcs[2]:
                  this.resetView(2);
                  TasksManager.dispatchActionEvent(TaskActionEvent.TASK_CUSTOM_FINISH,TASK_ID + StringConstants.SIGN + 0);
                  break;
               case this.yanMc:
                  _mapModel.contentLevel.removeChild(this.yanMc);
                  this.dogGotoPool();
            }
         }
      }
      
      private function clickHua2Handler(param1:MouseEvent) : void
      {
         MainManager.closeOperate(true,true,true);
         MouseController.instance.clear();
         this.replaceMcs[1].gotoAndPlay(3);
         this.replaceMcs[0].play();
         this.replaceMcs[0].addEventListener(Event.ENTER_FRAME,this.checkEndHandler);
         this.replaceMcs[1].addEventListener(Event.ENTER_FRAME,this.checkEndHandler);
         this.yanMc.x = 882;
         this.yanMc.y = 455;
         _mapModel.contentLevel.addChild(this.yanMc);
         this.yanMc.addEventListener(Event.ENTER_FRAME,this.checkEndHandler);
         var _loc2_:UserInfo = new UserInfo();
         _loc2_.roleType = DOG_RES_ID;
         _loc2_.actionID = 10001;
         _loc2_.serverSpeed = MainManager.actorInfo.serverSpeed * 2;
         _loc2_.pos = new Point(882,475);
         this.dogModel = new UserModel(_loc2_);
         this.dogModel.hideNick();
         this.dogModel.mouseChildren = false;
         this.dogModel.mouseEnabled = false;
         MapManager.currentMap.addUser(DOG_RES_ID,this.dogModel);
      }
      
      private function dogGotoPool() : void
      {
         this.point.pos = new Point(1901,753);
         MouseProcess.execRun(this.dogModel,this.point.pos);
         this.dogModel.execAction(new PosMoveAction(ActionXMLInfo.getInfo(10020),this.point.pos,false));
         this.dogModel.addEventListener(MoveEvent.MOVE_END,this.dogMoveEndHandler);
         this.point.pos = new Point(1974,809);
         CityMap.instance.tranChangeMap(this.point);
         MainManager.actorModel.addEventListener(MoveEvent.MOVE_END,this.endToTarget3Handler);
      }
      
      private function endToTarget3Handler(param1:MoveEvent) : void
      {
         MainManager.actorModel.removeEventListener(MoveEvent.MOVE_END,this.endToTarget3Handler);
         MainManager.openOperate();
         MouseController.instance.init();
      }
      
      private function dogMoveEndHandler(param1:MoveEvent) : void
      {
         this.dogModel.removeEventListener(MoveEvent.MOVE_END,this.dogMoveEndHandler);
         this.dogModel.execAction(new BaseAction(ActionXMLInfo.getInfo(20008)));
         this.replaceMcs[2].gotoAndPlay(2);
         this.replaceMcs[2].addEventListener(MouseEvent.CLICK,this.clickHua3Handler);
      }
      
      private function clickHua3Handler(param1:MouseEvent) : void
      {
         UserManager.remove(DOG_RES_ID);
         _mapModel.contentLevel.removeChild(this.dogModel);
         this.replaceMcs[2].removeEventListener(MouseEvent.CLICK,this.clickHua3Handler);
         this.replaceMcs[2].gotoAndPlay(3);
         this.replaceMcs[2].addEventListener(Event.ENTER_FRAME,this.checkEndHandler);
      }
      
      private function resetView(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(_mapModel.contentLevel.getChildIndex(this.replaceMcs[param1]));
         _mapModel.contentLevel.removeChild(this.replaceMcs[param1]);
         _mapModel.contentLevel.addChildAt(this.replacedMcs[param1],_loc2_);
      }
      
      override public function destroy() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.switchCompleteHandler);
         if(this.loader)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loaderCompleteHandler);
            if(this.dogModel)
            {
               this.dogModel.removeEventListener(MoveEvent.MOVE_END,this.dogMoveEndHandler);
            }
            if(Boolean(this.replaceMcs) && this.replaceMcs.length > 2)
            {
               this.replaceMcs[0].removeEventListener(MouseEvent.CLICK,this.clickHua1Handler);
               this.replaceMcs[1].removeEventListener(MouseEvent.CLICK,this.clickHua2Handler);
               this.replaceMcs[2].removeEventListener(MouseEvent.CLICK,this.clickHua3Handler);
            }
            this.yanMc = null;
         }
         this.loader = null;
         _mapModel = null;
      }
   }
}

