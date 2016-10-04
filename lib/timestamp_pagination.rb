module TimestampPagination
  def self.included(base)
    base.class_eval do
      scope :updated_after, -> (timestamp){ where("#{self.table_name}.updated_at > ?", timestamp) }
      scope :updated_before, -> (timestamp){ where("#{self.table_name}.updated_at < ?", timestamp) }
      scope :created_after, -> (timestamp){ where("#{self.table_name}.created_at > ?", timestamp) }
      scope :created_before, -> (timestamp){ where("#{self.table_name}.created_at < ?", timestamp) }

      def self.paginate_with_timestamp(timestamp, direction, timestamp_type=0 ,order_by_attr='updated_at', order_by_direction='DESC')
        timestamp ||= Time.now
        direction ||= Api::V1::DIRECTION[:down]
        records = self
        if direction.to_i == Api::V1::DIRECTION[:up]
          records = timestamp_type == Api::V1::TIMESTAMP_TYPE[:updated_at] ? records.updated_after(timestamp) : records.created_after(timestamp)
        elsif direction.to_i == Api::V1::DIRECTION[:down]
          records = timestamp_type == Api::V1::TIMESTAMP_TYPE[:updated_at] ? records.updated_before(timestamp).limit(Api::V1::LIMIT) : records.created_before(timestamp).limit(Api::V1::LIMIT)
        end
        records.order("#{order_by_attr} #{order_by_direction}")
      end
    end
  end

end