class InvitationsController < ApplicationController
  before_action :set_project, only: [:new, :create]
  skip_before_action :require_login, only: [:accept]

  def new
    @invitation = ProjectInvitation.new
  end

  def create
    @invitation = @project.project_invitations.new(
      email: params[:email],
      invited_by: current_user
    )

    if @invitation.save
      begin
        InvitationMailer.invite_email(@invitation).deliver_now
        redirect_to @project, notice: "Invitation sent to #{@invitation.email}."
      rescue Net::OpenTimeout, Net::SMTPAuthenticationError, SocketError => e
        redirect_to @project, alert: "Invitation saved but email could not be sent (#{e.class}: check SMTP settings)."
      end
    else
      redirect_to @project, alert: @invitation.errors.full_messages.to_sentence
    end
  end

  def accept
    @invitation = ProjectInvitation.find_by(token: params[:token])

    if @invitation.nil?
      redirect_to root_path, alert: "Invalid or expired invitation link."
    elsif @invitation.accepted?
      redirect_to sign_in_path, notice: "This invitation has already been accepted. Please sign in."
    else
      @invitation.accept!
      session[:pending_project_id] = @invitation.project_id
      if current_user
        @invitation.project.project_memberships.find_or_create_by(user: current_user)
        redirect_to project_path(@invitation.project),
                    notice: "Welcome! You now have access to #{@invitation.project.name}."
      else
        redirect_to sign_in_path,
                    notice: "Invitation accepted! Please sign in or create an account to access #{@invitation.project.name}."
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
