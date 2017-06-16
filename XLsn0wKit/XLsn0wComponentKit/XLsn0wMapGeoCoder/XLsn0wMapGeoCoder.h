/*********************************************************************************************
 *   __      __   _         _________     _ _     _    _________   __         _         __   *
 *	 \ \    / /  | |        | _______|   | | \   | |  |  ______ |  \ \       / \       / /   *
 *	  \ \  / /   | |        | |          | |\ \  | |  | |     | |   \ \     / \ \     / /    *
 *     \ \/ /    | |        | |______    | | \ \ | |  | |     | |    \ \   / / \ \   / /     *
 *     /\/\/\    | |        |_______ |   | |  \ \| |  | |     | |     \ \ / /   \ \ / /      *
 *    / /  \ \   | |______   ______| |   | |   \ \ |  | |_____| |      \ \ /     \ \ /       *
 *   /_/    \_\  |________| |________|   |_|    \__|  |_________|       \_/       \_/        *
 *                                                                                           *
 *********************************************************************************************/
#import <Foundation/Foundation.h>

typedef void(^GetLatitudeBlock)(NSString *lat);//纬度
typedef void(^GetLongitudeBlock)(NSString *lon);//经度

typedef void(^XLsn0wMapGeoInfoCallback)(NSMutableDictionary *mapGeoInfo);//存放获取到的信息的字典
typedef void(^GetAddressBlock)(NSString *addressName);

@interface XLsn0wMapGeoCoder : NSObject

//搜索输入的地址, 得到地址信息Dictionary(经纬度)
- (void)searchAddress:(NSString *)address mapGeoInfoCallback:(XLsn0wMapGeoInfoCallback)mapGeoInfoCallback;

//如果只需要得到经纬度,只需要传入mapcod(输入地址的字符串)  latitude<返回的纬度> longitude<返回的经度>
- (void)searchAddress:(NSString *)address getlatitude:(GetLatitudeBlock)latitude getlongitudeStr:(GetLongitudeBlock)longitude;


//根据输入的经纬度<latitude(纬度),longitude(经度)>, 得到地址信息Dictionary(经纬度)
- (void)inputLatitudeStr:(NSString *)latitude longitudeStr:(NSString *)longitudeStr mapGeoInfoCallback:(XLsn0wMapGeoInfoCallback)mapGeoInfoCallback;
//根据输入的经纬度<latitude(纬度),longitude(经度)>, 得到addressName<返回的地址>
- (void)inputLatitudeStr:(NSString *)latitude getlongitudeStr:(NSString *)longitude backAddressName:(GetAddressBlock)addressName;

@end
