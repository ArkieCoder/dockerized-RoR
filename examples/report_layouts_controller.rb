class ReportLayoutsController < ApplicationController
  def index
    excluded_columns = ['Layout', 'FilterResults', 'Report']
    @report_layouts = ReportLayout.all.select(
      ReportLayout.attribute_names - excluded_columns 
    )
    json_response(@report_layouts)
  end
    
  def show
    @report_layout = ReportLayout.find(params[:id])
    json_response(@report_layout)
  end 
end
