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

	$('#show_inclusion_box_contrib').change(function() {
		$('#show_inclusion_contrib').toggle(!this.checked);
	});

	$('#show_history_box_contrib').change(function() {
		$('#show_history_contrib').toggle(!this.checked);
	});

	$('#show_event_box_contrib').change(function() {
		$('#show_event_contrib').toggle(!this.checked);
	});	

	$('#show_gedcom_box_contrib').change(function() {
		$('#show_gedcom_contrib').toggle(!this.checked);
	});


});