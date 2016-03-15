Tributary
=========

Tributary is a helpful little plugin that pages your Ecto query for efficient
processing without any concern on your part for state management. It does
this by taking advantage of the [Elixir Stream](http://elixir-lang.org/docs/stable/elixir/Stream.html)
module which is a type of lazy enumerable. And it does this in a very efficient
manner on the database side.

Using Tributary
---------------

Before using Tributary itself, it's important that you take a quick look
at the table you want to query with Tributary. The table __must__ have
a unique field that is always ascending. In common database designs this
is going to be a primary key that is an auto-incremented integer on
the `id` column; however, Tributary knows how to deal with non-integer
keys as long as the database knows how to deal with them. 

Helpful Answers
---------------

### Is Tributary a paging library?

In the simplest terms, yes, in that it will page through data. However,
if you're looking for a library that will take a page number and a
number of objects and find the approppriate set of objects from
the database: no. 

