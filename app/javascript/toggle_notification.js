const toggleBell = () => {
  const getBell = document.querySelectorAll('.fa-bell');
  getBell.forEach((bell) => {
    if (bell.classList.contains('far')) {
      bell.addEventListener('click', (event) => {
        bell.classList.toggle('far');
        bell.classList.toggle('fas');
      });
    } else {
      bell.addEventListener('click', (event) => {
        bell.classList.toggle('fas');
        bell.classList.toggle('far');
      });
    }
  });
}

export { toggleBell };
