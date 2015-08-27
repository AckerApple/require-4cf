"use strict";
exports.readFileSync = function(filePath) hint="mocks reading a file like NodeJs. You must call toString() to get the cf equiivalent of fileRead()"{
	var rtn = {};
	var result = fileRead(filePath);

	rtn.toString = function(){
		return result;
	};

	return rtn;
};

exports.existsSync = function(pathTo){
	if(fileExists(pathTo))return true;
	return directoryExists(pathTo);
};

exports.mkdirSync = function(pathTo){
	directoryCreate(pathTo);
};

exports.unlinkSync = function(pathTo){
	fileDelete(pathTo);
};

exports.rmdirSync = function(pathTo){
	directoryDelete(pathTo);
};

exports.writeFileSync = function(pathTo, data){
	fileWrite(pathTo, data);
};