# frozen_string_literal: true

class User < ActiveRecord::Base
  include Stator::Model

  before_save :set_tagged_at

  stator track: true, initial: :pending do

    transition :activate do
      from :pending, :semiactivated
      to :activated
    end

    transition :deactivate do
      from any
      to :deactivated

      conditional do |condition|
        before_save :set_deactivated, if: condition
      end
    end

    transition :semiactivate do
      from :pending
      to :semiactivated

      conditional do |condition|
        validate :check_email_validity, if: condition
      end
    end

    transition :hyperactivate do
      from :activated
      to :hyperactivated
    end

    conditional :semiactivated, :activated do |condition|
      validate :check_email_presence, if: condition
    end

    state_alias :active, constant: true, scope: true do
      is :activated, :hyperactivated
      opposite :inactive, constant: true, scope: true
    end

    state_alias :luke_warm, constant: :luke_warmers, scope: :luke_warmers do
      is :semiactivated
      opposite :iced_tea
    end
  end

  validate :email_is_right_length

  protected

  def check_email_presence
    if email.nil? || email.empty?
      errors.add(:email, 'needs to be present')
      return false
    end

    true
  end

  def check_email_validity
    unless /example\.com$/.match?(email.to_s)
      errors.add(:email, 'format needs to be example.com')
      return false
    end

    true
  end

  def email_is_right_length
    unless email.to_s.length == 'four@example.com'.length
      errors.add(:email, 'needs to be the right length')
      return false
    end

    true
  end

  def set_deactivated
    self.activated = false
    true
  end

  def set_tagged_at
    self.tagged_at = semiactivated_state_at
  end
end

class Animal < ActiveRecord::Base
  include Stator::Model

  # initial state = unborn
  stator field: :status, track: true do
    transition :birth do
      from :unborn
      to :born
    end

    state :grown_up
  end
end

class Zoo < ActiveRecord::Base
  include Stator::Model

  # initial state = closed
  stator do
    transition :open do
      from :closed
      to :opened
    end

    transition :close do
      from  :opened
      to    :closed
    end

    conditional :opened do |c|
      validate :validate_lights_are_on, if: c
    end
  end

  protected

  def validate_lights_are_on
    true
  end
end

class ZooKeeper < ActiveRecord::Base
  include Stator::Model

  stator namespace: 'employment', field: 'employment_state', track: true do
    transition :hire do
      from nil, :fired
      to :hired
    end

    transition :fire do
      from :hired
      to :fired
    end
  end

  stator namespace: 'working', field: 'working_state', track: false do
    transition :start do
      from nil, :ended
      to :started
    end

    transition :end do
      from :started
      to :ended
    end
  end
end

class Farm < ActiveRecord::Base
  include Stator::Model

  # initial state = dirty
  stator do
    transition :cleanup do
      from :dirty
      to :clean
    end
  end

  # initial state = dirty
  stator namespace: 'house', field: 'house_state' do
    transition :cleanup do
      from :dirty
      to :clean
    end

    transition :ruin do
      from any
      to :disgusting
    end

    state_alias :cleaned do
      is_not :dirty, :disgusting
    end
  end
end

class Factory < ActiveRecord::Base
  include Stator::Model

  # initial state = nil
  stator do
    transition :construct do
      from nil
      to :constructed
    end

    transition :destruct do
      from :constructed
      to :on_the_ground
    end
  end
end
