(function () {
  var script = document.currentScript;
  var targetId = script ? script.dataset.target : 'post-list';
  var limit = parseInt((script && script.dataset.limit) || '0', 10);
  var target = document.getElementById(targetId);
  if (!target) return;

  function formatDate(iso) {
    return new Date(iso).toLocaleDateString('en-US', {
      year: 'numeric', month: 'short', day: 'numeric'
    });
  }

  function tagsHtml(tags) {
    if (!tags || !tags.length) return '';
    return tags.map(function (t) {
      return '<span class="badge bg-secondary me-1">' + t + '</span>';
    }).join('');
  }

  fetch('/articles.json')
    .then(function (r) { return r.json(); })
    .then(function (articles) {
      if (!articles.length) return;
      var sorted = articles.slice().sort(function (a, b) {
        return new Date(b.date) - new Date(a.date);
      });
      var shown = limit > 0 ? sorted.slice(0, limit) : sorted;
      target.innerHTML = shown.map(function (a) {
        return '<div class="card mb-3 shadow-sm">' +
          '<div class="card-body">' +
          '<div class="d-flex justify-content-between align-items-start mb-1">' +
          '<h5 class="card-title mb-0"><a href="/blog/' + a.slug + '/" class="text-decoration-none stretched-link">' + a.title + '</a></h5>' +
          '<small class="text-muted ms-3 text-nowrap">' + formatDate(a.date) + '</small>' +
          '</div>' +
          (a.readingTime ? '<small class="text-muted">' + a.readingTime + '</small>' : '') +
          (a.excerpt ? '<p class="card-text text-muted mt-2 mb-2">' + a.excerpt + '</p>' : '') +
          (a.tags && a.tags.length ? '<div>' + tagsHtml(a.tags) + '</div>' : '') +
          '</div>' +
          '</div>';
      }).join('');
    })
    .catch(function () { /* keep static empty state */ });
})();
