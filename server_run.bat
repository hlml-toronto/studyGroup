ruby -v             & :: check that ruby installed

IF EXIST Gemfile DEL /F Gemfile
IF EXIST Gemfile.lock DEL /F Gemfile.lock

(
  echo source 'https://rubygems.org'
  echo gem 'wdm'
  echo gem 'jekyll'
  echo gem "webrick", "~> 1.7"
) > Gemfile

call bundle install

bundle exec jekyll serve
