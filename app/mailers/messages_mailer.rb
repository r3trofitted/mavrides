class MessagesMailer < ApplicationMailer
  before_action :set_message
  
  default from: -> { game_email_address @message.game }
  
  def transmission
    @transmission = Transmission.new(@message)
    
    mail \
      subject: @transmission.subject,
      to: @transmission.recipient_email
    
  end
  
  def bounced
    mail to: @message.sender_email
  end
  
  private
  
  def set_message
    @message = params[:message]
  end
end
