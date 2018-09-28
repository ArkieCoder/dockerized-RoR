class ReportIndicesController < ApplicationController
  def index
    ## plain JSON response
    #json_response(ReportIndex.all)
    ## naive response for Datatables.net front end, not using ajax-datatables-rails
    #json_response({data: ReportIndex.all})
    ## using ajax-datatables-rails
    json_response(ReportIndexDatatable.new(params))
  end

  def show
    id = params[:id]
    ## required for DataTables dynamic columns
    if (id == "columns")
      @report_index = {
        columns: ReportIndex.first.attributes.keys.map do |k|
          {
            title: k,
            data: k
          }
        end
      }
    else
      @report_index = ReportIndex.find(id)
    end
    json_response(@report_index)
  end
end
