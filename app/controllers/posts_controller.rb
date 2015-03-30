class PostsController < ApplicationController
  before_filter :set_post, only: [:show, :edit, :step1, :step2, 
                                  :update, :destroy]

  respond_to :html

  def index
    @posts = Post.all
    respond_with(@posts)
  end

  def show
    respond_with(@post)
  end

  def new
    @post = Post.new
    respond_with(@post)
  end

  def edit
  end

  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if params[:to_step2]
        @post.save
          format.html { redirect_to step2_post_path(@post) }
          format.json { head :no_content }
      else
        if @post.save
          format.html { redirect_to @post, notice: 'Gefeliciteerd. Je klus is aangemaakt!' }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @post.update_attributes(params[:post])
    respond_to do |format|
      if params[:to_step2]
        format.html { redirect_to step2_post_path(@post) }
        format.json { head :no_content }
      else
        format.html { redirect_to @post, notice: 'Gefeliciteerd. Je klus is geupdated!' }
        format.json { render json: @post, status: :created, location: @post }
      end
    end
  end

  def destroy
    @post.destroy
    respond_with(@post)
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end
end
