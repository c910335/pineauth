# pineauth

[![Amber Framework](https://img.shields.io/badge/using-amber%20framework-orange.svg)](https://github.com/c910335/pineauth)

OAuth 2 Provider built with [Amber](https://github.com/amber-crystal/amber)

## Installation

Create a pg database called `pineauth_development` and configure the
`config/database.yml` to provide the credentials to access the table.

Then:

```shellsession
$ shards update
$ amber migrate up
```

## Usage

To run the demo:

```shellsession
$ crystal build src/pineauth.cr
$ ./pineauth
```

## Docker Compose

This will start an instance of postgres, migrate the database,
and launch the site at http://localhost:3000

```shellsession
$ docker-compose up -d
```

To view the logs:

```shellsession
$ docker-compose logs -f
```

Note: The Docker images are compatible with Heroku.

## Contributing

1. Fork it ( https://github.com/c910335/pineauth/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [c910335](https://github.com/c910335) Tatsujin Chin - creator, maintainer
