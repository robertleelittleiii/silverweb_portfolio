class ArtifactsController < ApplicationController

 #  uses_tiny_mce(:options => AppConfig.full_mce_options, :only => [:new, :edit])

  ACTION_VIEWERS = [["Image Slider","artifact_detail"],["Information Page","artifact_detail_custom"]]

  # GET /artifacts
  # GET /artifacts.json
  def index
   
    @artifacts = Artifact.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @artifacts} 
    end
  end

  # GET /artifacts/1
  # GET /artifacts/1.json
  def show
    @artifact = Artifact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @artifact }
    end
  end

  # GET /artifacts/new
  # GET /artifacts/new.json
  def new
    @artifact = Artifact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @artifact}
    end
  end

  # GET /artifacts/1/edit
  def edit
      if params[:request_type]== "nothing" then
      render nothing: true
    else
    @artifact = Artifact.find(params[:id])
    @action_viewers = ACTION_VIEWERS

    end
    
    @image_locations = ["Slider", "Primary","Cover", "Before", "Custom", "-"]  

  end

  # POST /artifacts
  # POST /artifacts.json
  def create
    @artifact = Artifact.new(artifact_params)

    respond_to do |format|
      if @artifact.save
        format.html { redirect_to(action: "edit", notice: "Artifact was successfully created.") }
        format.json { render json: @artifact, status: :created, location: @artifact }
      else
        format.html { render action: "new" }
        format.json { render json: @artifact.errors, status: :unprocessable_entry }
      end
    end
  end

  # PUT /artifacts/1
  # PUT /artifacts/1.json
  def update
    @artifact = Artifact.find(params[:id])

    respond_to do |format|
      if @artifact.update_attributes(artifact_params)
        format.html { redirect_to(action: "edit", notice: "Artifact was successfully updated.")  }
        format.json { render :json=> {:notice => 'Artifact was successfully updated.'} }
      else
        format.html { render action: "edit" }
        format.json { render json: @artifact.errors, status: "unprocessable_entry" }
      end
    end
  end

  # DELETE /artifacts/1
  # DELETE /artifacts/1.json
  def destroy
    @artifact = Artifact.find(params[:id])
    @artifact.destroy

    respond_to do |format|
      format.html { redirect_to artifacts_url }
      format.json { head :ok }
    end
  end
  
   # CREATE_EMPTY_RECORD /artifacts/1
   # CREATE_EMPTY_RECORD /artifacts/1.json

  def create_empty_record
    @artifact = Artifact.new
    @artifact.portfolio_id= params[:portfolio_id] rescue nil
    @artifact.name = "New Item"
    @artifact.description = "Enter Description Here."
    @artifact.position = 99
    @artifact.artifact_action_viewer = "artifact_detail"
    @artifact.artifact_active = true
    @artifact.save
    
    redirect_to(controller: :artifacts, action: :edit, id: @artifact)
  end

   def delete_ajax
    @artifact= Artifact.find(params[:id])
    @artifact.destroy
    render nothing: true
  end
  
  def artifacts_table
    
    @artifacts = Artifact.where(portfolio_id: params[:portfolio_id]);

    @objects = current_objects(params)
    @total_objects = total_objects(params)
    render layout: false
  end
  
  def add_image
    @artifact = Artifact.find(params[:id])
    format = params[:format]
    image=params[:image]
    if image.size > 0
      @picture = Picture.new(:image=>image)
      @picture.position=999
      @picture.active_flag=true
      image_saved = @picture.save
      @artifact.pictures<< @picture
    end
  
    respond_to do |format|
      if image_saved
        format.js   { render :action=>"../pictures/create.js" }
        format.html { redirect_to @picture, :notice=>"Picture was successfully created." }
        format.json { render :json=>@picture, :status=>:created, :location=>@picture }
      else
        format.html { render :action=>"new" }
        format.json { render :json=>@picture.errors, :status=>:unprocessable_entry }
      end
    end
  end
    
#  def add_image
#    @artifact = Artifact.find(params[:id])
#    @image_locations = ["Slider", "Primary","Cover", "Before", "Custom", "-"]  
#
#    format = params[:format]
#    image=params[:image]
#    if image.size > 0
#      @image = Picture.new(image: image)
#      @image.position=999
#      @image.title = "n/a"
#      @image.save
#      @artifact.pictures << @image
#    end
#    #  respond_to do |format|  
#    #          format.html { render :nothing => true}
#    #          format.js   { render :nothing => true }  
#    #  end  
#  
#    respond_to do |format|
#      flash[:notice] = 'Picture was successfully added.'
#      format.js do
#        responds_to_parent do
#          render :update do |page|
#            page.replace_html("images" , partial: "images" , object: @artifact.pictures)
#            if @artifact.pictures.count > 15
#              page.hide "imagebutton"
#            end
#            page.hide "loader_progress"
#            page.show "upload-form"
#            # page.call "alert", "test"
#            page.call "updateBestinplaceImageTitles"
#            #           page.call("jQuery('#loader_progress').toggle();")
#            # page.call("jQuery('#upload-form').toggle();")
#            # page.call("jQuery('.imageSingle .best_in_place').best_in_place();");
#            page.visual_effect :highlight, "image_#{@image.id}"
#            page[:images].show if @artifact.pictures.count == 1
#          end
#        end
#      end
#
#      format.html { redirect_to action: 'show', id: params[:id] }
#    end
#  end
  
   def delete_image
    @artifact = Artifact.find(params[:incoming_id])
    @image = Picture.find(params[:id])
    @image.destroy
   
    
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to action: 'show', id: params[:incoming_id]}
    end
  end


  def destroy_image
    @image = Picture.find(params[:id])
    @image.destroy
    redirect_to action: 'show', id: params[:id]
  end

  def update_image_order
    params[:picture].each_with_index do |id, position|
      #   Image.update(id, :position => position)
      Picture.reorder(id,position)
    end
    render nothing: true

  end
  
  def update_checkbox_tag
    @artifact=Artifact.find(params[:id])
    @tag_name=params[:tag_name] || "tag_list"
    # truely toggle the value
    
    if @artifact.send(@tag_name).include?(params[:field]) then
      @artifact.send(@tag_name).remove(params[:field])
    else
      @artifact.send(@tag_name).add(params[:field])
    end
    
    #    if params[:current_status]== "false" then
    #      @artifact.send(@tag_name).remove(params[:field])
    #    else
    #      @artifact.send(@tag_name).add(params[:field])
    #    end
    @artifact.save

    render(nothing: true)

    #   respond_to do |format|
    #       format.js if request.xhr?
    #       format.html {redirect_to :action => 'show', :id=>params[:id]}
    #  end

      
  end
  
    def render_category_div
    @artifact=Artifact.find(params[:id])
    render(partial: "category_div")
    
  end
  
    def sort
    @artifacts_per_portfolio = Settings.artifacts_per_portfolio.to_i || 8
    @current_page = params[:page].to_i
    
    params['artifact'].each_with_index do |artifact_id, counter|
      artifact = Artifact.find(artifact_id)
      new_position = counter + ((@current_page - 1) * @artifacts_per_portfolio) + 1
      old_position = artifact.position
  #    puts("Portfolio ID->#{artifact_id}: Old_position: #{artifact.position}, New Position: #{counter + ((@current_artifact - 1) * @artifacts_per_portfolio) + 1} ")
      if new_position != old_position
        artifact.position = new_position
        artifact.save 
      end

    end
    render nothing: true

  end
  
  def edit_picture
    @picture = Picture.find(params[:picture_id])
       @image_locations = ["Slider", "Primary","Cover", "Before", "Custom", "-"]  
     
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @picture} 
    end
  end
  
  
   private
 
  def current_objects(params={})
    current_page = (params[:iDisplayStart].to_i/params[:iDisplayLength].to_i rescue 0)+1
    
    @current_objects = Artifact.page(current_page).per(params[:iDisplayLength]).order("#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}").where(portfolio_id: params[:portfolio_id]).where(conditions)

  #  @current_objects = Artifact.where(:artifact_id=>[params[:artifact_id]]).paginate :page => current_page, 
  #    :order => "#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}", 
  #    :where => conditions,
  #    :per_page => params[:iDisplayLength]
    
    # @current_objects = Artifact.select("artifact.*").
    #   where(conditions).
    #   order("#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}")
  
  
  end
    

  def total_objects(params={})
    @total_objects = Artifact.where(portfolio_id: params[:portfolio_id]).where(conditions).count()
  end

  def datatable_columns(column_id)
    case column_id.to_i
    when 0
      return "artifacts.id"
    when 1
      return "artifacts.name"
    else
      return "artifacts.description"
    end
  end

  def conditions
    conditions = []
    conditions << "(artifacts.name LIKE '%#{params[:sSearch]}%' OR artifacts.description LIKE '%#{params[:sSearch]}%')" if(params[:sSearch])
    return conditions.join(" AND ")
  end
  
  def artifact_params
  params[:artifact].permit("name", "description", "portfolio_id", "created_at", "updated_at", "position", "artifact_active", "tag_list", "artifact_action_viewer","slider_width","slider_height","slider_effect","slider_play_speed","slider_nav")
 
end
  
end
 