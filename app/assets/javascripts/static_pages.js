$(document).ready(function(){

	$('#show_inclusion_box').change(function() {
		$('#show_inclusion').toggle(!this.checked);
	});

	$('#show_history_box').change(function() {
		$('#show_history').toggle(!this.checked);
	});

	$('#show_event_box').change(function() {
		$('#show_event').toggle(!this.checked);
	});	

	$('#show_gedcom_box').change(function() {
		$('#show_gedcom').toggle(!this.checked);
	});
});