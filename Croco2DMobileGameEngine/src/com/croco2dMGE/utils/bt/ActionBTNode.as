package com.croco2dMGE.utils.bt
{
	public class ActionBTNode extends BTNode
	{
		public function ActionBTNode()
		{
			super();
		}

		override public function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			return BTNodeResult.TRUE;
		}
	}
}