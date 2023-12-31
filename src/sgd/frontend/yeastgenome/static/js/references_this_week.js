
$(document).ready(function() {

  	$.getJSON('/redirect_backend?param=references/this_week', function(data) {
        $("#dates").html(data['start'] + ' to ' + data['end']);
        set_up_reference_list("references", "references_list", "references_list_empty_message", "references_list_wrapper", "references_list_download", "citations_for_week_of_" + data['start'].replace('-', '_'), data['references']);
    });

});

function set_up_reference_list(header_id, list_id, message_id, wrapper_id, download_button_id, download_filename, data) {
	set_up_header(header_id, data.length, 'reference', 'references');
        // set_up_references(data, list_id);
        reference_ids = []
        for (var i=0; i < data.length; i++) {
            var reference = data[i];
	    reference_ids.push(reference['id']);
	}
	if (data.length == 0) {
		$("#" + message_id).show();
		$("#" + wrapper_id).hide();
	}
        $("#" + download_button_id).click(function f() {
            post_to_url('/download_citations', {"display_name":download_filename, "reference_ids": reference_ids});
        });
}
