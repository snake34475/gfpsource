package com.gfp.app.manager
{
   import com.gfp.core.events.SummonEvent;
   import com.gfp.core.events.TaskActionEvent;
   import com.gfp.core.info.SummonInfo;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.manager.TasksManager;
   import flash.utils.ByteArray;
   
   public class NewTitileActivityManager
   {
      
      private static var _inst:NewTitileActivityManager;
      
      private var _allBufID:uint = 5022;
      
      private var _turnBufID:uint = 5023;
      
      private var _allBufIDs:Array = [6334,6335,6336,6337,6338];
      
      private var _turnBufIDs:Array = [6339,6340,6341,6342,6343];
      
      private var _arr20:Array = [13,21,41,49,50,51,52,53,54,55,56,57,58,59,60,63,64,65,66,67];
      
      private var _arr32:Array = [4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35];
      
      private var _allStep:int;
      
      private var _allBuf:uint;
      
      private var _turnStep:int;
      
      private var _turnBuf:uint;
      
      private var _stageID:uint;
      
      private var _type:int;
      
      public function NewTitileActivityManager()
      {
         super();
      }
      
      public static function get inst() : NewTitileActivityManager
      {
         if(_inst == null)
         {
            _inst = new NewTitileActivityManager();
         }
         return _inst;
      }
      
      public function init() : void
      {
         TasksManager.accept(5022);
         TasksManager.accept(5023);
         if(!TasksManager.taskHash.getValue(5022))
         {
            TasksManager.addBufInfo(5022);
         }
         if(!TasksManager.taskHash.getValue(5023))
         {
            TasksManager.addBufInfo(5023);
         }
         this.getAllBuf();
         this.getTurnBuf();
         SummonManager.addEventListener(SummonEvent.SUMMON_BREAK,this.onBreak);
         SummonManager.addEventListener(SummonEvent.SUMMON_FEED,this.onBreak);
      }
      
      private function onBreak(param1:SummonEvent) : void
      {
         var _loc2_:SummonInfo = param1.data;
         if(_loc2_.quality >= 4 && this._turnStep == 4)
         {
            SummonManager.removeEventListener(SummonEvent.SUMMON_BREAK,this.onBreak);
            SummonManager.removeEventListener(SummonEvent.SUMMON_FEED,this.onBreak);
            TasksManager.taskComplete(this._turnBufIDs[4]);
            TasksManager.setTaskProStatus(5023,0,Math.pow(2,this._turnStep) - 1);
            TasksManager.accept(6343);
         }
      }
      
      private function getAllBuf() : void
      {
         var _loc1_:uint = uint(TasksManager.getTaskProStatus(this._allBufID,0));
         this._allStep = this.getCurStep(_loc1_);
         TasksManager.accept(this._allBufIDs[this._allStep - 1]);
         if(!TasksManager.taskHash.getValue(this._allBufIDs[this._allStep - 1]))
         {
            TasksManager.addBufInfo(this._allBufIDs[this._allStep - 1]);
         }
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(this._allBufIDs[this._allStep - 1],0);
         this._allBuf = _loc2_.readUnsignedInt();
      }
      
      private function getTurnBuf() : void
      {
         var _loc1_:uint = uint(TasksManager.getTaskProStatus(this._turnBufID,0));
         this._turnStep = this.getCurStep(_loc1_);
         TasksManager.accept(this._turnBufIDs[this._turnStep - 1]);
         if(!TasksManager.taskHash.getValue(this._turnBufIDs[this._turnStep - 1]))
         {
            TasksManager.addBufInfo(this._turnBufIDs[this._turnStep - 1]);
         }
         var _loc2_:ByteArray = TasksManager.getTaskProBytes(this._turnBufIDs[this._turnStep - 1],0);
         this._turnBuf = _loc2_.readUnsignedInt();
      }
      
      private function getCurStep(param1:uint) : uint
      {
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            if(!(1 << _loc2_ & param1))
            {
               return _loc2_ + 1;
            }
            _loc2_++;
         }
         return 1;
      }
      
      public function initEnterStage(param1:uint, param2:int) : void
      {
         this._stageID = param1;
         if(this._allStep == 5 && this._arr32.indexOf(param1) != -1 && param2 == 4 || this._turnStep == 1 && this._arr20.indexOf(param1) != -1 && param2 == 5)
         {
            TasksManager.addActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,null,this.onPassStage);
         }
         if(this._allStep == 5 && this._arr32.indexOf(param1) != -1 && param2 == 4)
         {
            this._type = 0;
         }
         else if(this._turnStep == 1 && this._arr20.indexOf(param1) != -1 && param2 == 5)
         {
            this._type = 1;
         }
      }
      
      private function onPassStage(param1:TaskActionEvent) : void
      {
         TasksManager.removeActionListener(TaskActionEvent.TASK_TOLLGATE_PASSED,null,this.onPassStage);
         var _loc2_:uint = uint(param1.param);
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:uint = 0;
         if(this._arr32.indexOf(_loc2_) != -1 && this._allStep == 5)
         {
            if(this._type == 0)
            {
               this._allBuf = 1 << this._arr32.indexOf(_loc2_) | this._allBuf;
               _loc3_.writeUnsignedInt(this._allBuf);
               _loc4_ = uint(this._allBufIDs[this._allStep - 1]);
               TasksManager.setTaskProBytes(_loc4_,0,_loc3_);
            }
         }
         else if(this._arr20.indexOf(_loc2_) != -1 && this._turnStep == 1)
         {
            if(this._type == 1)
            {
               this._turnBuf = 1 << this._arr20.indexOf(_loc2_) | this._turnBuf;
               _loc3_.writeUnsignedInt(this._turnBuf);
               _loc4_ = uint(this._turnBufIDs[this._turnStep - 1]);
               TasksManager.setTaskProBytes(_loc4_,0,_loc3_);
            }
         }
         if(this.checkCanGetPrize() && _loc4_ > 0)
         {
            TasksManager.taskComplete(_loc4_);
            this.setParentStep();
         }
      }
      
      private function setParentStep() : void
      {
         if(this._allStep == 5 && this._allBuf == 4294967295)
         {
            TasksManager.setTaskProStatus(5022,0,Math.pow(2,this._allStep) - 1);
         }
         else if(this._turnStep == 1 && this._turnBuf == Math.pow(2,20) - 1)
         {
            TasksManager.setTaskProStatus(5023,0,Math.pow(2,this._turnStep) - 1);
         }
      }
      
      private function checkCanGetPrize() : Boolean
      {
         if(this._allStep == 5)
         {
            return this._allBuf == 4294967295;
         }
         if(this._turnStep == 1)
         {
            return this._turnBuf == Math.pow(2,20) - 1;
         }
         return true;
      }
   }
}

