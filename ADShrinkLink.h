//
//  ADShrinkLink.h
//
//  Created by Raphael Bartolome on 25.08.09.
//

#import <Cocoa/Cocoa.h>

/*
 *	Default API Url
 */
#define ADJIX_API_DOMAIN @"http://api.adjix.com/shrinkLink?"

/*
 *	Ad Type Options
 */
typedef enum {
	ADNoAdTypeOption = 0,
	ADRandomAdTypeOption = 1,
	ADArtAdTypeOption = 2,
	ADCarsAdTypeOption = 3,
	ADBusinessAdTypeOption = 4,
	ADEntertainmentAdTypeOption = 5,
	ADFinancialAdTypeOption = 6,
	ADFoodAndDrinksAdTypeOption = 7,
	ADGamingAdTypeOption = 8,
	ADHealthAndFitnessAdTypeOption = 9,
	ADHumorAdTypeOption = 10,
	ADInternationalAdTypeOption = 11,
	ADKidsAndTeesAdTypeOption = 12,
	ADLegalAdTypeOption = 13,
	ADMilitaryAdTypeOption = 14,
	ADMoviewAdTypeOption = 15,
	ADMusicAdTypeOption = 16,
	ADNewsAdTypeOption = 17,
	ADOffBeatAdTypeOption = 18,
	ADPetsAndAnimalsAdTypeOption = 19,
	ADPoliticsAdTypeOption = 20,
	ADRealEstateAdTypeOption = 21,
	ADScienceAdTypeOption = 22,
	ADSportsAdTypeOption = 23,
	ADTechnologyAdTypeOption = 24,
	ADTVAdTypeOption = 25,
}ADTypeOptions;


/*
 *	Delegate protocol
 */
@protocol ADShrinkLinkProtocol
	- (void)shrinkLinkResult:(NSString *)shrinkedURL 
					original:(NSString *)originalURL
					error:(NSError *)error;
@end


@interface ADShrinkLink : NSObject {

	id delegate;
	NSString *partnerID;
	NSString *partnerEmail;
	ADTypeOptions defaultAdType;
}

/*
 *	Init methods with a minimum set of API informations
 */
- (id)initWithPartnerID:(NSString *)newPartnerID
			   delegate:(id)newDelegate;

- (id)initWithPartnerEmail:(NSString *)newPartnerEmail
			   delegate:(id)newDelegate;


/*
 *	Delegate setter method
 */
- (void)setDelegate:(id)newDelegate;

/*
 *	Setter methods for partnerID and partnerEmail
 */
- (void)setPartnerID:(NSString *)newPartnerID;
- (void)setPartnerEmail:(NSString *)newPartnerEmail;

/*
 *	Getter methods for partnerID and partnerEmail
 */
- (NSString *)partnerID;
- (NSString *)partnerEmail;



/*
 *	Shrink link default methods
 */
- (void)shrinkLink:(NSString *)url;

- (void)shrinkLink:(NSString *)url
		adType:(const ADTypeOptions)newAdType;


/*
 *	Shrink link methods with ultra short option 
 *	ultrashort means shrinks to http://ad.vu/...
 */
- (void)shrinkLink:(NSString *)url
		ultraShort:(BOOL)shrinkUltraShort;

- (void)shrinkLink:(NSString *)url
			adType:(const ADTypeOptions)newAdType
		ultraShort:(BOOL)shrinkUltraShort;


/*
 *	Shrink link methods with tokenOnlyResult
 *	tokenOnly means: as result you get only the token 
 *	the domain in this case is http://adjix.com/
 */
- (void)shrinkLink:(NSString *)url
		 tokenOnly:(BOOL)tokenOnlyResult;

- (void)shrinkLink:(NSString *)url
			adType:(const ADTypeOptions)newAdType
		 tokenOnly:(BOOL)tokenOnlyResult;


@end
