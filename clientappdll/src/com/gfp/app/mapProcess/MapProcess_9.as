package com.gfp.app.mapProcess
{
   import com.gfp.app.info.dialog.DialogInfoSimple;
   import com.gfp.app.npcDialog.NpcDialogController;
   import com.gfp.app.storyProcess.StoryProcess_1;
   import com.gfp.core.manager.ItemManager;
   import com.gfp.core.manager.SightManager;
   import com.gfp.core.manager.TasksManager;
   import com.gfp.core.map.CityMap;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MapProcess_9 extends MapProcessAnimat
   {
      
      private var _pot0:MovieClip;
      
      private var _pot1:MovieClip;
      
      private var _npc10015:SightModel;
      
      public function MapProcess_9()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:int = 2;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _mapModel.downLevel["pot" + _loc2_];
            addSimpleClickAnimat(_loc3_);
            _loc2_++;
         }
         if(TasksManager.isAccepted(12))
         {
            this._pot0 = _mapModel.downLevel["pot0"];
            this._pot1 = _mapModel.downLevel["pot1"];
            this._pot0.addEventListener(MouseEvent.CLICK,this.onPotFind);
            this._pot1.addEventListener(MouseEvent.CLICK,this.onPotFind);
         }
         if(StoryProcess_1.instance.validate)
         {
            this.initNpc10015();
         }
      }
      
      private function initNpc10015() : void
      {
         this._npc10015 = SightManager.getSightModel(10015);
         this._npc10015.addEventListener("click",this.onNpc10015Click);
      }
      
      private function onNpc10015Click(param1:Event) : void
      {
         if(StoryProcess_1.instance.step <= StoryProcess_1.CHECK_STEP_1)
         {
            this.stepFunc_1();
            StoryProcess_1.instance.step = StoryProcess_1.CHECK_STEP_1;
            StoryProcess_1.instance.flushSO({"step":StoryProcess_1.CHECK_STEP_1});
         }
         else if(StoryProcess_1.instance.step == StoryProcess_1.CHECK_STEP_2)
         {
            this.stepFunc_2();
         }
         else
         {
            this._npc10015.removeEventListener("click",this.onNpc10015Click);
         }
      }
      
      private function stepFunc_1() : void
      {
         var _loc1_:String = "我得到了一块非常好的宝石。别看它上面蒙满了尘埃，经过我的鉴定，这是块非常久远充满灵力的宝石。";
         var _loc2_:String = "但这些尘埃，我想了无数办法也无法去除。小侠士，你能帮我想想办法吗？我会把宝石的记忆统统告诉你。";
         var _loc3_:DialogInfoSimple = new DialogInfoSimple([_loc1_,_loc2_],"我去找找药师爷爷吧，希望他会有合适的试剂。");
         NpcDialogController.showForSimple(_loc3_,10015,this.onNpc10015Dialog_step1);
      }
      
      private function stepFunc_2() : void
      {
         var _loc1_:String = "制造<font color=\'#ff0000\'>寒冰桶</font>的代价非常高，我只能每天提供给你<font color=\'#ff0000\'>两个</font>。记住，只有每天的<font color=\'#ff0000\'>12:00~13:00,19:00~20:00</font>，寒冰潭水才会涌动上来。";
         var _loc2_:String = "打寒冰水也不是那么容易的，你必须经过打水试炼，试炼的成败决定你能获得多少寒冰水，一切就靠你了，小侠士！";
         var _loc3_:DialogInfoSimple = new DialogInfoSimple([_loc1_,_loc2_],"当然没问题！");
         NpcDialogController.showForSimple(_loc3_,10015,this.onNpc10015Dialog_step2);
      }
      
      private function onNpc10015Dialog_step1() : void
      {
         CityMap.instance.changeMap(5,0,1,new Point(508,388));
      }
      
      private function onNpc10015Dialog_step2() : void
      {
         StoryProcess_1.instance.step == StoryProcess_1.CHECK_STEP_3;
         StoryProcess_1.instance.flushSO({"step":StoryProcess_1.CHECK_STEP_3});
         this._npc10015.removeEventListener("click",this.onNpc10015Click);
      }
      
      private function onPotFind(param1:MouseEvent) : void
      {
         if(ItemManager.getItemCount(1400002) < 4)
         {
            ItemManager.buyItem(1400002,false,2);
            MovieClip(param1.currentTarget).removeEventListener(MouseEvent.CLICK,this.onPotFind);
         }
      }
      
      override public function destroy() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:int = 2;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _mapModel.downLevel["pot" + _loc2_];
            removeSimpleClickAnimat(_loc3_);
            _loc3_ = null;
            _loc2_++;
         }
         if(this._pot1)
         {
            this._pot1.removeEventListener(MouseEvent.CLICK,this.onPotFind);
            this._pot1 = null;
         }
         if(this._pot0)
         {
            this._pot0.removeEventListener(MouseEvent.CLICK,this.onPotFind);
            this._pot0 = null;
         }
         super.destroy();
      }
   }
}

