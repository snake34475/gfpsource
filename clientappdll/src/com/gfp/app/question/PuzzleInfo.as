package com.gfp.app.question
{
   public class PuzzleInfo
   {
      
      public var qID:uint;
      
      public var qName:String = "";
      
      public var time:uint;
      
      public var options:Vector.<OptionInfo>;
      
      public function PuzzleInfo(param1:XML)
      {
         var _loc3_:XML = null;
         this.options = new Vector.<OptionInfo>();
         super();
         this.qID = uint(param1.@ID);
         this.qName = String(param1.@Name);
         this.time = uint(param1.@QuestionTime);
         var _loc2_:XMLList = param1.elements("Option");
         for each(_loc3_ in _loc2_)
         {
            this.options.push(new OptionInfo(_loc3_));
         }
      }
   }
}

