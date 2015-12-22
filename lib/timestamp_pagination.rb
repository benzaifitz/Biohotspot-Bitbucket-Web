module TimestampPagination
  def self.included(base)
    base.class_eval do
      scope :updated_after, -> (timestamp){ where("#{self.table_name}.updated_at >= ?", timestamp) }
      scope :updated_before, -> (timestamp){ where("#{self.table_name}.updated_at <= ?", timestamp) }

      def self.paginate_with_timestamp(timestamp, direction)
        timestamp = timestamp || Time.now
        direction = direction || ApiController::DIRECTION[:down]
        records = self
        if direction.to_i == ApiController::DIRECTION[:up]
          records = records.updated_after(timestamp)
        elsif direction.to_i == ApiController::DIRECTION[:down]
          records = records.updated_before(timestamp).limit(20)
        end
        records.order('updated_at DESC')
      end
    end
  end

end