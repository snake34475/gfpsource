package com.gfp.app.fight
{
   import com.gfp.core.CommandID;
   import com.gfp.core.config.xml.ItemXMLInfo;
   import com.gfp.core.info.RollInfo;
   import com.gfp.core.info.RollItemInfo;
   import com.gfp.core.info.item.SingleEquipInfo;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.LayerManager;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.UserManager;
   import com.gfp.core.model.UserModel;
   import com.gfp.core.net.SocketConnection;
   import com.gfp.core.ui.alert.TextAlert;
   import com.gfp.core.utils.ByteArrayUtil;
   import com.gfp.core.utils.TextFormatUtil;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class RollItemPanel
   {
      
      private static var _instance:RollItemPanel;
      
      private var _mainUI:Sprite;
      
      private var _rollItemMap:HashMap;
      
      public function RollItemPanel()
      {
         super();
         this._mainUI = new Sprite();
         this._mainUI.x = 210;
         this._mainUI.y = 430;
         this._rollItemMap = new HashMap();
         SocketConnection.addCmdListener(CommandID.TEAM_ROLL_GET_ITEM,this.onGetRollItem);
         SocketConnection.addCmdListener(CommandID.TEAM_ROLL_ITEM,this.onGetRollInfo);
      }
      
      public static function get instance() : RollItemPanel
      {
         if(_instance == null)
         {
            _instance = new RollItemPanel();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(_instance)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function addRoll(param1:RollInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.count)
         {
            this.addRoolItem(param1.rollItems[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addRoolItem(param1:RollItemInfo) : void
      {
         var _loc2_:RollItem = new RollItem(param1);
         this._rollItemMap.add(param1.rollID,_loc2_);
         this._mainUI.addChildAt(_loc2_,0);
         if(!this._mainUI.parent)
         {
            this.show();
         }
      }
      
      private function onGetRollItem(param1:SocketEvent) : void
      {
         var _loc9_:SingleEquipInfo = null;
         var _loc10_:String = null;
         var _loc2_:ByteArray = ByteArrayUtil.clone(param1.data as ByteArray);
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         var _loc6_:int = int(_loc2_.readUnsignedInt());
         var _loc7_:Boolean = _loc2_.readUnsignedInt() == 1;
         var _loc8_:String = ItemXMLInfo.getName(_loc5_);
         if(_loc4_ == MainManager.actorID)
         {
            if(_loc7_)
            {
               if(ItemXMLInfo.isEquipt(_loc5_))
               {
                  _loc9_ = new SingleEquipInfo();
                  _loc9_.itemID = _loc5_;
                  _loc9_.leftTime = _loc6_;
                  _loc9_.duration = int(ItemXMLInfo.getDuration(_loc5_)) * 50;
                  ItemManager.addEquip(_loc9_);
               }
               else
               {
                  ItemManager.addItem(_loc5_,1);
               }
               TextAlert.show("恭喜你摇到最大点获得了" + TextFormatUtil.getRedText(_loc8_) + "已放入你的背包！");
            }
            else
            {
               TextAlert.show("恭喜你摇到最大点获得了" + TextFormatUtil.getRedText(_loc8_) + "请在地图中拾取！");
            }
         }
         else
         {
            _loc10_ = this.getMemberName(_loc4_);
            if(_loc10_ == null)
            {
            }
            TextAlert.show(TextFormatUtil.getRedText(_loc10_) + "摇到最大点获得了" + TextFormatUtil.getRedText(_loc8_));
         }
      }
      
      private function onGetRollInfo(param1:SocketEvent) : void
      {
         var _loc7_:RollItem = null;
         var _loc2_:ByteArray = ByteArrayUtil.clone(param1.data as ByteArray);
         var _loc3_:int = int(_loc2_.readUnsignedInt());
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc5_:int = int(_loc2_.readUnsignedInt());
         if(_loc3_ == MainManager.actorID)
         {
            _loc7_ = this._rollItemMap.getValue(_loc4_);
            if((Boolean(_loc7_)) && _loc5_ != -1)
            {
               _loc7_.displayPoint(_loc5_);
            }
            else
            {
               _loc7_.destroy();
            }
         }
         var _loc6_:String = this.getMemberName(_loc3_);
         if(_loc6_ == null)
         {
         }
         if(_loc5_ == -1)
         {
            TextAlert.show(_loc6_ + "放弃了摇点");
         }
         else
         {
            TextAlert.show(_loc6_ + "摇到了" + _loc5_ + "点");
         }
      }
      
      private function getMemberName(param1:int) : String
      {
         var _loc2_:UserModel = UserManager.getModel(param1);
         var _loc3_:String = "";
         if(_loc2_)
         {
            _loc3_ = _loc2_.info.nick;
         }
         else
         {
            _loc3_ = FightOgreManager.getMemberInfo(param1).nick;
         }
         return _loc3_;
      }
      
      public function show() : void
      {
         LayerManager.topLevel.addChild(this._mainUI);
      }
      
      public function destroy() : void
      {
         var _loc4_:RollItem = null;
         this.hide();
         this.removeEvent();
         var _loc1_:Array = this._rollItemMap.getKeys();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._rollItemMap.getValue(_loc1_[_loc3_]);
            if(_loc4_)
            {
               DisplayUtil.removeForParent(_loc4_);
               _loc4_.destroy();
            }
            _loc3_++;
         }
         _instance = null;
         this._mainUI = null;
      }
      
      public function removeEvent() : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_ROLL_GET_ITEM,this.onGetRollItem);
         SocketConnection.removeCmdListener(CommandID.TEAM_ROLL_ITEM,this.onGetRollInfo);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI,false);
      }
   }
}

