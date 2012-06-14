# rbm

rbm is a command line tool for doing quick benchmarks of ruby code.

## Description

rbm lets you benchmark varies code fragments by running them a specified number of times along with code fragments before
and after all of the fragments or an individual fragment. See `rbm --help` for more information.

## Installation

Install it yourself as:

    $ gem install rbm

## Usage

Using rbm is quite simple. Just pass in each code fragment you want to test as a separate argument.

```
rbm "sleep 1" "sleep 5"
```

You can specify the number of times to run each code fragment.
You can also provide a code fragment to be run before all code fragments or before a code fragment.

```
rbm --times 1000 "5 / 5"
rbm --times 1000 --init "n = 5" "n / 5"
rbm --times 1000 --init "n = 5" --pre "m = 5" "n / m"
```

You may provide a name to each code fragment to be displayed on the benchmark.

```
rbm --name "sleep for 5" "sleep 5" --name "sleep for 2" "sleep 2"
```

You can see the full usage statement at any time with `rbm --help`

```
Usage: rbm [options] [--name name] [--pre code] code [[--name name] [--pre code] code...]

Ruby Options:
    -r, --require file[,file]        Files to require before benchmarking
    -I, --load-path path[,path]      Paths to append to $LOAD_PATH

Code Fragment Options:
    -n, --times n                    Number of times to run each code fragment
    -i, --init code                  Code to run before every code fragment
    -c, --cleanup code               Code to run after each code fragment
    -N, --name name                  Names the following code fragment
    -p, --pre code                   Code to run before the follow code fragment
    -P, --post code                  Code to run after the follow code fragment

General Options:
    -v, --version                    Print the version and exit
    -h, --help                       Print this message and exit
```

## Contributing

Fork, branch & pull request.
