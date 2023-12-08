# webenv
Setup your web development environment in one command

## overview
Setting up a development environment on your new machine can be hard sometimes. The sole aim of this project is to provide a convenient way of getting the job done with one command.

![](./screenshot.png)

## usage
Below are the environments currently available;

- [Node.js](./setup-nodejs.sh) : 
  Run this script to setup an envirnoment with an IDE, git, browser, node.js, package manager and your favorite framework cli
  ```sh
  curl -O https://raw.githubusercontent.com/henryhale/webenv/master/setup-nodejs.sh
  bash setup-nodejs.sh
  ```

- [LAMP stack](./setup-lamp.sh) : 
  Setup a PHP based enviroment with php, composer, database server and phpmyadmin
  ```sh
  curl -O https://raw.githubusercontent.com/henryhale/webenv/master/setup-lamp.sh
  bash setup-lamp.sh
  ```

>Note: In case of any errors concerning user permissions, re-run the command with sudo.
>
>Example:
>```sh
>$ chmod +x setup-lamp.sh
>$ sudo ./setup-lamp.sh
>```

## issues
In case of any issues such as bugs or errors, kindly [open an issue](https://github.com/henryhale/webenv/issues) describing what happened

## license

Released under [MIT License](./LICENSE.md)

Copyright 2023 [Henry Hale](https://github.com/henryhale)
