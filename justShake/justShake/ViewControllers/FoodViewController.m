//
//  FoodViewController.m
//  Shake-Food
//
//  Created by wuhao on 15/12/28.
//  Copyright © 2015年 wuhao. All rights reserved.
//

#import "FoodViewController.h"

@interface FoodViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *table;
}
@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation FoodViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:rgba(250, 250, 250, 1)}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray=[[NSMutableArray alloc]init];
    
    //检查数组数据
    [self checkData];
    
    self.title=@"菜单";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressPlusButton)];
    
    table=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
    
    
}


-(void)checkData{

    _dataArray=(NSMutableArray *)[[NSUserDefaults standardUserDefaults]objectForKey:@"foodArray"];
    if (_dataArray.count>0) {
        [table reloadData];
    }
    
}


-(void)pressPlusButton{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"添加" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        alert.delegate=self;
    [alert show];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"cellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.textLabel.text=_dataArray[indexPath.row];
    
    NSLog(@"%f",cell.frame.size.height);
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray?_dataArray.count:10;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return UITableViewCellEditingStyleDelete;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSMutableArray *new=[NSMutableArray new];
        [new removeAllObjects];
        new=[NSMutableArray arrayWithArray:_dataArray];
        [new removeObjectAtIndex:indexPath.row];
        _dataArray=[[NSMutableArray alloc]init];
        _dataArray=[NSMutableArray arrayWithArray:new];
        [self removeContentAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        return;
    }
    if (buttonIndex==1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        if (tf.text!=nil) {
            [self saveToLocalWithContent:tf.text];
        }
    }
    
}

-(void)saveToLocalWithContent:(NSString *)string{

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSMutableArray *localArr=[def objectForKey:@"foodArray"];
    if (localArr.count==0) {
        localArr=[[NSMutableArray alloc]init];
        [localArr addObject:string];
        [def setObject:localArr forKey:@"foodArray"];
        [def synchronize];
        [self checkData];
       // [table reloadData];
        
    }
    else if(localArr.count>0) {
        NSMutableArray *arr=[NSMutableArray new];
        [arr removeAllObjects];
        arr=[NSMutableArray arrayWithArray:localArr];
        [arr addObject:string];
        [def setObject:arr forKey:@"foodArray"];
       [def synchronize];
        [self checkData];
    }
    
}

-(void)removeContentAtIndex:(NSUInteger )index{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSMutableArray *arr=[def objectForKey:@"foodArray"];
    if (arr && arr.count>0 ) {
        NSMutableArray *new=[NSMutableArray new];
        new=[NSMutableArray arrayWithArray:arr];
        [new removeObjectAtIndex:index];
        [def setObject:new forKey:@"foodArray"];
    
    }
    [def synchronize];
    
}

@end
