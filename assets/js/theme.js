// Runs in <head> so the theme is applied before first paint (no flash).
(function () {
  var root = document.documentElement;
  var stored = null;
  try { stored = localStorage.getItem('theme'); } catch (e) {}

  // Pages can pin a theme with <html data-theme-lock="light"> (used by the tools).
  var lock = root.getAttribute('data-theme-lock');
  var preferred = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  root.dataset.theme = lock || stored || preferred;

  function toggle() {
    var next = root.dataset.theme === 'dark' ? 'light' : 'dark';
    root.dataset.theme = next;
    try { localStorage.setItem('theme', next); } catch (e) {}
  }

  document.addEventListener('DOMContentLoaded', function () {
    var btn = document.getElementById('theme-toggle');
    if (btn) btn.addEventListener('click', toggle);

    var year = document.getElementById('year');
    if (year) year.textContent = new Date().getFullYear();
  });
})();
