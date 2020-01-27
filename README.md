# diffzones

A command line utility to diff records against a set of nameservers.

## Install

1. Install ruby via [rbenv](https://github.com/rbenv/rbenv), Docker, or similar.
1. Install dependencies:

```bash
$ gem install bundler
$ bundle install
```

## Usage

```
$ ./bin/diffzones help diff
Usage:
  diffzones diff -s, --secondary-dns=SECONDARY_DNS

Options:
  -p, [--primary-dns=PRIMARY_DNS]    # the primary DNS server to use. If blank, uses Google
                                     # Default: 8.8.8.8
  -s, --secondary-dns=SECONDARY_DNS  # the second nameserve to use.
  -f, [--file=FILE]                  # the target file to use.
  -r, [--record=RECORD]              # the record to query (overrides file)
  -t, [--record-type=RECORD_TYPE]    # the record type.

diff a DNS resource record between two namservers
```
## Example

Test that Amazon returns the same results as the current public DNS

```
$ cat ./tmp/sysconfig.org
sysconfig.org A
sysconfig.org TXT
```

```
$ ./bin/diffzones diff -s ns-429.awsdns-53.com -f ./tmp/sysconfig.org
QUERY: SYSCONFIG.ORG A
RESULT: Pass
        NS1: ["208.113.160.220"]
        NS2: ["208.113.160.220"]
QUERY: SYSCONFIG.ORG TXT
RESULT: Pass
        NS1: ["\"v=spf1 include:_spf.google.com ~all\""]
        NS2: ["\"v=spf1 include:_spf.google.com ~all\""]k
```

## TODO

- Create response object type to abstract out some of the internal messiness of the differ class.
- Clean up logging
- More diffing functionality (TTLs etc)
