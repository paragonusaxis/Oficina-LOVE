const classTitle = document.querySelectorAll('.class-title');

classTitle.forEach((title) => {
    const childs = title.childNodes;

    title.addEventListener('click', () => {
        if (childs[1].className == "class-arrow arrow-active") {
            childs[1].className = "class-arrow";
        } else {
            childs[1].className = "class-arrow arrow-active";
        }

        title.nextElementSibling.nextElementSibling.classList.toggle('active');
    });
});