package com.croco2d.screens
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.GameObject;
	
	import starling.events.Event;

	public class SceneScreen extends CrocoScreen
	{
		public var scene:GameObject

		public function SceneScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(scene)
			{
				scene.dispose();
				scene = null;
			}
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			if(!scene)
			{
				scene = createScene();
			}
			
			if(scene)
			{
				onActiveScene();
			}
		}
		
		protected function onActiveScene():void
		{
			CrocoEngine.instance.setRootGameObject(scene);
		}
		
		protected function onDeactiveScene():void
		{
			scene.deactive();
			
			CrocoEngine.instance.setRootGameObject(null);
		}
		
		protected function createScene():GameObject
		{
			var scene:GameObject = GameObject.createEmpty();
			scene.name = this.screenID;
			
			return scene;
		}
		
		override protected function screen_addedToStageHandler(event:Event):void
		{
			super.screen_addedToStageHandler(event);

			if(scene)
			{
				onActiveScene();
			}
		}
		
		override protected function screen_removedFromStageHandler(event:Event):void
		{
			if(scene)
			{
				onDeactiveScene();
			}
		}
	}
}