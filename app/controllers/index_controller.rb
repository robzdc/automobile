class IndexController < ApplicationController
  def index
  	@marcas = Make.order("name")
    @states = State.where("country_id = ?",2)

    # Obtener varios anuncios random
    @random = Advert.pluck(:id,:image, :url).sample 6
  end
end
