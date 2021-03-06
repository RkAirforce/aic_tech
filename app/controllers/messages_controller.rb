class MessagesController < ApplicationController
  before_action :login_required

  def index
    @user = User.find_by(id: params[:user_id])
    @my_messages = current_user.messages
                    .where("receiver_id = ?", @user.id)
                    .order("created_at DESC")
    @matched_user_messages = @user.messages
                              .where("receiver_id = ?", current_user.id)
                              .order("created_at DESC")

    @message = current_user.messages.build
    msg = @my_messages + @matched_user_messages
    @messages = msg.sort{|a,b| a["created_at"] <=> b["created_at"]}

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      respond_to do |format|
        format.json
      end
    else
      render :index
    end
  end

private
  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end
end
