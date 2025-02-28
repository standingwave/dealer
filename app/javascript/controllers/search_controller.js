import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["searchResults", "searchText", "cardDetails"]
  
  connect() {
    let that = this;
    console.log(that.element)
  }
  search(event) {
    event.preventDefault();
    var url = new URL("/proxy", window.location.origin);
    url.searchParams.append('nameFragment', this.searchTextTarget.value)
    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        console.log(response);
        return response.json();
      })
      .then(data => {
        console.log(data);
        // response.body={"Results":[{"ID":"382866","Name":"Black Lotus","Group":null,"Snippet":"{T}, Sacrifice this artifact: Add three mana of any one color."}],"SearchCharacters":"black lotus"}
        if (data.Results.length === 0) {
          this.searchResultsTarget.innerHTML = `<li class="search_result_item p-2">No results found!</li>`;
        } else {
          this.searchResultsTarget.innerHTML = data.Results.map(card => `<li class="search_result_item p-2 hover:bg-gray-100 cursor-pointer"><a href="/cards/${card.ID}/details" data-turbo-stream="true">${card.Name}: ${card.Snippet}</a></li>`).join('');
        }
        this.searchResultsTarget.hidden = false;
      })
      .catch(error => {
        console.error('Fetch error:', error);
      });
  }

  details(event) {
    event.preventDefault();
    console.log(event);
    const card_id = event.target.dataset.cardId;

    var url = new URL(`/cards/details/${card_id}`, window.location.origin);
    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        console.log(response);
        return response.json();
      })
      .then(data => {
        console.log(data);
        // response.body=
        if (data.Results.length === 0) {
          this.searchResultsTarget.innerHTML = `<li class="search_result_item p-2">No results found.</li>`;
        } else {
          this.searchResultsTarget.innerHTML = data.Results.map(card => `<li class="search_result_item p-2 hover:bg-gray-100 cursor-pointer" data-action="click->search#details" data-card-id="${card.ID}">${card.Name}: ${card.Snippet}</li>`).join('');
        }
        this.searchResultsTarget.hidden = false;
      })
      .catch(error => {
        console.error('Fetch error:', error);
      });
  }
}
