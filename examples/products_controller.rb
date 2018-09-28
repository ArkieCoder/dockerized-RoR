class ProductsController < ApplicationController
  def index
    ## plain JSON response
    #json_response(Product.all)
    ## naive response for Datatables.net front end, not using ajax-datatables-rails
    #json_response({data: Product.all})
    ## using ajax-datatables-rails
    json_response(ProductDatatable.new(params))
  end
    
  def show
    id = params[:id]
    ## required for DataTables dynamic columns
    if (id == "columns")
      @products = {
        columns: Product.first.attributes.keys.map do |k|
          {
            title: k,
            data: k
          }
        end
      }
    else
      @products = Products.find(id)
    end
    json_response(@products)
  end 
end
