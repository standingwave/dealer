class CardsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  before_action :set_card, only: %i[ show edit update destroy ]

  def details
    require "mechanize"

    @gatherer_card = {}
    # store = OpenSSL::X509::Store.new
    # store.add_file "/usr/local/etc/openssl@3/cert.pem"
    # # a.cert_store = store

    a = Mechanize.new
    a.verify_mode= OpenSSL::SSL::VERIFY_NONE

    page = a.get("https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=#{params[:gatherer_id]}")

    @gatherer_card[:id] = params[:gatherer_id]
    @gatherer_card[:image] = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=#{@gatherer_card[:id]}&type=card"

    @gatherer_card[:name] = page.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_nameRow > div.value").text
    @gatherer_card[:card_type] = page.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_typeRow > .value").children.first.text
    @gatherer_card[:rarity] = page.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_rarityRow div.value span").children.first.text
    @gatherer_card[:description] = page.css("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_textRow > div.value").map(&:text)

    set = page.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_currentSetSymbol > a").first
    @gatherer_card[:set] = { id: set.attr("href").split("=")[1], description: set.children.first.attr("title") }

    # list of other sets this card has appeared in.
    #   the anchor has the id and the image within the anchor has the set name
    other_sets = page.search("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContent_otherSetsValue > div a")
    @gatherer_card[:other_sets] = other_sets.any? ? other_sets.collect { |s| { id: s.attr("href").split("=")[1], description: s.children.first.attr("title") } } : []

    logger.info @gatherer_card.inspect

    render turbo_stream: turbo_stream.update(
      "card_search",
      partial: "gatherer_card",
      locals: { gatherer_card: @gatherer_card }
    )
  end

  def index
    @cards = Card.all
    respond_to do |format|
      format.html
      format.csv { send_data Card.to_csv, filename: "cards-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv" }
    end
  end

  def list
    @cards = Card.all  # You might want to add pagination or filtering here
    render partial: "cards/list"
  end

  def show
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      redirect_to cards_path, notice: "Card was successfully created."
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
          locals: { card:, attribute: }
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
            locals: { card:, attribute: }
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
      params.expect(card: [ :card_type, :color, :condition, :description, :gatherer_id, :name, :price, :quantity, :rarity ])
    end
end
