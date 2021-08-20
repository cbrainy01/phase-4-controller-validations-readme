class BirdsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    #create a new record and save to bird variable. However, if the creation isnt up to code with the creation requirements
    # laid out in the model, it would not be valid(the valid? method would return false)
    bird = Bird.create!(bird_params)
      render json: bird, status: :created
    # rescue ActiveRecord::RecordInvalid => invalid 
      # if creation of record wasnt valid, a hash containing errors is sent back to the client
      # render json: { errors: invalid.record.errors }, status: 422
      # .errors looks like this { "name": ["can't be blank"] }
    
  end

  # GET /birds/:id
  def show
    bird = find_bird
    render json: bird
  end

  # PATCH /birds/:id
  def update
      bird = find_bird
      bird.update!(bird_params)
      render json: bird
  end

  # DELETE /birds/:id
  def destroy
    bird = find_bird
    bird.destroy
    head :no_content
  end

  private

  def find_bird
    Bird.find(params[:id])
  end

  def bird_params
    params.permit(:name, :species, :likes)
  end

  def render_not_found_response
    render json: { error: "Bird not found" }, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: 422
  end

end
