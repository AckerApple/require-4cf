

"use strict";//does nothing for ColdFusion

var assert = require('assert');
var fs = require('fs');
var path = require('path');
var module = '';

assert.equal(typeof('simple string'), 'string');
assert.equal(typeof(require), 'function');
assert.equal(typeof({}), 'object');
assert.equal(typeof([]), 'object');
assert.equal(isNaN(33), false);
assert.equal(isNaN('34'), false);
assert.equal(typeof(Date.now()), 'number');
assert.equal(typeof(Math), 'object');
assert.equal(Math.abs(-2.22), 2.22);
assert.equal(Math.ceil(2.1), 3);

var jso = {"mytest":464};
jso = JSON.stringify(jso);
assert.equal(jso, '{"mytest":464}');
jso = JSON.parse(jso);
assert.equal(jso.mytest, 464);

module = require('./tests/cases/module');
assert.equal(module, 'module.js');

module = require('./tests/cases/secrets');
assert.equal(module.password, 'password');

module = require('./tests/cases/number22');
assert.equal(module, 22);

//sub-folders
module = require('./tests/cases/folder/module');
assert.equal(module, 'folder/module.js');

//sub-require
module = require('./tests/cases/subrequire/subrequireA');
assert.equal(module, 'subrequireB.js');

//reverse-require
module = require('./tests/cases/subrequire/reverseRequire0/reverseRequire1/reverseRequire2.js');
assert.equal(module, 'reverseRequireEnd.js');

/* path test */
	assert.equal(typeof(__dirname), 'string');
	var pathMod = require('./tests/cases/pathMod');
	assert.equal(pathMod.back, path.join(__dirname,'tests',path.sep));
	assert.equal(pathMod.doubleBack, path.join(__dirname,path.sep));
/* end: path test */

/* fs tests */
	var readTestFilePath = path.join(__dirname, 'tests', 'cases', 'ftReadTest.txt');
	var read = fs.readFileSync(readTestFilePath);//, buffer, offset, length, position

	assert.equal(typeof(read.toString),'function');
	assert.equal(read.toString(),'ftReadTest.txt');

	var buildPath = path.join(__dirname,'tests','build-test');
	if(!fs.existsSync(buildPath)){
		fs.mkdirSync(buildPath);
	}
	
	assert.equal(fs.existsSync(buildPath), true);
	
	var buildFilePath = path.join(buildPath,'build-file.js');
	fs.writeFileSync(buildFilePath,'build-file-contents');
	assert.equal(fs.existsSync(buildPath), true);
	assert.equal(fs.readFileSync(buildFilePath).toString(), 'build-file-contents');

	fs.unlinkSync(buildFilePath);
	assert.equal(fs.existsSync(buildFilePath), false);

	assert.equal(fs.existsSync(buildPath), true);
	fs.rmdirSync(buildPath);
	assert.equal(fs.existsSync(buildPath), false);
/* end: fs tests */

//does nothing for ColdFusion
console.log('\x1b[32mtests completed without error\x1b[30m');