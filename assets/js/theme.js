(function () {
  var stored = localStorage.getItem('theme');
  var preferred = window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark';
  var theme = stored || preferred;
  document.documentElement.dataset.theme = theme;

  function setIcon(t) {
    var btn = document.getElementById('theme-toggle');
    if (btn) btn.querySelector('.theme-icon').textContent = t === 'dark' ? '☀' : '☽';
  }

  window.__toggleTheme = function () {
    var next = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
    document.documentElement.dataset.theme = next;
    localStorage.setItem('theme', next);
    setIcon(next);
  };

  document.addEventListener('DOMContentLoaded', function () {
    var btn = document.getElementById('theme-toggle');
    if (btn) {
      btn.addEventListener('click', window.__toggleTheme);
      setIcon(document.documentElement.dataset.theme);
    }
  });
})();
