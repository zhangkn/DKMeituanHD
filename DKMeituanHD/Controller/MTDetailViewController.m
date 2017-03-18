

#import "MTDetailViewController.h"
#import "DKDeal.h"
#import "DPAPI.h"
#import "DKConst.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "MTRestrictions.h"
#import "DKHomeModelTool.h"
#import "MTDealTool.h"

@interface MTDetailViewController () <UIWebViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
- (IBAction)back;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
- (IBAction)buy;
- (IBAction)collect;
- (IBAction)share;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpireButton;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@end

@implementation MTDetailViewController


- (void)setupleftTimeButtonTitle{
    //1.计算死亡时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *dead = [fmt dateFromString:self.deal.purchase_deadline];//死亡时间
    // 追加1天
    dead = [dead dateByAddingTimeInterval:24 * 60 * 60];
    //2. 当前时间
    NSDate *now = [NSDate date];
    //3. 时间比较
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:dead options:0];
    if (cmps.day > 365) {
        [self.leftTimeButton setTitle:@"一年内不过期" forState:UIControlStateNormal];
    } else {
        [self.leftTimeButton setTitle:[NSString stringWithFormat:@"%ld天%ld小时%ld分钟", (long)cmps.day, (long)cmps.hour, (long)cmps.minute] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    self.view.backgroundColor = DkGlobalBg;
    
    // 加载网页
    self.webView.hidden = YES;// 第一次加载的页面不显示，等第二个请求完成仔显示
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    self.webView.delegate = self;
    
//    return;
    // 设置基本信息
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    
    // 设置剩余时间
  
    [self setupleftTimeButtonTitle];
    // kevin  return
//    return;
    
    // 发送请求获得更详细的团购数据
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 页码
    params[@"deal_id"] = self.deal.deal_id;
    [api requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
    // 设置收藏状态
    self.collectButton.selected = [MTDealTool isCollected:self.deal];//判断是否存在数据库中
}

/**
 *  返回控制器支持的方向
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - DPRequestDelegate     处理请求大众点评的请求
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    self.deal = [DKDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    // 设置退款信息
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpireButton.selected = self.deal.restrictions.is_refundable;
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD showError:@"网络繁忙,请稍后再试" toView:self.view];
}

#pragma mark - UIWebViewDelegate  处理webView  的请求

/**
 *http://m.dianping.com/tuan/deal/moreinfo/21930402
 http://m.dianping.com/tuan/deal/21930402?utm_source=open
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //处理deal_h5_url 加载、以及moreinfo URL 的加载情况
    if ([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url]) {
        // 旧的HTML5页面加载完毕
        NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
        NSString *urlStr = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@", ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    } else { // 详情页面加载完毕
        // 用来拼接所有的JS
        NSMutableString *js = [NSMutableString string];
        // 删除header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        // 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        // 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        
        // 利用webView执行JS
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        // 获得页面
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
        // 显示webView
        webView.hidden = NO;//此时才显示weeview 的内容
        // 隐藏正在加载
        [self.loadingView stopAnimating];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    
    
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buy {
    
}

- (IBAction)collect {
    
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MTCollectDealKey] = self.deal;
    
    if (self.collectButton.isSelected) { // 取消收藏, --- 第一次点击的时候，isSelected为NO，要进行收藏
        [MTDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
        
        info[MTIsCollectKey] = @NO;
    } else { // 收藏
        [MTDealTool addCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        
        info[MTIsCollectKey] = @YES;
    }
    
    // 按钮的选中取反
    self.collectButton.selected = !self.collectButton.isSelected;
    
    // 1.发出通知----刷新收藏控制器的数据源
    [[NSNotificationCenter defaultCenter ] postNotificationName:MTCollectStateDidChangeNotification object:nil userInfo:info];//
}

- (IBAction)share {
    
}
@end
