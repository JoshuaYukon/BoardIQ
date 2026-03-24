import "@hotwired/turbo-rails"
import "controllers"

// Custom confirm modal — overrides Turbo's default browser alert (Turbo 8: config.forms.confirm)
Turbo.config.forms.confirm = function(message) {
  return new Promise(function(resolve) {
    var modal = document.getElementById("confirm-modal");
    var msgEl = document.getElementById("confirm-message");
    var okBtn = document.getElementById("confirm-ok");
    var cancelBtn = document.getElementById("confirm-cancel");
    var backdrop = document.getElementById("confirm-backdrop");

    if (!modal) { resolve(window.confirm(message)); return; }

    msgEl.textContent = message;

    // Set contextual button label and style
    var lc = message.toLowerCase();
    var isDelete = lc.includes("delete") || lc.includes("remove");
    var isStart  = lc.includes("start");
    var isComplete = lc.includes("complete") || lc.includes("mark sprint");
    if (isDelete) {
      okBtn.textContent = "Delete";
      okBtn.className = "btn danger";
    } else if (isStart) {
      okBtn.textContent = "Start";
      okBtn.className = "btn accent";
    } else if (isComplete) {
      okBtn.textContent = "Complete";
      okBtn.className = "btn";
    } else {
      okBtn.textContent = "Confirm";
      okBtn.className = "btn";
    }

    modal.style.display = "flex";

    function close(result) {
      modal.style.display = "none";
      okBtn.removeEventListener("click", onOk);
      cancelBtn.removeEventListener("click", onCancel);
      backdrop.removeEventListener("click", onCancel);
      resolve(result);
    }

    function onOk() { close(true); }
    function onCancel() { close(false); }

    okBtn.addEventListener("click", onOk);
    cancelBtn.addEventListener("click", onCancel);
    backdrop.addEventListener("click", onCancel);
  });
};
