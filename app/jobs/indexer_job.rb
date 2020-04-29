class IndexerJob < ApplicationJob
  queue_as :default

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: 'localhost:9200', logger: Logger

  def perform(operation:, record_id:, record_class:)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when /index/
      record = record_class.find(record_id)
      Client.index(index: index_name(record_class), id: record_id, body: record.__elasticsearch__)
    when /delete/
      begin
        Client.delete(index: index_name(record_class), id: record_id)
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        logger.debug("Object not found, ID: #{record_id}")
      end
    else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end

  private

  def index_name(record_class)
    record_class.name.pluralize.downcase
  end

  def index_type(record_class)
    record_class.name.downcase
  end
end
