# Cron parser

This script parses a given cron expression and prints the times of execution by part of expression

## Dependencies

* ruby - [Install ruby](https://github.com/rbenv/ruby-build/blob/master/bin/rbenv-install)
* make

## Install gems

```
make install
```

## Running

```
./parser '* * * * * echo example'
# or
make run [cmd='echo example'] [exp='* * * * *']
```

## Testing

```
rspec
# or
make test
```
