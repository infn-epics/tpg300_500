#include <stdio.h>
#include "StreamError.h"
#include "StreamFormatConverter.h"


/*
 * StreamDevice format converter for EPICS support for the Pfeiffer Vacuum TPG300 controller
 * that corrects the exponential number format from what StreamDevice provides
 * to what the device expects.
 *
 * StreamDevice formats numbers in exponent notation (%E or $e format specifier)
 * with at least two digits for the exponent (as specified by printf family
 * of functions). The controller expects a variable number of exponent digits
 * depending on the actual value of the exponent (even only one digit).
 *
 * Author: Krisztian Loki
 */


#define LOG_PREFIX "TPG300Format:\t"

class TPG300Format : public StreamFormatConverter
{
	friend class StreamFormatConverterRegistrar<TPG300Format>;
private:
	TPG300Format() : old_registered(NULL) {}
	TPG300Format(const TPG300Format&);
	StreamFormatConverter* old_registered;

public:
	void provides(const char* name, const char* provided);
	int  parse(const StreamFormat &fmt, StreamBuffer &into, const char*& source, bool scanFormat);
	bool printDouble(const StreamFormat &fmt, StreamBuffer &output, double value);
	int  scanDouble(const StreamFormat &fmt, const char* input, double &value);
};


int TPG300Format::parse(const StreamFormat &fmt, StreamBuffer &into, const char*& source, bool scanFormat)
{
	return old_registered->parse(fmt, into, source, scanFormat);
}


bool TPG300Format::printDouble(const StreamFormat &fmt, StreamBuffer &output, double value)
{
	/*
	 * Fake a string value output conversion
	 */
	char svalue[25];

	if (snprintf(svalue, sizeof(svalue), fmt.info, value) >= (int)sizeof(svalue))
	{
		error(LOG_PREFIX "Resulting string is too long, falling back to default %%E conversion!\n");
	}
	else
	{
		/*
		 * Remove the leading zero of the exponent
		 */
		char *E = strchr(svalue, 'E');
		if (E)
		{
			if (E[2] == '0')
			{
				E[2] = E[3];
				E[3] = '\0';
			}
			output.print("%s", svalue);

			return true;
		}

		error(LOG_PREFIX "'E' not found in %%E conversion, falling back to default conversion!\n");
	}

	output.print(fmt.info, value);

	return true;
}


int TPG300Format::scanDouble(const StreamFormat &fmt, const char* input, double &value)
{
	return old_registered->scanDouble(fmt, input, value);
}


void TPG300Format::provides(const char* name, const char* provided)
{
	old_registered = find(provided[0]);
	if (old_registered == NULL)
	{
		error(LOG_PREFIX "Cannot get previous format converter for %%%c conversion, _NOT_ registering ourselves!\n", provided[0]);
		return;
	}

	StreamFormatConverter::provides(name, provided);
}


RegisterConverter (TPG300Format, "E");
