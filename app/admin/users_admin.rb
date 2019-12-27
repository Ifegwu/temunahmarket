Trestle.resource(:users) do
  remove_action :destroy
  menu do
    item :users, icon: "fa fa-user"
  end

  table do
    column :full_name
    column :email
    column :active
    column :wallet
    column :paypal
    column :stripe_id
    column :created_at, align: :center
    actions do |toolbar, instance, admin|
      toolbar.link 'Wallet', 
                  admin.path(:wallet, id: instance.id), 
                  class: 'btn btn-warning'
      toolbar.link 'Activate', 
                  admin.path(:activate, id: instance.id), 
                  method: :post, 
                  class: 'btn btn-success'
      toolbar.link 'Deactivate', 
                  admin.path(:deactivate, id: instance.id), 
                  method: :post, 
                  class: 'btn btn-danger'
    end
  end

  controller do
    def activate
      user = admin.find_instance(params)
      user.update(active: true)
      flash[:message] = "User is activated"
      redirect_to admin.path(:show, id: user)
    end

    def deactivate
      user = admin.find_instance(params)
      user.update(active: false)
      flash[:message] = "User is deactivated"
      redirect_to admin.path(:show, id: user)
    end

    def wallet
      @user = admin.find_instance(params)
      @net_income = (Transaction.where("seller_id = ?",  @user.id).sum(:amount) / 1.1).round(2)

      @withdrawn = Transaction.where("buyer_id = ? AND status = ? AND transaction_type = ?",
                      @user.id,
                      Transaction.statuses[:approved],
                      Transaction.transaction_types[:withdraw]
                  ).sum(:amount)

      @pending = Transaction.where("buyer_id = ? AND status = ? AND transaction_type = ?",
                  @user.id,
                  Transaction.statuses[:pending],
                  Transaction.transaction_types[:withdraw]
                ).sum(:amount)

      @purchase = Transaction.where("buyer_id = ? AND status = ? AND transaction_type = ?",
                    @user.id,
                    Transaction.statuses[:system],
                    Transaction.transaction_types[:trans]
                  ).sum(:amount)

      @withdrawable = @user.wallet

      @transactions = Transaction.where("seller_id = ? OR (buyer_id = ? AND source_type = ?)",
                        @user.id,
                        @user.id,
                        Transaction.source_types[:system]
                      ).page(params[:page])
    end
  end

  routes do
    get :wallet, on: :member
    post :activate, on: :member
    post :deactivate, on: :member
  end

  form do |user|
    text_field :full_name
    text_field :paypal
    text_field :email
    text_field :phone
    text_field :about
  end

  search do |query|
    if query 
      User.where("email ILIKE ? OR full_name ILIKE ?", "%#{query}%", "%#{query}%")
    else
      User.all
    end
  end
  # Customize the table columns shown on the index view.
  #
  # table do
  #   column :name
  #   column :created_at, align: :center
  #   actions
  # end

  # Customize the form fields shown on the new/edit views.
  #
  # form do |user|
  #   text_field :name
  #
  #   row do
  #     col(xs: 6) { datetime_field :updated_at }
  #     col(xs: 6) { datetime_field :created_at }
  #   end
  # end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:user).permit(:name, ...)
  # end
end
