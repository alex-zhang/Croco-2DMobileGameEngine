package com.croco2d.tmx.scene.ornaments
{
	

	public class OrtAnimationSetSpriteEntity //extends CrocoGameObject
	{
		public function OrtAnimationSetSpriteEntity()
		{
			super();
		}
		
//		override protected function onInit():void
//		{
//			//==================================================================
//			//tmxPropertityParms：
//			//1. assetPath : 场景相对路径
//			//	 format ：path/a.anisetres
//			//			 path/a.anisetres:animationName
//			//	  如果后面指定动画名则播放指定动画，否则播放默认第一个动画
//			//
//			//==================================================================
//
//			//assets
//			var assetPath:String = propertyBag.read("assetPath");
//			var assetsManager:CrocoAssetsManager = scene.assetsManager;
//
//			var animationName:String;
//			if(assetPath.indexOf(":"))
//			{
//				var assetPathArr:Array = assetPath.split(":")
//				assetPath = assetPathArr[0];
//				animationName = assetPathArr[1];
//			}
//			
//			assetPath = AppConfig.findScreenResourcePath(scene.name, assetPath);
//			var animationSetAsset:AnimationSetAsset = assetsManager.getAniSetResAsset(assetPath);
//			
//			var animationSetSprite:AnimationSetSprite = new AnimationSetSprite();
//			animationSetSprite.animationSetInfo = animationSetAsset.animationSetInfo;
//			if(!animationName) animationName = animationSetAsset.animationSetInfo.defaultAniamtionName;
//			animationSetSprite.gotoAndPlay(animationName, true);
//			
//			//display component.
//			var displayComponent:DisplayComponent = new DisplayComponent();
//			displayComponent.displayObject = animationSetSprite;
//			
//			initComponents = [displayComponent];
//			
//			super.onInit();
//		}
	}
}