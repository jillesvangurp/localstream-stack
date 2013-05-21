# Introduction

This project serves as a skeleton project that documents the Localstream server stack. The original purpose of this project was to serve as reference material for a presentation I gave about how to use JRuby and Java together.

# Usage

The rest of this readme talks you through some detailed instructions for getting a working setup with Jruby, Sinatra, and Fishwife.

# Overview

This sample application demonstrates several things:

* how to integrate spring beans in your Jruby code and implement DIY dependency injection in Ruby
* how to load and access properties using my properties-configuration gem
* how to document your http API using sinatra-docdsl
* how to load Java jar files in jruby without jumping through hoops
* how to use Fishwife to run your Sinatra application with your Spring context
* how to use Logback for logging

## Java

Install the latest 1.7.x jdk from Oracle. Install the latest maven from Apache (3.0.4 or better).

then to build:

    mvn clean install 

This will compile the java code and download some dependencies into target/lib that are needed to run the jruby sample app. The pom.xml file has some configuration for this.

## Setting up jruby

There are many ways to install jruby. Assuming you want a sensible setup for development, using rbenv is a pretty good idea.
This allows you to switch between different ruby installations and give each their own place to dump their gems.

This assumes you have already set up homebrew. If not, RTFM: http://mxcl.github.com/homebrew/

    brew install rbenv

    # follow the instructions in the console about your .profile
    # restart your console
	
    # this allows you to install just about any version of ruby
    brew install ruby-build
	
    # now install jruby (adapt to whatever is the latest version of jruby; note, run brew update to make brew aware of that)
    rbenv install jruby-1.7.3
    
    # now go to the directory where our ruby stuff lives
    cd api
	
    # now make jruby the default for this directory
    rbenv local jruby-1.7.3
	
    # verify that rbenv is used when you call ruby and that it points to jruby in the api directory
    which ruby
    >/Users/jilles/.rbenv/shims/ruby
    ruby -v
    > jruby 1.7.3 (1.9.3p327) 2013-01-04 302c706 on Java HotSpot(TM) 64-Bit Server VM 1.7.0_13-b20 [darwin-x86_64]
	
    # add the following line to your .profile
    export JRUBY_OPTS="-J-Xmx2000M"

## Managing GEM dependencies (development)

We use bundler for dependency management on development machines. Bundler uses the Gemfile file in the root to determine what to install. In our setup it contains those gems that are required in our production setup. The Gemfile.lock contains a list of the exact versions of each dependency used. This file is under version control and only changes when it has to.

IMPORTANT Gemfile.lock is under version control. It should only change when gems are updated/added and it should at all times reflect a working setup.

First install bundler and rspec (for running the tests).

	gem install bundler rspec

After installing bundler itself using gem (see above), you can install the remaining dependencies using:

	bundle install

Bundler by default installs gems globally and any executables are placed on the path. When using rbenv, you have to use 

	rbenv rehash	

You can verify if you have the required gems installed by running

    bundle check    

## Vendorized setup

We do not use bundler on production machines. Instead we use a 'vendorized' setup for production. This means gems are installed in a vendor subdirectory.

To install locally in a vendor directory run

    bundle install --deployment

Then you have to tell JRuby to look for gems in that directory using. 

	export GEM_HOME=vendor/bundle/jruby/1.9    

IMPORTANT bundle stores some state in the .bundle directory and once you have a vendor directory any subsequent run of bundler will install there. So,
if you want to install globally, do it before the vendor dir is created or remove the vendor dir + .bundle directory.

If you want to use the vendorized setup for development (like we do in production), you must make sure to set the GEM_HOME environment 
variable correctly in the script that starts your application. DONOT set this variable in your .profile, you won't be able to
install gems gloabally if you do.

    export GEM_HOME=vendor/bundle/jruby/1.9

Rspec and bundler are not used in production so it is easiest to install at least these globally:

    # now install gems we need for running to start our app server, download app dependencies, and run our tests.
    # these gems are installed in the jruby shim
    gem install bundler rspec

    # make sure that any bin directories for these gems are added to the rbenv path (do this after installing gems)
    rbenv rehash
    
    # download the application dependencies as specified in Gemfile to a local vendor directory
    # IMPORTANT you must use the vendor directory if you plan to create a deployable tar ball using the build.sh script
    # simply omit the --deployment for a global install
    bundle install --deployment

## Cleaning your gems and starting clean

Gem and bundle make quite a mess and sometimes it is easiest to just start from scratch.

This cleans out all the gems you have installed globally:

	gem list | cut -d" " -f1 | xargs gem uninstall -aIx

There's some cruft that you can clean out using

	rm -rf versions .bundle

##	Fishwife

Simply run Fishwife like this. It will pickup config.ru and start a Jetty server:

	fishwife

To start the application using fishwife and the vendorized setup, you can use the production script:
    
    ./start.rb
