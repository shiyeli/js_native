//
//  ViewController.m
//  js_native
//
//  Created by 叶同学 on 16/7/3.
//  Copyright © 2016年 叶同学. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<WKScriptMessageHandler,UIWebViewDelegate>
{
    WKWebView* web1;
    UIWebView* web2;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    web1=[[WKWebView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.3)];
    NSString* str=[[NSBundle mainBundle]pathForResource:@"js_native" ofType:@"html"];
    
    [web1 loadHTMLString:[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
    [self.view addSubview:web1];
    
    
    
    
    
    web2=[[UIWebView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height*0.4, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.3)];
    [web2 loadHTMLString:[NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
    web2.delegate=self;
    [self.view addSubview:web2];
}

//添加了ScriptMessageHandler需要在视图消失的时候移除,不然控制器不会销毁
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [web1.configuration.userContentController addScriptMessageHandler:self name:@"function_wkwebview"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [web1.configuration.userContentController removeScriptMessageHandlerForName:@"function_wkwebview"];
}
#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"%@  %@",message.name,message.body);

}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext* context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"function_uiwebview"]=^(){
        
        NSLog(@"%@",[JSContext currentThis]);
    };
    
}
//主动调用js中的代码
- (IBAction)clickBtn1:(id)sender {
    NSString* str=[web2 stringByEvaluatingJavaScriptFromString:@"js_function('<h3>传给js函数的参数2</h3>')"];
    NSLog(@"%@",str);
}
- (IBAction)clickBtn2:(id)sender {
    
    [web1 evaluateJavaScript:@"js_function('<h3>传给js函数的参数1</h3>')" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
