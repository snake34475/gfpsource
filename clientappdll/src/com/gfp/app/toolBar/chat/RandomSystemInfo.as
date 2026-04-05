package com.gfp.app.toolBar.chat
{
   import com.gfp.core.utils.NumberUtil;
   import flash.utils.setTimeout;
   
   public class RandomSystemInfo
   {
      
      public var msgArr:Array = [" 按Enter(回车键)可以快速聊天"," 按住shift键,然后点击背包里物品,可以把物品发送到聊天栏"];
      
      public function RandomSystemInfo()
      {
         super();
         setTimeout(this.randomSystemMsg,1000);
      }
      
      public function randomSystemMsg() : void
      {
         var _loc1_:int = int(NumberUtil.randRange(0,this.msgArr.length - 1));
         MultiChatPanel.instance.showSystemNotice(this.msgArr[_loc1_]);
         var _loc2_:int = int(NumberUtil.randRange(60000,320000));
         setTimeout(this.randomSystemMsg,_loc2_);
      }
   }
}

