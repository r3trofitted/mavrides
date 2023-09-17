class MessagesMailer < ApplicationMailer
  before_action :set_message
  
  def transmission
    @transmission = Transmission.new(@message)
    
    mail(
      subject: @transmission.subject,
      from: "#{@message.game_id}@mavrides.example",
      to: @transmission.recipient_email
    )
  end
  
  # TODO
  def bounced
  end
  
  private
  
  def set_message
    @message = params[:message]
  end
end
