import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let that = this;
    that.element.addEventListener('change', that.handleChange)
    that.element.addEventListener('blur', that.handleBlur, true)

    console.log(that.element)
  }
  handleChange(event) {
    event.preventDefault()
    event.target.form.requestSubmit()
  }
  handleBlur(event) {
    console.log('blur card id:' + event.target.parentElement.dataset.cardid)
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