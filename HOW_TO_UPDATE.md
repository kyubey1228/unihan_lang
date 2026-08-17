# Setup

```bash
mkdir ~/.gem
RUBY_GEMS_ACCOUNT=TODO
curl -u $RUBY_GEMS_ACCOUNT https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials; chmod 0600 ~/.gem/credentials
```

# Publish

```bash
./bump_new_version.sh 1.2.3
```
