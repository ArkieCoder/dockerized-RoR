module ProductRecord 
  extend ActiveSupport::Concern
  db_opts = {
    :adapter => 'oracle_enhanced',
    :username => ENV['ORACLE_USERNAME'],
    :password => ENV['ORACLE_PASSWORD'],
    :database => ENV['ORACLE_TST_DB'],
    :schema => ENV['ORACLE_SCHEMA']
  }
  if ENV['DBENV'] == 'prod'
    db_opts[:database] = ENV['ORACLE_PROD_DB']
  end

  included do
    establish_connection(db_opts)
  end

  def to_h
    self.attributes.to_options
  end
end

class Product < ActiveRecord::Base
  include ProductRecord
  self.table_name = "ORCL_PRODUCTS"
end
