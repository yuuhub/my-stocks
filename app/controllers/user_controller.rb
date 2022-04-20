class UserController < ApplicationController
    before_action :authenticate_user!
    before_action :restrict_action

    def new
        @user = User.new
        respond_to do |format|
          format.html
          format.js
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to users_path
    end

    def create
        @user = User.new(user_params)
        respond_to do |format|  
        if @user.save
            #UserMailer.account_admin_created(@user).deliver_later
            format.html { redirect_to root_path, notice: 'User was successfully created.' }
            format.json { render :show, status: :created, location: @user }
        else
            # render :new
            format.html { render :partial => 'users/new', status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def user_params
        params.require(:user).permit(:email, :name, :password, :status, :balance)
    end
end
