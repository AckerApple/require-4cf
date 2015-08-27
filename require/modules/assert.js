exports.equal = function (actual, expected){
	if(isObject(actual) || isObject(expected)){
		if(!objectEquals(actual,expected)){
			throw 'Excpected #getMetaData(expected).name#. Got #getMetaData(actual).name#';
		}

		return;
	}

	if(isBoolean(actual) && isBoolean(expected)){
		if((!actual && expected)||(actual && !expected)){
			throw 'Excpected #expected#. Got #actual#';
		}
	}

	if(actual!=expected ){
		throw 'Excpected #serializeJson(expected)#. Got #serializeJson(actual)#';
	}
	/*
	try{
	}catch(any e){
		throw 'Excpected #getMetaData(expected).name#. Got #getMetaData(actual).name#';
	}
	*/
};
