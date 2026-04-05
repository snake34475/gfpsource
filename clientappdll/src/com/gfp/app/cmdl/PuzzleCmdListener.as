package com.gfp.app.cmdl
{
   import com.gfp.app.control.PuzzleControl;
   import com.gfp.app.time.CutDownTimePanel;
   import com.gfp.core.CommandID;
   import com.gfp.core.config.ClientConfig;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.ModuleManager;
   import com.gfp.core.manager.NumberManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.greensock.TweenLite;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.bean.BaseBean;
   import org.taomee.net.SocketEvent;
   
   public class PuzzleCmdListener extends BaseBean
   {
      
      private var _effectLoc:Array = [new Point(1254,236),new Point(2073,571),new Point(962,962),new Point(282,480)];
      
      private var _effectPool:Array;
      
      private const MAX_ROUND:uint = 25;
      
      private var _timeID:uint;
      
      public function PuzzleCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PUZZLE_START,this.onPuzzleStart);
         SocketConnection.addCmdListener(CommandID.PUZZLE_ROUND_START,this.onPuzzleRoundStart);
         SocketConnection.addCmdListener(CommandID.PUZZLE_ROUND_END,this.onPuzzleRoundEnd);
         finish();
      }
      
      private function onPuzzleStart(param1:SocketEvent) : void
      {
         PuzzleControl.instance.rightTime = 0;
         PuzzleControl.instance.round = 0;
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ <= 30)
         {
            TextAlert.show("智力大比拼马上开始，小侠士们请做好准备。");
         }
         CutDownTimePanel.initDetailTime(_loc3_,MainManager.actorInfo.mapID);
      }
      
      private function onPuzzleRoundStart(param1:SocketEvent) : void
      {
         var _loc6_:int = 0;
         if(this._effectPool == null)
         {
            this._effectPool = [];
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
               this._effectPool.push(new MovieClip());
               MapManager.currentMap.upLevel.addChild(this._effectPool[_loc6_]);
               _loc6_++;
            }
         }
         var _loc2_:ByteArray = param1.data as ByteArray;
         _loc2_.position = 0;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = 0;
         PuzzleControl.instance.currentPuzzleID = _loc4_;
         PuzzleControl.instance.round = _loc3_;
         ModuleManager.getModule("PuzzleOptionPanel","").hide();
         ModuleManager.turnAppModule("PuzzleOptionPanel","...",{
            "QID":_loc4_,
            "dExp":_loc5_
         });
      }
      
      private function onPuzzleRoundEnd(param1:SocketEvent) : void
      {
         var _loc2_:ByteArray = param1.data as ByteArray;
         var _loc3_:uint = _loc2_.readUnsignedInt();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc5_:uint = _loc2_.readUnsignedInt();
         var _loc6_:uint = _loc2_.readUnsignedInt();
         var _loc7_:uint = _loc2_.readUnsignedInt();
         var _loc8_:uint = _loc2_.readUnsignedInt();
         var _loc9_:uint = _loc2_.readUnsignedInt();
         PuzzleControl.instance.round = _loc3_;
         PuzzleControl.instance.setTeamPass(_loc7_);
         this.addEffect(_loc5_);
         if(_loc5_ == _loc6_)
         {
            PuzzleControl.instance.rightTime += 1;
            this.addExpCoins(_loc8_,_loc9_);
            TextAlert.show("恭喜你小侠士，回答正确！");
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PUZZLE_RIGHT,"");
         }
         else if(_loc7_ == 1)
         {
            PuzzleControl.instance.rightTime += 1;
            this.addExpCoins(_loc8_,_loc9_);
            TextAlert.show("恭喜你小侠士，你由于组队获得了一次抵消错误答案的机会，本次当做回答正确!");
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PUZZLE_RIGHT,"");
         }
         else if(PuzzleControl.instance.isUseItem && ItemManager.getItemCount(1500572) > 0)
         {
            ItemManager.removeItem(1500572,1);
            PuzzleControl.instance.rightTime += 1;
            this.addExpCoins(_loc8_,_loc9_);
            TextAlert.show("恭喜你小侠士，回答正确！");
            TasksManager.dispatchActionEvent(TaskActionEvent.TASK_PUZZLE_RIGHT,"");
         }
         else
         {
            TextAlert.show("很遗憾小侠士，你回答错误了！");
            CutDownTimePanel.destroy();
            PuzzleControl.instance.puzzleMapUnLimit();
            CityMap.instance.changeMap(1,0,1,new Point(1815,888));
         }
         if(_loc3_ == this.MAX_ROUND)
         {
            PuzzleControl.instance.showSightModel();
         }
         PuzzleControl.instance.currentPuzzleID = 0;
         PuzzleControl.instance.setTipVisible();
      }
      
      private function addEffect(param1:int) : void
      {
         var _loc3_:Loader = null;
         var _loc2_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < 4)
         {
            while(this._effectPool[_loc4_].numChildren > 0)
            {
               this._effectPool[_loc4_].removeChildAt(0);
               this._effectPool[_loc4_].alpha = 1;
            }
            if(_loc4_ == param1 - 1)
            {
               _loc2_ = "questYes";
            }
            else
            {
               _loc2_ = "questNo";
            }
            _loc3_ = new Loader();
            _loc3_.load(new URLRequest(ClientConfig.getCartoon(_loc2_)));
            this._effectPool[_loc4_].x = this._effectLoc[_loc4_].x;
            this._effectPool[_loc4_].y = this._effectLoc[_loc4_].y;
            this._effectPool[_loc4_].addChild(_loc3_);
            TweenLite.to(this._effectPool[_loc4_],3,{
               "alpha":0,
               "y":this._effectPool[_loc4_].y - 100
            });
            _loc4_++;
         }
         setTimeout(this.onSignEnd,3000);
      }
      
      private function onSignEnd() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            while(this._effectPool[_loc1_].numChildren > 0)
            {
               this._effectPool[_loc1_].removeChildAt(0);
               this._effectPool[_loc1_].alpha = 1;
            }
            _loc1_++;
         }
      }
      
      private function addExpCoins(param1:uint, param2:uint) : void
      {
         if(MainManager.actorInfo.lv < 70)
         {
            MainManager.actorInfo.exp += param1;
            NumberManager.showExp(MainManager.actorModel,param1);
         }
         MainManager.actorInfo.coins += param2;
         NumberManager.showCoin(MainManager.actorModel,param2);
      }
   }
}

