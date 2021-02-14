const hamburger = document.querySelector('.hamburger');
const navbarNav = document.querySelector('.nav-bar__nav');
const bgMobile = document.querySelector('.nav-bg-mobile');
const navBarLinks = document.querySelectorAll('.nav-bar__nav li');

hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('active');
    navbarNav.classList.toggle('active');
    bgMobile.classList.toggle('active');

    navBarLinks.forEach((link) => {
        link.style.animation = `nav-bar__nav__linkFade 0.9s ease forwards`;
    });
});