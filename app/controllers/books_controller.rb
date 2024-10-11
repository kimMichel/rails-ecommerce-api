class BooksController < ApplicationController
  before_action :set_book, only: %i[ show update destroy ]

  # GET /books
  def index
    @books = Book.where(is_active: true).order(id: :asc)

    render json: @books
  end

  # GET /books/1
  def show
    if @book
      render json: @book
    else
      render json: { message: 'Failed to find the book.' }, status: :unprocessable_entity
    end
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book
      if @book.update(book_params)
        render json: @book
      else
        render json: @book.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'Failed to find the book.' }, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    if @book
      if @book.update(is_active: false)
        render json: { message: 'Book was successfully deleted.' }, status: :ok
      else
        render json: { message: 'Failed to delete the book.' }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Failed to find the book.' }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find_by(id: params[:id], is_active: true)
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:name, :description, :price)
    end
end
