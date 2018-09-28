# dockerized-RoR
**Dockerized Ruby on Rails Template Project**

Is it possible to rapidly develop web applications with traditional software development practices?  Can these web applications be made to look attractive, be responsive, and be more customizable than the alternatives we use today?  Can these web applications connect to Microsoft SQL Server and Oracle databases, and even funnel data from one to the other?  And the bottom line question - can you really do all this for free?

Yes.  Yes, you can.

## Overview ##
### The container framework - Docker ###

### The databases - Microsoft SQL Server and Oracle ###
*(And anything else that RoR supports ...)*

### The backend - Ruby on Rails ###

## Puzzle Pieces ##
### Ruby ###
Each programming language or framework has its own terminology for shared libraries.  In the Ruby and Rails world, these are called gems.  In this template project, the following gems were used:

* [`rails`](http://rubyonrails.org) - the Ruby-based framework that allows for rapid web application development
* [`listen`](https://github.com/guard/listen) - required for `rails` and `guard`
* [`activerecord-sqlserver-adapter`](https://github.com/rails-sqlserver/activerecord-sqlserver-adapter) - the ActiveRecord adapter for Microsoft SQL server
* [`activerecord-oracle_enhanced-adapter`](https://github.com/rsim/oracle-enhanced) - the ActiveRecord adapter for Oracle
* [`ruby-oci8`](https://github.com/kubo/ruby-oci8) - required by `activerecord-oracle_enhanced-adapter`
* [`public_suffix`](https://github.com/weppos/publicsuffix-ruby) - required for `rails`
* [`addressable`](https://github.com/sporkmonger/addressable) - required for `rails`
* [`activeadmin`](https://activeadmin.info/) - provides the administration interface for the backend piece
* [`inherited_resources`](https://github.com/activeadmin/inherited_resources) - required by `activeadmin`
* [`devise`](https://github.com/plataformatec/devise) - used for authentication for `activeadmin`
* [`arbre`](https://github.com/activeadmin/arbre) - templating engine used by `activeadmin`
* [`table_print`](http://tableprintgem.com/) - utility gem used for pretty printing of data structures in a tabular format
* [`rack-cors`](https://github.com/cyu/rack-cors) - middleware piece that handles CORS (Cross Origin Resource Sharing) headers
* [`ajax-datatables-rails`](https://github.com/jbox-web/ajax-datatables-rails) - allows controllers to easily be built that can respond to requests from Datatables.net datatables.  *THIS VERSION IS PATCHED TO ADD SUPPORT FOR SQL SERVER!*
* [`guard`](https://github.com/guard/guard) - checks for changes to the code base, restarts and runs tests if any changes are detected
* [`guard-livereload`](https://github.com/guard/guard-livereload) - required by `guard`
* [`guard-minitest`](https://github.com/guard/guard-minitest) - required by `guard`
* [`guard-rails`](https://github.com/ranmocy/guard-rails) - required by `guard`

### Container Architecture ###
* [Docker](https://www.docker.com/) - a cross-platform container platform
* [`docker-compose`](https://docs.docker.com/compose/) - a utility program distributed by the Docker organization that allows linking together multiple Docker containers to perform tasks

### Backend System Dependencies ###
* Docker base image - [ruby](https://hub.docker.com/_/ruby/)
* [NodeJS](https://nodejs.org/en/) - JavaScript runtime required by the ruby gem [`uglifier`](https://github.com/lautis/uglifier), automatically required by other ruby gems
* [`curl`](https://curl.haxx.se/) - required to install latest NodeJS
* [`unzip`](http://infozip.sourceforge.net/UnZip.html) - required to extract Oracle packages required by ruby-oci8 and activerecord-oracle_enhanced-adapter ruby gems
* [`sudo`](https://www.sudo.ws/) - convenience utility when developing containers
* [libaio1](https://github.com/littledan/linux-aio) - package needed so that the ruby-oci8 gem will compile
* [FreeTDS](http://www.freetds.org/) - library required by [`tiny_tds`](https://github.com/rails-sqlserver/tiny_tds) ruby gem, on which `activerecord-sqlserver-adapter` depends
* [Oracle Instant Client archive files for 64-bit Linux](https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) - required for `ruby-oci8` to compile

## Instructions ##
* First, configure Docker on your machine, and install the `docker-compose` utility.
* Clone this repository
* Enter the new directory and run the `./rr_new` command.  Follow the instructions.
* Edit `docker-compose.yml` so that the Microsoft SQL Server and Oracle usernames, passwords, etc. are correct.
* Bring the backend project up with `./up`.  Once all the instructions are followed, the backend will run on your local machine at port 3000.
* After configuration, you should be able to see the following:
  * http://localhost:3000/admin - a backend administration interface for the data
  * http://localhost:3000/ - the Rails welcome page
* Notice that when you edit any code for the Ruby on Rails container, Rails will restart to reflect your changes.  Also, if you have any tests defined for your code, they will run before Rails is brought back up.
