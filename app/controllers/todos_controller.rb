class TodosController < ApplicationController
  def index
    matching_todos = Todo.all

    @list_of_todos = matching_todos

    @list_of_next_up = @list_of_todos.where({ :status => "next_up" }).order({ :created_at => :desc })
    @list_of_in_progress = @list_of_todos.where({ :status => "in_progress" }).order({ :created_at => :desc })
    @list_of_done = @list_of_todos.where({ :status => "done" }).order({ :created_at => :desc })




    render({ :template => "todos/index.html.erb" })
  end


  def show
    the_id = params.fetch("path_id")

    matching_todos = Todo.where({ :id => the_id })

    @the_todo = matching_todos.at(0)

    render({ :template => "todos/show.html.erb" })
  end

  def create
    the_todo = Todo.new
    the_todo.content = params.fetch("query_content")
    the_todo.status = "next_up"
    the_todo.user_id = session.fetch(:user_id)

    if the_todo.valid?
      the_todo.save
      redirect_to("/", { :notice => "Todo created successfully." })
    else
      redirect_to("/", { :alert => the_todo.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_todo = Todo.where({ :id => the_id }).at(0)

   # the_todo.content = params.fetch("query_content") #
   the_todo.status = params.fetch("query_status") 
    the_todo.user_id = @current_user.id

    if the_todo.valid?
      the_todo.save
      redirect_to("/", { :notice => "Todo updated successfully."} )
    else
      redirect_to("/", { :alert => the_todo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_todo = Todo.where({ :id => the_id }).at(0)

    the_todo.destroy

    redirect_to("/", { :notice => "Todo deleted successfully."} )
  end
end
