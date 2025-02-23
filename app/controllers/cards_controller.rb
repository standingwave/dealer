class CardsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  before_action :set_card, only: %i[ show edit update destroy ]

  def index
    @cards = Card.all
  end

  def show
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      redirect_to @card
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to @card
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path
  end

  # GET /cards/:id/edit_attribute/:attribute
  def edit_attribute
    attribute = params[:attribute]
    respond_to do |format|
      format.turbo_stream do
        # render form
        render turbo_stream: turbo_stream.update(
          helpers.dom_id(card, attribute),
          partial: "edit_attribute",
          locals: {card:, attribute:}
        )
      end
    end
  end

  # PATCH  /cards/:id/update_attribute/:attribute
  def update_attribute
    attribute = params[:attribute]
    attribute_id = helpers.dom_id(card, attribute)
    respond_to do |format|
      if card.update(card_params)
        format.turbo_stream do
          # render updated attribute
          render turbo_stream: turbo_stream.replace(
            attribute_id,
            partial: "attribute",
            locals: {card:, attribute:}
          )
        end
      else
        format.turbo_stream do
          # render errors
          render turbo_stream: turbo_stream.append(
            attribute_id,
            html: (
              helpers.tag.div id: "#{attribute_id}_errors" do
                card.errors.full_messages.join(", ")
              end
            )
          )
        end
      end
    end
  end
  private
    def card
      @card ||= Card.find(params[:id])
    end
    helper_method :card

    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.expect(card: [ :card_type, :color, :condition, :description, :name, :price, :quantity, :rarity ])
    end
end
