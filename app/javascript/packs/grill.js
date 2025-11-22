// Dependências via Yarn (se estiver usando)
import 'jquery'
import 'bootstrap'
import 'select2'
import 'jquery-ui/ui/widgets/sortable'; // Or 'jquery-ui' for the full library
import $ from "jquery"
import "jquery-ui/ui/widgets/autocomplete"   // jQuery UI Autocomplete
import "rails-jquery-autocomplete"           // inicializa inputs com data-autocomplete


// JS do tema (ajuste o nome do arquivo se for diferente)
import '../grill/js/scripts.js'

// app/javascript/packs/grill.js
import '../grill/scss/grill.scss';
import './usuarios'


// Se tiver JS do tema:
// import '../grill/js/grill.js';

// Para as imagens entrarem no manifest (logo, ícones…)
const images = require.context('../grill/images', true);

