class ProductDatatable < AjaxDatatablesRails::ActiveRecord

  @_view_columns = nil

  ## set the ActiveRecord model here
  def get_model
    m = self.class.to_s.gsub(/Datatable$/,"").constantize
    AjaxDatatablesRails.configure do |config|
      config.db_adapter = m.connection_config[:adapter].gsub(/_/,"").to_sym
    end
    m
  end

  ## since view_columns runs for each row, and since our
  ## view_columns is dynamic, these helper methods are
  ## necessary to prevent an extra database select for
  ## each row
  def get_view_columns
    if @_view_columns.nil?
      set_default_view_columns
    end
    @_view_columns
  end

  def set_default_view_columns
    set_view_columns(get_model.first.attributes.keys.map)
  end

  def set_view_columns(columns)
    @_view_columns = columns
  end

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    #@view_columns ||= {
    #  # id: { source: "User.id", cond: :eq },
    #  # name: { source: "User.name", cond: :like }
    #}

    # just show everything
    @view_columns ||= get_view_columns.map {|k|
      {"#{k}": {source: "#{get_model}.#{k}"}}
    }.reduce Hash.new, :merge
  end

  def data
    #records.map do |record|
    #  {
    #    # example:
    #    # id: record.id,
    #    # name: record.name
    #  }
    #end

    # just show everything
    records.map do |record|
      record.attributes.keys.map { |k|
        {
          "#{k}": record[k]
        }
      }.reduce Hash.new, :merge
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    get_model.all
  end

end
