/**
* Created by Acker Apple for the need of converting ColdFusion code to NodeJs by taking advatage of ColdFusion's scripting
*/
Component hint="proof-of-concept of a NodeJs like require that is intended to help assist in leaving CFML for NodeJs. Supports .cfm and .json file calls"{
	variables.mypath = getDirectoryFromPath(getCurrentTemplatePath());
	variables.slash = right(variables.myPath,1);
	variables.isProductionMode = false;//You should really never put this require module into production butttttt if you did, the server scope would be a great place to cache
	include 'jsConverts.cfm';
	
	function init(isProductionMode) hint="assumed CF will auto invoke this method and return you the require function"{
		if(!isNull(isProductionMode)){
			variables.isProductionMode = isProductionMode;
		}
		return getRequirer();
	}

	function getRequirer(basePath) hint="used to create a closure that can always find it's way back to it's owner's memory"{
		if(isNull(basePath)){
			basePath = false;
		}
		var $this = this;
		var require = function(path){
			if(isNull(path) || !isSimpleValue(path)){
				return;
			}

			var myOwner = $this.getMyCache();

			if( structKeyExists(myOwner.requireMap.cache, path) ){
				return myOwner.requireMap.cache[path].exports;
			}

			switch(path){
				case 'assert':{
					path = variables.mypath & 'modules' & variables.slash & 'assert.js';
					break;
				}
				case 'path':{
					path = variables.mypath & 'modules' & variables.slash & 'path.js';
					break;
				}
				case 'fs':{
					path = variables.mypath & 'modules' & variables.slash & 'fs.js';
					break;
				}
				default:{
					path = discoverRequirePath(path, basePath);
				}
			}

			if(!fileExists(path)){
				throw "Error: Cannot find module '#path#'";
			}

			myOwner.requireMap.cache[path] = {
				id:path, filename:path, loaded:false
			};

			var exports = $this.requireModule(path);
			myOwner.requireMap.cache[path]["exports"] = exports;
			myOwner.requireMap.cache[path]["loaded"] = true;

			return exports;
		};

		return require;
	}

	function discoverRequirePath(path, basePath) hint="primary function for figuring out a relative require path"{
		if(fileExists(path))return path;

		var ep = expandPath(path);
		if(fileExists(ep)){
			return ep;
		}

		var ext = listLast(path,'.');
		var hasExt = arrayFindNoCase(['cfc','cfm','json','js'], ext);
		if( !hasExt ){
			var json = discoverRequirePath( path & '.js' );
			if(fileExists(json)){
				return json;
			}

			var json = discoverRequirePath( path & '.json' );
			if(fileExists(json)){
				return json;
			}

			var cfm = discoverRequirePath( path & '.cfm' );
			if(fileExists(cfm)){
				return cfm;
			}

			var cfc = discoverRequirePath( path & '.cfc' );
			if(fileExists(cfc)){
				return cfc;
			}
		}

		if(!isNull(basePath) AND basePath!=false){
			var combinedPath = joinPaths(basePath,path);
			return discoverRequirePath( basePath&path );
		}

		return path;
	}

	function joinPaths(base, to) hint="handles fusing a base path to a requested path. Uses simple logic, if your relative path should work but doesnt, this function is most likely blame"{
		while(left(to,2)=='./'){
			to = right(to, len(to)-2);
		}

		while(left(to,2)=='../'){
			to = right(to, len(to)-3);
			base = getDirectoryFromPath(base);
		}

		return base & to;
	}

	function requireModule(absolutePath) hint="i should only be called if file has been verified as existing"{
		var filePath = getDirectoryFromPath(absolutePath);
		var fileName = getFileFromPath(absolutePath);
		var ext = listLast(fileName, '.');
		if(ext == 'cfc'){
			throw 'require() has been requested to load a ColdFusion specific #ext# file. At this time requiring cfcs is not supported. You should only want to include .js files since your intent is to move away from ColdFusion';
		}

		var fr = fileRead(absolutePath);
		if(ext == 'json'){
			return deserializeJson(fr);
		}

		var writePath = variables.myPath & 'requires' & variables.slash;
		var newFileName = createUUID() & '_' & fileName & '.cfm';
		var writeFilePath = writePath & newFileName;

		if(ext == 'cfm'){
			fileWrite(writeFilePath, fr);
		}else{
			fileWrite(writeFilePath, '<cfScript>runner = function(){#fr#};</cfScript><cfset runner() />');
		}

		try{
			/* fake nodeJs require.module.exports */
				var __dirname = left(filePath,len(filePath)-1);//NodeJs doesn't have a trailing slash
				var module = {"exports":{}};
				var exports = module.exports;
				var require = getRequirer( filePath );
			/* end */
			var iPath = 'requires' & variables.slash &  newFileName;
			include iPath;
			fileDelete(writeFilePath);
			return module.exports;
		}catch(any e){
			try{
				fileDelete(writeFilePath);
			}catch(any e){}
			rethrow;
		}
	}

	function getMyCache() hint="by default uses request scope to store requires. If you ever planned to put require into production, which most likely you shoudnt, you would use the server scope"{
		//if ever all this code was being used in a production enviroment (not suggested) you could cache your requires beyond ever request
		if(variables.isProductionMode){
			if(!structKeyExists(server, 'requireMap')){
				server.requireMap = {
					"cache":{}
				};
			}
			return server;
		}

		/*
			we cache exports to the request scope.
			It will disappear after every request but thats ok.
			We are here to leave ColdFusion not keep using it so these bad CF habits aren't that bad cause they are not intended to last
		*/
		if(!structKeyExists(request, 'requireMap')){
			request.requireMap = {
				"cache":{}
			};
		}
		return request;
	}

}