# frozen_string_literal: true

module NotificationsHelper
  def notification_enabled?(who, notification)
    return false unless Notification.enabled?(who, notification)
    block_given? ? yield : true
  end

  def get_confirm_text(project)
    html = "<div class='bootbox-heading'>End Project<hr>
      </div><div class='p-x-3'>Are you sure you want to end this project?<br>This will send a request to the specialist to
      <br>confirm project end"
    html + (project.internal? ? '</div>' : ' and accelerate all project payments due.</div>')
  end

  def seat_confirmation_message
    "<div class='bootbox-heading'>Assign Seat<hr></div>You are granting this employee access to your
    <br>dashboard by assigning a seat to them. Are you<br>sure you want to assign them a seat?"
  end

  def unavailable_seat
    "<div class='bootbox-heading'>No Available Seats<hr></div>Oops! It looks like you have no available seats to assign.
    <br/>Please purchase additional seats to assign them to an employee."
  end
end
