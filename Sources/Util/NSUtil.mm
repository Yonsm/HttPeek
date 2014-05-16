
#import "NSUtil.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>


// Convert number to string
NSString *NSUtil::FormatNumber(NSNumber *number, NSNumberFormatterStyle style)
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:style];
	NSString *result = [formatter stringFromNumber:number];
	[formatter release];
	return result;
}

// Convert date to string
NSString *NSUtil::FormatDate(NSDate *date, NSString *format)
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = format;
	return [formatter stringForObjectValue:date];
}

// Convert date to string
NSString *NSUtil::FormatDate(NSDate *date, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle)
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateStyle:dateStyle];
	[formatter setTimeStyle:timeStyle];
	return [formatter stringForObjectValue:date];
}

// Convert string to date
NSDate *NSUtil::FormatDate(NSString *string, NSString *format, NSLocale *locale)
{
	if (string == nil) return nil;
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = format;
	if (locale) formatter.locale = locale;
	return [formatter dateFromString:string];
}

// Convert string to date
NSDate *NSUtil::FormatDate(NSString *string, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle, NSLocale *locale)
{
	if (string == nil) return nil;
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateStyle:dateStyle];
	[formatter setTimeStyle:timeStyle];
	if (locale) formatter.locale = locale;
	return [formatter dateFromString:string];
}

// Convert date to readable string. Return nil on fail
NSString *NSUtil::SmartDate(NSDate *date)
{
	NSDate *now = [NSDate date];
	NSTimeInterval t1 = [now timeIntervalSinceReferenceDate];
	NSTimeInterval t2 = [date timeIntervalSinceReferenceDate];
	NSTimeInterval t = [[NSTimeZone defaultTimeZone] secondsFromGMT];
	NSInteger d1 = (t1 + t) / (24 * 60 * 60);
	NSInteger d2 = (t2 + t) / (24 * 60 * 60);
	NSInteger days = d2 - d1;
	switch (days)
	{
		case -2: return NSLocalizedString(@"Before Yesterday ", @"前天");
		case -1: return NSLocalizedString(@"Yesterday ", @"昨天");
		case 0: return NSLocalizedString(@"Today ", @"今天");
		case 1: return NSLocalizedString(@"Tomorrow ", @"明天");
		case 2: return NSLocalizedString(@"After Tomorrow ", @"后天");
	}
	return nil;
}


// Convert date to smart string
NSString *NSUtil::SmartDate(NSDate *date, NSString *format)
{
	NSString *string = SmartDate(date);
	return string ? string : FormatDate(date, format);
}

// Convert date to smart string
NSString *NSUtil::SmartDate(NSDate *date, NSDateFormatterStyle dateStyle)
{
	NSString *string = SmartDate(date);
	return string ? string : FormatDate(date, dateStyle, NSDateFormatterNoStyle);
}

// Convert date to smart string
NSString *NSUtil::SmartDate(NSDate *date, NSDateFormatterStyle dateStyle, NSDateFormatterStyle timeStyle)
{
	NSString *string = SmartDate(date);
	return string ? [string stringByAppendingFormat:@" %@", FormatDate(date, NSDateFormatterNoStyle, timeStyle)] : FormatDate(date, dateStyle, timeStyle);
}

// Check email address
BOOL NSUtil::IsEmailAddress(NSString *emailAddress)
{
	NSString *emailRegEx =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	return [regExPredicate evaluateWithObject:[emailAddress lowercaseString]];
}

// Check mobile number
BOOL NSUtil::IsMobileNumberInChina(NSString *phoneNumber)
{
	/**
	 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
	 * 联通：130,131,132,152,155,156,185,186
	 * 电信：133,1349,153,180,189
	 */
	
	NSString *mobileNumberRegEx = @"^1[358]\\d{9}$";
	
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberRegEx];
	return ([regextestmobile evaluateWithObject:phoneNumber]);
}


// Check phone number equal
BOOL NSUtil::IsPhoneNumberEqual(NSString *phoneNumber1, NSString *phoneNumber2, NSUInteger minEqual)
{
	if (!phoneNumber1 || !phoneNumber2) return NO;
	
	const char *number1 = phoneNumber1.UTF8String;
	const char *number2 = phoneNumber2.UTF8String;
	
	const char *end1 = number1 + strlen(number1);
	const char *end2 = number2 + strlen(number2);
	const char *p1 = end1 - 1;
	const char *p2 = end2 - 1;
	while ((p1 >= number1) && (p2 >= number2))
	{
		if ((*p1 < '0') || (*p1 > '9'))
		{
			p1--;
		}
		else if ((*p2 < '0') || (*p2 > '9'))
		{
			p2--;
		}
		else if (*p1 == *p2)
		{
			p1--;
			p2--;
		}
		else
		{
			break;
		}
	}
	return ((p1 < number1) && (p2 < number2)) || (end1 - p1 >= minEqual);
}

// Calculate MD5
NSString *NSUtil::MD5(NSString *str)
{
	if (str == nil) return nil;
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	const char *cstr = [str UTF8String];
	CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

// Calculate SHA1
NSString *NSUtil::HmacSHA1(NSString *text, NSString *secret)
{
	NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
	NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
	
	unsigned char result[20];
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
	return BASE64Encode(result, 20);
}

// BASE64 encode
NSString *NSUtil::BASE64Encode(const unsigned char *data, NSUInteger length, NSUInteger lineLength)
{
	// BASE64 table
	const static char c_baseTable[64] =
	{
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
		'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
		'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
		'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/'
	};
	
	NSMutableString *result = [NSMutableString stringWithCapacity:length];
	unsigned long ixtext = 0;
	unsigned long lentext = length;
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	short i = 0;
	short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while (YES)
	{
		ctremaining = lentext - ixtext;
		if (ctremaining <= 0) break;
		
		for (i = 0; i < 3; i++)
		{
			ix = ixtext + i;
			if (ix < lentext)
			{
				inbuf[i] = data[ix];
			}
			else
			{
				inbuf [i] = 0;
			}
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch (ctremaining)
		{
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		
		for (i = 0; i < ctcopy; i++)
		{
			[result appendFormat:@"%c", c_baseTable[outbuf[i]]];
		}
		
		for (i = ctcopy; i < 4; i++)
		{
			[result appendFormat:@"%c",'='];
		}
		
		ixtext += 3;
		charsonline += 4;
		
		if (lineLength > 0)
		{
			if (charsonline >= lineLength)
			{
				charsonline = 0;
				[result appendString:@"\n"];
			}
		}
	}
	
	return result;
}

// BASE64 decode
NSData *NSUtil::BASE64Decode(NSString *string)
{
	NSMutableData *mutableData = nil;
	
	if (string)
	{
		unsigned long ixtext = 0;
		unsigned long lentext = 0;
		unsigned char ch = 0;
		unsigned char inbuf[4], outbuf[4];
		short i = 0, ixinbuf = 0;
		BOOL flignore = NO;
		BOOL flendtext = NO;
		NSData *base64Data = nil;
		const unsigned char *base64data = nil;
		
		// Convert the string to ASCII data.
		base64Data = [string dataUsingEncoding:NSASCIIStringEncoding];
		base64data = (const unsigned char *)[base64Data bytes];
		mutableData = [NSMutableData dataWithCapacity:[base64Data length]];
		lentext = [base64Data length];
		
		while (YES)
		{
			if (ixtext >= lentext)
			{
				break;
			}
			ch = base64data[ixtext++];
			flignore = NO;
			
			if ((ch >= 'A') && (ch <= 'Z')) ch = ch - 'A';
			else if ((ch >= 'a') && (ch <= 'z')) ch = ch - 'a' + 26;
			else if ((ch >= '0') && (ch <= '9')) ch = ch - '0' + 52;
			else if (ch == '+') ch = 62;
			else if (ch == '=') flendtext = YES;
			else if (ch == '/') ch = 63;
			else flignore = YES;
			
			if (!flignore)
			{
				short ctcharsinbuf = 3;
				BOOL flbreak = NO;
				
				if (flendtext)
				{
					if (!ixinbuf) break;
					if ((ixinbuf == 1) || (ixinbuf == 2)) ctcharsinbuf = 1;
					else ctcharsinbuf = 2;
					ixinbuf = 3;
					flbreak = YES;
				}
				
				inbuf[ixinbuf++] = ch;
				
				// Please ignore any warning here
				if (ixinbuf == 4)
				{
					outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
					outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
					outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
					ixinbuf = 0;
					
					for (i = 0; i < ctcharsinbuf; i++)
					{
						[mutableData appendBytes:&outbuf[i] length:1];
					}
				}
				
				if (flbreak)
				{
					break;
				}
			}
		}
	}
	
	return mutableData;
}

//
NSString *NSUtil::CountryAreaCode(NSString *country)
{
	const static struct {NSString *country; NSString *code;} c_codes[] =
	{
		{@"CN", @"86"},
		
 		{@"AD", @"376"},
 		{@"AE", @"971"},
 		{@"AE", @"9712"},
 		{@"AE", @"9714"},
 		{@"AF", @"93"},
 		{@"AG", @"1268"},
 		{@"AI", @"1264"},
 		{@"AL", @"355"},
 		{@"AM", @"374"},
 		{@"AN", @"599"},
 		{@"AO", @"244"},
 		{@"AR", @"54"},
 		{@"AS", @"684"},
 		{@"AT", @"43"},
 		{@"AU", @"61"},
 		{@"AW", @"297"},
 		{@"AZ", @"994"},
 		{@"BA", @"387"},
 		{@"BB", @"1246"},
 		{@"BD", @"880"},
 		{@"BE", @"32"},
 		{@"BF", @"226"},
 		{@"BG", @"359"},
 		{@"BH", @"973"},
 		{@"BI", @"257"},
 		{@"BJ", @"229"},
 		{@"BM", @"1441"},
 		{@"BN", @"673"},
 		{@"BO", @"591"},
 		{@"BR", @"55"},
 		{@"BS", @"1242"},
 		{@"BT", @"975"},
 		{@"BW", @"267"},
 		{@"BY", @"375"},
 		{@"BZ", @"501"},
 		{@"CD", @"243"},
 		{@"CF", @"236"},
 		{@"CG", @"242"},
 		{@"CH", @"41"},
 		{@"CI", @"225"},
 		{@"CK", @"682"},
 		{@"CL", @"56"},
 		{@"CM", @"237"},
 		//{@"CN", @"86"},
 		{@"CO", @"57"},
 		{@"CR", @"506"},
 		{@"CU", @"53"},
 		{@"CV", @"238"},
 		{@"CY", @"357"},
 		{@"CZ", @"420"},
 		{@"DE", @"49"},
 		{@"DJ", @"253"},
 		{@"DK", @"45"},
 		{@"DM", @"1767"},
 		{@"DO", @"1809"},
 		{@"DZ", @"213"},
 		{@"EC", @"593"},
 		{@"EE", @"372"},
 		{@"EG", @"20"},
 		{@"ER", @"291"},
 		{@"ES", @"34"},
 		{@"ET", @"251"},
 		{@"FI", @"358"},
 		{@"FJ", @"679"},
 		{@"FK", @"500"},
 		{@"FM", @"691"},
 		{@"FO", @"298"},
 		{@"FR", @"33"},
 		{@"GA", @"241"},
 		{@"GB", @"44"},
 		{@"GD", @"1473"},
 		{@"GE", @"995"},
 		{@"GF", @"594"},
 		{@"GH", @"233"},
 		{@"GI", @"350"},
 		{@"GL", @"299"},
 		{@"GM", @"220"},
 		{@"GN", @"224"},
 		{@"GP", @"590"},
 		{@"GQ", @"240"},
 		{@"GR", @"30"},
 		{@"GT", @"502"},
 		{@"GU", @"1671"},
 		{@"GW", @"245"},
 		{@"GY", @"592"},
 		{@"HK", @"852"},
 		{@"HN", @"504"},
 		{@"HR", @"385"},
 		{@"HT", @"509"},
 		{@"HU", @"36"},
 		{@"ID", @"62"},
 		{@"IE", @"353"},
 		{@"IL", @"972"},
 		{@"IN", @"91"},
 		{@"IQ", @"964"},
 		{@"IR", @"98"},
 		{@"IS", @"354"},
 		{@"IT", @"39"},
 		{@"JM", @"1876"},
 		{@"JO", @"962"},
 		{@"JP", @"81"},
 		{@"KE", @"254"},
 		{@"KG", @"331"},
 		{@"KH", @"855"},
 		{@"KI", @"686"},
 		{@"KM", @"269"},
 		{@"KN", @"1869"},
 		{@"KP", @"850"},
 		{@"KR", @"82"},
 		{@"KW", @"965"},
 		{@"KY", @"1345"},
 		{@"KZ", @"73"},
 		{@"LA", @"856"},
 		{@"LB", @"961"},
 		{@"LC", @"1758"},
 		{@"LI", @"423"},
 		{@"LK", @"94"},
 		{@"LR", @"231"},
 		{@"LS", @"266"},
 		{@"LT", @"370"},
 		{@"LU", @"352"},
 		{@"LV", @"371"},
 		{@"LY", @"218"},
 		{@"MA", @"212"},
 		{@"MC", @"377"},
 		{@"MD", @"373"},
 		{@"ME", @"382"},
 		{@"MG", @"261"},
 		{@"MH", @"692"},
 		{@"MK", @"389"},
 		{@"ML", @"223"},
 		{@"MM", @"95"},
 		{@"MN", @"976"},
 		{@"MO", @"853"},
 		{@"MP", @"1670"},
 		{@"MQ", @"596"},
 		{@"MR", @"222"},
 		{@"MS", @"1664"},
 		{@"MT", @"356"},
 		{@"MU", @"230"},
 		{@"MV", @"960"},
 		{@"MW", @"265"},
 		{@"MX", @"52"},
 		{@"MY", @"60"},
 		{@"MZ", @"258"},
 		{@"NA", @"264"},
 		{@"NC", @"687"},
 		{@"NE", @"227"},
 		{@"NG", @"234"},
 		{@"NI", @"505"},
 		{@"NL", @"31"},
 		{@"NO", @"47"},
 		{@"NP", @"977"},
 		{@"NR", @"674"},
 		{@"NZ", @"64"},
 		{@"OM", @"968"},
 		{@"PA", @"507"},
 		{@"PE", @"51"},
 		{@"PF", @"689"},
 		{@"PG", @"675"},
 		{@"PH", @"63"},
 		{@"PK", @"92"},
 		{@"PL", @"48"},
 		{@"PM", @"508"},
 		{@"PR", @"1787"},
 		{@"PS", @"970"},
 		{@"PT", @"351"},
 		{@"PW", @"680"},
 		{@"PY", @"595"},
 		{@"QA", @"974"},
 		{@"RE", @"262"},
 		{@"RO", @"40"},
 		{@"RS", @"381"},
 		{@"RU", @"7"},
 		{@"RW", @"250"},
 		{@"SA", @"966"},
 		{@"SB", @"677"},
 		{@"SC", @"248"},
 		{@"SD", @"249"},
 		{@"SE", @"46"},
 		{@"SG", @"65"},
 		{@"SI", @"386"},
 		{@"SK", @"421"},
 		{@"SL", @"232"},
 		{@"SM", @"378"},
 		{@"SN", @"221"},
 		{@"SO", @"252"},
 		{@"SR", @"597"},
 		{@"ST", @"239"},
 		{@"SV", @"503"},
 		{@"SY", @"963"},
 		{@"SZ", @"268"},
 		{@"TC", @"1649"},
 		{@"TD", @"235"},
 		{@"TG", @"228"},
 		{@"TH", @"66"},
 		{@"TJ", @"992"},
 		{@"TL", @"670"},
 		{@"TM", @"993"},
 		{@"TN", @"216"},
 		{@"TO", @"676"},
 		{@"TR", @"90"},
 		{@"TT", @"1868"},
 		{@"TW", @"886"},
 		{@"TZ", @"255"},
 		{@"UA", @"380"},
 		{@"UG", @"256"},
 		{@"US", @"1"},
 		{@"UY", @"598"},
 		{@"UZ", @"998"},
 		{@"VA", @"379"},
 		{@"VC", @"1784"},
 		{@"VE", @"58"},
 		{@"VG", @"1284"},
 		{@"VI", @"1340"},
 		{@"VN", @"84"},
 		{@"VU", @"678"},
 		{@"WF", @"681"},
 		{@"WS", @"685"},
 		{@"YE", @"967"},
 		{@"ZA", @"27"},
 		{@"ZM", @"260"},
 		{@"ZW", @"263"},
	};
	
	for (NSUInteger i = 0; i < sizeof(c_codes) / sizeof(c_codes[0]); i++)
	{
		if ([country isEqualToString:c_codes[i].country])
		{
			return c_codes[i].code;
		}
	}
	return nil;
}
