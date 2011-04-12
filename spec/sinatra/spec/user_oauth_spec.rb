require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "User with oauth submodule" do
  before(:all) do
    ActiveRecord::Migrator.migrate("#{APP_ROOT}/db/migrate/external")
  end
  
  after(:all) do
    ActiveRecord::Migrator.rollback("#{APP_ROOT}/db/migrate/external")
  end

  # ----------------- PLUGIN CONFIGURATION -----------------------
  describe User, "loaded plugin configuration" do
  
    before(:all) do
      sorcery_reload!([:external])
      sorcery_controller_property_set(:external_providers, [:twitter])
      sorcery_model_property_set(:authentications_class, Authentication)
      sorcery_controller_oauth_property_set(:twitter, :key, "eYVNBjBDi33aa9GkA3w")
      sorcery_controller_oauth_property_set(:twitter, :secret, "XpbeSdCoaKSmQGSeokz5qcUATClRW5u08QWNfv71N8")
      sorcery_controller_oauth_property_set(:twitter, :callback_url, "http://blabla.com")
      create_new_external_user(:twitter)
    end
    
    it "should respond to 'load_from_provider'" do
      User.should respond_to(:load_from_provider)
    end
    
    it "'load_from_provider' should load user if exists" do
      User.load_from_provider(:twitter,123).should == @user
    end
    
    it "'load_from_provider' should return nil if user doesn't exist" do
      User.load_from_provider(:twitter,980342).should be_nil
    end
    
  end
  
end