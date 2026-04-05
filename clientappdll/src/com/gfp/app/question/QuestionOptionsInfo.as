package com.gfp.app.question
{
   public class QuestionOptionsInfo
   {
      
      private var _title:String;
      
      private var _id:int;
      
      private var _optionArr:Array;
      
      private var _isMultipleSelect:Boolean;
      
      private var _ans:String;
      
      public function QuestionOptionsInfo(param1:XML)
      {
         var _loc5_:XML = null;
         super();
         this._id = param1.@id;
         this._title = param1.@name;
         this._isMultipleSelect = param1.@MultipleSelect == 1;
         this._ans = param1.@ans;
         this._optionArr = new Array();
         var _loc2_:XMLList = param1.elements("option");
         var _loc3_:uint = uint(_loc2_.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            this._optionArr.push({
               "index":_loc5_.@index,
               "lable":_loc5_.@lable
            });
            _loc4_++;
         }
      }
      
      public function get ans() : String
      {
         return this._ans;
      }
      
      public function get isMultipleSelect() : Boolean
      {
         return this._isMultipleSelect;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
      
      public function get optionArr() : Array
      {
         return this._optionArr;
      }
   }
}

