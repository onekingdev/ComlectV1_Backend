# frozen_string_literal: true
class Admin::UserPolicy < AdminPolicy
  def update?
    !discourse_admin?
  end

  def destroy?
    !discourse_admin?
  end

  def impersonate?
    true
  end

  def stop_impersonating?
    true
  end

  def toggle_suspend?
    true
  end

  private

  def discourse_admin?
    [
      ENV.fetch('DISCOURSE_BUSINESS_ADMIN_ID'),
      ENV.fetch('DISCOURSE_SPECIALIST_ADMIN_ID')
    ].include?(record.id.to_s)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
