import $ from "jquery";
import "jquery-ui/ui/widgets/autocomplete";

// DataTables server-side cache (pipeline) helper
// Based on the official DataTables example: https://datatables.net/examples/server_side/pipeline.html
$.fn.dataTable.pipeline = function (opts) {
  const conf = $.extend({
    pages: 5,     // how many pages to cache
    url: '',      // script url
    data: null,   // function or object with parameters to send to the server
    method: 'GET' // Ajax HTTP method
  }, opts);

  let cacheLower = -1;
  let cacheUpper = null;
  let cacheLastRequest = null;
  let cacheLastJson = null;

  return function (request, drawCallback, settings) {
    let ajax = false;
    const requestStart = request.start;
    const draw = request.draw;
    const requestEnd = requestStart + request.length;

    if (settings.clearCache) {
      ajax = true;
      settings.clearCache = false;
    } else if (cacheLower < 0 || requestStart < cacheLower || requestEnd > cacheUpper
      || JSON.stringify(request.order) !== JSON.stringify(cacheLastRequest.order)
      || JSON.stringify(request.columns) !== JSON.stringify(cacheLastRequest.columns)
      || JSON.stringify(request.search) !== JSON.stringify(cacheLastRequest.search)) {
      ajax = true;
    }

    cacheLastRequest = $.extend(true, {}, request);

    if (ajax) {
      cacheLower = requestStart;
      cacheUpper = requestStart + (request.length * conf.pages);
      request.start = requestStart;
      request.length = request.length * conf.pages;

      if (typeof conf.data === 'function') {
        const d = conf.data(request);
        if (d) {
          $.extend(request, d);
        }
      } else if ($.isPlainObject(conf.data)) {
        $.extend(request, conf.data);
      }

      settings.jqXHR = $.ajax({
        type: conf.method,
        url: conf.url,
        data: request,
        dataType: 'json',
        cache: false,
        success(json) {
          cacheLastJson = $.extend(true, {}, json);

          if (cacheLower !== requestStart) {
            json.data.splice(0, requestStart - cacheLower);
          }
          if (request.length >= -1) {
            json.data.splice(request.length, json.data.length);
          }

          drawCallback(json);
        }
      });
    } else {
      const json = $.extend(true, {}, cacheLastJson);
      json.draw = draw; // Update the echo for each response
      json.data.splice(0, requestStart - cacheLower);
      json.data.splice(request.length, json.data.length);

      drawCallback(json);
    }
  };
};

$.fn.dataTable.Api.register('clearPipeline()', function () {
  return this.iterator('table', function (settings) {
    settings.clearCache = true;
  });
});

$(document).ready(function () {
    $(':checkbox').on('change', function () {
        $('#enviar').prop('disabled', !$(':checkbox:checked').length);
    }).change();

    $('#usuarios_datatable').DataTable({
        bJQueryUI: true,
        processing: true,
        serverSide: true,
        scrollY: (2 * 390 + 16),
        scrollX: true,
        searching: true,
        scrollCollapse: true,
        paging: true,
        pagingType: 'full_numbers',
        lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
        columns: [
            {"data": "nome"},
            {"data": "cpf"},
            {"data": "perfis"},
            {"data": "status"},
            {"data": "acoes"}
        ],
        columnDefs: [
            {
                targets: [2, 3, 4],
                orderable: false,
                searchable: false
            }
        ],
        "ajax": $.fn.dataTable.pipeline({
            'pages': 1,
            "url": $('#usuarios_datatable').data('source')
        }),
        "language": defaultLanguage()
    });
});

document.addEventListener('turbolinks:load', () => {
  const $input  = $('#autocomplete');
  const $hidden = $('#identificacao_login_id');

  if (!$input.length) return;

  const url = $input.data('autocomplete-url');
  if (!url) return;

  $input.autocomplete({
    source(request, response) {
      $.getJSON(url, { term: request.term }, response);
    },
    minLength: 3,
    delay: 500,
    select(_event, ui) {
      if ($hidden.length) {
        $hidden.val(ui.item.id);
      }
    }
  });
});
