module TimestampPagination
  def self.included(base)
    base.class_eval do
      scope :updated_after, -> (timestamp){ where("#{self.table_name}.updated_at >= ?", timestamp) }
      scope :updated_before, -> (timestamp){ where("#{self.table_name}.updated_at <= ?", timestamp) }

      def self.paginate_with_timestamp(timestamp, direction)
        timestamp ||= Time.now
        direction ||= Api::V1::DIRECTION[:down]
        records = self
        if direction.to_i == Api::V1::DIRECTION[:up]
          records = records.updated_after(timestamp)
        elsif direction.to_i == Api::V1::DIRECTION[:down]
          records = records.updated_before(timestamp).limit(20)
        end
        records.order('updated_at DESC')
      end
    end
  end

end