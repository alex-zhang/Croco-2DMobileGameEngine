package com.croco2dMGE.utils.bt
{
	/** 
 	 * A simple task that always, immediately, returns true.
 	 */
	public class SuccessBTNode extends BTNode
	{
		public function SuccessBTNode()
		{
			super();
		}
	
		public override function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			return BTNodeResult.TRUE;
		}
	}
}