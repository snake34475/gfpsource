package com.gfp.app.npcDialog
{
   import com.gfp.app.info.dialog.DialogInfoMultiple;
   import com.gfp.app.info.dialogex.DialogExInfo;
   import com.gfp.core.map.CityMap;
   import flash.utils.Dictionary;
   
   public class DialogAdapter
   {
      
      public var npcId:int;
      
      public var info:DialogExInfo;
      
      private var currentInfo:DialogExInfo;
      
      private var callBack:Function;
      
      private var tempDic:Dictionary;
      
      public function DialogAdapter(param1:int, param2:DialogExInfo, param3:Function = null)
      {
         super();
         this.npcId = param1;
         this.info = param2;
         this.currentInfo = param2;
         this.callBack = param3;
      }
      
      private function calculateRandomInfo(param1:Vector.<DialogExInfo>, param2:Vector.<DialogExInfo>, param3:int) : void
      {
         var _loc7_:DialogExInfo = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:Number = NaN;
         var _loc4_:Number = Math.random();
         var _loc5_:Vector.<Number> = new Vector.<Number>();
         var _loc6_:Number = 0;
         for each(_loc7_ in param1)
         {
            _loc6_ += _loc7_.mass;
         }
         _loc8_ = 0;
         _loc9_ = int(param1.length);
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc12_ = param1[_loc10_].mass / _loc6_;
            _loc8_ += _loc12_;
            _loc5_.push(_loc8_);
            _loc10_++;
         }
         var _loc11_:int = 0;
         while(_loc11_ < _loc9_)
         {
            if(_loc4_ < _loc5_[_loc11_])
            {
               param2.push(param1[_loc11_]);
               param1.splice(_loc11_,1);
               break;
            }
            _loc11_++;
         }
         if(param2.length < param3)
         {
            this.calculateRandomInfo(param1,param2,param3);
         }
      }
      
      public function show() : void
      {
         var _loc4_:int = 0;
         var _loc5_:Vector.<DialogExInfo> = null;
         var _loc6_:Vector.<DialogExInfo> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         this.tempDic = null;
         var _loc1_:String = this.currentInfo.title;
         var _loc2_:Array = [];
         if(this.currentInfo.next)
         {
            if(this.currentInfo.next.select)
            {
               _loc2_.push(this.currentInfo.next.select);
            }
            else
            {
               _loc2_.push("-1");
            }
         }
         else
         {
            if(!this.currentInfo.children)
            {
               return;
            }
            if(this.currentInfo.showCount > 0)
            {
               this.tempDic = new Dictionary();
               _loc5_ = this.currentInfo.children.concat();
               _loc6_ = new Vector.<DialogExInfo>();
               this.calculateRandomInfo(_loc5_,_loc6_,this.currentInfo.showCount);
               _loc7_ = int(_loc6_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc9_ = this.currentInfo.children.indexOf(_loc6_[_loc8_]);
                  if(_loc9_ != -1)
                  {
                     this.tempDic[_loc8_] = _loc9_;
                     _loc2_.push(this.currentInfo.children[_loc9_].select);
                  }
                  _loc8_++;
               }
            }
            else
            {
               _loc10_ = int(this.currentInfo.children.length);
               _loc11_ = 0;
               while(_loc11_ < _loc10_)
               {
                  _loc2_.push(this.currentInfo.children[_loc11_].select);
                  _loc11_++;
               }
            }
         }
         var _loc3_:DialogInfoMultiple = new DialogInfoMultiple([_loc1_],_loc2_);
         if(this.currentInfo.npcID != 0)
         {
            _loc4_ = this.currentInfo.npcID;
         }
         else
         {
            _loc4_ = this.npcId;
         }
         if(this.currentInfo.next)
         {
            NpcDialogController.showForMultipleEx(_loc3_,_loc4_,this.onNextSelect);
         }
         else
         {
            NpcDialogController.showForMultipleEx(_loc3_,_loc4_,this.onChildrenSelect);
         }
      }
      
      private function onChildrenSelect(param1:int) : void
      {
         if(this.tempDic)
         {
            param1 = int(this.tempDic[param1]);
            this.tempDic = null;
         }
         this.currentInfo = this.currentInfo.children[param1];
         this.exeNext();
      }
      
      private function onNextSelect(param1:int) : void
      {
         this.currentInfo = this.currentInfo.next;
         this.exeNext();
      }
      
      private function exeNext() : void
      {
         if(this.currentInfo.tran)
         {
            CityMap.instance.tranChangeMapByStr(this.currentInfo.tran);
         }
         this.show();
         if(this.callBack != null)
         {
            this.callBack(this.currentInfo);
         }
      }
      
      public function destory() : void
      {
         this.currentInfo = null;
         this.info = null;
      }
   }
}

