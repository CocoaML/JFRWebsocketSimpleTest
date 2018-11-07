//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  ViewController.m
//  SimpleTest
//
//  Created by Austin and Dalton Cherry on on 2/24/15.
//  Copyright (c) 2014-2017 Austin Cherry.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

#import "ViewController.h"
#import "JFRWebSocket.h"

@interface ViewController ()<JFRWebSocketDelegate>

@property(nonatomic, strong)JFRWebSocket *socket;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *url = @"ws://121.40.165.18:8800";
//    NSString *url = @"ws://127.0.0.1:9080";
    NSString *url = @"ws://127.0.0.1:8080";
    self.socket = [[JFRWebSocket alloc] initWithURL:[NSURL URLWithString:url] protocols:@[@"chat",@"superchat"]];
    self.socket.delegate = self;
    [self.socket connect];
}

- (IBAction)clearText:(id)sender {
    self.contentTextView.text = nil;
}


// pragma mark: WebSocket Delegate methods.

-(void)websocketDidConnect:(JFRWebSocket*)socket {
    NSLog(@"websocket is connected");
}

-(void)websocketDidDisconnect:(JFRWebSocket*)socket error:(NSError*)error {
    NSLog(@"websocket is disconnected: %@", [error localizedDescription]);
        [self.socket connect];
    
    self.contentTextView.text = [NSString stringWithFormat:@"%@\n连接失败", self.contentTextView.text];
}

-(void)websocket:(JFRWebSocket*)socket didReceiveMessage:(NSString*)string {
    NSLog(@"Received text: %@", string);
    
    self.contentTextView.text = [NSString stringWithFormat:@"%@\n%@", self.contentTextView.text, string];
    [self.contentTextView scrollRangeToVisible:NSMakeRange(self.contentTextView.text.length, 1)];
}

-(void)websocket:(JFRWebSocket*)socket didReceiveData:(NSData*)data {
    NSLog(@"Received data: %@", data);
}

// pragma mark: target actions.

- (IBAction)writeText:(UIBarButtonItem *)sender {
    NSString *sendString = @"我说 Hello here";
    [self.socket writeString:sendString];
}

- (IBAction)disconnect:(UIBarButtonItem *)sender {
    if(self.socket.isConnected) {
        sender.title = @"Connect";
        [self.socket disconnect];
    } else {
        sender.title = @"Disconnect";
        [self.socket connect];
    }
}

@end
