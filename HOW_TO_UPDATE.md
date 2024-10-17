# Setup

```bash
mkdir ~/.gem
RUBY_GEMS_ACCOUNT=TODO
curl -u $RUBY_GEMS_ACCOUNT https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials; chmod 0600 ~/.gem/credentials
```

# Publish

```bash
# Add release branch
VERSION=TODO
git checkout master
git checkout -b release/$VERSION
vi lib/unihan_lang/version.rb # edit version
git commit -am "Bump version $VERSION"

# Publish to rubygems
gem build unihan_lang.gemspec
bundle install
gem push unihan_lang-$VERSION.gem

# GitHub release
git tag $VERSION
git push --tags
open https://github.com/kyubey1228/unihan_lang/releases/new

# merge to master
git checkout master
git merge release/$VERSION
```
