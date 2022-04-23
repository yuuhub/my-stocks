class TransactionsController < ApplicationController
    def index
        @transactions = Transaction.where(user_id: current_user.id).order('created_at desc')
    end
end
