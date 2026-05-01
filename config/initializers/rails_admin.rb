RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.model "Race" do
    object_label_method :name
  end

  config.model "RaceTier" do
    edit do
      field :race
      field :tier_number
      field :drivers do
        associated_collection_cache_all true
        associated_collection_scope do
          proc { |scope| scope.order("car_number::integer") }
        end
      end
    end
  end

  config.model "QualifyingResult" do
    edit do
      field :year
      field :pole_driver
      field :saturday_wreck
      field :sunday_wreck
      field :finalized
      field :fast_twelve_drivers do
        associated_collection_cache_all true
        associated_collection_scope { proc { |scope| scope.order("car_number::integer") } }
      end
      field :last_row_drivers do
        associated_collection_cache_all true
        associated_collection_scope { proc { |scope| scope.order("car_number::integer") } }
      end
    end
  end

  config.model "QualifyingPrediction" do
    edit do
      field :participant
      field :year
      field :pole_pick
      field :saturday_wreck
      field :sunday_wreck
      field :fast_twelve_drivers do
        associated_collection_cache_all true
        associated_collection_scope { proc { |scope| scope.order("car_number::integer") } }
      end
      field :last_row_drivers do
        associated_collection_cache_all true
        associated_collection_scope { proc { |scope| scope.order("car_number::integer") } }
      end
    end
  end

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    member :bulk_race_results do
      only ["Race"]
      http_methods [:get, :post]
      turbo false
      link_icon "fas fa-list-ol"
      controller do
        proc do
          @drivers = Driver.order(:car_number)
          @existing_results = @object.race_results.index_by(&:driver_id)

          if request.post?
            ActiveRecord::Base.transaction do
              params[:finishing_positions].each do |driver_id, position|
                if position.present?
                  result = @object.race_results.find_or_initialize_by(driver_id: driver_id.to_i)
                  result.finishing_position = position.to_i
                  result.save!
                else
                  @object.race_results.where(driver_id: driver_id.to_i).destroy_all
                end
              end
            end

            flash[:success] = "Race results saved for #{@object.name}."
            redirect_to rails_admin.bulk_race_results_path(model_name: "race", id: @object.id)
          else
            render :bulk_race_results
          end
        end
      end
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
