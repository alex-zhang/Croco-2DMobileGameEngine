package com.croco2d.components.bt
{
	/** 
 	 * A simple task that always, immediately, returns false.
 	 */
	public class FailureBTNode extends BTNode
	{
		public function FailureBTNode()
		{
			super();
		}
	
		public override function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			return BTNodeResult.FALSE;
		}
	}
}