//
//  ADShrinkLink.m
//
//  Created by Raphael Bartolome on 25.08.09.
//

#import "ADShrinkLink.h"


@interface ADShrinkLink (PrivateMethods)
- (void)_requestShrinkLink:(NSDictionary *)requestValues;
@end

@implementation ADShrinkLink

#pragma mark -


#pragma mark init methods

- (id)initWithPartnerID:(NSString *)newPartnerID
			   delegate:(id)newDelegate
{
	self = [super init];
	
	if(self)
	{
		if([newDelegate conformsToProtocol:@protocol(ADShrinkLinkProtocol)])
		{
			partnerEmail = nil;
			[self setDelegate:newDelegate];
			[self setPartnerID:newPartnerID];
		}
		else
		{
			NSLog(@"Make sure your delegate is conform to protocol 'AdShrinkLinkProtocol'");
			self = nil;
		}
	}
	
	return self;
}


- (id)initWithPartnerEmail:(NSString *)newPartnerEmail
				  delegate:(id)newDelegate;
{
	self = [super init];
	
	if(self)
	{
		if([newDelegate conformsToProtocol:@protocol(ADShrinkLinkProtocol)])
		{
			partnerID = nil;
			[self setDelegate:newDelegate];
			[self setPartnerEmail:newPartnerEmail];
		}
		else
		{
			NSLog(@"Make sure your delegate conforms to protocol 'AdShrinkLinkProtocol'");
			self = nil;
		}
	}
	
	return self;
}


#pragma mark -




#pragma mark dealloc methods

- (void)dealloc
{
	[delegate release];
	[partnerEmail release];
	[partnerID release];
	
	[super dealloc];
}

- (void)finalize
{
	[delegate release];
	[partnerEmail release];
	[partnerID release];
	
	[super finalize];
}

#pragma mark -




#pragma mark setter methods

- (void)setDelegate:(id)newDelegate
{
	[delegate release];
	[newDelegate retain];
	delegate = newDelegate;
}

- (void)setPartnerID:(NSString *)newPartnerID
{
	[partnerID release];
	[newPartnerID retain];
	partnerID = newPartnerID;
}

- (void)setPartnerEmail:(NSString *)newPartnerEmail
{
	[partnerEmail release];
	[newPartnerEmail retain];
	partnerEmail = newPartnerEmail;
}


#pragma mark -




#pragma mark getter methods

- (NSString *)partnerID
{
	return partnerID;
}

- (NSString *)partnerEmail
{
	return partnerEmail;
}


#pragma mark -




#pragma mark default methods
- (void)shrinkLink:(NSString *)url
{
	[self performSelectorInBackground:@selector(_requestShrinkLink:) 
						   withObject:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
}

- (void)shrinkLink:(NSString *)url
			adType:(const ADTypeOptions)newAdType
{
	NSArray *attributes = [NSArray arrayWithObject:[NSString stringWithFormat:@"at=%i",newAdType]];
	
	[self performSelectorInBackground:@selector(_requestShrinkLink:) 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", attributes, @"attributes", nil]];
}



#pragma mark ultra short methods
- (void)shrinkLink:(NSString *)url
		ultraShort:(BOOL)shrinkUltraShort
{
	NSArray *attributes = [NSArray arrayWithObject:[NSString stringWithFormat:@"ultraShort=%@",shrinkUltraShort ? @"yes" : @"no"]];
	
	[self performSelectorInBackground:@selector(_requestShrinkLink:) 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", attributes, @"attributes", nil]];
}

- (void)shrinkLink:(NSString *)url
			adType:(const ADTypeOptions)newAdType
		ultraShort:(BOOL)shrinkUltraShort
{
	
	NSArray *attributes = [NSArray arrayWithObjects:
								[NSString stringWithFormat:@"at=%i",newAdType],
								[NSString stringWithFormat:@"ultraShort=%@",shrinkUltraShort ? @"yes" : @"no"],nil];
	
	[self performSelectorInBackground:@selector(_requestShrinkLink:) 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", attributes, @"attributes", nil]];		
}



#pragma mark token only methods
- (void)shrinkLink:(NSString *)url
		 tokenOnly:(BOOL)tokenOnlyResult
{
	NSArray *attributes = [NSArray arrayWithObject:[NSString stringWithFormat:@"tokenOnly=%@",tokenOnlyResult ? @"yes" : @"no"]];
	
	[self performSelectorInBackground:@selector(_requestShrinkLink:) 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", attributes, @"attributes", nil]];
}

- (void)shrinkLink:(NSString *)url
			adType:(const ADTypeOptions)newAdType
		 tokenOnly:(BOOL)tokenOnlyResult
{
	NSArray *attributes = [NSArray arrayWithObjects:
						   [NSString stringWithFormat:@"at=%i",newAdType],
						   [NSString stringWithFormat:@"tokenOnly=%@",tokenOnlyResult ? @"yes" : @"no"],nil];
	
	[self performSelectorInBackground:@selector(_requestShrinkLink:) 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", attributes, @"attributes", nil]];		
}


#pragma mark -




#pragma mark private worker method
- (void)_requestShrinkLink:(NSDictionary *)requestValues
{	
	NSAutoreleasePool *shrinkLinkRequestPool = [[NSAutoreleasePool alloc]init];
	
	[requestValues retain];

	NSURLRequest *urlRequest = nil;
	NSURLResponse *resp = nil;
	NSData *resultData = nil;
	NSString *resultString = nil;
	NSError *error = nil;
		
	NSArray *attributes = [requestValues objectForKey:@"attributes"];
	NSString *url = [requestValues objectForKey:@"url"];
	NSMutableString *urlString = [[NSMutableString alloc]init];
	NSString *encodedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																			   (CFStringRef)url, 
																			   NULL, 
																			   (CFStringRef)@";/?:@&=$+{}<>,",
																			   kCFStringEncodingUTF8);
	
	[urlString appendString:ADJIX_API_DOMAIN];
	[urlString appendFormat:@"url=%@&",encodedURL];
			
	if(partnerID != nil)
	{
		[urlString appendFormat:@"partnerID=%@",[self partnerID]];
	}
	else if(partnerEmail != nil)
	{
		[urlString appendFormat:@"partnerEmail=%@",[self partnerEmail]];
	}
	
	if(attributes != nil && [attributes count] > 0)
	{
		for(NSString *tmpItem in attributes)
		{
			[urlString appendString:@"&"];
			[urlString appendString:tmpItem];
		}
	}
	
	
	urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	resultData = [NSURLConnection sendSynchronousRequest:urlRequest 
									   returningResponse:&resp 
												   error:&error];
	
	if(error == nil)
	{
		resultString = [[NSString alloc]initWithData:resultData 
											encoding:NSUTF8StringEncoding];
	}
	
	
	[delegate shrinkLinkResult:resultString original:url error:error];

	
	[urlString autorelease];
	[encodedURL autorelease];
	[resultString autorelease];
	[requestValues autorelease];
	
	[shrinkLinkRequestPool drain];
}

@end
