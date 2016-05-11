# Quick

## Introduction

Quick is a fluent query builder for ColdBox.  Using Quick, you can:

+ Quickly scaffold simple queries
+ Make complex, out-of-order queries possible
+ Abstract away differences between database engines

## Code Samples

Compare these two examples:

```cfc
// Plain old CFML
q = queryExecute("SELECT * FROM users");

// Quick
query = wirebox.getInstance('Builder@Quick');
q = query.from('users').get();
```

The differences become even more stark when we introduce more complexity:

```cfc
// Plain old CFML
q = queryExecute(
    "SELECT * FROM posts WHERE published_at IS NOT NULL AND author_id IN ?",
    [ { value = '5,10,27', cfsqltype = 'CF_SQL_NUMERIC', list = true } ]
);

// Quick
query = wirebox.getInstance('Builder@Quick');
q = query.from('posts')
         .whereNotNull('published_at')
         .whereIn('author_id', [5, 10, 27])
         .get();
```

With Quick you can easily handle setting order by statements before the columns you want or join statements after a where clause:

```cfc
query = wirebox.getInstance('Builder@Quick');
q = query.from('posts')
         .orderBy('published_at')
         .select('post_id', 'author_id', 'title', 'body')
         .whereLike('author', 'Ja%')
         .join('authors', 'authors.id', '=', 'posts.author_id')
         .get();

// Becomes

q = queryExecute(
    "SELECT post_id, author_id, title, body FROM posts INNER JOIN authors ON authors.id = posts.author_id WHERE author LIKE ? ORDER BY published_at",
    [ { value = 'Ja%', cfsqltype = 'CF_SQL_VARCHAR', list = false, null = false } ]
);
```

Quick enables you to explore new ways of organizing your code by letting you pass around a query builder object that will compile down to the right SQL without you having to keep track of the order, whitespace, or other SQL gotchas!

Here's a gist with an example of the powerful models you can create with this!
https://gist.github.com/elpete/80d641b98025f16059f6476561d88202

## Installation

Installation is easy through [CommandBox](https://www.ortussolutions.com/products/commandbox) and [ForgeBox](https://www.coldbox.org/forgebox).  Simply type `box install quick` to get started.

## Usage

To start a new query, instantiate a new Builder: `wirebox.getInstance('Builder@Quick')`.

## Docs

[See our wiki!](https://github.com/elpete/quick/wiki)