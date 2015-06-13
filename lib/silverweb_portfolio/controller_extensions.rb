module SilverwebPortfolio
  module ControllerExtensions
  
    module SiteControllerExtensions
    
      def self.included(base)
        base.send(:include, InstanceMethods)
        # base.alias_method_chain :new, :my_module
      end

      module InstanceMethods
        def show_custom_portfolios
          session[:mainnav_status] = false
          session[:last_catetory] = request.env['REQUEST_URI']
          @page_name=Menu.find(session[:parent_menu_id]).name rescue ""
    
          @customs_per_page = Settings.portfolios_per_page.to_i || 8
          @category_id = params[:category_id] || ""
          @department_id = params[:department_id] || ""
          @category_children = params[:category_children] || false
          @get_first_submenu = params[:get_first_sub] || false
          @the_page = params[:page] || "1"
    
    
          puts("----------- *********** ----------- ************")
          puts(" @category_id = '#{@category_id}'")
          puts(" @department_id = '#{@department_id}' ")
          puts(" @category_children = '#{@category_children}'")
          puts(" @get_first_submenu = '#{@get_first_submenu}'")
          puts(" @the_page = '#{@the_page}' ")


          @menu = Menu.where(:name=>@department_id).first 
    
          puts("@menu.menus: #{@menu.menus.inspect}" )

          puts("----------- *********** ----------- ************")

          if params[:top_menu] and @get_first_submenu == "true" then
            # puts("top_menu id: #{@menu.menus[0].name}")
            session[:parent_menu_id] = @menu.id rescue 0
            #@menu = @menu.menus[0]
            @category_id = @menu.name rescue "n/a"
          end
      
          #@page_name=Menu.find(session[:parent_menu_id]).name rescue ""
          # begin 
          #    if @category_children == "true" then
          #      @categories =  create_menu_lowest_child_list(@category_id, nil,false) + [@category_id]
          #      puts("categories: #{@categories.inspect} ")
          #      @artifacts_list = Artifact.where(:artifact_active=>true).tagged_with(@categories, :any=>true, :on=>:category).tagged_with(@department_id, :on=>:department)
          #
          #    else
          #      if @category_id.blank? and @department_id.blank? then
          #        puts("both  @category_id and  @department_id blank!")
          #        @artifacts_list = Artifact.where(:artifact_active=>true)
          #      else
          #        if @category_id.empty? or (@category_id = @department_id)   then
          #          puts("@category_id blank!")
          #
          #          @artifacts_list = Artifact.where(:artifact_active=>true).tagged_with(@department_id, :on=>:department)
          #        else
          #          puts("neither  @category_id and  @department_id blank!")
          #          @artifacts_list = Artifact.where(:artifact_active=>true).tagged_with(@category_id, :on=>:category).tagged_with(@department_id, :on=>:department)
          #        end
          #      end
          #    end
          #  rescue
          #    @artifacts_list = Artifact.all
          #  end
    
          #@artifact_ids = @artifacts_list.collect{|artifact| artifact.id }

          #puts("@artifact_ids --> #{@artifact_ids.inspect }")
    
    
          @customs_count = @menu.menus.length

          # @portfolios = Kaminari.paginate_array(@portfolios).page(params[:page]).per(@portfolios_per_page)
          # @artifacts = Artifact.where(:id=>@artifact_ids).order("position ASC").order("created_at DESC").page(params[:page]).per(@portfolios_per_page)
          @customs = @menu.menus.where(:menu_active=>true).order(:m_order).page(params[:page]).per(@customs_per_page)
          #    @portfolios = @portfolios.page(params[:page]).per(@portfolios_per_page)

          @customs_first = params[:page].blank? ? "1" : (params[:page].to_i*@customs_per_page - (@customs_per_page-1))
    
          @customs_last = params[:page].blank? ? @customs.length : ((params[:page].to_i*@customs_per_page) - @customs_per_page) + @customs.length || @customs.length


          respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @artifacts }
          end
        end
  
        def update_artifact_partial
          @artifact = Artifact.find(params[:id])
          
          render :partial=>"artifact_item.html"
          
        end
        
        def show_portfolios
          session[:mainnav_status] = false
          session[:last_catetory] = request.env['REQUEST_URI']
          @page_name=Menu.find(session[:parent_menu_id]).name || "Portfolios" rescue ""
    
          @portfolios_per_page = Settings.portfolios_per_page.to_i || 8
          @category_id = params[:category_id] || ""
          @department_id = params[:department_id] || ""
          @category_children = params[:category_children] || false
          @get_first_submenu = params[:get_first_sub] || false
          @the_page = params[:page] || "1"
    
          @menu = Menu.where(:name=>@category_id).first 
  
          if params[:top_menu] then
            # puts("top_menu id: #{@menu.menus[0].name}")
            session[:parent_menu_id] = @menu.id rescue 0
            @menu = @menu.menus[0] rescue Menu.new
            @category_id = @menu.name rescue "n/a"

          end
      
          #@page_name=Menu.find(session[:parent_menu_id]).name rescue ""
          @portfolios_list = Portfolio.where(:portfolio_active=>true)
          # begin 
          #      if @category_children == "true" then
          #        @categories =  create_menu_lowest_child_list(@category_id, nil,false) + [@category_id]
          #        puts("categories: #{@categories.inspect} ")
          #        @portfolios_list = Portfolio.where(:portfolio_active=>true)
          #
          #      else
          #        if @category_id.blank? or @department_id.blank? then
          #          @portfolios_list = Portfolio.where(:portfolio_active=>true)
          #        else
          #          @portfolios_list = Portfolio.where(:portfolio_active=>true).tagged_with(@category_id, :on=>:category).tagged_with(@department_id, :on=>:department)
          #        end
          #      end
          #    rescue
          #      @portfolios_list = Portfolio.all
          #    end
    
          @portfolio_ids = @portfolios_list.collect{|prod| prod.id }

          puts("@portfolio_ids --> #{@portfolios_list.inspect }")
    
    
          @portfolio_count = @portfolios_list.length

          # @portfolios = Kaminari.paginate_array(@portfolios).page(params[:page]).per(@portfolios_per_page)
          @portfolios = Portfolio.where(:id=>@portfolio_ids).order("position ASC").order("created_at DESC").page(params[:page]).per(@portfolios_per_page)
          #    @portfolios = @portfolios.page(params[:page]).per(@portfolios_per_page)

          @portfolio_first = params[:page].blank? ? "1" : (params[:page].to_i*@portfolios_per_page - (@portfolios_per_page-1))
    
          @portfolio_last = params[:page].blank? ? @portfolios.length : ((params[:page].to_i*@portfolios_per_page) - @portfolios_per_page) + @portfolios.length || @portfolios.length


          respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @portfolios }
          end
        end
  
        def show_artifact_group
          session[:mainnav_status] = false
          session[:last_catetory] = request.env['REQUEST_URI']
          @page_name=Menu.find(session[:parent_menu_id]).name rescue ""
    
          @artifacts_per_page = Settings.portfolios_per_page.to_i || 8
          @category_id = params[:category_id] || ""
          @department_id = params[:department_id] || ""
          @category_children = params[:category_children] || false
          @get_first_submenu = params[:get_first_sub] || false
          @the_page = params[:page] || "1"
          puts("----------- *********** ----------- ************")
          puts(" @category_id = '#{@category_id}'")
          puts(" @department_id = '#{@department_id}' ")
          puts(" @category_children = '#{@category_children}'")
          puts(" @get_first_submenu = '#{@get_first_submenu}'")
          puts(" @the_page = '#{@the_page}' ")
          puts("----------- *********** ----------- ************")


          @menu = Menu.where(:name=>@department_id).first 
  
          if params[:top_menu] and @get_first_submenu == "true" then
            # puts("top_menu id: #{@menu.menus[0].name}")
            session[:parent_menu_id] = @menu.id rescue 0
            @menu = @menu.menus[0]
            @category_id = @menu.name rescue "n/a"
          end
      
          #@page_name=Menu.find(session[:parent_menu_id]).name rescue ""
          # begin 
          if @category_children == "true" then
            @categories =  create_menu_lowest_child_list(@category_id, nil,false) + [@category_id]
            puts("categories: #{@categories.inspect} ")
            @artifacts_list = Artifact.where(:artifact_active=>true).tagged_with(@categories, :any=>true, :on=>:category).tagged_with(@department_id, :on=>:department)

          else
            if @category_id.blank? and @department_id.blank? then
              puts("both  @category_id and  @department_id blank!")
              @artifacts_list = Artifact.where(:artifact_active=>true)
            else
              if @category_id.empty? or (@category_id = @department_id)   then
                puts("@category_id blank!")

                @artifacts_list = Artifact.where(:artifact_active=>true).tagged_with(@department_id, :on=>:department)
              else
                puts("neither  @category_id and  @department_id blank!")
                @artifacts_list = Artifact.where(:artifact_active=>true).tagged_with(@category_id, :on=>:category).tagged_with(@department_id, :on=>:department)
              end
            end
          end
          #  rescue
          #    @artifacts_list = Artifact.all
          #  end
    
          @artifact_ids = @artifacts_list.collect{|artifact| artifact.id }

          puts("@artifact_ids --> #{@artifact_ids.inspect }")
    
    
          @artifact_count = @artifacts_list.length

          # @portfolios = Kaminari.paginate_array(@portfolios).page(params[:page]).per(@portfolios_per_page)
          @artifacts = Artifact.where(:id=>@artifact_ids).order("position ASC").order("created_at DESC").page(params[:page]).per(@artifacts_per_page)
          #    @portfolios = @portfolios.page(params[:page]).per(@portfolios_per_page)

          @artifact_first = params[:page].blank? ? "1" : (params[:page].to_i*@artifacts_per_page - (@artifacts_per_page-1))
    
          @artifact_last = params[:page].blank? ? @artifacts.length : ((params[:page].to_i*@artifacts_per_page) - @artifacts_per_page) + @artifacts.length || @artifacts.length


          respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @artifacts }
          end
        end
  
        def show_artifact_custom_group
          session[:mainnav_status] = false
          session[:last_catetory] = request.env['REQUEST_URI']
          @page_name=Menu.find(session[:parent_menu_id]).name rescue ""
    
          @artifacts_per_page = Settings.portfolios_per_page.to_i || 8
          @category_id = params[:category_id] || ""
          @department_id = params[:department_id] || ""
          @category_children = params[:category_children] || false
          @get_first_submenu = params[:get_first_sub] || false
          @the_page = params[:page] || "1"
          puts("----------- *********** ----------- ************")
          puts(" @category_id = '#{@category_id}'")
          puts(" @department_id = '#{@department_id}' ")
          puts(" @category_children = '#{@category_children}'")
          puts(" @get_first_submenu = '#{@get_first_submenu}'")
          puts(" @the_page = '#{@the_page}' ")
          puts("----------- *********** ----------- ************")


          @menu = Menu.where(:name=>@department_id).first 
  
          if params[:top_menu] and @get_first_submenu == "true" then
            # puts("top_menu id: #{@menu.menus[0].name}")
            session[:parent_menu_id] = @menu.id rescue 0
            @menu = @menu.menus[0]
            @category_id = @menu.name rescue "n/a"
          end
      
          #@page_name=Menu.find(session[:parent_menu_id]).name rescue ""
          # begin 
          if @category_children == "true" then
            @categories =  create_menu_lowest_child_list(@category_id, nil,false) + [@category_id]
            puts("categories: #{@categories.inspect} ")
            @artifacts_list = Artifact.tagged_with(@categories, :any=>true, :on=>:category).tagged_with(@department_id, :on=>:department)

          else
            if @category_id.blank? and @department_id.blank? then
              puts("both  @category_id and  @department_id blank!")
              @artifacts_list = Artifact
            else
              if @category_id.empty? or (@category_id = @department_id)   then
                puts("@category_id blank!")

                @artifacts_list = Artifact.tagged_with(@department_id, :on=>:department)
              else
                puts("neither  @category_id and  @department_id blank!")
                @artifacts_list = Artifact.tagged_with(@category_id, :on=>:category).tagged_with(@department_id, :on=>:department)
              end
            end
          end
          #  rescue
          #    @artifacts_list = Artifact.all
          #  end
    
          @artifact_ids = @artifacts_list.collect{|artifact| artifact.id }

          puts("@artifact_ids --> #{@artifact_ids.inspect }")
    
    
          @artifact_count = @artifacts_list.length

          # @portfolios = Kaminari.paginate_array(@portfolios).page(params[:page]).per(@portfolios_per_page)
          @artifacts = Artifact.where(:id=>@artifact_ids).order("position ASC").order("created_at DESC").page(params[:page]).per(@artifacts_per_page)
          #    @portfolios = @portfolios.page(params[:page]).per(@portfolios_per_page)

          @artifact_first = params[:page].blank? ? "1" : (params[:page].to_i*@artifacts_per_page - (@artifacts_per_page-1))
    
          @artifact_last = params[:page].blank? ? @artifacts.length : ((params[:page].to_i*@artifacts_per_page) - @artifacts_per_page) + @artifacts.length || @artifacts.length


          respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @artifacts }
          end
        end
  

  
        def portfolio_detail

          session[:mainnav_status] = false
          if params[:id].blank? then
            @portfolio = Portfolio.first
          else
            @portfolio = Portfolio.find(params[:id]) 
          end
          puts("in portfolio detail!")
          if params[:next] then
            @portfolio = @portfolio.next_in_collection
            puts "=======NEXT========"
          end
    
          if params[:prev] then
            @portfolio = @portfolio.previous_in_collection
            puts "=======PREV======="

          end
          @menu_id= session[:parent_menu_id] || 0
          @menu = Menu.find(@menu_id) rescue Menu.all[0]
    
          # session[:parent_menu_id] = 0
    
          @collection_portfolio_list = Portfolio.all()
          #@pictures = @portfolio.pictures.where(:active_flag=>true)

          @artifacts = @portfolio.artifacts.where(:artifact_active=>true).order(:position)
      

    
          respond_to do |format|
            format.html { render :action=>@page_template} # show.html.erb
            format.xml  { render :xml => @page }
          end
    
        end
  
        def artifact_detail

         
          session[:mainnav_status] = false
          if params[:id].blank? then
            @artifact = Artifact.first
          else
            @artifact = Artifact.find(params[:id]) 
          end
                    
          if params[:next] then
            @artifact = @artifact.next_in_collection
            puts "=======NEXT========"
          end
    
          if params[:prev] then
            @artifact = @artifact.previous_in_collection
            puts "=======PREV======="

          end
          @menu_id= session[:parent_menu_id] || 0
          @menu = Menu.find(@menu_id) rescue Menu.all[0]
    
          # session[:parent_menu_id] = 0
    
          @collection_portfolio_list = Artifact.all()
          #@pictures = @artifact.pictures.where(:active_flag=>true)

          #@artifacts = @artifact.where(:artifact_active=>true).order(:position)
      

    
          respond_to do |format|
            if @artifact.action_viewer != "artifact_detail" then
              redirect_to :action => @artifact.action_viewer, :params=>params 
              return
            else
              format.html { render :action=>@page_template} # show.html.erb
              format.xml  { render :xml => @page }
            end
          
          end
    
        end
  
        def artifact_detail_custom

          session[:mainnav_status] = false
          if params[:id].blank? then
            @artifact = Artifact.first
          else
            @artifact = Artifact.find(params[:id]) 
          end
    
          if params[:next] then
            @artifact = @artifact.next_in_collection
            puts "=======NEXT========"
          end
    
          if params[:prev] then
            @artifact = @artifact.previous_in_collection
            puts "=======PREV======="

          end
          @menu_id= session[:parent_menu_id] || 0
          @menu = Menu.find(@menu_id) rescue Menu.all[0]
    
          # session[:parent_menu_id] = 0
    
          @collection_portfolio_list = Artifact.all()
          #@pictures = @artifact.pictures.where(:active_flag=>true)

          #@artifacts = @artifact.where(:artifact_active=>true).order(:position)
      

    
          respond_to do |format|
            format.html { render :action=>@page_template} # show.html.erb
            format.xml  { render :xml => @page }
          end
    
        end
  
        # override the 'new' method
        # def new_with_my_module
        #   # do stuff
        # end
      end
    
    end
  
  


  end

end