class JobsController < ApplicationController
  before_filter :authenticate_user!
  def show
  end

  def new
    @job = Job.new
    @job.company = Company.new
    @job.company.address = Address.new
    @skills = []
  end

  def create
    if job_params['company_attributes']['name'].blank?
      redirect_to new_job_path(alert: 'Company Name cannot be blank')
      return
    end
    @job = Job.new
    @job.update_attributes(job_params)
    unless params[:job][:skill].blank?
      @skill = Skill.new
      @skill.name = params[:job][:skill][:name]
      @skill.save
      @job.skills << @skill
    end
    if @job.valid?
      current_user.jobs << @job
      redirect_to dashboard_path
    else
      redirect_to new_job_path
    end
  end

  private

  def job_params
    params.require(:job).permit(
      :title,
      :description,
      :posting_url,
      :notes,
      company_attributes: [:name, address_attributes: [:city, :state]]
    )
  end
end
