package com.croco2d.utils.tmx.scene
{
	public class TMXImageLayer extends TMXBasicLayer
	{
//		public var tmxImageSource:String;
//		
//		protected var mBackgroundImage:CrocoImage;
//		
//		public function TMXImageLayer()
//		{
//			super();
//		}
//		
//		override public function deserialize(xml:XML):void
//		{
//			super.deserialize(xml);
//			
//			//must has the image XML tag.
//			var imageXML:XML = xml.image[0];
//			tmxImageSource = imageXML.@source;
//		}
//		
//		override public function addChild(child:CrocoObject):CrocoObject
//		{
//			throw new Error("TMXImageLayer:: U can not add any things to this layer.");
//		}
//		
//		override protected function onInit():void
//		{
//			super.onInit();
//			
//			var assetsManager:CrocoAssetsManager = scene.screen.screenPreLoadAssetsManager;
//			
//			var assetURL:String = AppConfig.findTargetScenePathResource(scene.name, tmxImageSource);
//			
//			mBackgroundImage = new CrocoImage();
//			mBackgroundImage.texture = assetsManager.getImageAsset(assetURL).texture;
//		}
//		
//		override public function draw(support:RenderSupport, parentAlpha:Number):void
//		{
//			mBackgroundImage.x = int(-CrocoEngine.camera.scrollX * scrollFactorX);
//			mBackgroundImage.y = int(-CrocoEngine.camera.scrollY * scrollFactorY);
//			
//			//render
//			support.pushMatrix();
//			support.transformMatrix(mBackgroundImage);
//			mBackgroundImage.render(support, parentAlpha * layerAlpha);
//			support.popMatrix();
//		}
//		
//		override public function dispose():void
//		{
//			super.dispose();
//			
//			if(mBackgroundImage)
//			{
//				mBackgroundImage.dispose();
//				mBackgroundImage = null;
//			}
//		}
	}
}