module PortfoliosHelper
  
  def portfolio_edit_div(portfolio, div_id="")
    returnval=""
    if session[:user_id] then
      user=User.find(session[:user_id])
       if user.roles.detect{|role|((role.name=="Admin") | (role.name=="Site Owner"))} then
          returnval = "<div class='edit-portfolios' id=\""+ (div_id=="" ? "edit-portfolios" : div_id) + "\" >"
          returnval << "<div id='portfolio-id' class='hidden-item'>#{portfolio.id}</div>"
          returnval << image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Portfolio") # link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Page"),:controller => 'portfolios', :id =>portfolio.id ,  :action => 'edit')
          returnval << "</div>"
        end
    end
    return returnval.html_safe
  end
  
    def json_clean(input)
    # return input.gsub('"', '\\"').gsub(/'/) {|s| "\\'"} 
    return input.gsub(/\n/," ").gsub(/\r/," ").gsub(/\\|"/) { |c| "\\#{c}" }
    
  end 
  
    def portfolio_info(portfolio)
    returnval = "<div id=\"attr-portfolios\" class=\"hidden-item\">"
    returnval << "<div id=\"portfolio-id\">"+(portfolio.id.to_s rescue "-1")+"</div>"
    
    returnval=returnval + "</div>"
    return returnval.html_safe
 
  end
  
    def portfolio_attr_display(portfolio,full_screen="false", has_slider="false")
    returnval=""
    returnval << "<div id=\"attr-portfolios\" class=\"hidden-item\">"
    returnval << "<div id=\"portfolio-id\">"+(portfolio.id.to_s rescue "n/a")+"</div>"
    returnval << "<div id=\"full-screen\">"+(portfolio.full_screen.to_s rescue full_screen)+"</div>"
    returnval << "<div id=\"has-slider\">"+(portfolio.has_slider.to_s rescue has_slider)+"</div>"

    returnval << "</div>"
    return returnval.html_safe
 
  end
  
end
