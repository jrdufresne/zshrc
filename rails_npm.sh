rails_clean() {
  git clean public -dxf
  bundle install
  npm install
  bundle exec rails db:test:prepare
}

alias rails-clean="rails_clean"

alias rrd="bundle exec rails-response-dumper --fail-fast --order random"