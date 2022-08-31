# frozen_string_literal: true

class TasksController < ApplicationController
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  before_action :load_task!, only: %i[show update destroy]

  def index
    # tasks = Task.all
    # render status: :ok, json: { tasks: tasks }
    # tasks = Task.all.as_json(include: { assigned_user: { only: %i[name id] } })
    # respond_with_json(tasks)

    # tasks = TaskPolicy::Scope.new(current_user, Task).resolve
    tasks = policy_scope(Task)
    tasks_with_assigned_user = tasks.as_json(include: { assigned_user: { only: %i[name id] } })
    respond_with_json(tasks_with_assigned_user)
  end

  def create
    task = current_user.created_tasks.new(task_params)
    authorize task
    task.save!
    respond_with_success(t("successfully_created", entity: "Task"))
  end

  def show
    # respond_with_json({ task: @task, assigned_user: @task.assigned_user })
    authorize @task
    @comments = @task.comments.order("created_at DESC")
  end

  def update
    authorize @task
    @task.update!(task_params)
    respond_with_success(t("successfully_updated", entity: "Task"))
  end

  def destroy
    authorize @task
    @task.destroy!
    respond_with_json
  end

  private

    def load_task!
      @task = Task.find_by!(slug: params[:slug])
    end

    def task_params
      params.require(:task).permit(:title, :assigned_user_id)
    end
end
