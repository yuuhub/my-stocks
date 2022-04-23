class UsersController < ApplicationController
    before_action :authenticate_user!

    def new
        @user = User.new
        respond_to do |format|
          format.html
          format.js
        end
    end

    def index
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
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
            format.html { redirect_to root_path, notice: 'User was successfully created.' }
            format.json { render :show, status: :created, location: @user }
        else
            # render :new
            format.html { render :partial => 'users/new', status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def pending
        @users = User.all.where(:admin => false, :status => 'disapproved')
    end

    def change_status
        @user = User.find(params[:id])
        @user.update(status: params[:status])
        redirect_to params[:path]
    end

    private

    def user_params
        params.require(:user).permit(:email, :name, :password, :status, :balance)
    end
end
