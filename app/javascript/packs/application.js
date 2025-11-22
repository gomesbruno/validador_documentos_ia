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


//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/autocomplete
//= require jquery-ui/widgets/menu
//= require autocomplete-rails
//= require moment/min/moment.min.js
//= require sweetalert2
//= require sweet-alert2-rails
//= require datatables
//= require js-routes
//= require info-modal
//= require itens_natureza_despesa_utils
//= require mask_utils
//= require tinymce
//= require_tree ./angle/
//= require_tree ./lib/

function exibePreLoader() {
  $('.preloaderLoad').append('<div class="preloader"></div>')
  $('.preloader').append('<div class="preloaderContent"></div>')
  $('.preloaderContent').append('<div class="preloaderContentCircle"></div>')
  $('.preloaderContentCircle').append('<div></div>')
  $('.preloaderContentCircle').append('<div></div>')
  $('.preloaderContentCircle').append('<div></div>')
}

function removePreLoader() {
  $('.preloader').remove()
}

// Observer para exibir e esconder loading de autocomplete
function onAutocompleteLoading(autocompleteID, callback) {
  var $div = $(autocompleteID)
  var changed = false
  var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if (mutation.attributeName === 'class') {
        var attributeValue = $(mutation.target).prop(mutation.attributeName)
        if (attributeValue.split(' ').includes('ui-autocomplete-loading')) {
          changed = true
          callback()
        } else if (!attributeValue.split(' ').includes('ui-autocomplete-loading') && changed) {
          changed = false
        }
      }
    })
  })
  observer.observe($div[0], {
    attributes: true
  })
}

/// Carregar a lista de cidades baseada no estado selecionado
// Se for uma tela de editar deve carregar a lista de cidades do estado e deixar a cidade previamente
// escolhida já marcada.
// o spinner_id é pra saber qual sipnner está associado a este select field
function setEstadoCidadeLoad(elemento_estado_id, cidades_select, cidade_id, spinner_id) {
  var estado_id = $(elemento_estado_id).val()
  if (estado_id) {
    $(cidades_select).prop('disabled', true)
    $.ajax({
      type: 'GET',
      url: Routes.cidades_for_select_projetos_curso_path(),
      data: {
        estado_id: estado_id,
        elemento: cidades_select
      },
      success: function() {
        var cidade_val = $(cidade_id).val()
        $(cidades_select + ' option[value=' + cidade_val + ']')[0].selected = true
      }
    })
  } else {
    $(cidades_select).prop('disabled', true)
  }

  $(elemento_estado_id).change(function() {
    $(cidades_select).addClass('select-loading')
    var estado_id = $(this).val()
    $(cidades_select).prop('disabled', true)
    $.ajax({
      type: 'GET',
      url: Routes.cidades_for_select_projetos_curso_path(),
      data: {
        estado_id: estado_id,
        elemento: cidades_select
      },
      success: function() {
        $(cidades_select).removeClass('select-loading')
      }
    })
  })
}

function setDatePickerMonths(periodo_inicio, periodo_fim) {
  $(periodo_inicio).datetimepicker({
    locale: 'pt-BR',
    useCurrent: false,
    format: 'MM/YYYY',
    viewMode: 'months'
  })

  $(periodo_fim).datetimepicker({
    locale: 'pt-BR',
    useCurrent: false, // Important! See issue #1075
    format: 'MM/YYYY',
    viewMode: 'months'
  })
  if ($(periodo_inicio).val() == '') {
    $(periodo_inicio).data('DateTimePicker').minDate(moment().startOf('month'))
    $(periodo_fim).data('DateTimePicker').minDate(moment().startOf('month'))
  } else if ($(periodo_inicio).val() && $(periodo_fim).val()) {
    $(periodo_inicio).data('DateTimePicker').minDate(moment($(periodo_inicio).val(), 'MM/YYYY').startOf('month'))
    $(periodo_inicio).data('DateTimePicker').maxDate(moment($(periodo_fim).val(), 'MM/YYYY').startOf('month'))
    $(periodo_fim).data('DateTimePicker').minDate(moment($(periodo_inicio).val(), 'MM/YYYY').startOf('month'))
  }

  $(periodo_inicio).on('dp.change', function(e) {
    $(periodo_fim).data('DateTimePicker').minDate(e.date)
  })
  $(periodo_fim).on('dp.change', function(e) {
    $(periodo_inicio).data('DateTimePicker').maxDate(e.date)
  })
}

function setDatePickerDays(periodo_inicio, periodo_fim) {
  var data_inicio = moment($('#data_inicio_projeto').val(), 'MM-YYYY')
  var data_fim = moment($('#data_fim_projeto').val(), 'MM-YYYY')

  $(periodo_inicio).datetimepicker({
    locale: 'pt-BR',
    format: 'DD/MM/YYYY'
    // minDate: data_inicio,
    // maxDate: data_fim,
  })

  $(periodo_fim).datetimepicker({
    locale: 'pt-BR',
    format: 'DD/MM/YYYY'
    // minDate: data_inicio,
    // maxDate: data_fim,
  })

  if ($(periodo_inicio).data('DateTimePicker') != undefined) {
    $(periodo_inicio).data('DateTimePicker').minDate(data_inicio)
    $(periodo_inicio).data('DateTimePicker').maxDate(data_fim.endOf('month'))
    $(periodo_fim).data('DateTimePicker').minDate(data_inicio)
    $(periodo_fim).data('DateTimePicker').maxDate(data_fim.endOf('month'))

    $(periodo_inicio).on('dp.change', function(e) {
      $(periodo_fim).data('DateTimePicker').minDate(e.date)
    })
    $(periodo_fim).on('dp.change', function(e) {
      $(periodo_inicio).data('DateTimePicker').maxDate(e.date)
    })
  }
}

function getSelectedText(elementId) {
  const elt = document.getElementById(elementId)

  if (elt.selectedIndex == -1) { return null }

  return elt.options[elt.selectedIndex].text
}

function addAlertOrNotice(type, hide_others, text) {
  if (hide_others) {
    $('.alert').remove()
    $('.notice').remove()
  }
  $('.content-wrapper').prepend('' +
        '<div role="' + type + '" class="' + type + ' ' + type + '-danger ' + type + '-dismissible fade in">' +
        '<button type="button" data-dismiss="' + type + '" aria-label="Close" class="close">' +
        '<span aria-hidden="true">' +
        '×' +
        '</span>' +
        '</button>' +
        '<ul>' +
        '<li>' + text + '</li>' +
        '</ul>' +
        '</div>'
  )
}

function addSweetAlert(title, text, type, txtConfirmBtn, funcConfirm) {
  swal({
    title: title || '',
    text: text || '',
    type: type,
    showCancelButton: false,
    confirmButtonColor: '#34B247',
    confirmButtonText: txtConfirmBtn || 'OK',
    closeOnConfirm: true
  }).then((isConfirm) => {
    if (isConfirm) {
      if (funcConfirm) {
        funcConfirm()
      }
    }
  })
}

function loadCustomValidators() {
  if (window.Parsley) {
    Object.keys(customValidators).map(function(nome) {
      window.Parsley.addValidator(nome, customValidators[nome])
    })
  }
}

function cancelar_login_sei() {
  document.getElementById('login_sei_form').reset()
  window.location.reload(true)
}

function removeModalCasoExista() {
  while ($('.modal.fade').size() > 0) {
    $('.modal.fade').remove()
  }
}

function ativaSpanToolTipDisabled() {
  $('[data-toggle="tooltip"]').tooltip()
  $(document).on('hover', '.tool-tip', function(e) {
    $('.tool-tip').children().on('input', function() {
      $(this).parent()
        .attr('data-original-title', this.value)
        .tooltip({ show: false })
        .tooltip('show')
    })
  })
}

function submitAjaxForm(form, button) {
  exibePreLoader()
  $.ajax({
    url: form.attr('action'),
    type: form.attr('method'),
    data: new FormData(form[0]),
    processData: false,
    contentType: false
  }).always(function(msg) {
    button.prop('disabled', false)
    removePreLoader()
  })
}
function validaTinymce(form_id) {
  var form = $(form_id)
  var valido = false
  form.parsley().on('form:validate', function() {
    tinymce.triggerSave()
    valido = form.parsley().isValid()
  })
  return valido
}
