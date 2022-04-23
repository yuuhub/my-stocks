class StocksController < ApplicationController
    def index
        client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_publishable_key ,
            endpoint: 'https://cloud.iexapis.com/v1')
        @trending_stocks = client.stock_market_list(:mostactive)
    end

    def search
		if params[:stock].present?
			@stock = Stock.new_lookup(params[:stock])
			if @stock
				respond_to do |format|
					format.html { render partial: 'layouts/result'}
					format.js { render partial: 'layouts/result'}
				end
			else
				respond_to do |format|
					flash.now[:alert] = "Please enter a valid symbol"
					format.html { render partial: 'layouts/result'}
					format.js { render partial: 'layouts/result' }
				end
			end
		else
			respond_to do |format|
				flash.now[:alert] = "Please enter a stock to search"
				format.html { render partial: 'layouts/result'}
				format.js { render partial: 'layouts/result' }
			end
		end
	end

    def show
		if params[:transaction] == 'buy'
			@transaction_path = buy_path
			@page_header = 'Buy Stock'
			@button_class = 'btn-success add-user'
			@button_text = 'Buy'
		else
			@transaction_path = sell_path
			@page_header = 'Sell Stock'
			@button_class = 'btn-danger delete-user'
			@button_text = 'Sell'
		end
			client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_publishable_key,
				endpoint: 'https://cloud.iexapis.com/v1')
			
			@stock = Stock.new
			@stock.ticker = params[:stock_ticker]
			@company_logo = "https://storage.googleapis.com/iex/api/logos/#{@stock.ticker}.png"
			@stock.name = client.company(params[:stock_ticker]).company_name
			
			@stock.last_price = client.quote(params[:stock_ticker]).latest_price
	end

    def buy
		user = User.find(current_user.id)
		existing_stock = Stock.find_by(:user_id => current_user.id, :ticker => params[:ticker])
		total_amount = params[:quantity].to_i * params[:last_price].to_i
		stock = Stock.new(name: params[:name], ticker: params[:ticker], quantity: params[:quantity], user_id: current_user.id)
		if total_amount <= current_user.balance && params[:quantity].to_i > 0
			if user.update(balance: user.balance - total_amount)
				if existing_stock
					existing_stock.update(quantity: existing_stock.quantity.to_i + params[:quantity].to_i)
				else
					stock.save
				end
				Transaction.create(name: params[:name], ticker: params[:ticker], quantity: params[:quantity], user_id: current_user.id, transaction_type: 'buy', price: params[:last_price])
				# redirect_to root_path
				respond_to do |format|
					format.html { redirect_to root_path, notice: "You have successfully bought #{params[:quantity]} share(s) of #{params[:name]} (#{params[:ticker]})" }
					# format.json { head :no_content }
				end
			end
		else
			respond_to do |format|
				format.html { redirect_to root_path, alert: "Invalid quantity" }
				# format.json { head :no_content }
			end
		end	
	end

    def sell
		user = User.find(current_user.id)
		existing_stock = Stock.find_by(:user_id => current_user.id, :ticker => params[:ticker], quantity: 1..)
		total_amount = params[:quantity].to_i * params[:last_price].to_i
		
		if existing_stock && params[:quantity].to_i > 0 && params[:quantity].to_i <= existing_stock.quantity.to_i
			if user.update(balance: user.balance + total_amount)
				existing_stock.update(quantity: existing_stock.quantity.to_i - params[:quantity].to_i)
				Transaction.create(name: params[:name], ticker: params[:ticker], quantity: params[:quantity], user_id: current_user.id, transaction_type: 'sell', price: params[:last_price])
				redirect_to root_path
			end	
		else
			respond_to do |format|
				format.html { redirect_to root_path, notice: "Invalid quantity" }
				# format.json { head :no_content }
			end
		end	
	end
end
