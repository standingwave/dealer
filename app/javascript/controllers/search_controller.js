import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["searchResults", "searchText"]
  
  connect() {
    let that = this;
    console.log(that.element)
  }
  load(event) {
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
        // Ensure data is properly formatted before inserting into the DOM
        // No results found.
        // response.body={"Results":[{"ID":"382866","Name":"Black Lotus","Group":null,"Snippet":"{T}, Sacrifice this artifact: Add three mana of any one color."}],"SearchCharacters":"black lotus"}
        this.searchResultsTarget.innerHTML = data.Results.map(card => `<li class="search_result_item p-2 hover:bg-gray-100 cursor-pointer" data-card-id="${card.ID}">${card.Name}: ${card.Snippet}</li>`).join('');
        this.searchResultsTarget.hidden = false;
      })
      .catch(error => {
        console.error('Fetch error:', error);
      });
  }
  search(event) {
    console.log(event);
    const searchInput = event.target.value.toLowerCase(); // assigns the value of the text in the input field

    //  + event.target.parentElement.dataset.cardid
    // 'http://gatherer.wizards.com/Handlers/InlineCardSearch.ashx' , :args => ['nameFragment']
    // const card_id = event.target.parentElement.dataset.cardid
    // let url = `/cards/${card_id}/edit_attribute/card_type`
    // fetch(url, {
    //   method: 'GET',
    //   headers: {
    //     'Content-Type': 'application/json',
    //   }
    // })
    //   .then(response => response.json())
    //   .then(data => {
    //     alert(data.message)
    //   })
  }
}
