package sample.MEncrypt.vfs
{
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class InMemoryBackingStore extends EventDispatcher implements IBackingStore
   {
      
      private var filemap:Object = {};
      
      public function InMemoryBackingStore()
      {
         super();
      }
      
      public function get readOnly() : Boolean
      {
         return false;
      }
      
      public function getPaths() : Vector.<String>
      {
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc4_:* = 0;
         var _loc3_:Object = filemap;
         for(_loc4_ in _loc3_)
         {
            var _temp_1:* = _loc4_;
            _loc2_.push(_temp_1);
         }
         return _loc2_;
      }
      
      public function flush() : void
      {
      }
      
      public function deleteFile(param1:String) : void
      {
         delete filemap[param1];
      }
      
      public function addFile(param1:String, param2:ByteArray) : void
      {
         filemap[param1] = param2;
      }
      
      public function addDirectory(param1:String) : void
      {
         if(param1.lastIndexOf("/") == param1.length - 1 && param1.length > 1)
         {
            param1 = param1.slice(0,param1.length - 1);
         }
         filemap[param1] = null;
      }
      
      public function getFile(param1:String) : ByteArray
      {
         return filemap[param1];
      }
      
      public function isDirectory(param1:String) : Boolean
      {
         return filemap[param1] == null;
      }
      
      public function pathExists(param1:String) : Boolean
      {
         return filemap.hasOwnProperty(param1);
      }
   }
}

const §4§:*;

§__force_ordering_ns_4e902a51-5514-438c-838c-60e190109bb1§;

