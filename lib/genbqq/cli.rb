require "genbqq"

require "google/cloud/bigquery"
require "thor"

module GenBqq
  class CLI < Thor
    desc "merge {project.dataset.table}", "generate merge sql template from BigQuery table"
    def merge(full_table_str)
      prj, dataset, tbl = full_table_str.split "."
      puts "-- project: #{prj}"
      puts "-- dataset: #{dataset}"
      puts "-- table: #{tbl}"

      bq = Google::Cloud::Bigquery.new project: prj
      target_tbl = bq.dataset(dataset).table(tbl)
      # puts target_tbl.headers
      cols_str = target_tbl.headers.map{|col| "  target.#{col} = tmp.#{col}"}.join(",\n")

      result = <<-EOQ
MERGE `#{full_table_str}` target USING `#{full_table_str}_tmp` tmp
ON(target.id = tmp.id)
WHEN MATCHED AND target.updated_at < tmp.updated_at THEN
  -- idが一致かつ、更新日時が増えている場合は行を更新する
  UPDATE SET
  -- 更新対象としたいカラムをすべて記述する
#{cols_str}
WHEN NOT MATCHED THEN
  -- 不一致 = 新規行として判断し、追加する
  INSERT ROW
      EOQ

      puts result
    end

  end
end
