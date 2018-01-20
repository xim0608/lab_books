# LaBooks
This is book stock management system. 
You can import books data from [booklog](http://booklog.jp/).
Introduce slides:
[Slide Share](https://www.slideshare.net/secret/yoI3xiryaOrKQT).

## Requirement
* Ruby 2.4.2
* Rails 5.1.1
* bundler 1.16.0

## Get Start
```shell
$ git clone -b master https://github.com/xim0608/labooks.git
$ cd labooks
```
Set variables in `.env` file.
```shell
$ cp env.example .env
```
To import your booklog data, export and download your csv from [booklog](http://booklog.jp/) and copy to `db/seeds` directory.  
Before you execute below command, set up mysql user authentication.
```shell
$ bundle install
$ bundle exec rake db:setup
```
`rake db:setup` command is
1. creating database and tables
2. making admin initial user (you must set ENV initial_user_email and pass)
3. import booklog csv data

Then execute
```shell
$ bundle exec rails server
```
