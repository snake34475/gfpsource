package com.gfp.app.mapConfigFun
{
   import com.gfp.core.map.IMapConfigFun;
   import com.gfp.core.model.sensemodels.SightModel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapXML_RandomMove implements IMapConfigFun
   {
      
      private var dx:int = 1;
      
      private var dy:int = 1;
      
      private var angle:Number = Math.random() * (2 * Math.PI);
      
      private var maxX:int;
      
      private var maxY:int;
      
      private var minX:int;
      
      private var minY:int;
      
      private var speed:int = 3;
      
      private var smMC:SightModel;
      
      public function MapXML_RandomMove()
      {
         super();
      }
      
      public function exec(param1:SightModel, param2:XML, param3:XMLList) : void
      {
         this.speed = param2.@speed;
         this.dx = this.speed;
         this.dy = this.speed;
         var _loc4_:Array = param2.@rect.split(",");
         this.maxX = param1.x + _loc4_[0] / 2;
         this.minX = param1.x - _loc4_[0] / 2;
         this.maxY = param1.y + _loc4_[1] / 2;
         this.minY = param1.y - _loc4_[1] / 2;
         this.smMC = param1;
         this.smMC.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      private function onAddToStage(param1:Event) : void
      {
         this.smMC.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.smMC.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.smMC.addEventListener(Event.ENTER_FRAME,this.enterFreameMove);
         this.smMC.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         this.smMC.removeEventListener(Event.ENTER_FRAME,this.enterFreameMove);
         this.smMC.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function enterFreameMove(param1:Event) : void
      {
         if(this.smMC.stage == null)
         {
            return;
         }
         this.smMC.x += Math.cos(this.angle) * this.dx;
         this.smMC.y += Math.sin(this.angle) * this.dy;
         if(this.smMC.x > this.maxX)
         {
            this.dx *= -1;
            this.smMC.x -= this.speed;
            this.chageAngle();
         }
         if(this.smMC.x < this.minX)
         {
            this.dx *= -1;
            this.smMC.x += this.speed;
         }
         if(this.smMC.y > this.maxY)
         {
            this.dy *= -1;
            this.smMC.y -= this.speed;
            this.chageAngle();
         }
         if(this.smMC.y < this.minY)
         {
            this.dy *= -1;
            this.smMC.y += this.speed;
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.chageAngle();
      }
      
      private function chageAngle() : void
      {
         this.angle = Math.random() * (2 * Math.PI);
         this.angle = this.angle < 1 ? 1 : this.angle;
      }
   }
}

