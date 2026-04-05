package sample.MEncrypt.vfs
{
   public class CheckPath
   {
      
      public static const PATH_VALID:String = "pathValid";
      
      public static const PATH_COMPONENT_DOES_NOT_EXIST:String = "pathComponentDoesNotExist";
      
      public static const PATH_COMPONENT_IS_NOT_DIRECTORY:String = "pathComponentIsNotDirectory";
      
      public function CheckPath()
      {
         super();
      }
   }
}

import sample.MEncrypt.vfs.CheckPath;
import sample.MEncrypt.vfs.FileHandle;
import sample.MEncrypt.vfs.IVFS;

