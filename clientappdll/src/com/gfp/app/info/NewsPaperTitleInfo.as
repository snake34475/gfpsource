package com.gfp.app.info
{
   import com.gfp.core.utils.TextUtil;
   
   public class NewsPaperTitleInfo
   {
      
      public static const NORMAL:int = 0;
      
      public static const GRADE:int = 1;
      
      public static const AD:int = 2;
      
      public static const REGULAR:int = 10;
      
      public var titleName:String;
      
      public var type:int;
      
      public var index:int;
      
      public var isSelected:Boolean;
      
      public var url:String = "";
      
      public var action:String;
      
      public var params:Object;
      
      public function NewsPaperTitleInfo(param1:XML)
      {
         super();
         this.titleName = param1.@name;
         this.type = int(param1.@type);
         this.index = int(param1.@toIndex);
         this.action = param1.@action;
         this.params = TextUtil.parseJson(param1.@params);
      }
   }
}

