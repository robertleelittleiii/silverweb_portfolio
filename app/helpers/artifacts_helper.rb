module ArtifactsHelper
  
#  def artifact_edit_div(artifact)
#    returnval=""
#    if session[:user_id] then
#      user=User.find(session[:user_id])
#      if user.roles.detect{|role|((role.name=="Admin") | (role.name=="Site Owner"))} then
#        returnval="<div id=\"edit-artifact\" class=\"edit-artifact\">"
#        returnval=returnval+link_to(image_tag("interface/edit.png",border: "0", class: "imagebutton", title: "Edit this artifact"),controller: 'artifacts', id: artifact.id ,  action: 'edit')
#        returnval=returnval + "</div>"
#
#      end
#    end
#    return returnval.html_safe
#  end
  
    def artifact_edit_div(artifact, div_id="")
    returnval=""
    begin
      if session[:user_id] then
        user=User.find(session[:user_id])
        if user.roles.detect{|role|((role.name=="Admin") | (role.name=="Site Owner"))} then
          returnval = "<div class='edit-artifacts' id=\""+ (div_id=="" ? "edit-artifacts" : div_id) + "\" >"
          returnval << "<div id='artifact-id' class='hidden-item'>#{artifact.id}</div>"
          returnval << image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this") # link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Page"),:controller => 'artifacts', :id =>artifact.id ,  :action => 'edit')
          returnval << "</div>"
        end
      end
    rescue
    end
    return returnval.html_safe
  end
  
  def build_slider_gallary_v3(artifact, effect="fade", picture_size=:artifact_slider)
    effect_type = effect || "fade"    
    if not artifact.blank? then
      
      returnval = ""
      returnval = returnval + "<div class=\"hidden-item\"> \n"
      returnval =  returnval + "<div id='slider-width'>1024</div> \n"
      returnval =  returnval + "<div id='slider-height'>500</div> \n"
      returnval =  returnval + "<div id='slider-nav'>true</div> \n"
      returnval =  returnval + "<div id='slider-effect'>#{effect_type}</div> \n"
      returnval =  returnval + "</div> \n"
      
      returnval = returnval + "<div id=\"slides3\"> \n"
      artifact.pictures.visible.each_with_index do |picture, slide_count| 
     
        puts("slide count #{slide_count}")
        if slide_count == 0 then
          returnval =  returnval + "<div class='slider-content'> \n"
          
        else
          returnval =  returnval + "<div class='slider-content' style='display:none'>"
        end
        #        returnval =  returnval + "<h1>" + slider.slider_name + "</h1>"
        returnval =  returnval +  "<div class='" + action_name + " slider-content-float'>" +  image_tag(picture.image_url(picture_size).to_s) + "</div> \n"
  
        if ((slide_count == 0 ) and (not artifact.pictures.where(title: "Before").first.image_url(:artifact_before).to_s).blank?) then
          returnval = returnval + "<div id='image-before-button'> \n"
          returnval = returnval + "click here to view the before photo\n"
          returnval = returnval + "</div>"
          returnval =  returnval +  "<div id='before-picture'>" 
          returnval =  returnval + "<div id='close-before-picture'>X</div>"
          returnval =  returnval + image_tag( ( ( (artifact.pictures.where(title: "Before").first.image_url(:artifact_before).to_s).blank? ? "empty_s.jpg" : artifact.pictures.where(title: "Before").first.image_url(:artifact_before).to_s ) rescue "empty_s.jpg" )   ) 
          returnval =  returnval + "</div> \n"                 
        end rescue ""
        returnval =  returnval + "</div> \n"
      end
      returnval =  returnval + "</div> \n"
      return returnval.html_safe
    else
      return "" 
    end #rescue ""
  end  
  
  def artifact_info(artifact)
    returnval = "<div id=\"attr-artifacts\" class=\"hidden-item\">"
    returnval << "<div id=\"artifact-id\">"+(artifact.id.to_s rescue "-1")+"</div>"
    
    returnval=returnval + "</div>"
    return returnval.html_safe
 
  end
end
