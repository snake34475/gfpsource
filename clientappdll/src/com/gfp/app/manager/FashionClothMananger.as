package com.gfp.app.manager
{
   import com.gfp.app.toolBar.HeadSelfPanel;
   import com.gfp.core.controller.CameraController;
   import com.gfp.core.manager.MainManager;
   import com.gfp.core.manager.SummonManager;
   import com.gfp.core.map.MapManager;
   import com.gfp.core.model.MapModel;
   
   public class FashionClothMananger
   {
      
      private static var _instance:FashionClothMananger;
      
      public function FashionClothMananger()
      {
         super();
      }
      
      public static function get instance() : FashionClothMananger
      {
         if(_instance == null)
         {
            _instance = new FashionClothMananger();
         }
         return _instance;
      }
      
      public function resetActorModel() : void
      {
         var _loc1_:MapModel = MapManager.currentMap;
         var _loc2_:CameraController = _loc1_.camera;
         MainManager.deleteActor();
         MainManager.creatActor();
         _loc2_.init(_loc1_,MainManager.actorModel,_loc2_.totalArea);
         HeadSelfPanel.instance.init(MainManager.actorModel);
         HeadSelfPanel.instance.show();
         _loc1_.contentLevel.addChild(MainManager.actorModel);
         SummonManager.setupUserSummonInfo(MainManager.actorID,SummonManager.getActorSummonInfo());
      }
   }
}

