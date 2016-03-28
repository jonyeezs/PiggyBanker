# Piggy Monitor

No we're not monitoring a piglet's growth.

We're monitoring our piggybank!

This will be an educational experiment for me to learn Ruby and at the same time do some household management.



## What's involved

This is a ruby API service using Sinatra as the base.

Connected to Google Drive through [goodle-drive-ruby](https://github.com/gimite/google-drive-ruby).

Using rake to build my test.

## The Database

The database is a spreadsheet on google docs, formatted by preference of my SO.
So that's the limitation I have to work with but that's fine with me.

If this ever kicks off well with her, the spreadsheet can be changed to something more of a database structure.

This is the, strict, spreadsheet layout

![](spreadsheet_example_for_readme.png)

## Folder structure
```
  app\
    |
    | lib\
    |   | mappers
    |   | adapters
    |   | common functionalities
    |
    | models\
    |    | object models
    |
    | routes\
         | API url paths
```

## Starting the endpoint service

Sinatra just sits on top of rack. So why not utilize its simple startup process; thus the use of config.ru.

simple type `rackup`

## Run spec test

Command is `rake test`
