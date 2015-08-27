<cfScript>
	require('test.js');
	require('./tests/cases/testCfm.cfm');
</cfScript>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=0" />
</head>
<body>
	<div style="color:green;">Test completed without error</div>
	<br />
	<div>
		To make the require() function available to all cfcs, integrate require.cfc into:
		<br />
		- <cfOutput>#getMetaData(new "WEB-INF.cftags.component"()).path#</cfOutput>
	</div>
	<br />
	<div>
		When files are required, I am writing/deleting them into:
		<br />
		- <cfOutput>#expandPath('./require/requires')#</cfOutput>
	</div>
	<br />
	<p><a href="README.md" target="_blank">View README.md</a></p>
</body>
</html>