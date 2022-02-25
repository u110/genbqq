# Genbqq

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/genbqq`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'genbqq'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install genbqq

## Usage

```
$ BIGQUERY_CREDENTIALS=./cred.json genbqq merge web-u-project.sample_dataset.many_cols_tbl
-- project: web-u-project
-- dataset: sample_dataset
-- table: many_cols_tbl
MERGE `web-u-project.sample_dataset.many_cols_tbl` target USING `web-u-project.sample_dataset.many_cols_tbl_tmp` tmp
ON(target.id = tmp.id)
WHEN MATCHED AND target.updated_at < tmp.updated_at THEN
  -- idが一致かつ、更新日時が増えている場合は行を更新する
  UPDATE SET
  -- 更新対象としたいカラムをすべて記述する
  ...
  target.updated_at = tmp.updated_at
WHEN NOT MATCHED THEN
  -- 不一致 = 新規行として判断し、追加する
  INSERT ROW
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/genbqq.
