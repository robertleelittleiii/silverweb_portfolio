# frozen_string_literal: true

module SilverwebPortfolio
  class Railtie < Rails::Railtie
    #    initializer "silverweb_portfolio.action_controller" do
    #      ActiveSupport.on_load(:action_controller) do
    #        puts "Extending #{self} with silverweb_portfolio"
    #        # ActionController::Base gets a method that allows controllers to include the new behavior
    #        include SilverwebPortfolio::ControllerExtensions # ActiveSupport::Concern
    #        config.to_prepare do
    #      SiteController.send(:include, SilverwebPortfolio::ControllerExtensions::SiteControllerExtensions)
    #    end
    #      end
    #    end

    # The block you pass to this method will run for every request in
    # development mode, but only once in production.

    initializer 'silverweb_portfolio.update_picture_model' do
      SilverwebCms::Config.add_nav_item(name: 'Portfolio', controller: 'portfolios', action: 'index')

      SilverwebCms::Config.add_menu_class(%w[Portfolio menu_show_portfolios])
      #  SilverwebCms::Config.add_menu_class(["Show Artifact Group","menu_show_artifact_group"])

      #  SilverwebCms::Config.add_menu_actions(["Show Portfolio",20])

      Picture.class_eval do
        belongs_to :artifacts, polymorphic: true,  optional: true
      end

      ImageUploader.class_eval do
        version :artifact_slider do
          process resize_to_fill: [885, 600]
        end

        version :artifact_custom_slider do
          process resize_to_limit: [600, 615]
        end

        version :artifact_before do
          process resize_to_limit: [375, 255]
        end

        version :artifact_list do
          process resize_to_fill: [180, 130]
        end
      end
    end

    #    initializer "silverweb_portfolio.update_menu_defs" do
    #      MenusController::MENU_TYPES << ["Portfolio",6]
    #      MenusController::ACTION_TYPES << ["Show Portfolio",20]
    #    end

    config.to_prepare do
      SiteController.send(:include, SilverwebPortfolio::ControllerExtensions::SiteControllerExtensions)
    end
  end
end
