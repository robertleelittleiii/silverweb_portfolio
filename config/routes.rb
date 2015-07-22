Rails.application.routes.draw do
  
  resources :portfolios do
    collection do
      get "create_empty_record"
      get "portfolios_table"
      get "portfolio_table"
      get "delete_ajax"
      post "sort"
      get "portfolio_preferences"
    end
  end
  
  resources :artifacts do
    collection do
      get "create_empty_record"
      get "artifacts_table"
      get "delete_ajax"
      post "update_checkbox_tag"
      post "render_category_div"
      post "add_image"
      post "update_image_order"
      get "edit_picture"
      post "sort"
    end
  end
  
  
match "/site/show_portfolios" => "site#show_portfolios", via: :get
match "/site/artifact_detail" => "site#artifact_detail", via: :get
match "/site/portfolio_detail" => "site#portfolio_detail", via: :get
match "/site/show_artifact_group" => "site#show_artifact_group", via: :get
match "/site/show_custom_portfolios" => "site#show_custom_portfolios", via: :get
match "/site/show_artifact_custom_group" => "site#show_artifact_custom_group", via: :get
match "/site/artifact_detail_custom" => "site#artifact_detail_custom", via: :get
match "/site/update_artifact_partial" => "site#update_artifact_partial", via: :get

#resources :site do
#    collection do
#      get "show_portfolios"
#      get "artifact_detail"
#      get "portfolio_detail"
#      get "show_artifact_group"
#      get "show_custom_portfolios"
#      get "show_artifact_custom_group"
#      get "artifact_detail_custom"
#
#    end
#    end  
end
