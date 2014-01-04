package com.croco2dMGE.utils.assets
{
	
	import com.croco2dMGE.AppConfig;
	
	import flash.utils.clearTimeout;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;

	public class CrocoAssetsManager
	{
		//type
		public static const TEXT_TYPE:String = "text";
		public static const XML_TYPE:String = "xml";
		public static const JSON_TYPE:String = "json";
		
		public static const SOUND_TYPE:String = "sound";
//		public static const VIDEO_TYPE:String = "video";
		
		public static const IMAGE_TYPE:String = "image";
		
		public static const EXCEL_DATA_REPOSITORY_TYPE:String = "excelDataRepository";
		
		public static const CORAL_DIR_PACK_RES_TYPE:String = "coralDirPackRes";
		public static const ANIMATION_SET_RES_TYPE:String = "animationSetRes";
		public static const SPRIT_SHEET_RES_TYPE:String = "spritsheetRes";
		public static const PARTICLE_SET_RES_TYPE:String = "particleSetRes";
		public static const BITMAP_FONT_RES_TYPE:String = "bitmapFontRes";
		
		public static const BINARY_TYPE:String = "binary";
		
		//tmx is tiled map editor export.
		public static const TEXT_EXTENSIONS:Array = ["txt", "ini", "text", "js", "php", "asp", "py"];
		public static const XML_TYPE_EXTENTION:Array = ["xml", "tmx", "pex", "fnt"];
		public static const JSON_TYPE_EXTENTION:Array = ["json"];
		
		public static const SOUND_TYPE_EXTENTION:Array = ["mp3", "f4a", "f4b"];
//		public static const VIDEO_TYPE_EXTENTION:Array = ["flv", "f4v", "f4p", "mp4"];
		
		public static const IMAGE_TYPE_EXTENTION:Array = ["jpg", "jpeg", "png", "atf"];
		
		public static const EXCEL_DATA_REPOSITORY_EXTENTION:String = "drp";
		
		public static const CORAL_DIR_PACK_RES_EXTENTION:String = "crdirpacres";
		public static const ANIMATION_SET_RES_EXTENTION:String = "anisetres";
		public static const SPRIT_SHEET_RES_EXTENTION:String = "sprsres";
		public static const PARTICLE_SET_RES_EXTENTION:String = "parsetres";
		public static const BITMAP_FONT_RES_EXTENTION:String = "bfntres";
		
		public static const BINARY_EXTENTION:String = "bin";//or other can'r read binary file.
		
		private static var mAssetsTypeClassMap:Array = [];//type->AssetTypeClass
		private static var mAssetsExtentionToTypeMap:Array = [];//extention->AssetTypeClass
		
		public static function registAssetTypeClass(assetType:String, typeClass:Class):void
		{
			mAssetsTypeClassMap[assetType] = typeClass;
		}
		
		public function unRegistAssetTypeClass(assetType:String):void
		{
			delete mAssetsTypeClassMap[assetType];
		}
		
		public static function getRegistedAssetTypeClsByType(assetType:String):Class
		{
			return mAssetsTypeClassMap[assetType];
		}
		
		public static function registAssetTypeExtention(assetType:String, extention:String):void
		{
			mAssetsExtentionToTypeMap[extention] = assetType;
		}
		
		public function unRegistAssetTypeExtention(extention:String):void
		{
			delete mAssetsExtentionToTypeMap[extention];
		}
		
		public static function getRegistedAssetTypeByExtention(extention:String):String
		{
			return mAssetsExtentionToTypeMap[extention];
		}
		
		//----------------------------------------------------------------------
		
		private var mTypedAssetsMap:Array;//assetType->[name->instance]
		
		private var mQueue:Array;
		private var mIsLoading:Boolean;
		private var mTimeoutID:uint;
		
		private var mLogEnable:Boolean = false;
		private var mScaleFactor:Number;
		private var mUseMipMaps:Boolean;
		private var mVerbose:Boolean;
		
		/** Create a new AssetManager. The 'scaleFactor' and 'useMipmaps' parameters define
		 *  how enqueued bitmaps will be converted to textures. */
		public function CrocoAssetsManager()
		{
			super();
			
			mVerbose = mIsLoading = false;
			mScaleFactor = AppConfig.assetsTextureScaleFactor > 0 ? 
				AppConfig.assetsTextureScaleFactor : Starling.contentScaleFactor;

			mUseMipMaps = AppConfig.assetsTextureUseMipmaps;
			
			mQueue = [];
			
			mTypedAssetsMap = [];
		}
		
		// properties
		
		/** The queue contains one 'Object' for each enqueued asset. Each object has 'asset'
		 *  and 'name' properties, pointing to the raw asset and its name, respectively. */
		protected function get queue():Array { return mQueue; }
		
		/** Returns the number of raw assets that have been enqueued, but not yet loaded. */
		public function get numQueuedAssets():int { return mQueue.length; }
		
		/** When activated, the class will trace information about added/enqueued assets. */
		public function get logEnable():Boolean { return mLogEnable; }
		public function set logEnable(value:Boolean):void { mLogEnable = value; }
		
		/** For bitmap textures, this flag indicates if mip maps should be generated when they 
		 *  are loaded; for ATF textures, it indicates if mip maps are valid and should be
		 *  used. */
		public function get useMipMaps():Boolean { return mUseMipMaps; }
		public function set useMipMaps(value:Boolean):void { mUseMipMaps = value; }
		
		/** Textures that are created from Bitmaps or ATF files will have the scale factor 
		 *  assigned here. */
		public function get scaleFactor():Number { return mScaleFactor; }
		public function set scaleFactor(value:Number):void { mScaleFactor = value; }
		
		public function dispose():void
		{
			clear();
			
			mTypedAssetsMap = null;
		}
		
		//helper
		public function getTEXTAsset(name:String):TextAsset
		{
			return getAssetByTypeAndName(TEXT_TYPE, name) as TextAsset;	
		}
		
		public function getXMLAsset(name:String):XMLAsset
		{
			return getAssetByTypeAndName(XML_TYPE, name) as XMLAsset;
		}
		
		public function getJSONAsset(name:String):JSONAsset
		{
			return getAssetByTypeAndName(JSON_TYPE, name) as JSONAsset;
		}
		
		public function getSoundAsset(name:String):SoundAsset
		{
			return getAssetByTypeAndName(SOUND_TYPE, name) as SoundAsset;
		}
		
		public function getImageAsset(name:String):ImageAsset
		{
			return getAssetByTypeAndName(IMAGE_TYPE, name) as ImageAsset;
		}
		
		public function getExcelDataRepositoryAsset(name:String):ExcelDataRepositoryAsset
		{
			return getAssetByTypeAndName(EXCEL_DATA_REPOSITORY_TYPE, name) as ExcelDataRepositoryAsset;
		}
		
		public function getAniSetResAsset(name:String):AnimationSetAsset
		{
			return getAssetByTypeAndName(ANIMATION_SET_RES_TYPE, name) as AnimationSetAsset;
		}
		
		public function getCoralDirPackAsset(name:String):CoralDirPackAsset
		{
			return getAssetByTypeAndName(CORAL_DIR_PACK_RES_TYPE, name) as CoralDirPackAsset;
		}
		
		public function getSpriteSheetAsset(name:String):SpriteSheetAsset
		{
			return getAssetByTypeAndName(SPRIT_SHEET_RES_TYPE, name) as SpriteSheetAsset;
		}
		
		public function getParticleSetAsset(name:String):ParticleSetAsset
		{
			return getAssetByTypeAndName(PARTICLE_SET_RES_TYPE, name) as ParticleSetAsset;
		}
		
		public function getBitmapFontAsset(name:String):BitmapFontAsset
		{
			return getAssetByTypeAndName(BITMAP_FONT_RES_TYPE, name) as BitmapFontAsset;
		}
		
		public function getBinaryAsset(name:String):BinaryAsset
		{
			return getAssetByTypeAndName(BINARY_TYPE, name) as BinaryAsset;
		}
		
		public function getAssetByTypeAndName(assetType:String, name:String):AssetBasic
		{
			var assetsTypeMap:Array = mTypedAssetsMap[assetType];
			if(!assetsTypeMap) return null;
			
			return assetsTypeMap[name];
		}
		
		public function addAssetByTypeAndName(assetType:String, name:String, instance:AssetBasic):void
		{
			var assetsTypeMap:Array = mTypedAssetsMap[assetType];
			if(!assetsTypeMap)
			{
				assetsTypeMap = mTypedAssetsMap[assetType] = [];
			}
			
			assetsTypeMap[name] = instance;
		}
		
		public function removeAssetByTypeAndName(assetType:String, name:String, dispose:Boolean = true):void
		{
			var assetsTypeMap:Array = mTypedAssetsMap[assetType];
			if(!assetsTypeMap) return;
			
			var instance:AssetBasic = assetsTypeMap[name];
			delete assetsTypeMap[name];
			
			if(dispose)
			{
				instance.dispose();
			}
		}
		
		//loading
		/** Empties the queue and aborts any pending load operations. */
		public function clearQueue():void
		{
			mIsLoading = false;
			mQueue.length = 0;
			clearTimeout(mTimeoutID);
		}
		
		/** Removes assets of all types, empties the queue and aborts any pending load operations.*/
		public function clear():void
		{
			log("Purging all assets, emptying queue");
			
			clearQueue();
			
			var assetType:String;
			var typedAssets:Array;
			var assetInstanceName:String;
			var assetInstace:AssetBasic;
			
			for(assetType in mTypedAssetsMap)
			{
				typedAssets = mTypedAssetsMap[assetType];
				
				for each(assetInstanceName in typedAssets)
				{
					assetInstace = typedAssets[assetInstanceName];
					
					assetInstace.dispose();
				}
			}
			
			mTypedAssetsMap = [];
		}
		
		
		// queued adding
		
		/** Enqueues one or more raw assets; they will only be available after successfully 
		 *  executing the "loadQueue" method. This method accepts a variety of different objects:
		 *  
		 *  <ul>
		 *    <li>Strings containing an URL to a local or remote resource. Supported types:
		 *        <code>png, jpg, gif, atf, mp3, xml, fnt, json, binary</code>.</li>
		 *    <li>Instances of the File class (AIR only) pointing to a directory or a file.
		 *        Directories will be scanned recursively for all supported types.</li>
		 *    <li>Classes that contain <code>static</code> embedded assets.</li>
		 *    <li>If the file extension is not recognized, the data is analyzed to see if
		 *        contains XML or JSON data. If it's neither, it is stored as ByteArray.</li>
		 *  </ul>
		 *  
		 *  <p>Suitable object names are extracted automatically: A file named "image.png" will be
		 *  accessible under the name "image". When enqueuing embedded assets via a class, 
		 *  the variable name of the embedded object will be used as its name. An exception
		 *  are texture atlases: they will have the same name as the actual texture they are
		 *  referencing.</p>
		 *  
		 *  <p>XMLs that contain texture atlases or bitmap fonts are processed directly: fonts are
		 *  registered at the TextField class, atlas textures can be acquired with the
		 *  "getTexture()" method. All other XMLs are available via "getXml()".</p>
		 *  
		 *  <p>If you pass in JSON data, it will be parsed into an object and will be available via
		 *  "getObject()".</p>
		 */
		public function enqueue(...urls):void
		{
			for each (var rawAsset:Object in urls)
			{
				if (rawAsset is Array)
				{
					enqueue.apply(this, rawAsset);
				}
				else if (getQualifiedClassName(rawAsset) == "flash.filesystem::File")
				{
					if (!rawAsset["exists"])
					{
						log("File or directory not found: '" + rawAsset["url"] + "'");
					}
					else if (!rawAsset["isHidden"])
					{
						if (rawAsset["isDirectory"])
						{
							enqueue.apply(this, rawAsset["getDirectoryListing"]());
						}
						else
						{
							enqueueWithName(rawAsset["url"]);
						}
					}
				}
				else if (rawAsset is String)
				{
					enqueueWithName(String(rawAsset));
				}
				else
				{
					log("Ignoring unsupported asset type: " + getQualifiedClassName(rawAsset));
				}
			}
		}
		
		/** Enqueues a single asset with a custom name that can be used to access it later. 
		 *  If you don't pass a name, it's attempted to generate it automatically.
		 *  @returns the name under which the asset was registered. */
		public function enqueueWithName(url:String, name:String = null):String
		{
			if (name == null) name = getAssetNameScheme(url);
			
			log("Enqueuing '" + name + "'");
			
			mQueue.push(
				{
					name: name,
					url: url
				});
			
			return name;
		}
		
		/** Loads all enqueued assets asynchronously. The 'onProgress' function will be called
		 *  with a 'ratio' between '0.0' and '1.0', with '1.0' meaning that it's complete.
		 *
		 *  @param onProgress: <code>function(ratio:Number):void;</code> 
		 */
		public function loadQueue(onProgress:Function):void
		{
			if (Starling.context == null)
				throw new Error("The Starling instance needs to be ready before textures can be loaded.");
			
			if (mIsLoading)
				throw new Error("The queue is already being processed");
			
			var numElements:int = mQueue.length;
			var currentRatio:Number = 0.0;
			
			mIsLoading = true;
			
			resume();
			
			function resume():void
			{
				if (!mIsLoading)
				{
					return;
				}
				
				currentRatio = mQueue.length ? 1.0 - (mQueue.length / numElements) : 1.0;
				
				if (mQueue.length)
				{
					mTimeoutID = setTimeout(processNext, 1);
				}
				else
				{
					mIsLoading = false;
				}
				
				onProgress(currentRatio);
			}
			
			function processNext():void
			{
				clearTimeout(mTimeoutID);

				var assetInfo:Object = mQueue.pop();
				processRawAsset(assetInfo.name, assetInfo.url, progress, resume);
			}
			
			function progress(ratio:Number):void
			{
//				trace("---- " + (currentRatio + (1.0 / numElements) * Math.min(1.0, ratio) * 0.99));
				onProgress(currentRatio + (1.0 / numElements) * Math.min(1.0, ratio) * 0.99);
			}
		}
		
		protected function processRawAsset(name:String, url:String,
										 onProgress:Function, onComplete:Function):void
		{
			var extention:String = getAsstExtention(url);
			
			var assetType:String = getRegistedAssetTypeByExtention(extention);
			
			var assetTypeCls:Class = getRegistedAssetTypeClsByType(assetType);
			
			if(!assetTypeCls)
			{
				assetType = BINARY_TYPE;
				assetTypeCls = BinaryAsset;
			}
			
			var assetItem:AssetBasic = new assetTypeCls(name, assetType, extention, url); 
			assetItem.mAssetsManager = this;
			
			addAssetByTypeAndName(assetType, name, assetItem);
			
			assetItem.load(onProgress, onComplete);
		}
		
		protected function getAsstExtention(url:String):String
		{
			var searchString : String = url.indexOf("?") > -1 ? 
				url.substring(0, url.indexOf("?")) : 
				url;
			
			// split on "/" as an url can have a dot as part of a directory name
			var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));;
			
			var extension:String = finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
			
			return extension;
		}
		
		/** This method is called by 'enqueue' to determine the name under which an asset will be
		 *  accessible; override it if you need a custom naming scheme. Typically, 'rawAsset' is 
		 *  either a String or a FileReference. Note that this method won't be called for embedded
		 *  assets. */
		protected function getAssetNameScheme(url:String):String
		{
			return url;
		}
		
		/** This method is called during loading of assets when 'verbose' is activated. Per
		 *  default, it traces 'message' to the console. */
		protected function log(message:String):void
		{
			if (logEnable) trace("[AssetManager]", message);
		}
	}
}