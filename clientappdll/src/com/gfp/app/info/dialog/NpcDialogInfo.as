package com.gfp.app.info.dialog
{
   import com.gfp.core.Constant;
   import com.gfp.core.config.xml.RoleXMLInfo;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.utils.Logger;
   
   public class NpcDialogInfo
   {
      
      public var npcID:uint;
      
      public var resort:Boolean;
      
      public var npcName:String;
      
      public var firstDialog:DialogInfo;
      
      public var normalDialogs:Array;
      
      public var shopDialogs:Array;
      
      public var minigameDialogs:Array;
      
      public var tollgateDialogs:Array;
      
      public var pvpDialogs:Array;
      
      public var sellDialogs:Array;
      
      public var repairDialogs:Array;
      
      public var taskAccepts:Array;
      
      public var taskProcess:Array;
      
      public var taskOvers:Array;
      
      public var appDialogs:Array;
      
      public var actAmbaDialogs:Array;
      
      public var customDialogs:Array;
      
      public var gotoTowerDialogs:Array;
      
      public var pageUrlDialogs:Array;
      
      public var goToMapDialogs:Array;
      
      public var dailyActivityDialogs:Array;
      
      public var optionsArray:Array;
      
      public var resID:uint;
      
      public function NpcDialogInfo(param1:XML)
      {
         var _loc3_:XML = null;
         var _loc5_:XML = null;
         var _loc22_:XMLList = null;
         var _loc23_:XMLList = null;
         var _loc24_:XMLList = null;
         var _loc25_:XMLList = null;
         var _loc26_:XMLList = null;
         var _loc27_:XMLList = null;
         var _loc28_:XMLList = null;
         var _loc29_:XMLList = null;
         var _loc30_:XMLList = null;
         var _loc31_:XMLList = null;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:XML = null;
         var _loc35_:XML = null;
         var _loc36_:XMLList = null;
         var _loc37_:XMLList = null;
         var _loc38_:XMLList = null;
         var _loc39_:XMLList = null;
         super();
         this.npcID = uint(param1.@id);
         this.resort = Boolean(String(param1.@resort));
         this.npcName = String(param1.@name);
         this.resID = RoleXMLInfo.getResID(this.npcID);
         var _loc2_:XMLList = param1.elements("first");
         if(_loc2_.length() > 0)
         {
            this.firstDialog = new DialogInfo(_loc2_[0]);
         }
         var _loc4_:XMLList = param1.elements("normal");
         this.normalDialogs = new Array();
         for each(_loc3_ in _loc4_)
         {
            this.normalDialogs.push(new DialogInfo(_loc3_));
         }
         _loc5_ = param1.elements("shop")[0];
         this.shopDialogs = new Array();
         if(_loc5_ != null)
         {
            _loc22_ = _loc5_.elements("pnode");
            for each(_loc3_ in _loc22_)
            {
               this.addDialogArr(this.shopDialogs,_loc3_.@roleType,new DialogShopInfo(_loc3_));
            }
         }
         var _loc6_:XML = param1.elements("minigame")[0];
         this.minigameDialogs = new Array();
         if(_loc6_ != null)
         {
            _loc23_ = _loc6_.elements("pnode");
            for each(_loc3_ in _loc23_)
            {
               this.addDialogArr(this.minigameDialogs,_loc3_.@roleType,new DialogMinigameInfo(_loc3_));
            }
         }
         var _loc7_:XML = param1.elements("tollgate")[0];
         this.tollgateDialogs = new Array();
         if(_loc7_ != null)
         {
            _loc24_ = _loc7_.elements("pnode");
            for each(_loc3_ in _loc24_)
            {
               this.addDialogArr(this.tollgateDialogs,_loc3_.@roleType,new DialogTollgateInfo(_loc3_));
            }
         }
         var _loc8_:XML = param1.elements("pvp")[0];
         this.pvpDialogs = new Array();
         if(_loc8_ != null)
         {
            _loc25_ = _loc8_.elements("pnode");
            for each(_loc3_ in _loc25_)
            {
               this.addDialogArr(this.pvpDialogs,_loc3_.@roleType,new DialogPvPInfo(_loc3_));
            }
         }
         var _loc9_:XML = param1.elements("sell")[0];
         this.sellDialogs = new Array();
         if(_loc9_ != null)
         {
            _loc26_ = _loc9_.elements("pnode");
            for each(_loc3_ in _loc26_)
            {
               this.addDialogArr(this.sellDialogs,_loc3_.@roleType,new DialogSellInfo(_loc3_));
            }
         }
         var _loc10_:XML = param1.elements("repair")[0];
         this.repairDialogs = new Array();
         if(_loc10_ != null)
         {
            _loc27_ = _loc10_.elements("pnode");
            for each(_loc3_ in _loc27_)
            {
               this.addDialogArr(this.repairDialogs,_loc3_.@roleType,new DialogRepairInfo(_loc3_));
            }
         }
         var _loc11_:XML = param1.elements("taskAccept")[0];
         this.taskAccepts = new Array();
         if(_loc11_ != null)
         {
            _loc28_ = _loc11_.elements("task");
            for each(_loc3_ in _loc28_)
            {
               this.taskAccepts.push(new DialogTaskInfo(_loc3_,DialogTaskInfo.TYPE_ACCEPT));
            }
         }
         var _loc12_:XML = param1.elements("taskProcess")[0];
         this.taskProcess = new Array();
         if(_loc12_ != null)
         {
            _loc29_ = _loc12_.elements("task");
            for each(_loc3_ in _loc29_)
            {
               this.taskProcess.push(new DialogTaskInfo(_loc3_,DialogTaskInfo.TYPE_PROCESS));
            }
         }
         var _loc13_:XML = param1.elements("taskOver")[0];
         this.taskOvers = new Array();
         if(_loc13_ != null)
         {
            _loc30_ = _loc13_.elements("task");
            for each(_loc3_ in _loc30_)
            {
               this.taskOvers.push(new DialogTaskInfo(_loc3_,DialogTaskInfo.TYPE_OVER));
            }
         }
         var _loc14_:XML = param1.elements("app")[0];
         this.appDialogs = new Array();
         if(_loc14_ != null)
         {
            _loc31_ = _loc14_.elements("node");
            for each(_loc3_ in _loc31_)
            {
               this.addDialogArr(this.appDialogs,_loc3_.@roleType,new DialogAppInfo(_loc3_));
            }
         }
         var _loc15_:XML = param1.elements("activeAmbassador")[0];
         this.actAmbaDialogs = new Array();
         if(_loc15_ != null)
         {
            this.addDialogArr(this.actAmbaDialogs,_loc15_.@roleType,new DialogActAmbaInfo(_loc15_.elements("node")[0]));
         }
         var _loc16_:XML = param1.elements("custom")[0];
         this.customDialogs = new Array();
         if(_loc16_)
         {
            _loc32_ = _loc16_.elements("pnode").length();
            _loc33_ = 0;
            while(_loc33_ < _loc32_)
            {
               _loc34_ = _loc16_.elements("pnode")[_loc33_];
               this.addDialogArr(this.customDialogs,_loc34_.@roleType,new DialogCustomInfo(_loc34_));
               _loc33_++;
            }
         }
         var _loc17_:XML = param1.elements("gotoTower")[0];
         this.gotoTowerDialogs = new Array();
         if(_loc17_)
         {
            _loc35_ = _loc17_.elements("pnode")[0];
            this.addDialogArr(this.gotoTowerDialogs,_loc35_.@roleType,new DialogGotoTowerInfo(_loc35_));
         }
         var _loc18_:XML = param1.elements("pageUrl")[0];
         this.pageUrlDialogs = new Array();
         if(_loc18_)
         {
            _loc36_ = _loc18_.elements("node");
            for each(_loc3_ in _loc36_)
            {
               this.addDialogArr(this.pageUrlDialogs,_loc3_.@roleType,new DialogPageUrlInfo(_loc3_));
            }
         }
         var _loc19_:XML = param1.elements("gotoMap")[0];
         this.goToMapDialogs = new Array();
         if(_loc19_)
         {
            _loc37_ = _loc19_.elements("node");
            for each(_loc3_ in _loc37_)
            {
               this.addDialogArr(this.goToMapDialogs,_loc3_.@roleType,new DialogGoToMapInfo(_loc3_));
            }
         }
         var _loc20_:XML = param1.elements("activityExchange")[0];
         this.dailyActivityDialogs = new Array();
         if(_loc20_ != null)
         {
            _loc38_ = _loc20_.elements("pnode");
            for each(_loc3_ in _loc38_)
            {
               this.addDialogArr(this.dailyActivityDialogs,_loc3_.@roleType,new DialogActivityExchangeInfo(_loc3_));
            }
         }
         var _loc21_:XML = param1.elements("options")[0];
         this.optionsArray = new Array();
         if(_loc21_ != null)
         {
            _loc39_ = _loc21_.elements("option");
            for each(_loc3_ in _loc39_)
            {
               this.optionsArray.push(new DialogOptionsInfo(_loc3_));
            }
         }
      }
      
      private function addDialogArr(param1:Array, param2:String, param3:Object) : void
      {
         if(param2 == "" || param2 == null)
         {
            Logger.info(this,"++++++++++" + param3 + "角色类型信息为空");
         }
         if(this.isRoleRight(param2))
         {
            param1.push(param3);
         }
      }
      
      private function isRoleRight(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split(Constant.CHAR_LINE);
         if(_loc2_[0] == 0)
         {
            return true;
         }
         return _loc2_.indexOf(MainManager.roleType.toString()) != -1;
      }
   }
}

