const projectCard = document.querySelectorAll('.project-card');
const blackLayer = document.querySelector('.black-layer')

projectCard.forEach((card) => {
    const openCard = card.nextElementSibling;
    const closeButton = openCard.firstElementChild;

    card.addEventListener('click', () => {
        blackLayer.classList.toggle('active');
        openCard.classList.toggle('active');
    });

    closeButton.addEventListener('click', () => {
        console.log('click');
        blackLayer.classList.toggle('active');
        openCard.classList.toggle('active');
    });
});