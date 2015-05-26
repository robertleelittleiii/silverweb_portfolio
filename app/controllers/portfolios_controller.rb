class PortfoliosController < ApplicationController
  # uses_tiny_mce(:options => AppConfig.full_mce_options, :only => [:new, :edit])

  
  # GET /portfolios
  # GET /portfolios.json
  def index
    @portfolios = Portfolio.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @portfolios} 
    end
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
    @portfolio = Portfolio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @portfolio }
    end
  end

  # GET /portfolios/new
  # GET /portfolios/new.json
  def new
    @portfolio = Portfolio.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @portfolio}
    end
  end

  # GET /portfolios/1/edit
  def edit
        session[:mainnav_status] = true

    @portfolio = Portfolio.find(params[:id])
  end

  # POST /portfolios
  # POST /portfolios.json
  def create
    @portfolio = Portfolio.new(portfolio_params)

    respond_to do |format|
      if @portfolio.save
        format.html { redirect_to @portfolio, notice: "Portfolio was successfully created." }
        format.json { render json: @portfolio, status: :created, location: @portfolio }
      else
        format.html { render action: "new" }
        format.json { render json: @portfolio.errors, status: :unprocessable_entry }
      end
    end
  end

  # PUT /portfolios/1
  # PUT /portfolios/1.json
  def update
    @portfolio = Portfolio.find(params[:id])

    respond_to do |format|
      if @portfolio.update_attributes(portfolio_params)
        format.html { redirect_to action: "edit", notice: "Portfolio was successfully updated."}
        format.json { render :json=> {:notice => 'Portfolio was successfully updated.'} }
      else
        format.html { render action: "edit" }
        format.json { render json: @portfolio.errors, status: "unprocessable_entry" }
      end
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy
    @portfolio = Portfolio.find(params[:id])
    @portfolio.destroy

    respond_to do |format|
      format.html { redirect_to portfolios_url }
      format.json { head :ok }
    end
  end
  
   # CREATE_EMPTY_RECORD /portfolios/1
   # CREATE_EMPTY_RECORD /portfolios/1.json

  def create_empty_record
    @portfolio = Portfolio.new
    @portfolio.portfolio_active = true
    @portfolio.position = 99
    @portfolio.save
    
    redirect_to(controller: :portfolios, action: :edit, id: @portfolio)
  end

  def sort
    @portfolios_per_portfolio = Settings.portfolios_per_portfolio.to_i || 8
    @current_page = params[:page].to_i
    
    params['portfolio'].each_with_index do |portfolio_id, counter|
      portfolio = Portfolio.find(portfolio_id)
      new_position = counter + ((@current_page - 1) * @portfolios_per_portfolio) + 1
      old_position = portfolio.position
  #    puts("Portfolio ID->#{portfolio_id}: Old_position: #{portfolio.position}, New Position: #{counter + ((@current_portfolio - 1) * @portfolios_per_portfolio) + 1} ")
      if new_position != old_position
        portfolio.position = new_position
        portfolio.save 
      end

    end
    render nothing: true

  end
  
  def portfolio_table
    @objects = current_objects(params)
    @total_objects = total_objects(params)
    render layout: false
  end
  
   def delete_ajax
    @portfolio =  Portfolio.find(params[:id])
    @portfolio.destroy
    render nothing: true
  end
  
  
  private

  def current_objects(params={})
    current_portfolio = (params[:iDisplayStart].to_i/params[:iDisplayLength].to_i rescue 0)+1
    @current_objects = Portfolio.page(current_portfolio).per(params[:iDisplayLength]).order("#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}").where(conditions(params))
  end
  

  def total_objects(params={})
    @total_objects = Portfolio.where(conditions(params)).count()
  end

  def datatable_columns(column_id)
    puts(column_id)
    case column_id.to_i
    when 0
      return "`portfolios`.`id`"
    when 1
      return "`portfolios`.`name`"
    else
      return "`portfolios`.`description`"
    end
  end

      
  def conditions(params={})
    
    conditions = []
   
    conditions << "(portfolios.id LIKE '%#{params[:sSearch]}%' OR
       portfolios.name LIKE '%#{params[:sSearch]}%' OR 
       portfolios.description LIKE '%#{params[:sSearch]}%')" if(params[:sSearch])
    return conditions.join(" AND ")
  end
  
  def portfolio_params
  params[:portfolio].permit( "name", "description", "meta_description", "meta_keywords", "meta_robot", "created_at", "updated_at", "location", "portfolio_active", "position")
end
  
end
