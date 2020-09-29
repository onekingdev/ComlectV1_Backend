# frozen_string_literal: true

module NotificationsHelper
  def notification_enabled?(who, notification)
    return false unless Notification.enabled?(who, notification)
    block_given? ? yield : true
  end

  def get_confirm_text(project)
    if project.internal?
      "<div class='bootbox-heading'>End Project<hr>
      </div><div class='p-x-3'>Are you sure you want to end this project?
      <br>This will send a request to the specialist to<br>confirm project end</div>"
    else
      "<div class='bootbox-heading'>End Project<hr></div><div class='p-x-3'>Are you sure you want to end this project?
       <br>This will send a request to the specialist to
       <br>confirm project end and accelerate all project payments due.</div>"
    end
  end
end
