// For internal use only
function _net_util_split(inputString, splitter) {
	var splitterLength = string_length(splitter);
	var result;
	var splitterLocation;
	var part;
	var count = 0;

	while (string_pos(splitter, inputString) > 0) {
	    splitterLocation = string_pos(splitter, inputString);
	    part = string_copy(inputString, 1, splitterLocation - 1);
	    result[count] = part;
	    count++;
	    inputString = string_delete(inputString, 1, splitterLocation + splitterLength - 1);
	}

	result[count] = inputString;
	return result;
}
