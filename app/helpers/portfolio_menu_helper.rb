module PortfolioMenuHelper

  #  def menu_show_artifact_group
  #    return "junk"
  #  end

  def menu_show_portfolios(menuItem, html_options, span_options, class_options=nil, options=nil)
    
    return_link = ""
    
    puts("options-> #{options}")
    
    class_options==nil ? class_options={} : ""
    
    puts("menuItem.name:#{menuItem.name}")
    
    if menuItem.menu_active then
      menuText="<span "+ span_options +">"+menuItem.name + "</span>"

      if not options.blank? then
        if not options[:menu_name_sub_container].blank? then
          menu_sub_container_start = "<#{options[:menu_name_sub_container]}>"
          menu_sub_container_end= "</#{options[:menu_name_sub_container]}>"
        else
          menu_sub_container_start =  menu_sub_container_end= ""
        end
      
        if not options[:menu_name_container].blank? then
          menuText="<#{options[:menu_name_container]}" + span_options +">"+ menu_sub_container_start + menuItem.name + menu_sub_container_end + "</{options[:menu_name_container]}>"
        else
          menuText="<span "+ span_options +">"+ menu_sub_container_start + menuItem.name + menu_sub_container_end + "</span>"

        end
      end
      
      #  menuText="<span "+ span_options +">"+menuItem.name + "</span>"
      #top_menu = Menu.find(session[:parent_menu_id]) rescue {}
      if menuItem.menu.parent_id == 0 then
        top_menu = menuItem
      else
        top_menu = menuItem.menu
      end
      
      case menuItem.rawhtml
          
      when "","0"
        if(menuItem.has_image and not menuItem.pictures.empty?) then
          item_link_to = image_tag(menuItem.pictures[0].image_url.to_s, :border=>"0", :alt=>menuItem.name.html_safe)
        else
          item_link_to = menuText.html_safe
        end
        
        class_options.merge!({:controller=>:site, :action=>:show_portfolios,:department_id=>top_menu.name, :category_id=>menuItem.name,})

        return_link =  link_to(item_link_to, class_options, html_options)
      when "1"
        if(menuItem.has_image and not menuItem.pictures.empty?) then
          item_link_to = image_tag(menuItem.pictures[0].image_url.to_s, :border=>"0", :alt=>menuItem.name.html_safe)
        else
          item_link_to = menuText.html_safe
        end
        
        class_options.merge!({:controller=>:site, :action=>:show_custom_portfolios,:department_id=>top_menu.name, :category_id=>menuItem.name,})

        return_link =  link_to(item_link_to, class_options, html_options)
          
      when "2"   
        if(menuItem.has_image and not menuItem.pictures.empty?) then
          image_to_link_to = menuItem.pictures[0].image_url.to_s rescue "interface/missing_image_very_small.png"
          item_link_to = image_tag(image_to_link_to, :border=>"0", :alt=>menuItem.name.html_safe)
        else
          item_link_to = menuText.html_safe
        end
        
        class_options.merge!({:controller=>:site, :action=>:show_artifact_group, :department_id=>top_menu.name, :category_id=>"", :category_children=>false, :get_first_sub=>true})
        return_link =  link_to(item_link_to,class_options , html_options)
       
      end
    else
      return ""
    end
  end
  
  
  def menu_show_artifact_group(menuItem, html_options, span_options, class_options=nil, options=nil)
    return_link = ""
    
    puts("options-> #{options}")
    
    class_options==nil ? class_options={} : ""
    
    puts("menuItem.name:#{menuItem.name}")
    
    if menuItem.menu_active then
      menuText="<span "+ span_options +">"+menuItem.name + "</span>"

      if not options.blank? then
        if not options[:menu_name_sub_container].blank? then
          menu_sub_container_start = "<#{options[:menu_name_sub_container]}>"
          menu_sub_container_end= "</#{options[:menu_name_sub_container]}>"
        else
          menu_sub_container_start =  menu_sub_container_end= ""
        end
      
        if not options[:menu_name_container].blank? then
          menuText="<#{options[:menu_name_container]}" + span_options +">"+ menu_sub_container_start + menuItem.name + menu_sub_container_end + "</{options[:menu_name_container]}>"
        else
          menuText="<span "+ span_options +">"+ menu_sub_container_start + menuItem.name + menu_sub_container_end + "</span>"

        end
      end
      
      #  menuText="<span "+ span_options +">"+menuItem.name + "</span>"
      #top_menu = Menu.find(session[:parent_menu_id]) rescue {}
      if menuItem.menu.parent_id == 0 then
        top_menu = menuItem
      else
        top_menu = menuItem.menu
      end
        
      if(menuItem.has_image and not menuItem.pictures.empty?) then
        image_to_link_to = menuItem.pictures[0].image_url.to_s rescue "interface/missing_image_very_small.png"
        item_link_to = image_tag(image_to_link_to, :border=>"0", :alt=>menuItem.name.html_safe)
      else
        item_link_to = menuText.html_safe
      end
        
      class_options.merge!({:controller=>:site, :action=>:show_artifact_group, :department_id=>top_menu.name, :category_id=>"", :category_children=>false, :get_first_sub=>true})
      return_link =  link_to(item_link_to,class_options , html_options)
       
          

      return return_link.html_safe rescue "<none>"
    
    else
      return ""
    end
  end
end