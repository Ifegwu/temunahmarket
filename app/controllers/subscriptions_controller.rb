class SubscriptionsController < ApplicationController
    before_action :authenticate_user!, only: [:subscribe]
    skip_before_action :verify_authenticity_token, only: [:webhook]

    def subscribe
        if !current_user.stripe_id?
            return redirect_to edit_payment_path, alert: "Please add your card before subcribing"
        end

        plan = Stripe::Plan.retrieve(params[:plan_id])
        if !plan.id
            return redirect_to request.referrer, alert: "Invalid Plan"
        end

        subscription = Subscription.exists?(user_id: current_user.id)
        if subscription.present?
            return redirect_to request.referrer, alert: "You cannot subscribe to another plan"
        end

        # Create Stripe Subscription
        stripe_sub = Stripe::Subscription.create(
            customer: current_user.stripe_id,
            items: [{ plan: plan.id }]
        )

        # Create Local Subscription (on our database)
        subscription = Subscription.create(
            user_id: current_user.id,
            plan_id: plan.id,
            sub_id: stripe_sub.id
        )

        return redirect_to dashboard_path, notice: "Subscribed Successfully"
    end

    def webhook
        begin
            event_json = JSON.parse(request.body.read)
            event_body = event_json['data']['object']

            case event_json['type']
                when 'invoice.payment_succeeded'
                    stripe_sub_id = event_object['subscription']
                    subscription = Subscription.find_by_sub_id(stripe_sub_id)

                    if subscription.expires_at.nil?
                        expires_at = Date.current + 1.month
                    else
                        expires_at = subscription.expires_at + 1.month
                    end

                    subscription.update(status: Subscription.statuses[:success], expires_at: expires_at)
                
                when 'invoice.payment_failed'
                    stripe_sub_id = event_object['subscription']
                    subscription = Subscription.find_by_sub_id(stripe_sub_id)
                    subscription.update(status: Subscription.statuses[:pending])
               
                when 'customer.subscription_deleted'
                    stripe_sub_id = event_object[:id]
                    subscription = Subscription.find_by_sub_id(stripe_sub_id)
                    subcription.destroy
            end

            
        rescue Exception => e
            render :json => { status: 422, error: e } 
            return 
        end

        render :json => { status: 200 }
    end
end