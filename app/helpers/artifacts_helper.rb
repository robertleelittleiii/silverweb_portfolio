# frozen_string_literal: true

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

  def artifact_edit_div(artifact, div_id = '')
    returnval = ''.dup
    begin
      if session[:user_id]
        user = User.find(session[:user_id])
        if user.roles.detect { |role| ((role.name == 'Admin') | (role.name == 'Site Owner')) }
          returnval = "<div class='edit-artifacts' id=\"" + (div_id == '' ? 'edit-artifacts' : div_id) + '" >'
          returnval << "<div id='artifact-id' class='hidden-item'>#{artifact.id}</div>"
          returnval << image_tag('interface/edit.png', border: '0', class: 'imagebutton', title: 'Edit this') # link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Page"),:controller => 'artifacts', :id =>artifact.id ,  :action => 'edit')
          returnval << '</div>'
        end
      end
    rescue StandardError
    end
    returnval.html_safe
  end

  def build_slider_gallary_v3(artifact, effect = '', picture_size = :artifact_slider, slider_width = '', slider_height = '', slider_nav = '')
    # effect_type = effect || "fade"

    if !artifact.blank?
      returnval = ''.dup
      returnval += "<div class=\"hidden-item\"> \n"
      returnval +=  "<div id='slider-width'>#{slider_width}</div> \n" unless slider_width.blank?
      returnval +=  "<div id='slider-height'>#{slider_height}</div> \n" unless slider_height.blank?
      returnval +=  "<div id='slider-nav'>#{slider_nav}</div> \n" unless slider_nav.blank?
      returnval +=  "<div id='slider-effect'>#{effect}</div> \n" unless effect .blank?
      returnval +=  "</div> \n"

      returnval += "<div id=\"slides3\"> \n"
      artifact.pictures.visible.each_with_index do |picture, slide_count|
        puts("slide count #{slide_count}")
        returnval = if slide_count == 0
                      returnval + "<div class='slider-content'> \n"

                    else
                      returnval + "<div class='slider-content' style='display:none'>"
                    end
        #        returnval =  returnval + "<h1>" + slider.slider_name + "</h1>"
        returnval = returnval + "<div class='" + action_name + " slider-content-float'>" + image_tag(picture.image_url(picture_size).to_s) + "</div> \n"

        begin
          if (slide_count == 0) && (!artifact.pictures.where(title: 'Before').first.image_url(:artifact_before).to_s).blank?
            returnval += "<div id='image-before-button'> \n"
            returnval += "click here to view the before photo\n"
            returnval += '</div>'
            returnval +=  "<div id='before-picture'>"
            returnval +=  "<div id='close-before-picture'>X</div>"
            returnval += image_tag((begin
                                                    (artifact.pictures.where(title: 'Before').first.image_url(:artifact_before).to_s.blank? ? 'empty_s.jpg' : artifact.pictures.where(title: 'Before').first.image_url(:artifact_before).to_s)
                                    rescue StandardError
                                      'empty_s.jpg'
                                                  end))
            returnval += "</div> \n"
                  end
        rescue StandardError
          ''
        end
        returnval += "</div> \n"
      end
      returnval += "</div> \n"
      returnval.html_safe
    else
      ''
    end # rescue ""
  end

  def artifact_info(artifact)
    returnval = '<div id="attr-artifacts" class="hidden-item">'.dup
    returnval << '<div id="artifact-id">' + (begin
                                               artifact.id.to_s
                                             rescue StandardError
                                               '-1'
                                             end) + '</div>'

    returnval += '</div>'
    returnval.html_safe
  end

  def artifact_pagination(artifact, action_name)
    returnval = ''.dup

    if Settings.artifact_nav == 'true'
      if artifact.previous_in_portfolio.name != artifact.next_in_portfolio.name
        returnval << "<div class='artifact-pagination'>"
        returnval << "        <div class='previos_artifact'>"
        begin
          returnval << link_to('< ' + artifact.previous_in_portfolio.name, controller: :site, action: action_name, prev: true, id: artifact)
        rescue StandardError
          ''
        end
        returnval << '        </div>'
        returnval << "        <div  class='next_artifact'>"
        begin
          returnval << link_to(artifact.next_in_portfolio.name + ' >', controller: :site, action: action_name, next: true, id: artifact)
        rescue StandardError
          ''
        end
        returnval << '        </div>'
        returnval << '    </div>'

        return returnval.html_safe

      end
    end
  end
end
