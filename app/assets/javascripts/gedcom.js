$(document).ready(function(){

if($('#ged_choice').is(':checked')){
    $('#select-gedcom').toggle(true);
    $('#upload-gedcom').toggle(false);

}else{
    $('#select-gedcom').toggle(false);
    $('#upload-gedcom').toggle(true);
};


$('#ged_choice').change(function() {
    $('#select-gedcom').toggle(this.checked);
    $('#upload-gedcom').toggle(!this.checked);

});

$('#stat_ged').change(function() {
    $('#stat-ged').toggle(!this.checked);
});


});
