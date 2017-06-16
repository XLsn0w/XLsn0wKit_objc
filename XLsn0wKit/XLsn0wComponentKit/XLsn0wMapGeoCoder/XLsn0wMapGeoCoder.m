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
#import "XLsn0wMapGeoCoder.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XLsn0wKit_objc.h"

@interface XLsn0wMapGeoCoder()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UILabel *alertView;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation XLsn0wMapGeoCoder

- (CLGeocoder *)geocoder{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (UILabel *)alertView{
    if (_alertView == nil) {
        _alertView = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 100, kScreenHeight/2 - 30, 200, 30)];
        _alertView.text = @"没有找到该地点或网络状况不佳";
        _alertView.backgroundColor = [UIColor grayColor];
        _alertView.font = [UIFont systemFontOfSize:14];
        _alertView.textAlignment = NSTextAlignmentCenter;
        _alertView.alpha = 0.9;
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 8;
        [[[UIApplication sharedApplication]keyWindow] addSubview:_alertView];
    }
    return _alertView;
}

- (UIView *)grayView{
    if (_grayView == nil) {
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 30, kScreenHeight/2 - 30, 60, 60)];
        _grayView.backgroundColor = [UIColor grayColor];
        _grayView.alpha = 0.9;
        _grayView.layer.cornerRadius = 10;
        [_grayView addSubview:self.activityIndicator];
        [[[UIApplication sharedApplication]keyWindow] addSubview:_grayView];
        [self.activityIndicator startAnimating];
    }
    return _grayView;
}

- (UIActivityIndicatorView *)activityIndicator{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc]init];
        _activityIndicator.frame = CGRectMake(0, 0, 60, 60);
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _activityIndicator;
}

- (void)timerStop {
    [self.alertView removeFromSuperview];
}

/*
 location  ------------ 位置  --  (CLLocation)
 region    ------------ 地区  --  (CLRegion)
 timeZone  ------------ 时区  --  (NStimeZone)
 addressDictionary ---- 地址字典 - (NSDictionary)
 name      -------------名字  --  (NSString)
 thoroughfare --------- 街道  --  (NSString)
 subThoroughfare ------ 子街道 -- (NSString)
 locality  ------------ 位置  --  (NSString)
 subLocality ---------- 子位置 --  (NSString)
 administrativeArea---- 行政区域 -- (NSString)
 subAdministrativeArea--子行政区域- (NSString)
 postalCode ----------- 邮政代码 -- (NSString)
 ISOcountryCode ------- ISO国家代码-(NSString)
 country ---------------国家  --   (NSString)
 inlandWater ---------- 内陆水--   (NSString)
 ocean     ------------ 海洋  --   (NSString)
 areasOfInterest ------ 感兴趣的地方-(NSArray)
 */
//这个方法可以取到<输入地点>的所有信息
- (void)searchAddress:(NSString *)address mapGeoInfoCallback:(XLsn0wMapGeoInfoCallback)mapGeoInfoCallback {
    [self grayView];
    NSMutableDictionary *mapGeoInfo = [[NSMutableDictionary alloc]init];
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            //菊花消失,加载没有查到地址的提示,设置时间让它消失
            [self.grayView removeFromSuperview];
            [self alertView];
            [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
        }else{
            CLPlacemark *place = [placemarks firstObject];
            CLLocationDegrees Weidu = place.location.coordinate.latitude;
            CLLocationDegrees Jindu = place.location.coordinate.longitude;
            NSString *lat = [NSString stringWithFormat:@"%.2f",Weidu];
            NSString *lon = [NSString stringWithFormat:@"%.2f",Jindu];
            CLRegion *clregion = [[CLRegion alloc]init];
            clregion = place.region;
            NSString *clr = [NSString stringWithFormat:@"%@",clregion];
            NSTimeZone *timeZone = [[NSTimeZone alloc]init];
            timeZone = place.timeZone;
            NSString *timeZon = [NSString stringWithFormat:@"%@",timeZone];
            [mapGeoInfo setValue:lat forKey:@"latitude"];//纬度
            [mapGeoInfo setValue:lon forKey:@"longitude"];//经度
            [mapGeoInfo setValue:clr forKey:@"region"];//地区
            [mapGeoInfo setValue:timeZon forKey:@"timeZone"];//时区
            [mapGeoInfo setValue:place.name forKey:@"name"];
            [mapGeoInfo setValue:place.thoroughfare forKey:@"thoroughfare"];
            [mapGeoInfo setValue:place.subThoroughfare forKey:@"subThoroughfare"];
            [mapGeoInfo setValue:place.locality forKey:@"locality"];
            [mapGeoInfo setValue:place.subLocality forKey:@"subLocality"];
            [mapGeoInfo setValue:place.administrativeArea forKey:@"administrativeArea"];
            [mapGeoInfo setValue:place.subAdministrativeArea forKey:@"subAdministrativeArea"];
            [mapGeoInfo setValue:place.postalCode forKey:@"postalCode"];
            [mapGeoInfo setValue:place.ISOcountryCode forKey:@"ISOcountryCode"];
            [mapGeoInfo setValue:place.country forKey:@"country"];
            [mapGeoInfo setValue:place.inlandWater forKey:@"inlandWater"];
            [mapGeoInfo setValue:place.ocean forKey:@"ocean"];
            [mapGeoInfo setValue:place.areasOfInterest forKey:@"areasOfInterest"];
            [mapGeoInfo setValue:place.addressDictionary forKey:@"addressDictionary"];
            mapGeoInfoCallback(mapGeoInfo);
            [self.grayView removeFromSuperview];
        }
    }];
}

//如果只需要取到 经纬度 用此方法就可以
- (void)searchAddress:(NSString *)address getlatitude:(GetLatitudeBlock)latitude getlongitudeStr:(GetLongitudeBlock)longitude{
    [self grayView];
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            //菊花消失,加载没有查到地址的提示,设置时间让它消失
            [self.grayView removeFromSuperview];
            [self alertView];
            [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
        }else{
            CLPlacemark *place = [placemarks firstObject];
            CLLocationDegrees Weidu = place.location.coordinate.latitude;
            CLLocationDegrees Jindu = place.location.coordinate.longitude;
            NSString *lat = [NSString stringWithFormat:@"%.2f",Weidu];
            NSString *lon = [NSString stringWithFormat:@"%.2f",Jindu];
            latitude(lat);
            longitude(lon);
            [self.grayView removeFromSuperview];
            
        }
    }];
}

//这个方法可以取到<输入经纬度>的所有信息
- (void)inputLatitudeStr:(NSString *)latitude longitudeStr:(NSString *)longitudeStr mapGeoInfoCallback:(XLsn0wMapGeoInfoCallback)mapGeoInfoCallback {
    [self grayView];
    NSMutableDictionary *mapGeoInfo = [[NSMutableDictionary alloc]init];
    
    if (latitude.length<1 || longitudeStr.length <1) {
        [self.grayView removeFromSuperview];
        [self alertView];
        [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
    }else{
        CLLocationDegrees weiduude = [latitude doubleValue];
        CLLocationDegrees jinduude = [longitudeStr doubleValue];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:weiduude longitude:jinduude];
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error || placemarks.count == 0) {
                //菊花消失,加载没有查到地址的提示,设置时间让它消失
                [self.grayView removeFromSuperview];
                [self alertView];
                [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
            }else{
                CLPlacemark *place = [placemarks firstObject];
                CLLocationDegrees Weidu = place.location.coordinate.latitude;
                CLLocationDegrees Jindu = place.location.coordinate.longitude;
                NSString *lat = [NSString stringWithFormat:@"%.2f",Weidu];
                NSString *lon = [NSString stringWithFormat:@"%.2f",Jindu];
                CLRegion *clregion = [[CLRegion alloc]init];
                clregion = place.region;
                NSString *clr = [NSString stringWithFormat:@"%@",clregion];
                NSTimeZone *timeZone = [[NSTimeZone alloc]init];
                timeZone = place.timeZone;
                NSString *timeZon = [NSString stringWithFormat:@"%@",timeZone];
                
                [mapGeoInfo setValue:lat forKey:@"latitude"];//纬度
                [mapGeoInfo setValue:lon forKey:@"longitude"];//经度
                [mapGeoInfo setValue:clr forKey:@"region"];//地区
                [mapGeoInfo setValue:timeZon forKey:@"timeZone"];//时区
                [mapGeoInfo setValue:place.name forKey:@"name"];
                [mapGeoInfo setValue:place.thoroughfare forKey:@"thoroughfare"];
                [mapGeoInfo setValue:place.subThoroughfare forKey:@"subThoroughfare"];
                [mapGeoInfo setValue:place.locality forKey:@"locality"];
                [mapGeoInfo setValue:place.subLocality forKey:@"subLocality"];
                [mapGeoInfo setValue:place.administrativeArea forKey:@"administrativeArea"];
                [mapGeoInfo setValue:place.subAdministrativeArea forKey:@"subAdministrativeArea"];
                [mapGeoInfo setValue:place.postalCode forKey:@"postalCode"];
                [mapGeoInfo setValue:place.ISOcountryCode forKey:@"ISOcountryCode"];
                [mapGeoInfo setValue:place.country forKey:@"country"];
                [mapGeoInfo setValue:place.inlandWater forKey:@"inlandWater"];
                [mapGeoInfo setValue:place.ocean forKey:@"ocean"];
                [mapGeoInfo setValue:place.areasOfInterest forKey:@"areasOfInterest"];
                [mapGeoInfo setValue:place.addressDictionary forKey:@"addressDictionary"];
                mapGeoInfoCallback(mapGeoInfo);
                
                [self.grayView removeFromSuperview];
            }
        }];
    }
}

//如果只需要取到地址 用此方法就可以
- (void)inputLatitudeStr:(NSString *)latitude getlongitudeStr:(NSString *)longitude backAddressName:(GetAddressBlock)addressName{
    [self grayView];
    if (latitude.length<1 || longitude.length <1) {
        [self.grayView removeFromSuperview];
        [self alertView];
        [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
    }else{
        CLLocationDegrees weiduude = [latitude doubleValue];
        CLLocationDegrees jinduude = [longitude doubleValue];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:weiduude longitude:jinduude];
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error || placemarks.count == 0) {
                //菊花消失,加载没有查到地址的提示,设置时间让它消失
                [self.grayView removeFromSuperview];
                [self alertView];
                [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(timerStop) userInfo:nil repeats:YES];
            }else{
                CLPlacemark *place = [placemarks firstObject];
                
                NSString *address = [[place.country stringByAppendingString:place.administrativeArea] stringByAppendingString:place.name];
                NSLog(@"%@",place.country);
                NSLog(@"%@",place.administrativeArea);
                NSLog(@"%@",place.name);
                addressName(address);
                [self.grayView removeFromSuperview];
            }
        }];
    }
}

@end
