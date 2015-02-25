This is an Javascript/[`AngularJS`](https://angularjs.org/) app for printing web maps

Building the source code requires installing [`NodeJs`](http://nodejs.org/), [`npm`](https://www.npmjs.com/), [`bower`](http://bower.io/), [`grunt`](http://gruntjs.com/) and [`compass`](http://compass-style.org/) as dependancies 

To use the source code for development install the system wide dependencies then 

1. Get the source code, Example using `git clone https://github.com/WorldBank-Transport/angular-map-printer.git`

2. Move to project directory, `cd angular-map-printer`

3. Install javascript dependencies by running  `npm install` and `bower install`

4. You are good to go

To start the development server run

    grunt serve --watch

To build the source code for deployment run

    grunt build
 
 This will build the source code into a folder named `dist` within your project root. The content of the `dist` folder can be server using your favorite web server as a simple static content.
 

Licence
---------

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
