module SilverwebPortfolio
  module Config
        @PORTFOLIO_TYPES = nil

    # Accessor used to access plugin configuration settings (returns a Hash that
    # directly corresponds to the contents of <tt>config/vtools_ui.yml</tt>)
    def self.PORTFOLIO_TYPES
      @PORTFOLIO_TYPES
    end
    
    def self.load_portfolio_types
      @PORTFOLIO_TYPES = [["Default",""],["Custom",1], ["Artfiact Group",2]]
    end
    
    def self.add_portfolio_types(portfolio_type_item)
      @PORTFOLIO_TYPES << portfolio_type_item
    end
  end
  
  
end


SilverwebPortfolio::Config.load_portfolio_types
