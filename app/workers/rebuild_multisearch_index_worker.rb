class RebuildMultisearchIndexWorker < ApplicationWorker
  sidekiq_options lock: :until_and_while_executing, on_conflict: :log

  def perform(class_name)
    PgSearch::Multisearch.rebuild(Object.const_get(class_name))
  end
end
