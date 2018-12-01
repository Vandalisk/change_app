# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database,
# and then regenerate this schema definition.
#
ActiveRecord::Schema.define(version: 2018_12_01_110511) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'coins', force: :cascade do |t|
    t.float 'value'
    t.integer 'count'
  end
end
