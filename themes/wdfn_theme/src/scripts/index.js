import wdfnviz from 'wdfn-viz';

const load = function () {
    null;
};

window.toggle_visibility = function (button, id) {
    var e = document.getElementById(id);
    if (e.style.display == 'block' || e.style.display == '') {
        e.style.display = 'none';
        button.innerHTML = 'Show Code'
    } else {
        e.style.display = 'block';
        button.innerHTML = 'Hide Code';
    }
};

wdfnviz.main(load);