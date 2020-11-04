begin
  ::FactoryWrapper.call(command_options)
rescue StandardError => e
  logger.error "#{e.class}: #{e.message}"
  logger.error e.backtrace.join("\n")
  logger.error e.record.to_s if e.is_a?(ActiveRecord::RecordInvalid)
  raise e
end
