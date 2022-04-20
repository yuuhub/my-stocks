class DashboardController < ApplicationController
    def index
        redirect_to users_path if current_user.admin?
        @stocks = Stock.where(user_id: current_user.id, quantity: 1..)
    end
  

    def add_balance
        amount = params[:amount].to_d
        if amount > 0
            user = User.find(current_user.id)
            respond_to do |format|
                if user.update(balance: user.balance + amount)
                    format.html { redirect_to root_path, notice: "You have added #{number_to_currency(amount)} to your account" }
                    format.json { head :no_content }
                end
            end
        else
            respond_to do |format|
                format.html { redirect_to root_path, alert: "Invalid Amount" }
                format.json { head :no_content }
            end
        end
        
    end
end
