Component output="no" hint="this component just ensures that during testing, no other appliation.cfc file is being loaded"{
	function onRequest(targetPage) output="yes"{
		//require will be available to all templates
		var require = new require.require();//You would need to wire your .cfc files by adding a line "like" this into the file WEB-INF.cftags.component
		include targetPage;
		return;
	}
}