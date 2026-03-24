class InvitationMailer < ApplicationMailer
  def invite_email(invitation)
    @invitation = invitation
    @project = invitation.project
    @invited_by = invitation.invited_by
    @accept_url = accept_invitation_url(token: invitation.token)

    mail(
      to: invitation.email,
      subject: "#{@invited_by.name} invited you to join #{@project.name} on BoardIQ"
    )
  end
end
