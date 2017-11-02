require 'HTTParty'

class EdamamApiWrapper
  BASE_URL = "https://api.edamam.com/search"
  SHOW_URL = "http://www.edamam.com/ontologies/edamam.owl%23"
  APP_ID = ENV["app_id"]
  APP_KEY = ENV["app_key"]

  def self.search(query)
    #needs to be encoded
    encoded_query = URI.encode("#{query}")
    url = BASE_URL + "?" + "app_id=#{APP_ID}" + "&" + "app_key=#{APP_KEY}" + "&" + "q=" + encoded_query
    # encoded_url = URI.encode("#{url}")
    data = HTTParty.get(url)
    if data["hits"]
      search_results = data["hits"].map do |recipe|
        Recipe.new(
          recipe["recipe"]["label"],
          recipe["recipe"]["image"],
          recipe["recipe"]["uri"],
          recipe["recipe"]["url"]
        )
      end
      return search_results
    else
      return []
    end
  end

  def self.view_recipe(uri)
    #get the show page
    #if search is a get request for a list of items,
    #show is a get request for an individual item, utilizing where uri acts
    #as an identifier

    url = BASE_URL + "?" + "app_id=#{APP_ID}" + "&" + "app_key=#{APP_KEY}" + "&" + "r=" + uri
    new_url = url.sub("#", "%23")

    data = HTTParty.get(new_url)
    # return data
    if data
      view_results = data.map do |recipe|
        Recipe.new(
          recipe["label"],
          recipe["image"],
          recipe["uri"],
          recipe["url"]

          # recipe["ingredientLines"],
          # recipe["digest"].each do |diet|
          #   diet["label"],
          #   diet["daily"],
          #   diet["unit"]
          # end
        )
      end
      return view_results
    else
      return []
    end

  end

end
