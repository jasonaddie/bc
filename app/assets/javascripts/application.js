// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery-3.3.1.min
//= require custom_jqueryui_datepicker
// require jquery-ui/widgets/datepicker
//= require jquery-ui/i18n/datepicker-az
//= require jquery-ui/i18n/datepicker-hy
//= require jquery-ui/i18n/datepicker-ka
//= require jquery-ui/i18n/datepicker-ru
//= require_tree .
//= stub 'admin'

function isVerticalOverflown(element) {
  return element.scrollHeight > element.clientHeight;
}

// // Returns a function, that, as long as it continues to be invoked, will not
// // be triggered. The function will be called after it stops being called for
// // N milliseconds. If `immediate` is passed, trigger the function on the
// // leading edge, instead of the trailing.
// function debounce(func, wait, immediate) {
//   console.log('debounce....')
//   var timeout;
//   return function() {
//     var context = this, args = arguments;
//     var later = function() {
//       timeout = null;
//       if (!immediate) func.apply(context, args);
//     };
//     var callNow = immediate && !timeout;
//     clearTimeout(timeout);
//     timeout = setTimeout(later, wait);
//     if (callNow) func.apply(context, args);
//   };
// };

const debounce = (func, delay) => {
  let inDebounce
  return function() {
    const context = this
    const args = arguments
    clearTimeout(inDebounce)
    inDebounce = setTimeout(() => func.apply(context, args), delay)
  }
}


function convertRemToPixels(rem) {
  return rem * parseFloat(getComputedStyle(document.documentElement).fontSize);
}

function getAll(selector) {
  return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
}


function formatDate(d)
{

  if (d !== null){
    var month = d.getMonth();
    var day = d.getDate();
    month = month + 1;

    month = month + "";

    if (month.length == 1)
    {
        month = "0" + month;
    }

    day = day + "";

    if (day.length == 1)
    {
        day = "0" + day;
    }

    return d.getFullYear() + '-' + month + '-' + day;
  }
}