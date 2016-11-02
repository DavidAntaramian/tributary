Tributary
=========

[![CircleCI Build Status](https://img.shields.io/circleci/project/DavidAntaramian/tributary/master.svg?maxAge=86400)](https://circleci.com/gh/DavidAntaramian/tributary)

Tributary is a helpful little plugin that pages your Ecto query for efficient
processing without any concern on your part for state management. It does
this by taking advantage of the [Elixir Stream](http://elixir-lang.org/docs/stable/elixir/Stream.html)
module which is a type of lazy enumerable. And it does this in a very efficient
manner on the database side.

Using Tributary
---------------

Before using Tributary itself, it's important that you take a quick look
at the table you want to query with Tributary. The table __must__ have
a unique btree index on a single field. In common database designs this
is going to be a primary key that is an auto-incremented integer on
the `id` column; however, Tributary knows how to deal with non-integer
keys as long as the database knows how to deal with them, and you
specify the initial key.

Tributary is addded in to your project by calling `use Tributary`
inside your Ecto repository. For example, let's assume we are
writing an application for a brokerage firm. You may set up the
Repo like this:

```elixir
defmodule Brokerage.Repo
  use Ecto.Repo, otp_app: brokerage
  use Tributary
end
```

Now, let's assume you have an Ecto model `Brokerage.Client` which has
the residence country of each client listed in the `country` field.
You need to send each US-based client a 1099-DIV. Let's create
a mix task for it:

```elixir
defmodule Mix.Tasks.Emails.SendUS1099DIV
  use Mix.Task
  alias Brokerage.{User, Repo}
  import Ecto.Query, only: [from: 2]

  def run(_)
    Repo.start_link

    from(u in User, where: u.country == "US")
	|> Repo.stream
	|> Stream.each(fn user ->
	  Brokerage.Emails.TaxUS1099DIV.send(user)
	end)
	|> Stream.run
  end
end
```

That's it. 

How Tributary Works
------------------

Tributary is actually a very simple library. It relies on `Stream.resource/3`
to generate a Stream, abstracting away all the concerns about state
management so that you can reliably process your data set as a 
single, continuous enumerable. 

Tributary's key feature, though, is its reliance on indexes
for paging: keyset pagination. Many libraries, regardless of language,
will page the database using the SQL `OFFSET` keyword, which by its
standardized definition will perform worse as the offset size grows
because the database still has to acknowledge the rows it is not
returning to the client. Instead, Tributary follows the "seek method,"
which adds a `WHERE` clause requesting only records higher than
the last seen key it is paging by.

For more resources on keyset pagination and why it is so important,
see the following posts:

  * ["Pagination Done the PostgreSQL Way"](http://leopard.in.ua/2014/10/11/postgresql-paginattion) by Alexey Vasiliev
  * ["We need tool support for keyset pagination"](http://use-the-index-luke.com/no-offset) by Markus Winand

Helpful Answers
---------------

### Is Tributary a paging library?

In the simplest terms, yes, in that it will "page" through data. However,
if you're looking for a library that will take a page number and a
number of objects and find the approppriate set of objects from
the database: no.

Tribtuary is designed for situations where you have to perform contextual
or complex data operations over a large subset of records in a table.
Instead of managing loops to page the data from the database and then
creating internal loops to iterate over records for each page, Tributary
provides you with a way to treat the entire data set you want to
operate on as a single, large enumerable while it silently loads
only the necessary data in the background.

Future Tasks
------------

- [ ] Support using mutli-column indexes

Testing
-------

To test Tributary, you will need to have Postgres installed and create a
testing database. You'll also need a test environment secrets file,
which you can create at `config/test.secret.exs`—this is already ignored
by git.

The most basic form looks something like this:

```elixir
use Mix.Config

config :tributary, Tributary.Repo,
  url: "postgres://localhost/tributary"
```

You may need to tweak the URL parameters. Or you can use the
other provided [Ecto Postgres adapter
options](https://hexdocs.pm/ecto/2.0.5/Ecto.Adapters.Postgres.html).

You will need to run `mix ecto.migrate` with the environment variable
`MIX_ENV` set to `test`:

```bash
MIX_ENV=test mix ecto.migrate
```

You should now be able to run `mix test`.

License
------

Tributary is issued under the MIT License. See the `LICENSE.md` file.

