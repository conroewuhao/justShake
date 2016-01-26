//
//  WanpuTestViewController.m
//  justShake
//
//  Created by wuhao on 16/1/25.
//  Copyright © 2016年 houbu. All rights reserved.
//

#import "WanpuTestViewController.h"
#import "WHObject.h"
#import "WHTest.h"


@interface WanpuTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *showList;
@property (weak, nonatomic) IBOutlet UIButton *showTable;
- (IBAction)pressShowList:(id)sender;
- (IBAction)pressShowTable:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *BundleIDTf;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
- (IBAction)pressOpenBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *DictionaryTv;

@end

@implementation WanpuTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WHTest *test=[[WHTest alloc]init];
    NSDictionary *infoDic=[test all];
    NSString *str=[self dictionaryToJson:infoDic];
    self.DictionaryTv.text=str;


}



- (IBAction)pressShowList:(id)sender {
    
    //原生的展示列表
    WHObject *newObject=[[WHObject alloc]init];
    [newObject showList:self];

}

- (IBAction)pressShowTable:(id)sender {
}
- (IBAction)pressOpenBtn:(id)sender {
    
    if (self.BundleIDTf.text==nil) {
        return;
    }
    
    

    if (self.BundleIDTf.text!=nil) {
        
        WHTest *test=[[WHTest alloc]init];
         [test open:self.BundleIDTf.text];
        
            
        }
            
        
    
    
    
}



-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}







@end
