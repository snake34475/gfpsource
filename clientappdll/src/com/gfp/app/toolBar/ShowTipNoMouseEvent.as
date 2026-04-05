package com.gfp.app.toolBar
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import org.taomee.component.manager.PopUpManager;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ShowTipNoMouseEvent
   {
      
      private static var _container:Sprite;
      
      private static var _txt:TextField;
      
      private static var _bg:DisplayObject;
      
      private static var _map:HashMap;
      
      private static var _cx:Number;
      
      private static var _cy:Number;
      
      public function ShowTipNoMouseEvent()
      {
         super();
      }
      
      public static function setup(param1:DisplayObject) : void
      {
         _bg = param1;
         _map = new HashMap();
         _container = new Sprite();
         _container.mouseChildren = false;
         _container.mouseEnabled = false;
         _container.addChild(_bg);
         _txt = new TextField();
         _txt.multiline = true;
         _txt.autoSize = TextFieldAutoSize.LEFT;
         _txt.x = 2;
         _txt.y = 2;
         _container.addChild(_txt);
      }
      
      public static function onOver(param1:InteractiveObject, param2:String, param3:MouseEvent, param4:int = 120, param5:Boolean = true) : void
      {
         _map.add(param1,{
            "text":param2,
            "wordWrap":param5,
            "width":param4
         });
         var _loc6_:* = param3.currentTarget as InteractiveObject;
         var _loc7_:* = _map.getValue(_loc6_);
         if(_loc7_.wordWrap)
         {
            _txt.wordWrap = true;
            _txt.width = 120;
         }
         else
         {
            _txt.wordWrap = false;
         }
         _txt.width = _loc7_.width;
         _txt.htmlText = _loc7_.text;
         _bg.width = _txt.textWidth + 9;
         _bg.height = _txt.textHeight + 9;
         _txt.width = _txt.textWidth + 4;
         _txt.height = _txt.textHeight + 4;
         PopUpManager.showForMouse(_container,PopUpManager.TOP_RIGHT,5,-5);
         _cx = _container.x - param3.stageX;
         _cy = _container.y - param3.stageY;
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      public static function onOut() : void
      {
         DisplayUtil.removeForParent(_container);
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      private static function onMove(param1:MouseEvent) : void
      {
         _container.x = _cx + param1.stageX;
         _container.y = _cy + param1.stageY;
      }
   }
}

