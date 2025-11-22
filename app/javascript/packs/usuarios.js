// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//-- AUTOCOMPLETE
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails

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
            {"data": "perfis"},
            {"data": "acoes"}
        ],
        columnDefs: [
            {
                targets: [1, 2],
                orderable: false
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
    select(_event, ui) {
      if ($hidden.length) {
        $hidden.val(ui.item.id);
      }
    }
  });
});
