# Falcony

Falcony is an app to provide COVID related travel information.

I was created as part of LeWagon Coding bootcamp and is now further developed as side project.

Data comes from different trusted sources: European Commission - https://reopen.europa.eu/ and Our World in Data - https://ourworldindata.org/#entries

Any private feedback, please contact: contact@falcony.info

Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.


## Contribute
### Setting up
```
git clone git@github.com:Flott2410/falcony.git
cd falcony

# Install Redis for Sidekiq
# On OSX
brew update
brew install redis
brew services start redis

# Ubuntu
sudo apt-get install redis-server

bundle install
bundle binstub sidekiq

yarn install --check-files

# Request .env file from existing contributors an
```

#### Create and migrate the database
```
rails db:create db:migrate
rails c
Country.destroy_all

countries.each do |country|
  Country.create!(name: country[1], iso: country[0])
end

exit

rails db:seed
```


### Git guidelines

#### Making a Pull Request
[How to Write a Git Commit Message](https://chrisbeams.com/posts/git-commit/)

You can do multiple commits per Pull Request so do them as often as possible explaining *what* you changed and *why* as suggested on the guide linked above.

#### First thing in the morning
```
git checkout master
git pull origin master
```

#### Test Pull Request
```
git checkout master
git checkout -b <pull-request-branch>
git checkout <pull-request-branch>
rails s
```
