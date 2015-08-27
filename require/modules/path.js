"use strict";
var sep = getDirectoryFromPath(getCurrentTemplatePath());
sep = right(sep,1);
exports.sep = sep;

exports.join = function() hint="Joins paths together with correct system slashing. Performs barely a primitive job like the NodeJs version."{
	var p = '';var x=1;
	for(; x <= structCount(arguments); ++x){
		if(isNull(arguments[x]) || !isSimpleValue(arguments[x]))continue;
		var arg = arguments[x];
		while(len(arg) >= 3 && left(arg,3)=='../'){
			p = getDirectoryFromPath(p);
			if(right(p,1)==sep){
				p = left(p,len(p)-1);
			}
			if(len(arg) <= 3){
				arg = '';
			}else{
				arg = right(arg,len(arg)-3);
			}
		}
		if(len(arg) && len(p) && arg!=sep){
			p &= sep;
		}
		p &= arg;
	}
	if(right(p,1)==sep){
		p = left(p,len(p)-1);		
	}
	return p;
};