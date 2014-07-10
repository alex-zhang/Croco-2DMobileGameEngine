package com.croco2d.components.physics
{
	import com.croco2d.components.GameObjectComponent;
	import com.croco2d.components.TransformComponent;
	import com.croco2d.core.GameObject;
	
	import nape.constraint.ConstraintList;
	import nape.dynamics.ArbiterList;
	import nape.geom.AABB;
	import nape.geom.Vec2;
	import nape.geom.Vec3;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Compound;

	public class RigidbodyComponent extends GameObjectComponent
	{
		public var beginContactCallEnabled:Boolean = false;
		public var endContactCallEnabled:Boolean = false;
		
		public var __rigidbody:Body;
		public var __bodyType:BodyType = BodyType.DYNAMIC;//default
		public var __physicsSpaceComponent:PhysicsSpaceComponent;
		
		public var __allowMovement:Boolean = true;
		public var __allowRotation:Boolean = true;
		public var __angularVel:Number = 0.0;
		public var __compound:Compound;
		public var __disableCCD:Boolean = false;
		
		public var __transform:TransformComponent;
		
		public function RigidbodyComponent()
		{
			super();
			
			name = GameObject.PROP_RIGID_BODY;
		}

		public function get bodyType():BodyType
		{
			return __bodyType;
		}
		
		public function set bodyType(value:BodyType):void
		{
			if(__bodyType != value)
			{
				__bodyType = value;
				
				if(__rigidbody)
				{
					__rigidbody.type = __bodyType;
				}
			}
		}
		
		public function get physicsSpaceComponent():PhysicsSpaceComponent
		{
			return __physicsSpaceComponent;
		}
		
		public function set physicsSpaceComponent(value:PhysicsSpaceComponent):void
		{
			if(__physicsSpaceComponent != value)
			{
				__physicsSpaceComponent = value;
				
				if(__rigidbody)
				{
					__rigidbody.space = __physicsSpaceComponent.__physicsSpace;
				}
			}
		}
		
		public function get	allowMovement():Boolean
		{
			return __allowMovement;
		}
		
		public function set allowMovement(value:Boolean):void
		{
			if(__allowMovement != value)
			{
				__allowMovement = value;
				
				if(__rigidbody)
				{
					__rigidbody.allowMovement = __allowMovement;
				}
			}
		}
		
		public function get allowRotation():Boolean
		{
			return __allowRotation;
		}
		
		public function set allowRotation(value:Boolean):void
		{
			if(__allowRotation != value)
			{
				__allowRotation = value;
				
				if(__rigidbody)
				{
					__rigidbody.allowRotation = __allowRotation;
				}
			}
		}
		
		public function get angularVel():Number
		{
			return __angularVel;
		}
		
		public function set angularVel(value:Number):void
		{
			if(__angularVel != value)
			{
				__angularVel = value;
				
				if(__rigidbody)
				{
					__rigidbody.angularVel = __angularVel;
				}
			}
		}
		
		public function get arbiters():ArbiterList
		{
			return __rigidbody ? __rigidbody.arbiters : null;
		}
		
		public function get bounds():AABB
		{
			return __rigidbody ? __rigidbody.bounds : null;
		}
		
		public function get compound():Compound
		{
			return __compound;
		}
		
		public function set compound(value:Compound):void
		{
			if(__compound != value)
			{
				__compound = value;
				
				if(__rigidbody)
				{
					__rigidbody.compound = __compound;
				}
			}
		}
		
		public function get constraintMass():Number
		{
			return __rigidbody ? __rigidbody.constraintMass : 0;
		}
		
		public function get constraintVelocity():Vec3
		{
			return __rigidbody ? __rigidbody.constraintVelocity : null;
		}
		
		public function get constraints():ConstraintList
		{
			return __rigidbody ? __rigidbody.constraints : null;
		}
		
		public function get disableCCD():Boolean
		{
			return __disableCCD;
		}
		
		public function set disableCCD(value:Boolean):void
		{
			if(__disableCCD != value)
			{
				__disableCCD = value;

				if(__rigidbody)
				{
					__rigidbody.disableCCD = __disableCCD;
				}
			}
		}
		
		override protected function onInit():void
		{
			__transform = GameObject(owner).transform;
			
			__rigidbody = new Body(__bodyType, Vec2.weak(__transform.x, __transform.y));
			__rigidbody.allowMovement = __allowMovement;
			__rigidbody.allowRotation = __allowRotation;
			__rigidbody.angularVel = __angularVel;
			__rigidbody.compound = __compound;
			__rigidbody.disableCCD = __disableCCD;
			__rigidbody.space = __physicsSpaceComponent ? __physicsSpaceComponent.__physicsSpace : null;
			
			__rigidbody.userData.owner = this;//keep the ref.
		}
		
		override public function tick(deltaTime:Number):void
		{
			__transform.setPosition(__rigidbody.position.x, __rigidbody.position.y);
			__transform.rotation = __rigidbody.rotation;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__rigidbody)
			{
				__rigidbody.space = null;
				__rigidbody = null;
			}
		}
	}
}