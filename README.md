# danger-chikuwatter

Danger Plugin for reporting flutter analyze errors, warnings and **info**.

## Installation

Add this line to your Gemfile:

```
gem danger-chikuwa
```

## Usage

### Report flutter analyze errors and warnings
Run flutter analyze and save the result to a file.

```
$ flutter analyze 2>&1 | tee analyze.log
```

Add the following to your Dangerfile.

```
chikuwatter.analyze "analyze.log"
chikuwatter.report
```

### Repost riverpod_lint errors and warnings
Run riverpod_lint and save the result to a file.

```
$ dart run custom_lint 2>&1 | tee riverpod_lint.log
```

Add the following to your Dangerfile.

```
chikuwatter.riverpod_lint_log "riverpod_lint.log"
chikuwatter.report
```

### Report inline comments

If `inline_mode` is true, the plugin will report the errors, warnings and **info** as inline comments.

```
chikuwatter.inline_mode = true
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
