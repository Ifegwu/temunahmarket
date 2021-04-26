class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_i18n_locale_from_params

    protected

    def set_i18n_locale_from_params
        if params[:locale]
            if I18n.available_locales.map(&:to_s).include?(params[:locale])
                I18n.locale = params[:locale]
            else
                flash.now[:notice] = "#{params[:locale]} translation not available"
                logger.error flash.now[:notice]
            end
        end
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:full_name])
    end

    def after_sign_in_path_for(resource)
        dashboard_path
    end

    # private
    # def set_locale
    #     I18n.locale = params[:locale] || I18n.default_locale
    # end
end
