# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    tasks = Task.all
    render status: :ok, json: { tasks: tasks }
    # @task = Task.find_by(identifier_name: params[:identifier_name])bundle exec rails generate migration MakeSlugNotNullable
  end
end
