//
//  BDFmdbModel.m
//  QianYueBao
//
//  Created by Black on 17/5/11.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDFmdbModel.h"

#define SQLITE_NAME @"BDSqlite.sqlite"

@interface BDFmdbModel ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation BDFmdbModel

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static BDFmdbModel *model;
    dispatch_once(&onceToken, ^{
        model = [[BDFmdbModel alloc]init];
    });
    return model;
}

- (instancetype)init
{
    if (self = [super init])
    {
        // 或得沙盒中的数据库文件名
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:SQLITE_NAME];
        // 创建数据库队列
        self.queue = [FMDatabaseQueue databaseQueueWithPath:filename];
    }
    return self;
}

#pragma mark - 数据库中是否存在表
- (BOOL)isExistWithTableName:(NSString *)name
{
    if (name == nil)
    {
        return NO;
    }
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:name];
    }];
    return result;
}

#pragma mark - 创建表
- (BOOL)createTableWithTableName:(NSString *)name keys:(NSArray *)keys
{
    if (name == nil)
    {
        return NO;
    }
    else if (keys == nil)
    {
        return NO;
    }
    else
    {
        __block BOOL result;
        // 创建表
        [self.queue inDatabase:^(FMDatabase *db) {
            NSString *heard = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement",name];
            NSMutableString *sql = [[NSMutableString alloc]init];
            [sql appendString:heard];
            for (int i=0; i<keys.count; i++)
            {
                [sql appendFormat:@",%@ text",keys[i]];
                if (i == (keys.count -1))
                {
                    [sql appendString:@");"];
                }
            }
            result = [db executeUpdate:sql];
        }];
        return result;
    }
}

#pragma mark - 插入值
- (BOOL)insertIntoTableName:(NSString *)name Dict:(NSDictionary *)dict
{
    if (name == nil)
    {
        return NO;
    }
    else if (dict == nil)
    {
        return NO;
    }
    else
    {
        __block BOOL result;
        [self.queue inDatabase:^(FMDatabase *db) {
            NSArray *keys = dict.allKeys;
            NSArray *values = dict.allValues;
            NSMutableString* SQL = [[NSMutableString alloc] init];
            [SQL appendFormat:@"insert into %@(",name];
            for (int i=0; i<keys.count; i++)
            {
                [SQL appendFormat:@"%@",keys[i]];
                if(i == (keys.count-1))
                {
                    [SQL appendString:@") "];
                }
                else
                {
                    [SQL appendString:@","];
                }
            }
            [SQL appendString:@"values("];
            for(int i=0;i<values.count;i++)
            {
                [SQL appendString:@"?"];
                if(i == (keys.count-1))
                {
                    [SQL appendString:@");"];
                }
                else
                {
                    [SQL appendString:@","];
                }
            }
            
            result = [db executeUpdate:SQL withArgumentsInArray:values];
        }];
        return  result;
    }
}

#pragma mark -根据条件查询字段
- (NSArray *)queryWithTableName:(NSString *)name keys:(NSArray *)keys where:(NSArray *)where
{
    if (name == nil)
    {
        return nil;
    }
    else if (keys == nil)
    {
        return nil;
    }
    else
    {
        __block NSMutableArray *arrM = [[NSMutableArray alloc]init];
        [self.queue inDatabase:^(FMDatabase *db) {
            NSMutableString *SQL = [[NSMutableString alloc]init];
            [SQL appendString:@"select "];
            for(int i=0;i<keys.count;i++)
            {
                [SQL appendFormat:@"%@",keys[i]];
                if (i != (keys.count-1))
                {
                    [SQL appendString:@","];
                }
            }
            [SQL appendFormat:@" from %@ where ",name];
            if ((where!=nil) && (where.count>0))
            {
                if(!(where.count%3)){
                    for(int i=0;i<where.count;i+=3)
                    {
                        [SQL appendFormat:@"%@%@'%@'",where[i],where[i+1],where[i+2]];
                        if (i != (where.count-3))
                        {
                            [SQL appendString:@" and "];
                        }
                    }
                }
                else
                {
                    NSLog(@"条件数组错误!");
                }
            }
            // 查询数据
            FMResultSet *rs = [db executeQuery:SQL];
            // 遍历结果集
            while (rs.next)
            {
                NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
                for(int i=0;i<keys.count;i++)
                {
                    dictM[keys[i]] = [rs stringForColumn:keys[i]];
                }
                [arrM addObject:dictM];
            }
        }];
        return arrM;
    }
}

#pragma mark - 全部查询
- (NSArray *)queryWithTableName:(NSString *)name
{
    if (name == nil)
    {
        return nil;
    }
    __block NSMutableArray *arrM = [[NSMutableArray alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *SQL = [NSString stringWithFormat:@"select * from %@",name];
        // 查询数据
        FMResultSet *rs = [db executeQuery:SQL];
        // 遍历结果集
        while (rs.next)
        {
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
            for (int i=0;i<[[[rs columnNameToIndexMap] allKeys] count];i++)
            {
                if ([[rs columnNameForIndex:i] isEqualToString:@"basicModel"])
                {
                    dictM[[rs columnNameForIndex:i]] = [rs dataForColumnIndex:i];
                }
                else if ([[rs columnNameForIndex:i] isEqualToString:@"contractModel"])
                {
                    dictM[[rs columnNameForIndex:i]] = [rs dataForColumnIndex:i];
                }
                else if ([[rs columnNameForIndex:i] isEqualToString:@"ownerModel"])
                {
                    dictM[[rs columnNameForIndex:i]] = [rs dataForColumnIndex:i];
                }
                else
                {
                    dictM[[rs columnNameForIndex:i]] = [rs stringForColumnIndex:i];
                }
                
            }
            [arrM addObject:dictM];
        }
    }];
    return arrM;
}
#pragma mark - 根据key更新value

- (BOOL)updateWithTableName:(NSString *)name valueDict:(NSDictionary *)valueDict where:(NSArray *)where
{
    NSMutableArray *dataArray = [NSMutableArray new];
    if (name == nil)
    {
        return NO;
    }
    else if (valueDict == nil)
    {
        return NO;
    }
    else
    {
        __block BOOL result;
        [self.queue inDatabase:^(FMDatabase *db) {
            NSMutableString* SQL = [[NSMutableString alloc] init];
            [SQL appendFormat:@"update %@ set ",name];
            for(int i=0;i<valueDict.allKeys.count;i++)
            {
                [SQL appendFormat:@"%@='%@'",valueDict.allKeys[i],valueDict[valueDict.allKeys[i]]];
                [dataArray addObject:valueDict[valueDict.allKeys[i]]];
                if (i == (valueDict.allKeys.count-1))
                {
                    [SQL appendString:@" "];
                }
                else
                {
                    [SQL appendString:@","];
                }
            }
            if ((where!=nil) && (where.count>0))
            {
                if(!(where.count%3)){
                    [SQL appendString:@"where "];
                    for(int i=0;i<where.count;i+=3)
                    {
                        [SQL appendFormat:@"%@%@'%@'",where[i],where[i+1],where[i+2]];
                        if (i != (where.count-3))
                        {
                            [SQL appendString:@" and "];
                        }
                    }
                }
                else
                {
                    NSLog(@"条件数组错误!");
                }
            }
            result = [db executeUpdate:SQL withArgumentsInArray:dataArray];
//            result = [db executeUpdate:SQL];
        }];
        return result;
    }
}

#pragma mark - 删除
- (BOOL)deleteWithTableName:(NSString *)name where:(NSArray *)where
{
    if (name == nil)
    {
        return NO;
    }
    else if (where==nil || (where.count%3))
    {
        NSLog(@"条件数组错误!");
        return NO;
    }
    else;
    
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db)
     {
         NSMutableString* SQL = [[NSMutableString alloc] init];
         [SQL appendFormat:@"delete from %@ where ",name];
         for(int i=0;i<where.count;i+=3)
         {
             [SQL appendFormat:@"%@%@'%@'",where[i],where[i+1],where[i+2]];
             if (i != (where.count-3))
             {
                 [SQL appendString:@" and "];
             }
         }
         result = [db executeUpdate:SQL];
     }];
    return result;
}
#pragma mark - 根据表名删除表格全部内用
- (BOOL)clearTable:(NSString *)name
{
    if (name==nil)
    {
        NSLog(@"表名不能为空!");
        return NO;
    }
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db)
     {
         NSString* SQL = [NSString stringWithFormat:@"delete from %@;",name];
         result = [db executeUpdate:SQL];
     }];
    return result;
}

#pragma mark - 删除表
- (BOOL)dropTable:(NSString *)name
{
    if (name == nil)
    {
        return NO;
    }
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString* SQL = [NSString stringWithFormat:@"drop table %@;",name];
        result = [db executeUpdate:SQL];
    }];
    return result;
}

#pragma mark - 保存数据
+ (void)saveDetailModel:(BDSignDetailModel *)model complete:(BDHandler)complete
{
    NSString *message = @"";
    BOOL result = [[BDFmdbModel shareInstance] createTableWithTableName:READ_SHOP_SIGN(User_ID) keys:[BDSignDetailModel getAllProperties]];
    if (result)
    {
        model.currentTime = [NSString getCurrentTime];
        NSDictionary *dic = [model properties_asp];
        BOOL saveSuccess = [[BDFmdbModel shareInstance] insertIntoTableName:READ_SHOP_SIGN(User_ID) Dict:dic];
        if (saveSuccess)
        {
           message = REQUEST_SUCCESS;
        }
        else
        {
            message = LS(@"Save_Fail");
        }
    }
    else
    {
        message = LS(@"Save_Fail");
    }
    if (complete)
    {
        complete(message);
    }
}

//#pragma mark - 更新信息
//+ (void)updateDetailModel:(BDSignDetailModel *)modle id:(NSString *)valueID complete:(BDHandler)complete
//{
//    NSArray *modelArray =[[BDFmdbModel shareInstance]queryWithTableName:READ_SHOP_SIGN(User_ID) keys:[BDSignDetailModel getAllProperties] where:@[@"id",@"=",@"4"]];
//    if (modelArray)
//    {
//        if (modelArray && modelArray.count>0)
//        {
//            dispatch_queue_t where = dispatch_queue_create("where", nil);
//            dispatch_async(where, ^{
//                BOOL deleteSuccess = [[BDFmdbModel shareInstance] deleteWithTableName:READ_SHOP_SIGN(User_ID) where:@[@"id",@"=",valueID]];
//                //下面是注线程，刷新UI的
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (deleteSuccess)
//                    {
//                        [BDFmdbModel saveDetailModel:modle complete:^(id value) {
//                            if (complete)
//                            {
//                                complete(value);
//                            }
//                        }];
//                    }
//                    else
//                    {
//                        complete(LS(@"Save_Fail"));
//                    }
//                });
//            });
//        }
//        else
//        {
//            [BDFmdbModel saveDetailModel:modle complete:^(id value) {
//                if (complete)
//                {
//                    complete(value);
//                }
//            }];
//        }
//    }
//    else
//    {
//        complete(LS(@"Save_Fail"));
//    }
//}

+ (void)updateDetailModel:(BDSignDetailModel *)modle id:(BDSignListModel *)listModel currentVC:(BDSuperViewController *)vc complete:(BDHandler)complete
{
    if (listModel.contract_status == TradeStatus_Fail)
    {
        modle.status = TradeStatus_Fail;
         NSArray *modelArray =[[BDFmdbModel shareInstance]queryWithTableName:READ_SHOP_SIGN(User_ID) keys:[BDSignDetailModel getAllProperties] where:@[@"signID",@"=",[NSString trimNSNullASDefault:listModel.sign_mid andDefault:@"-2"]]];
        if (modelArray)
        {
            [BDStyle showLoading:@"" rootView:vc.view];
            if (modelArray && modelArray.count>0)
            {
                dispatch_queue_t where = dispatch_queue_create("where", nil);
                dispatch_async(where, ^{
                    BOOL deleteSuccess = [[BDFmdbModel shareInstance] deleteWithTableName:READ_SHOP_SIGN(User_ID) where:@[@"signID",@"=",[NSString trimNSNullASDefault:listModel.sign_mid andDefault:@"-2"]]];
                    //下面是注线程，刷新UI的
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (deleteSuccess)
                        {
                            modle.signID = listModel.sign_mid;
                            [BDFmdbModel saveDetailModel:modle complete:^(id value) {
                                if ([value isEqualToString:REQUEST_SUCCESS])
                                {
                                    [vc scrollviewNotifice:LS(@"Save_Success") style:@"3"];
                                }
                                else
                                {
                                    [BDStyle handlerDataError:value currentVC:vc handler:nil];
                                }
                            }];
                        }
                        else
                        {
                            [BDStyle handlerDataError:LS(@"Save_Fail") currentVC:vc handler:nil];
                        }
                    });
                });
            }
            else
            {
                modle.signID = listModel.sign_mid;
                [BDFmdbModel saveDetailModel:modle complete:^(id value) {
                    if ([value isEqualToString:REQUEST_SUCCESS])
                    {
                        [vc scrollviewNotifice:LS(@"Save_Success") style:@"3"];
                    }
                    else
                    {
                        [BDStyle handlerDataError:value currentVC:vc handler:nil];
                    }
                }];
            }
        }
        else
        {
            [BDStyle handlerDataError:LS(@"Save_Fail") currentVC:vc handler:nil];
        }
        
    }
    else if (listModel.contract_status == TradeStatus_Wait)
    {
        modle.status = TradeStatus_Wait;
        NSArray *modelArray =[[BDFmdbModel shareInstance]queryWithTableName:READ_SHOP_SIGN(User_ID) keys:[BDSignDetailModel getAllProperties] where:@[@"id",@"=",[NSString trimNSNullASDefault:listModel.detailID andDefault:@"-1"]]];
        if (modelArray)
        {
            [BDStyle showLoading:@"" rootView:vc.view];
            if (modelArray && modelArray.count>0)
            {
                dispatch_queue_t where = dispatch_queue_create("where", nil);
                dispatch_async(where, ^{
                    BOOL deleteSuccess = [[BDFmdbModel shareInstance] deleteWithTableName:READ_SHOP_SIGN(User_ID) where:@[@"id",@"=",[NSString trimNSNullASDefault:listModel.detailID andDefault:@"-1"]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (deleteSuccess)
                        {
                            [BDFmdbModel saveDetailModel:modle complete:^(id value) {
                                if ([value isEqualToString:REQUEST_SUCCESS])
                                {
                                    [vc scrollviewNotifice:LS(@"Save_Success") style:@"3"];
                                }
                                else
                                {
                                    [BDStyle handlerDataError:value currentVC:vc handler:nil];
                                }
                            }];
                        }
                        else
                        {
                            [BDStyle handlerDataError:LS(@"Save_Fail") currentVC:vc handler:nil];
                        }
                    });
                });
            }
            else
            {
                [BDFmdbModel saveDetailModel:modle complete:^(id value) {
                    if ([value isEqualToString:REQUEST_SUCCESS])
                    {
                        [vc scrollviewNotifice:LS(@"Save_Success") style:@"3"];
                    }
                    else
                    {
                        [BDStyle handlerDataError:value currentVC:vc handler:nil];
                    }
                }];
            }
        }
        else
        {
            [BDStyle handlerDataError:LS(@"Save_Fail") currentVC:vc handler:nil];
        }

    }
}

@end
