<cfScript>
	if(isNull(console)){
		console={};
		console.log = function(){};//at this time it's too prevent error when used
	}
	
	//fList = getFunctionList();
	function typeof(vv){
		if(isNull(vv)){
			return 'undefined';
		}

		var meta = getMetaData(vv);
		
		if(isNumeric(vv)){
			return 'number';
		}
		
		if(meta.name == 'java.lang.String'){
			return 'string';
		}

		if( isValid("function", vv) || meta.name=='coldfusion.runtime.CFPageMethod'){
			return 'function';
		}
		
		if( isObject(vv) || isStruct(vv) || isArray(vv) ){
			return 'object';
		}

		return 'unknown';
	}

	function isNaN(n){
		return !isNumeric(n);
	}

	Math = {
		abs:function(n){
			return abs(n);
		},
		ceil:function(n){
			return ceiling(n);
		}
	};

	Date = {
		now:function(){
			return now().getTime();
		}
	};

	JSON = {
		stringify:function(ob){
			return serializeJson(ob);
		},
		parse:function(ob){
			return deserializeJson(ob);
		}
	};
</cfScript>