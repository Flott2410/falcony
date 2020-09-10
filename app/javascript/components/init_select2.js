import $ from 'jquery';
import 'select2';

const initSelect2 = () => {

  $('.select2').select2(); // (~ document.querySelectorAll)
};

export { initSelect2 };


// document.addEventListener('turbolinks:before-cache', () => {
//   // destroy objects before load js again
//   document.querySelectorAll('.select2').forEach(function(input){
//     if (input.select2) {
//       input.select2.destroy();
//     }
//   });
// });
