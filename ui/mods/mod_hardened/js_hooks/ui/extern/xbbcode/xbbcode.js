Hardened.Hooks.XBBCODE_process = XBBCODE.process;
XBBCODE.process = function(config)
{
	// Feat: improve formatting of minus signs in front of negative numbers
	// Vanilla and every mod only ever use the hyphen-minus that is most common on keyboards
	// This one however is only half as wide as the plus sign. And it is also missing a built-in space left and right of it
	// As a result this minus sign is really small and hard to spot, compared to the plus sign
	// We fix this by replacing such a minus sign with the "en dash" (U+2013) and put additional non-breaking spaces on either side of it
	// Ideally we would use the "minus sign" (U+2212), but this one causes glitches when followed by other formatting
	config.text = config.text.replace(/(\[color=[^\]]+\])-/g, "$1&nbsp;–&nbsp;");

	var ret = Hardened.Hooks.XBBCODE_process(config);

	ret.html = ret.html.replace(
		/(?:\[|&#91;)wbr(?:\]|&#93;)(?:\[|&#91;)\/wbr(?:\]|&#93;)/g,
		"<wbr>"
	);

	return ret;
};
