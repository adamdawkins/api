class Api::V1::ProjectsController < ApplicationController
  def show
    project = ProjectRepo.by_api_id(params[:api_id])
    render json: { project: }, status: :ok
  end
end
