# frozen_string_literal: true

ActiveAdmin.register Answer do
  menu false

  actions :all, except: %i[show new edit create update]

  controller do
    def destroy
      super location: params[:return_to] || smart_collection_url
    end
  end
end
