! Never ever ever put .js ColdFusion-to-NodeJs conversion files into production

Your request server could serve that .js conversion file as a static .js file which would completely expose your code logic.

- use any file extension your server won't automatically server as a static file. Reminder, .cfm files need to be wrapped in <cfScript></cfScript>



Please read ../README.md carefully if anything above is not fully understood