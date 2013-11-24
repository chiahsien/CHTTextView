//
//  ViewController.m
//  Sample
//
//  Created by Nelson Tai on 2013/11/23.
//  Copyright (c) 2013年 Nelson Tai. All rights reserved.
//

#import "ViewController.h"
#import "CHTTextView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet CHTTextView *textView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *fontNames;
@property (strong, nonatomic) UIToolbar *toolbar;
@end

@implementation ViewController

#pragma mark - Accessors

- (NSArray *)fontNames {
  if (!_fontNames) {
    _fontNames = [[UIFont familyNames] sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
      return [str1 localizedCaseInsensitiveCompare:str2];
    }];
  }
  return _fontNames;
}

- (UIToolbar *)toolbar {
  if (!_toolbar) {
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _toolbar.items =
    @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)]
    ];
  }
  return _toolbar;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.textView.inputAccessoryView = self.toolbar;
  self.textView.placeholder = @"Here is the placeholder.";
  self.textView.font = [UIFont systemFontOfSize:self.stepper.value];
}

#pragma mark - Actions

- (IBAction)changeFontSize:(UIStepper *)sender {
  self.textView.font = [self.textView.font fontWithSize:sender.value];
}

- (void)done:(id)sender {
  [self.view endEditing:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.fontNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fontCellIdentifier" forIndexPath:indexPath];
  cell.textLabel.text = self.fontNames[indexPath.row];
  return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.textView.font = [UIFont fontWithName:self.fontNames[indexPath.row] size:self.stepper.value];
}

@end
