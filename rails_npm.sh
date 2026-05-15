rails_clean() {
  git clean public -dxf
  bundle install
  npm install
  bundle exec rails db:test:prepare
}

alias rails-clean="rails_clean"
