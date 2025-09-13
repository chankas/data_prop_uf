// app/javascript/controllers/view_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["finalView", "btnTable", "btnCalendar"]

  connect() {
    console.log('conectado')
    // nada más al conectar
  }

  toggleTable() {
    if (this.btnTableTarget.classList.contains("active")) return

    this.finalViewTarget.classList.remove("calendar-view")
    this.finalViewTarget.classList.add("table-view")

    this._activateButton(this.btnTableTarget, this.btnCalendarTarget)
  }

  toggleCalendar() {
    if (this.btnCalendarTarget.classList.contains("active")) return

    this.finalViewTarget.classList.remove("table-view")
    this.finalViewTarget.classList.add("calendar-view")

    this._activateButton(this.btnCalendarTarget, this.btnTableTarget)
  }

  _activateButton(activeBtn, inactiveBtn) {
    activeBtn.classList.add("active", "btn-primary")
    activeBtn.classList.remove("btn-outline-primary")

    inactiveBtn.classList.remove("active", "btn-primary")
    inactiveBtn.classList.add("btn-outline-primary")
  }
}
