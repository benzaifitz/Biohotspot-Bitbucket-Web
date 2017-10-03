module Extensions
  module ActiveRecordLogger
    IGNORE_PAYLOAD_NAMES = ActiveRecord::LogSubscriber::IGNORE_PAYLOAD_NAMES

    # ActiveRecord::LogSubscriber doesn't implement this method.
    # This method will be invoked before event starts processing.
    # It's exactly we are looking for!
    def start(name, id, payload)
      super

      return unless logger.debug?
      return if IGNORE_PAYLOAD_NAMES.include?(payload[:name])

      name = payload[:name]
      sql = payload[:sql]

      name = color(name, nil, true)
      sql  = color(sql, nil, true)

      debug "STARTING #{name}  #{sql}"
    end
  end
end

ActiveRecord::LogSubscriber.include Extensions::ActiveRecordLogger