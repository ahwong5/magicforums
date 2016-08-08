class TopicsController < ApplicationController

  def index
    @topics = Topic.all.order(created_at: :desc)
    #@topics = Topic.all
    #@topics = Topic.where(id: 1)
    # @topics = Topic.first(3)
  end

  # def show
  #   @topic = Topic.find_by(id: params[:id])
  # end


  def new
    @topic = Topic.new
  end


  def create
    @topic = Topic.new(topic_params)

    if @topic.save
      flash[:success] = "You've successfully created a new topic."
      redirect_to topics_path
    else
      flash[:danger] = @topic.errors.full_messages
      render new_topic_path
    end
  end


  def edit
    @topic = Topic.find_by(id: params[:id])
  end


  def update
    @topic = Topic.find_by(id: params[:id])

    if @topic.update(topic_params)
      flash[:success] = "You've successfully edited the topic."
      redirect_to topics_path
    else
      flash[:danger] = @topic.errors.full_messages
      redirect_to edit_topic_path(@topic)
    end
  end

  def destroy
    @topic = Topic.find_by(id: params[:id])

    if @topic.destroy
      flash[:success] = "You've successfully deleted the topic."
      redirect_to topics_path
    else
      flash[:danger] = @topic.errors.full_messages
      redirect_to topic_path(@topic)
    end
  end

  private  #to prevent accessible to below info

  def topic_params
    params.require(:topic).permit(:title, :description)
  end

end
