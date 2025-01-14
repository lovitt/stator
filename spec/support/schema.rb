# frozen_string_literal: true

ActiveRecord::Schema.define(version: 20_130_628_161_227) do
  create_table 'users', force: true do |t|
    t.string   'name'
    t.string   'email'
    t.datetime 'tagged_at'
    t.string   'state',                                 default: 'pending'
    t.boolean  'activated',                             default: true
    t.datetime 'created_at',                            null: false
    t.datetime 'updated_at',                            null: false
    t.datetime 'semiactivated_state_at'
    t.datetime 'activated_state_at'
  end

  create_table 'animals', force: true do |t|
    t.string   'name'
    t.string   'status',                                default: 'unborn'
    t.datetime 'created_at',                            null: false
    t.datetime 'updated_at',                            null: false
    t.datetime 'status_changed_at'
    t.datetime 'unborn_status_at'
    t.datetime 'born_status_at'
  end

  create_table 'zoo_keepers', force: true do |t|
    t.string   'name'
    t.string   'employment_state', default: 'hired'
    t.datetime 'hired_employment_state_at'
    t.datetime 'fired_employment_state_at'
    t.string   'working_state'
    t.datetime 'started_working_state_at'
    t.datetime 'ended_working_state_at'
  end

  create_table 'zoos', force: true do |t|
    t.string   'name'
    t.string   'state',                                 default: 'closed'
    t.datetime 'created_at',                            null: false
    t.datetime 'updated_at',                            null: false
  end

  create_table 'farms', force: true do |t|
    t.string   'name'
    t.string   'state',                                 default: 'dirty'
    t.string   'house_state',                           default: 'dirty'
    t.datetime 'created_at',                            null: false
    t.datetime 'updated_at',                            null: false
  end

  create_table 'factories', force: true do |t|
    t.string 'name'
    t.string 'state'
  end
end
