package com.gfp.app.toolBar
{
   import com.gfp.core.CommandID;
   import com.gfp.core.info.ReceiveHornInfo;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.UIManager;
   import com.gfp.core.net.SocketConnection;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class HornPanel
   {
      
      private static var _instnace:HornPanel;
      
      public static const MAX_HORN_NUM:int = 3;
      
      private static const POS:int = 500;
      
      public static const user_horn:int = 1;
      
      public static const TYPE_EXPO:int = 1;
      
      public static const TYPE_USER:int = 2;
      
      private var _itemArr:Array;
      
      private var _mainUI:Sprite;
      
      private var _hornItemPoolArr:Array;
      
      public function HornPanel()
      {
         super();
         this._mainUI = UIManager.getSprite("com.gfp.app.toolBar.HornPanelMainUI");
         this._itemArr = new Array();
         this.initHornItemPool();
         this.initEvent();
      }
      
      public static function get instance() : HornPanel
      {
         if(_instnace == null)
         {
            _instnace = new HornPanel();
         }
         return _instnace;
      }
      
      private function initEvent() : void
      {
         SocketConnection.addCmdListener(CommandID.RECEIVE_HORN,this.onReceiveHorn);
      }
      
      private function onReceiveHorn(param1:SocketEvent) : void
      {
         var _loc2_:ReceiveHornInfo = param1.data as ReceiveHornInfo;
         this.showHorn(_loc2_);
      }
      
      private function showHorn(param1:ReceiveHornInfo) : void
      {
         var _loc3_:HornItem = null;
         Tick.instance.addCallback(this.onTick);
         if(this._itemArr.length >= MAX_HORN_NUM)
         {
            _loc3_ = this._itemArr.shift();
            _loc3_.receive();
            this.removeHoemItem(_loc3_);
         }
         var _loc2_:HornItem = this._hornItemPoolArr.shift();
         _loc2_.setInfo(param1);
         this._itemArr.push(_loc2_);
         _loc2_.y = POS;
         _loc2_.receive();
         this.realign();
      }
      
      private function realign() : void
      {
         var _loc2_:HornItem = null;
         var _loc1_:int = int(this._itemArr.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this._itemArr[_loc3_];
            _loc2_.x = 450;
            _loc2_.y = POS - (_loc1_ - _loc3_) * 22;
            if(_loc2_.parent == null)
            {
               LayerManager.uiLevel.addChildAt(_loc2_,0);
            }
            _loc3_++;
         }
      }
      
      public function show() : void
      {
         if(this._mainUI)
         {
            DisplayUtil.align(this._mainUI,null,AlignType.BOTTOM_RIGHT,new Point(-100,-60));
            LayerManager.topLevel.addChild(this._mainUI);
         }
      }
      
      private function initHornItemPool() : void
      {
         var _loc3_:HornItem = null;
         this._hornItemPoolArr = new Array();
         var _loc1_:int = 4;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new HornItem();
            _loc3_.mouseChildren = false;
            _loc3_.mouseEnabled = false;
            this._hornItemPoolArr.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function onTick(param1:int) : void
      {
         var _loc4_:HornItem = null;
         var _loc2_:int = int(this._itemArr.length);
         if(_loc2_ == 0)
         {
            Tick.instance.removeCallback(this.onTick);
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._itemArr[_loc3_];
            if(_loc4_)
            {
               if(_loc4_.isFinished)
               {
                  this._itemArr.splice(_loc3_,1);
                  this.removeHoemItem(_loc4_);
                  this.realign();
               }
               else
               {
                  _loc4_.setInvTime(param1);
               }
            }
            _loc3_++;
         }
      }
      
      private function removeHoemItem(param1:HornItem) : void
      {
         DisplayUtil.removeForParent(param1);
         param1.destroy();
         param1.receive();
         this._hornItemPoolArr.push(param1);
      }
      
      public function destroy() : void
      {
         var _loc2_:HornItem = null;
         super.destroy();
         SocketConnection.removeCmdListener(CommandID.RECEIVE_HORN,this.onReceiveHorn);
         Tick.instance.removeCallback(this.onTick);
         var _loc1_:int = int(this._itemArr.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this._itemArr[_loc3_];
            DisplayUtil.removeForParent(_loc2_);
            _loc2_.destroy();
            _loc3_++;
         }
      }
   }
}

