# XL Release

## Overview of REST EndPoints

XL Release is using a embedded jetty. It handle all configuration in code rather than a web.xml and we load a certain number of filters and servlets to make the applications works.
All this configuration is done in `com.xebialabs.deployit.plumbing.XebiaLabsServer` class.


## Server Startup

* Jetty : We startup jetty with an optional SSL configuration, and the root context.
* scanit : Scanit startup before everything else.
* Spring
	* Spring Security: We load Spring security as it handle all authentication/ authorization.
	* JBossRestEasy: Is our rest framework, most of the code goes by it. It's loaded through spring.
* Wro4J : is a filter used to concatenate and minimize javascript files.

## Detailed REST End Point
HTTP verb

* `GET` is reading some resource
* `POST` is creating a new resource
* `PUT` is modifying a part of the resource
* `DELETE` is removing a part of the resource

(this is not crud, evenhow it may look like it is)

All answers are of mime type `application/json`

* CommentResource
	* `GET` `/comments` Modify a commment with the payload given.
* DeployitResource
	* `GET` `/deployit/servers`  Read all servers.
	* `POST` `/deployit/servers` Create a new server, with the payload given.
	* `DELETE` `/deployit/servers/{id}` delete a specific server.
	* `PUT` `/deployit/servers/{id}` Modify a server, with the payload given.
	* `POST` `/deployit/servers/check` Check a server exist giving a url, a package, an environement. (!)
	* `GET` `/deployit/{id}/packages` Read all the package of a specific server.
	* `GET` `/deployit/{id}/environements` Read all environements of a specific server.
* EmailResource
	* `GET` `/email` read all email from the currently logged user.
	* `PUT` `/email` send an email from the currently logged user.
* GatesResource
	* `PUT` `/gates/conditions/{id}` Modify the condition of a gate. (!)
	* `POST` `/gates/{id}/conditions/add` add a new condition to a gate. (!)
	* `DELETE` `/gates/conditions/{id}` delete a condition of a gate. (!)
* LoginResource
	* `GET` `/login` get the current logged permissons (check login in a success)
* PhaseResource
	* `GET` `/phases/{id}/titles` read all the titles of a phase
	* `DELETE` `/phases/{id}` read a phase
* ReleaseResource
	* `GET` `/releases/templates` read the templates of a release
	* `POST` `/releases/templates` create a new template using the payload given.
	* `POST` `/releases/templates/copy` copy a new template using the payload given. (!)
	* `DELETE` `/releases/templates/{id}` delete a template.
	* `PUT` `/releases/templates/{id}` modify a template using the payload given.
	* `GET` `/releases` read all releases.
	* `POST` `/releases` create a new release using the payload given.
	* `GET` `/releases/active` read all active release (!)
	* `PUT` `/releases/{id}` modify a release using the payload given.
	* `POST` `/releases/{id}/start` start a new release (!)
	* `GET` `/releases/{id}` read a specific release
	* `POST` `/releases/{id}/phases/move` (!)
	* `POST` `/releases/{id}/tasks/move` (!)
	* `PUT` `/releases/{id}/phases/add` (!)
	* `PUT` `/releases/{id}/duplicate/{phaseId}` duplicate the phaseId phase in the id release
	* `PUT` `/releases/{id}/duplicate/{taskId}` duplicate the taskId phase in the id release
	* `PUT` `/releases/{id}/log` log a string
* ReportResource
	* `GET` `/reports/releases/duration` get the duration of releases
* RolePermissions
	* `GET` `/roles/persmissions/global` get the global permission
	* `GET` `/roles/persmissions/{id}` get the permission of a specific roles
	* `POST` `/roles/persmissions/{id}` create a new permission
	* `POST` `/roles/persmissions/global` create a new global permission
* TaskResource
	* `POST` `/tasks` create a new task
	* `GET` `/tasks/{id}` read a specific task
	* `GET` `/tasks` Read all tasks
	* `POST` `/tasks/{id}/complete` change the status of a task to complete
	* `POST` `/tasks/{id}/skip` change the status of a task to skip
	* `POST` `/tasks/{id}/fail` change the status of a task to fail
	* `POST` `/tasks/{id}/retry`  change the status of a task to retry
	* `GET` `/tasks/{id}/comment` read a new comment
	* `GET` `/tasks/{id}/teams/assignable` 
	* `POST` `/tasks/{id}/comments` add a new comment to a task
	* `PUT` `/tasks/{id}` modify an existing task
	* `DELETE` `/tasks/{id}` delete a task
* TeamResource
	* `GET` `/teams/release/{id}` read the teams assigned on a specific. (!)
	* `POST` `/teams/release/{id}` create a new team in a specific release. (!)
	* `DELETE` `/teams/{id}` delete a specific team
	* `PUT` `/teams/{id}` modify a specific team, with the payload given.


(!) -> see Restafarian-api-fix file.

## WRO

Wro act as a filter which use the `/wro` url prefix
It concatenates, mimimize js & css files and keep the result in a cache

### DevMode
In devMode wro does only the concatenation, cache is not used, and mimification is not done.
This enables to debug.

DevMode is activated by setting the 'RELESEITDEVMODE' system variable in the environement the application runs.


## Client Side Code Organization

Client side code is mainly located in the `src/web` folder.

As the application is a single-page-app, we only have 1 html page `index.html`.

* `components` : all the externals javascripts files. (see below to modify this directory)
* `fonts` : All the externals custom fonts
* `img` : All the images used by the site
* `js` : All the javascript files written 
* `partials` : all the tiny bits of html used by angular to modify the single page. Grouped by functional components.
* `styles` : all the less files used to style the application
	* `styles/components` : Bootstrap css & glyph files

the `components` directory is populated through a bower call. All files here should not be modified by hand. Use the `/scripts/update-components.sh`. It's *very* important to use this script rather than launching bower/grunt directly as we parse some files of BootStrap & JQuery UI which css doesn't play nice.

Remember that some of those files are not served as is. All the js and css files are probably going to be concatened and mimified by wro as explained before.

## Server Side Code Organization

### com.xebialabs.deployit.plumbing.*
As we sometime have to `GET` a hold on DeployIt code base, a bit of the code coming from Deployit used in XL Release that we need to modify, or configure differently is in the package `deployit.config`

### com.xebialabs.xlrelease.*

Beside that, the organization is a mix between "let's `PUT` together objects of the same technical goal" and "let's organize the package functionally".
Having said that :

* `activity` : Everything related to the audit los
* `api` : ( Technical package ) All resources and REST Endpoints
* `builder` : ( Technical package ) All builders used to create domain objects
* `notification` : Everything related to sending emails
* `repository` :
( Technical Package ) All repositories used in storing/reading domain objects from the jcr
* `security` : Everything related to authentification/authorization
* `service` : ( Technical Package ) Every classes handling some functional logic in between resources and repositories
* `views` : ( Technical Package ) All objects returned to the views as json
* `wro` : Everything related to wro4j concatenation & mimification of javascrit and css files

All the technical packages could be exploded and unified under a more functional organization. This will help grouping classes working together in the same package.

### com.xebialabs.xlrelease.domain, com.xebialabs.xlrelease.configuration

Contains all the objects handled by the JCR, including all domain objects used everywhere else server-side


## Testing suites Usages & Goals

We have 3 levels of testing

Most of the time we use an "outside-in" approach where we start to write an acceptance test which involves the guy.
Then we start writing the html + javascript components, eventually starting a tdd cycle in javascript. Then we dwelve into the backend
and start coding server side by writing a junit test. At some point during all thoses iterations all tests passes.

### Acceptance (end 2 end) Testing

Each acceptance test describe a feature we have to implement, we usually wrote them first.
They involve clicking on buttons, links and checking the dom for assertions.
All scripts are written in CoffeeScript, they are ran by KarmaJS using the Angular-Scenario adapter.

The e2e tests are located in the `src/test/javascript/e2e` folder.

Those tests take time, so we need some of them, but unit testing is the way to go, to have a proper coverage.

we have 100 acceptance tests running in 120 secs ( as of june 2013 )

### Javascript Unit Testing

The javascript components are also unit tested. This is a more common way of testing.
Those test are written in coffeescript, they are ran by karmaJS using the Jasmine adapter.
We make a heavy use of angular-mock to mock away most of the network call, and angular injection.

Those test runs blazingly fast, so we can have as many as we can.

The javacript unit tests are located in the `src/test/javascript/unit` folder.

we have 234 unit tests running in 1.19 secs ( as of june 2013 )

### Java Unit Testing

The Java unit tests help us test the server side. We have mostly unit tests, and some small integration tests.
all tests are located in the `src/test/java` folder.

Most of tests accessing domain objects must have the type system initialized. This initialization is done
ine XLReleaseTest. All test classes using domain objects must inehrit from this class.

we have 308 unit tests ( as of june 2013 )
