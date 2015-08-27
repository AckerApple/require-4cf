# require-4cf

Exceptional tool to aide in molding ColdFusion code into NodeJs code

Adds require() method in ColdFusion that works a lot like the require() in NodeJs. This tool closes a gap between ColdFusion and NodeJs that makes converting into NodeJs a much more fluent process.

## Teaser Example

secrets.json
```json
{"mailPassword":"easy-as-123"}
```

module.js
```js
"use strict";//does nothing for CFML

var secrets = require('./secrets');
module.exports.secrets = secrets;

module.exports.test = function(ob){
    Math.abs(-2.22);
    Math.ceil(3.33);
    isNaN('yo');
    return JSON.stringify(ob);
};
```

template.cfm
```cfm
<cfScript>
    variables.module = require('./module.js');
    variables.module.test({someObject:434});
    writeDump(var=variables.module.secrets);
</cfScript>
```

## Table of Contents

- [What for?](#what-for)
- [Brief History](#brief-history)
- [General Developer Requirements](#general-developer-requirements)
- [What Should I Know?](#what-should-i-know)
- [Keep in mind](#keep-in-mind)
- [! Not inteded for production servers](#not-intended-for-production-servers)
- [General Tips for Converting](#general-tips-for-converting)
- [Provided Javascript Conversions](#provided-javascript-conversions)
- [Provided NodeJs Module Functionality](#provided-nodejs-modules-and-functionality)
- [Installation Recommendations](#installation-recommendations)
- [EXAMPLE USAGE](#example-usage)
	- [Test This Code](#test-this-code)
		- [ColdFusion](#coldfusion)
		- [NodeJs](#nodejs)
	- [Require .json file](#require-json-file)
	- [Require .js file or any non .cfm or .json file](#require-js-file-or-any-non-cfm-or-json-file)
	- [Require .cfm file](#require-cfm-file)
	- [CFC Conversion Example](#cfc-conversion-example)
- [A Special Thanks from Acker Apple](#a-special-thanks-from-acker-apple)
- [License](#license)

## What for?

This tool is intended to be used if code logic, with a proven work flow in CFML, needs to be massaged into NodeJs code. If you’re looking to bring your CFML code flow as close to NodeJs as possible before making the final permanent switch to NodeJs, this is the right tool for that job.

## Brief History

The require-4cf module was first created during a conversion process of a CFML based security camera display interface. All the CFML dynamic display logic was pushed into static html templates and content populated via [AngularJs](angularjs.org). All the sign-up logic, login logic, and form-submit logic was converted to NodeJs code using this require-4cf module. This module has now been made available to the public by a heartfelt care that Acker Apple has for other CFML developers who are eager to exit the CFML language.

### General Developer Requirements

You should have the following in mind before casting CF code to NodeJs.

- Have learned enough about NodeJs to satisfy code conversion dependencies.
- Most likely will need to have learned how NodeJs supplies http request/response objects for creating servers to work in place of CFML request processing engine.
- Have a strong plan and know what code is worth being massaged into NodeJs versus a complete rewrite.
- Have a need for a tool to bring additional confidence to a smoother transition process from CFML to NodeJs.
- Have learned alternatives to applicable CF functionality:
	- cfHttp (recommend: [request](https://www.npmjs.com/package/request))
	- Hibernate ORM (recommend: [sequelize](https://www.npmjs.com/package/sequelize))
	- cfQuery (recommend: [sequelize](https://www.npmjs.com/package/sequelize).query())
	- cfPdf (recommend: [phantom](https://www.npmjs.com/package/phantom) & [phantomjs](https://www.npmjs.com/package/phantomjs))
	- etc.
- This require() module was built and tested on ColdFusion 10 & 11 for Mac and Windows

## What Should I Know?

When you run CFML code and call the provided require() method, the following occurs:

- The requested required file is looked up using several relative path location functions, including expandPath.
- When required file is found, a copy is written to disc and wrapped in functional code to produce a NodeJs-like enviroment.
- Required cloned-file is included with implied scopes and logic such as the module.exports scope and the require() method are made available.

Since the required file is cloned you should know:

- The actual running required file, in a CFML request that is using this require() method, is actually executing the required file in a cloned directory.
- Errors in the required file will stack trace paths as the cloned-file’s location and not the original files location.
- Because the file is running in a seperate location, commands like cfInclude and createObject("component", "") will most likely fail due to broken relative paths.
	- Remember, your intent is to leave CFML for NodeJs so you won’t need nor want to use cfInclude or createObject("component", "") anymore.
- By default, a required file's results are cached in the request scope as request.requireMap and are not re-required for the life of the request.
	- Since you are converting away from CFML, you should not be concerned with the best caching technique for your requires in CF.

## Keep in mind

The NodeJs-like enviroment is still just CF scripting. Code-blocking and all.

- Your indexes for things like loops will still start at 1 and not 0 like in Javascript.
- Using the "new" keyword, for example the new Date() won’t work because CFML thinks that it is a file request for a CFC (Note: Date.now() has been provided)
- Although many conversions exist like JSON.parse() and Math.abs(), they are CFML equivalents that use serializeJson() and abs()
	- the typeof() supplied converted method, will be very useful making if logic that works in both CFML and NodeJs
- You can’t set variables onto functions like in NodeJs. In CFML an error is thrown for something about a Java bean error (example: myFunction.myVar=22;)
- If you understand that the "hack" here is exposing cfScript as a cousin of Javascript, then you will get how to work with this require() quite easily.

## ! Not intended for production servers

### WOW, this is exteremly important!

When you make .js files as your conversion files, they may now become available to a request as a static file.

- This would expose your code logic (bad. very bad)
- This tool can require .cfm files. Cfm files require a cfScript declaration though.
- Other than .json &amp; .cfm any other file exension or none, will be treated as a .js file
	- Remember you are converting CFML away from NodeJs. Going into production with your conversions while still running CFML code is not recommended and is advised against.

### General Tips for Converting

- Know when not to convert
	- cfm/cfc code that generates dynamic output may work better as static html files that are dynamically populated by [AngularJs](angularjs.org).
- Get CFML code as close to Javascript as possible. Then work out replacing cfQuery and other such functionality.
- Convert CFCs into objectified module.export ([example provided below](#cfc-conversion-example))
	- CFC accessors are bells and whistles, bad ideas. If you like accessors maybe converting to NodeJs now is not the time.
	- Convert accessors into this.variables. I recommend this.data or this.$scope
- Reminder: use semi-colons at least during the conversion process


### Provided Javascript Conversions
Comes with some really handy common CFML-to-NodeJs conversion logic

- Date.now()
- JSON.parse()
- JSON.stringify()
- typeof() (at this time returns: string, number, undefined, object or unknown)
- isNaN()
- Math.abs()
- Math.ceil()
- console.log (does nothing, just prevents error when called in CF)

Conversion logic can be extended by editing ./require/jsConverts.cfm

### Provided NodeJs Modules and Functionality

- __dirname
- module.exports & exports
- require('assert')
	- assert.equal()
- require('path')
	- path.sep
	- path.join()
- require('fs')
	- fs.readFileSync().toString()
	- fs.existsSync()
	- fs.mkdirSync()
	- fs.unlinkSync()
	- fs.rmdirSync()
	- fs.writeFileSync()

Provided modules can be extended by editing ./require/modules/

#### Installation Recommendations

If you have NodeJs & npm installed, get the files installed the fastest via:

```bash
$ npm install require-4cf
```

##### Install into ColdFusion Requests

Copy just the folder ./require-4cf/require and put it relative to your application(s) files. Using the Application.cfc demo below, is one way to make require() available to all requests.

Application.cfc
```cfc
Component output="no"{
	function onRequest(targetPage) output="yes"{
		var require = new require.require();//path-to invoke require.cfc, which returns a function
		include targetPage;//templates can now call require()
		return;
	}
}
```

## EXAMPLE USAGE

#### Test This Code

##### ColdFusion

In this same folder as this README.md file, request the index.cfm via ColdFusion accessible URL address.

##### NodeJs

- In Terminal/CMD, navigate to the require-4cf folder and run "npm test"

#### Require .json file

secrets.js
```json
{"secretPassword":"password"}
```
template.cfm<br>
```cfm
<cfScript>
    //Example 0
    require('./secrets.json').secretPassword;

    //Example 1
    require('./secrets').secretPassword;
</cfScript>
```

#### Require .js file or any non .cfm or .json file

module.js
```js
module.exports.test = function(){
    return 22;
};
```
template.cfm
```cfm
<cfScript>
    require('./module.js').test();
</cfScript>
```

#### Require .cfm file
module.cfm
```cfm
<cfScript>
	module.exports.test = function(){
	    return 22;
	};
</cfScript>
```
template.cfm
```cfm
<cfScript>
	require('./module.cfm').test();
</cfScript>
```

#### CFC Conversion Example
```cfm
component accessors="true"{
    property myVar;
    function init(){
        return this;
    }

    function doSomething(a){
        return getMyVar() + a;
    }
}
```
Could convert into:
```js
exports.init = function($scope){
    this.$scope = $scope;return this;
}

exports.doSomething = function(a){
    return this.$scope.myVar + a;
}
```
You can view more examples in the included test.js file

### A Special Thanks from [Acker Apple](https://plus.google.com/108604932521122539441/about/)

- To everything that has come before me and created me. Respect. [Life is a mother](http://blog.shelbyedge.com/2015/07/jordi-birth.html).
- To my brother Nicholas Acker, thank you for making leaving ColdFusion a blunt obvious goal. I feel relevant again thanks to you.
- To [Adam Cameron](http://blog.adamcameron.me/), you are the 2nd best smart smart-ass after myself ;)
- To Adobe, I truly feel you bought CFML and decided to give the presence that CFML is alive and growing while only caring to collect licensing fees. This module is because of you.
- To anyone still programming CFML, best of luck on the road ahead. I didn’t want a future in CFML anymore. I got fed up with legacy projects. Never liked PHP or ASP. Ruby came close, but NodeJs is a world of harmony from ColdFusion and I recommend you feel that notion too. This module is for you.


## License

Acker Apple cares more about you than licensing. Do what you will with this code.

But in-case you need an MIT license, here it is below:

Copyright (c) 2015 Acker Apple

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.