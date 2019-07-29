# frozen_string_literal: true

module PortfoliosHelper
  def portfolio_edit_div(portfolio, div_id = '')
    returnval = ''.dup
    if session[:user_id]
      user = User.find(session[:user_id])
      if user.roles.detect { |role| ((role.name == 'Admin') | (role.name == 'Site Owner')) }
        returnval = "<div class='edit-portfolios' id=\"" + (div_id == '' ? 'edit-portfolios' : div_id) + '" >'
        returnval << "<div id='portfolio-id' class='hidden-item'>#{portfolio.id}</div>"
        returnval << image_tag('interface/edit.png', border: '0', class: 'imagebutton', title: 'Edit this Portfolio') # link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Page"),:controller => 'portfolios', :id =>portfolio.id ,  :action => 'edit')
        returnval << '</div>'
       end
    end
    returnval.html_safe
  end

  def json_clean(input)
    # return input.gsub('"', '\\"').gsub(/'/) {|s| "\\'"}
    input.tr("\n", ' ').tr("\r", ' ').gsub(/\\|"/) { |c| "\\#{c}" }
end

  def portfolio_info(portfolio)
    returnval = '<div id="attr-portfolios" class="hidden-item">'.dup
    returnval << '<div id="portfolio-id">' + (begin
                                                  portfolio.id.to_s
                                              rescue StandardError
                                                '-1'
                                                end) + '</div>'

    returnval += '</div>'
    returnval.html_safe
end

  def portfolio_attr_display(portfolio, full_screen = 'false', has_slider = 'false')
    returnval = ''
    returnval << '<div id="attr-portfolios" class="hidden-item">'
    returnval << '<div id="portfolio-id">' + (begin
                                                  portfolio.id.to_s
                                              rescue StandardError
                                                'n/a'
                                                end) + '</div>'
    returnval << '<div id="full-screen">' + (begin
                                                 portfolio.full_screen.to_s
                                             rescue StandardError
                                               full_screen
                                               end) + '</div>'
    returnval << '<div id="has-slider">' + (begin
                                                portfolio.has_slider.to_s
                                            rescue StandardError
                                              has_slider
                                              end) + '</div>'

    returnval << '</div>'
    returnval.html_safe
end
end
