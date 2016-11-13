////
//  ContentViewController.m
//  FragmentsTabsPager
//
//  Created by nakajijapan on 11/28/14.
//  Copyright (c) 2015 net.nakajijapan. All rights reserved.
//

#import "ViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define AllNumber 150

@interface ViewController (){
    int everyLineWidth[AllNumber];
    int lwh[AllNumber];
    int labelWidth[AllNumber];
    int minLwh[AllNumber];
    int find[AllNumber*AllNumber];
    int labelCount,minLineCount;
    int sumV;
    int space;
    int searchLeft;
    int searchRight;
    int searchMid;
}

@property (weak) IBOutlet UILabel *label;
//@property (weak) IBOutlet UILabel *labelTitle;

@property NSString *textLabel;
//@property NSString *textLabelTitle;

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) NSArray *dataSourceCopy;

@property (nonatomic) NSMutableArray *mDataSource;

@property (nonatomic) NSArray *showDataSource;
@property (weak, nonatomic) IBOutlet UIView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%lf",WIDTH);
    self.label.text = self.textLabel;
    [self creatDataSource];
    [self drawTags];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapDisorder:(id)sender
{
    
    _dataSource = [NSArray arrayWithArray:_dataSourceCopy];
    [self drawTags];
}

//从小到大
- (IBAction)didTapSortFromSmall:(id)sender
{
//    [self dps];
    _dataSource = [_dataSource sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
    [self drawTags];
}

//从大到小
- (IBAction)didTapSortFromeBig:(id)sender
{
    _dataSource = [_dataSource sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] <[obj2 integerValue];
    }];
    [self drawTags];
    
}

//前后各取值
- (IBAction)didTapGetFromBigAndSmall:(id)sender
{
    
    _dataSource = [_dataSource sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] <[obj2 integerValue];
    }];
    
    NSMutableArray *array = [NSMutableArray array];
    int left = 0, right = (int)[_dataSource count] - 1;
    
    int lWidth = (int)WIDTH - 25;
    
    while (left <= right) {
        int len = (int)[_dataSource[left] integerValue];
        if (len  <= lWidth ){
            lWidth -= len;
            [array addObject:_dataSource[left]];
            left++;
            continue;
        }
        len = (int)[_dataSource[right] integerValue];
        if ( len <= lWidth ){
            lWidth -= len;
            [array addObject:_dataSource[right]];
            right--;
            continue;
        }
        lWidth = (int)WIDTH - 25;
    }
    _dataSource = [NSArray arrayWithArray:array];
    [self drawTags];
}

- (IBAction)didTapDeepDfs:(id)sender
{
    [self DFS];
}

- (void)creatDataSource
{
    _dataSource = [NSArray arrayWithObjects:@(260),@(95),@(240) ,@(25),@(95),@(235),@(95),@(45),@(190),@(10),@(85),@(228),@(20),@(55),nil];
    //    _dataSource = [NSArray arrayWithObjects:@(280),@(280),@(280) ,@(285),@(235),@(55),@(190),@(85),@(95),@(95),@(95),@(10),@(45),@(228),nil];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for ( int i = 0; i < [_dataSource count]; ++i ){
        NSInteger subWidth = [_dataSource[i] integerValue];
        [array addObject:@(subWidth+5)];
    }
    
    _dataSource = [NSArray arrayWithArray:array];
    
    _dataSourceCopy = [NSArray arrayWithArray:_dataSource];}

- (void)drawTags
{
    for ( UIView *view in [_drawView subviews] ){
        [view removeFromSuperview];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
    [view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
    
    int pointx = 10, pointY = 0;
    for ( int i = 0; i < [_dataSource count]; ++i ){
        if ( pointx + [_dataSource[i] integerValue] > WIDTH - 15 ){
            pointx = 10;
            pointY += 30;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pointx+5, pointY, [_dataSource[i] integerValue]-5, 20)];
        pointx += [_dataSource[i] integerValue];
        
        [label.layer setBorderWidth:1.0];
        [label.layer setBorderColor:[UIColor blackColor].CGColor];
        [label setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.2]];
        [view addSubview:label];
        [label setText:[NSString stringWithFormat:@"%d",(int)i]];
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    [_drawView addSubview:view];
}



//迭代深搜
- (void)DFS
{
    for ( int i = 0; i < [_dataSource count]; ++i ){
        labelWidth[i+1] = (int)[_dataSource[i] integerValue];
    }
    int left = 0, right = (int)[_dataSource count];
    sumV = 0;
    labelCount = (int)[_dataSource count];
    
    memset(minLwh, 0, sizeof(minLwh));    //前i个label的总长
    for ( int i = 1; i <= labelCount; ++i ){
        minLwh[i] = minLwh[i-1] + lwh[i];
    }
    for ( int i = 1; i <= labelCount; ++i ){
        lwh[i] = labelWidth[i];
    }
    qsort(&lwh[1], labelCount, sizeof(lwh[1]),cmp);
    
    //二分最少需要几行
    while (left < right) {
        
        minLineCount = (left + right) / 2;    //最少的行数
        sumV = 0;                             //总空间大小
        
        for ( int i = 1; i <= minLineCount; ++i ){
            everyLineWidth[i] = WIDTH - 25;
            sumV += everyLineWidth[i];
        }
        space = 0;                           //废弃空间
        
        if ([self search:labelCount  pos:1] ){
            right = minLineCount;
            
        }else{
            left = minLineCount + 1;
        }
        
    }
    minLineCount = left;
    sumV = 0;
    memset(minLwh, 0, sizeof(minLwh));
    
    for ( int i = 1; i <= minLineCount; ++i ){
        everyLineWidth[i] = WIDTH - 25;
        sumV += everyLineWidth[i];
    }
    
    space = 0;
    memset(find, 0, sizeof(find));
    [self search:labelCount pos:1];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for ( int i = 1; i <= left; ++i )
    {
        for ( int j = 1; j <= labelCount; ++j ){
            if ( find[j] == i ){
                [array addObject:@(lwh[j])];
            }
        }
    }
    _dataSource = [NSArray arrayWithArray:array];
    [self drawTags];
}

- (BOOL)search:(int)step pos:(int)pos
{
    if ( step < 1 ){
        return 1;
    }
    
    if ( space > sumV - minLwh[labelCount] ) return 0;   //废弃的空间大于可以剩余的空间，说明一定至少有一个label没有了位置,强力剪枝
    
    for ( int i = minLineCount; i >= pos; --i ){
        
        if ( everyLineWidth[i] >= lwh[step] ){
            everyLineWidth[i] -= lwh[step];
            find[step] = i;
            if ( everyLineWidth[i] < lwh[1] ){      //剩余空间已无法装下最小的label，被人问废弃的空间
                space += everyLineWidth[i];
            }
            if ( lwh[step] == lwh[step+1] ) {
                if ([self search:step-1 pos:i] ) return 1;    //当前标签和上一个标签长度相等，停止向下枚举
            }else{
                if ( [self search:step-1 pos:1] ) return 1;
            }
            
            //没有结果后，回溯，还原数据
            if ( everyLineWidth[i] <lwh[1] ) space -= everyLineWidth[i];
            everyLineWidth[i] += lwh[step];
            find[step] = 0;
        }
    }
    return 0;
    
}


- (void)dps
{
    int left = 0, right = (int)[_dataSource count];
    while (left < right ) {
        int mid = (left + right) / 2;
        printf("mid: %d/n",mid);
        if ( [self dpFunction:mid] ){
            right = mid;
        }else{
            left = mid + 1;
        }
    }
    printf("left:  %d\n",left);
    
}

- (BOOL)dpFunction:(int)number
{
    int dp[100000];
    memset(dp,0, sizeof(dp));
    int all = ( WIDTH - 25 ) * number;
    int widthss = (WIDTH - 25);
    int lw[100];
    int dataNum = (int)[_dataSource count];
    for ( int i = 0; i < dataNum; ++i ){
        lw[i] = (int)[_dataSource[i] integerValue];
        printf("%d ",lw[i]);
    }
    printf("/n");
    for ( int j = 0; j < dataNum; ++j ){
        for ( int i = all - lw[j]; i >=0 ; --i ){
            if ( i % widthss == 0 ){
                int max = 0;
                for ( int k = i; k >= 0; --k ){
                    max = MAX(max, dp[k]);
                }
                dp[i] = MAX(max, dp[i]);
            }
            if( i % widthss == 0  ){
                dp[i+lw[j]] = MAX(dp[i+lw[j]], dp[i] + 1 );
                
            }else if ( dp[i] > 0 ){
                if( (i + lw[j] ) / widthss > ( i /widthss )){
                    continue;
                }
                dp[i+lw[j]] = MAX(dp[i+lw[j]], dp[i] + 1 );
            }
        }
    }
    
    for ( int i = all; i >= 0; --i ){
        printf("%d ",dp[i]);
        if( dp[i] == dataNum ){
            return 1;
        }
    }
    printf("/n");
    return 0;
}

int cmp(const void *a,const void *b)
{
    return *(int *)a-*(int *)b;
}


@end



