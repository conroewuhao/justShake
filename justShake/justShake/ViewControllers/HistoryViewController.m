//
//  HistoryViewController.m
//  Shake-Food
//
//  Created by wuhao on 15/12/28.
//  Copyright © 2015年 wuhao. All rights reserved.
//

#import "HistoryViewController.h"

#define rgba(a,b,c,d) [UIColor colorWithRed:a/255.f green:b/255.f blue:c/255.f alpha:d]

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    UITableView *historyTable;//table
    NSMutableArray *historyDataArray;//数据源

}
@end

@implementation HistoryViewController


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSForegroundColorAttributeName:rgba(250, 250, 250, 1)}];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"历史";

    historyDataArray=[[NSMutableArray alloc]init];
    
    [self checkData];
    
    [self.navigationController.navigationBar setBarTintColor:rgba(41, 204, 204, 1)];
    
    
    historyTable=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    historyTable.delegate=self;
    historyTable.dataSource=self;
    [self.view addSubview:historyTable];
    

}

/**
 *  检索数据
 */
-(void)checkData{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSMutableArray *arr=[def objectForKey:@"foodAndTimeArray"];
    
    if (arr && arr.count>0) {
        [historyDataArray removeAllObjects];
        historyDataArray=[NSMutableArray arrayWithArray:arr];
        
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"cellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    
    if (!historyDataArray || historyDataArray.count==0) {
        return cell;
    }
    else{
    NSDictionary *dic=historyDataArray[indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"contentString"];
    cell.textLabel.textColor=rgba(89, 89, 89, 1);
    cell.textLabel.font=[UIFont systemFontOfSize:18];
    cell.detailTextLabel.textColor=rgba(155, 155, 155, 1);
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        cell.detailTextLabel.text=[dic objectForKey:@"dateString"];}
    
    return cell;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return historyDataArray.count>0?historyDataArray.count:10;
    
}

@end
