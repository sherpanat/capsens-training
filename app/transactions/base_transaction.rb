class BaseTransaction
  include Dry::Transaction

  def self.execute(*args, &block)
    new.call(*args, &block)
  end
end
