package com.gfp.app.systems
{
   import flash.display.Shader;
   import flash.display.ShaderJob;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class BenderLoader extends EventDispatcher
   {
      
      private var KernelClass:Class = BenderLoader_KernelClass;
      
      private var result:ByteArray;
      
      private var shaderJob:ShaderJob;
      
      private var shader:Shader;
      
      public var fuckNum:Number;
      
      public var shitNum:Number;
      
      public function BenderLoader()
      {
         super();
      }
      
      public function load() : void
      {
         this.result = new this.KernelClass();
         this.result.readUTFBytes(6);
         this.result.readUTFBytes(9);
         this.fuckNum = this.result.readShort();
         this.shitNum = this.result.readShort();
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

