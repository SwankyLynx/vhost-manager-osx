# What is it?

A little script to quickly add virtual hosts to your local Apache configuration for development purposes on Mac OS X.

Given a name like "example.local" and a path to the files for the site root directory, it will make the site appear at http://example.local.

Currently it has been tested on Apache 2.4.23 in Mac OS Sierra.  
It is also reported to work on Apache 2.4.28 in Mac OS El Capitan.

## Installation

Make a directory to contain all the generated vhost config files:

```sh
sudo mkdir /etc/apache2/extra/vhosts
```

Add this line to your /etc/apache2/httpd.conf file:

```apache
Include /private/etc/apache2/extra/vhosts/*.conf
```

**Do not restart Apache on this step.**

Place the `vhostman.rb` to somewhere, for instance, somewhere in your home dir and add alias for this into your `.bash_profile`, like:

```sh
alias vhostman="sudo $HOME/somewhere/vhostman.rb"
```

Ensure it's executable:

```sh
chmod 777 $HOME/somewhere/vhostman.rb
```

That's it, now you can start to use it.

## Usage

Create folder for your domain in your *Sites* dir (`$HOME/Sites`), for instance: *example* (for real, it doesn't matter how you'll name it)

```sh
mkdir $HOME/Sites/example
```

Next open Terminal and do like this to add `example.local` (it's what you will type in your browser):

```sh
vhostman add example.local $HOME/Sites/example
```

Apache will be restarted and virtual host config will be applied to get it work.

That’s it! You can view your site in browser: http://example.local.

## Fixing issues

### bad interpreter: Operation not permitted

If you get an error like this:

    bad interpreter: Operation not permitted

Then do this:
```sh
xattr -d com.apple.quarantine vhostman.rb
```

### ERROR: Specified webroot dir does not exist

It's possible the webroot path contains a space. In this case enclose the path in quotes, and do not escape spaces with a backslash:
```sh
vhostman add example.local "$HOME/path with spaces/Sites/example"
```


